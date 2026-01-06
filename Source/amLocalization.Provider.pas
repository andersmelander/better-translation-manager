unit amLocalization.Provider;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  amLanguageInfo,
  amLocalization.Model;

// -----------------------------------------------------------------------------
//
// ITranslationProvider
//
// -----------------------------------------------------------------------------
type
  ITranslationProvider = interface
    ['{254E24D5-8F3C-422E-9304-1E21126C8B3C}']
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
    procedure EndLookup;

    function GetProviderName: string;
    property ProviderName: string read GetProviderName;

    function GetEnabled: boolean;
    property Enabled: boolean read GetEnabled;
  end;


// -----------------------------------------------------------------------------
//
// ITranslationService
//
// -----------------------------------------------------------------------------
type
  ITranslationService = interface
    ['{0613B25B-5D59-47E1-B38C-A9FD193E5CC5}']
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; var TargetValue: string): boolean;
    procedure EndLookup;
  end;


// -----------------------------------------------------------------------------
//
// TranslationProviderRegistry
//
// -----------------------------------------------------------------------------
type
  TTranslationProviderFactory = reference to function(): ITranslationProvider;
  TTranslationProviderEnabled = reference to function(): boolean;

  TranslationProviderRegistry = class abstract
  private type
    TProviderRecord = record
      ProviderName: string;
      ProviderFactory: TTranslationProviderFactory;
      EnabledDelegate: TTranslationProviderEnabled;
      NextFreeHandle: integer;
    end;
  private
    class var
      FRegistry: TList<TProviderRecord>;
      FFirstFreeHandle: integer; // Linked list of unused records
  public type
    TProvider = record
      Handle: integer;
      ProviderName: string;
      Enabled: boolean;
    end;

    TProviderEnumerator = record
    strict private
      FList: TList<TProviderRecord>;
      FIndex: Integer;
    private
      class function Initialize(List: TList<TProviderRecord>): TProviderEnumerator; static;
    public
      function GetCurrent: TProvider;
      function MoveNext: Boolean;
      property Current: TProvider read GetCurrent;
    end;

  public
    class constructor Create;
    class destructor Destroy;

    class function RegisterProvider(const ProviderName: string; ProviderFactory: TTranslationProviderFactory; EnabledDelegate: TTranslationProviderEnabled = nil): integer;
    class procedure UnregisterProvider(ProviderHandle: integer);

    function GetEnumerator: TProviderEnumerator;

    class function CreateProvider(ProviderHandle: integer): ITranslationProvider;
  end;


// -----------------------------------------------------------------------------
//
// TTranslationProviderDataModule
//
// -----------------------------------------------------------------------------
// Abstract reference counted ITranslationProvider base class data module
// -----------------------------------------------------------------------------
type
  TTranslationProviderDataModule = class abstract(TDataModule, IUnknown, ITranslationProvider)
  private
    FRefCount: integer;
  protected
    // IInterface
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean; virtual;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean; virtual; abstract;
    procedure EndLookup; virtual;
    function GetProviderName: string; virtual; abstract;
    function GetEnabled: boolean; virtual; abstract;
  end;


// -----------------------------------------------------------------------------
//
// TTranslationLookupResult
//
// -----------------------------------------------------------------------------
// Translation lookup result container.
// -----------------------------------------------------------------------------
type
  TTranslationLookupResult = class
  strict private type
    TTranslation = record
      SourceValue: string;
      TargetValue: string;
    end;
    TTranslationList = TList<TTranslation>;
  strict private
    FItems: TTranslationList;
  public
    constructor Create(ACapacity: integer = 0);
    destructor Destroy; override;

    procedure Clear;
    procedure Add(const SourceValue, TargetValue: string);

    procedure RankTranslations(const SourceValue: string);

    procedure AddToStrings(Strings: TStrings);

    function GetEnumerator: TEnumerator<TTranslation>;
  end;


type
  ELocalizationProvider = class(Exception);

// -----------------------------------------------------------------------------
//
// CreateTranslationService
//
// -----------------------------------------------------------------------------
// Translation provider factory.
// -----------------------------------------------------------------------------
function CreateTranslationService(const ATranslationProvider: ITranslationProvider): ITranslationService;


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  StrUtils,
  SyncObjs,
  System.Character,
  System.UITypes,
  VCL.Dialogs,
  amLocalization.ExceptionHandler.Prompt,
  amLocalization.Settings,
  amLocalization.Normalization,
  amLocalization.Dialog.TranslationMemory.SelectDuplicate;

type
  TTranslationService = class(TInterfacedObject, ITranslationService)
  private
    FTranslationProvider: ITranslationProvider;
    FFormSelectDuplicate: TFormSelectDuplicate;
    FDuplicateAction: TDuplicateAction;
    FConflictResolution: TDictionary<string, string>;
  private
  protected
    // ITranslationService
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; var TargetValue: string): boolean;
    procedure EndLookup;
  public
    constructor Create(const ATranslationProvider: ITranslationProvider);
    destructor Destroy; override;
  end;

// -----------------------------------------------------------------------------

constructor TTranslationService.Create(const ATranslationProvider: ITranslationProvider);
begin
  inherited Create;

  FTranslationProvider := ATranslationProvider;
end;

destructor TTranslationService.Destroy;
begin
  FreeAndNil(FFormSelectDuplicate);
  FreeAndNil(FConflictResolution);

  inherited;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

function TTranslationService.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
begin
  Result := FTranslationProvider.BeginLookup(SourceLanguage, TargetLanguage);

  if (not Result) then
    Exit;

  FDuplicateAction := daPrompt;

  if (FConflictResolution = nil) then
    FConflictResolution := TDictionary<string, string>.Create
  else
    FConflictResolution.Clear;
end;

procedure TTranslationService.EndLookup;
begin
  FTranslationProvider.EndLookup;

  if (FConflictResolution <> nil) then
    FConflictResolution.Clear;
end;

function TTranslationService.Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; var TargetValue: string): boolean;
var
  Translations: TStringList;
resourcestring
  sProviderLookupFailed = 'Provider lookup failed';
  sProviderLookupFailedMsg = 'Error: %s'#13'%s';
begin
  if (Prop.Value.Trim.IsEmpty) then
    Exit(False);

  Translations := TStringList.Create;
  try
    Translations.Sorted := True;
    Translations.Duplicates := dupIgnore;

    try

      Result := FTranslationProvider.Lookup(Prop, SourceLanguage, TargetLanguage, Translations);

    except
      on E: ELocalizationProvider do
      begin
        if (PromptPropagateError(sProviderLookupFailed, sProviderLookupFailedMsg, [E.ToString, E.ClassName])) then
          raise;
        Exit(False);
      end;
    end;

    if (not Result) then
      Exit;

    Assert(Translations.Count > 0);

    if (Translations.Count > 1) then
    begin
      // Attempt to resolve using previously resolved conflicts
      if (FConflictResolution.TryGetValue(Prop.Value, TargetValue)) then
        Exit;

      if (FFormSelectDuplicate = nil) then
        FFormSelectDuplicate := TFormSelectDuplicate.Create(nil);

      FFormSelectDuplicate.DuplicateAction := FDuplicateAction;

      if (not FFormSelectDuplicate.SelectDuplicate(Prop, Translations, TargetLanguage.IsRightToLeft, TargetValue)) then
        Abort;

      if (not FFormSelectDuplicate.SkipOne) then
      begin
        FDuplicateAction := FFormSelectDuplicate.DuplicateAction;

        if (FFormSelectDuplicate.ApplyToIdentical) then
          FConflictResolution.Add(Prop.Value, TargetValue);

        Result := (not (FDuplicateAction in [daSkip, daSkipAll]));
      end else
        Result := False;
    end else
      TargetValue := Translations[0];

  finally
    Translations.Free;
  end;
end;

// -----------------------------------------------------------------------------

function CreateTranslationService(const ATranslationProvider: ITranslationProvider): ITranslationService;
begin
  Result := TTranslationService.Create(ATranslationProvider);
end;

// -----------------------------------------------------------------------------
//
// TranslationProviderRegistry
//
// -----------------------------------------------------------------------------
class constructor TranslationProviderRegistry.Create;
begin
  FRegistry := TList<TProviderRecord>.Create;
  FFirstFreeHandle := -1;
end;

class destructor TranslationProviderRegistry.Destroy;
begin
  FreeAndNil(FRegistry);
end;

// -----------------------------------------------------------------------------

class function TranslationProviderRegistry.TProviderEnumerator.Initialize(List: TList<TProviderRecord>): TProviderEnumerator;
begin
  Result.FList := List;
  Result.FIndex := -1;
end;

function TranslationProviderRegistry.TProviderEnumerator.MoveNext: Boolean;
begin
  Result := (FIndex < FList.Count-1);
  if Result then
    inc(FIndex);
end;

function TranslationProviderRegistry.TProviderEnumerator.GetCurrent: TProvider;
begin
  Result.Handle := FIndex;
  Result.ProviderName := FList[FIndex].ProviderName;

  if (Assigned(FList[FIndex].EnabledDelegate)) then
    Result.Enabled := FList[FIndex].EnabledDelegate()
  else
    Result.Enabled := True;
end;

function TranslationProviderRegistry.GetEnumerator: TProviderEnumerator;
begin
  // This is a hack. Self=nil.
  Result := TProviderEnumerator.Initialize(TranslationProviderRegistry.FRegistry);
end;

// -----------------------------------------------------------------------------

class function TranslationProviderRegistry.CreateProvider(ProviderHandle: integer): ITranslationProvider;
begin
  Result := FRegistry[ProviderHandle].ProviderFactory();
end;

class function TranslationProviderRegistry.RegisterProvider(const ProviderName: string; ProviderFactory: TTranslationProviderFactory; EnabledDelegate: TTranslationProviderEnabled): integer;
var
  ProviderRecord: TProviderRecord;
begin
  ProviderRecord.ProviderName := ProviderName;
  ProviderRecord.ProviderFactory := ProviderFactory;
  ProviderRecord.EnabledDelegate := EnabledDelegate;
  ProviderRecord.NextFreeHandle := -1;

  if (FFirstFreeHandle <> -1) then
  begin
    Result := FFirstFreeHandle;
    FFirstFreeHandle := FRegistry[FFirstFreeHandle].NextFreeHandle;
    FRegistry[Result] := ProviderRecord;
  end else
    Result := FRegistry.Add(ProviderRecord);
end;

class procedure TranslationProviderRegistry.UnregisterProvider(ProviderHandle: integer);
var
  ProviderRecord: TProviderRecord;
begin
  ProviderRecord := Default(TProviderRecord);
  ProviderRecord.NextFreeHandle := FFirstFreeHandle;
  FRegistry[ProviderHandle] := ProviderRecord;
  FFirstFreeHandle := ProviderHandle;
end;

// -----------------------------------------------------------------------------
//
// TTranslationProviderDataModule
//
// -----------------------------------------------------------------------------
function TTranslationProviderDataModule.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
begin
  Result := True;
end;

procedure TTranslationProviderDataModule.EndLookup;
begin
end;

function TTranslationProviderDataModule.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TTranslationProviderDataModule._AddRef: Integer;
begin
  Result := TInterlocked.Increment(FRefCount);
end;

function TTranslationProviderDataModule._Release: Integer;
begin
  Result := TInterlocked.Decrement(FRefCount);
  if (Result = 0) then
    Free;
end;


// -----------------------------------------------------------------------------
//
// TTranslationLookupResult
//
// -----------------------------------------------------------------------------
constructor TTranslationLookupResult.Create(ACapacity: integer);
begin
  inherited Create;

  FItems := TTranslationList.Create;
  FItems.Capacity := ACapacity;
end;

destructor TTranslationLookupResult.Destroy;
begin
  FItems.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TTranslationLookupResult.Clear;
begin
  FItems.Clear;
end;

// -----------------------------------------------------------------------------

function TTranslationLookupResult.GetEnumerator: TEnumerator<TTranslation>;
begin
  Result := FItems.GetEnumerator;
end;

// -----------------------------------------------------------------------------

procedure TTranslationLookupResult.Add(const SourceValue, TargetValue: string);
var
  Translation: TTranslation;
begin
  Translation.SourceValue := SourceValue;
  Translation.TargetValue := TargetValue;
  FItems.Add(Translation);
end;

procedure TTranslationLookupResult.AddToStrings(Strings: TStrings);
var
  i: integer;
begin
  for i := 0 to FItems.Count-1 do
    Strings.Add(FItems[i].TargetValue);
end;

procedure TTranslationLookupResult.RankTranslations(const SourceValue: string);
var
  i, j: integer;
  DoneCount: integer;
  Translation: TTranslation;
begin
  DoneCount := 0;
  // Exact match
  i := FItems.Count-1;
  while (i >= DoneCount) do
  begin
    if (FItems[i].SourceValue = SourceValue) then
    begin
      FItems.Move(i, DoneCount);
      Inc(DoneCount);
    end else
      Dec(i);
  end;
  // Just case mismatch
  i := FItems.Count-1;
  while (i >= DoneCount) do
  begin
    if (AnsiSameText(FItems[i].SourceValue, SourceValue)) then
    begin
      if (EqualizeCase in TranslationManagerSettings.Editor.EqualizerRules) then
      begin
        Translation := FItems[i];
        Translation.TargetValue := MakeAlike(SourceValue, Translation.TargetValue, [EqualizeCase]);
        FItems[i] := Translation;
      end;

      FItems.Move(i, DoneCount);
      Inc(DoneCount);
    end else
      Dec(i);
  end;
  // Just case and/or space mismatch
  i := FItems.Count-1;
  while (i >= DoneCount) do
  begin
    if (AnsiSameText(FItems[i].SourceValue.Trim, SourceValue.Trim)) then
    begin
      if (EqualizeCase in TranslationManagerSettings.Editor.EqualizerRules) then
      begin
        Translation := FItems[i];
        Translation.TargetValue := MakeAlike(SourceValue, Translation.TargetValue, [EqualizeCase, EqualizeSpace]);
        FItems[i] := Translation;
      end;

      FItems.Move(i, DoneCount);
      Inc(DoneCount);
    end else
      Dec(i);
  end;
  // Both have Format() specifiers
  i := FItems.Count-1;
  while (i >= DoneCount) do
  begin
    if (SanitizeText(FItems[i].SourceValue, [skFormat]) <> FItems[i].SourceValue) and (SanitizeText(SourceValue, [skFormat]) <> SourceValue) then
    begin
      Translation := FItems[i];
      Translation.TargetValue := MakeAlike(SourceValue, Translation.TargetValue);
      FItems[i] := Translation;

      FItems.Move(i, DoneCount);
      Inc(DoneCount);
    end else
      Dec(i);
  end;
  // Both have accelerators
  i := FItems.Count-1;
  while (i >= DoneCount) do
  begin
    if (HasAccelerator(FItems[i].SourceValue)) and (HasAccelerator(SourceValue)) then
    begin
      Translation := FItems[i];
      Translation.TargetValue := MakeAlike(SourceValue, Translation.TargetValue);
      FItems[i] := Translation;

      FItems.Move(i, DoneCount);
      Inc(DoneCount);
    end else
      Dec(i);
  end;
  // Just equalize the rest
  for i := FItems.Count-1 downto DoneCount do
  begin
    Translation := FItems[i];
    Translation.TargetValue := MakeAlike(SourceValue, Translation.TargetValue);
    FItems[i] := Translation;
  end;

  // Eliminate duplicate target values, worst matches first
  i := 0;
  while (i <= FItems.Count-2) do
  begin
    for j := FItems.Count-1 downto i+1 do
      if (FItems[i].TargetValue = FItems[j].TargetValue) then
        FItems.Delete(j);
    Inc(i);
  end;
end;

// -----------------------------------------------------------------------------

end.
