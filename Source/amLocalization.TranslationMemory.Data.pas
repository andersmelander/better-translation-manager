unit amLocalization.TranslationMemory.Data;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

{.$define TM_BENCHMARK}

uses
  Generics.Collections,
  SyncObjs,
  Types,
  System.SysUtils, System.Classes, Windows, Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  amLanguageInfo,
  amProgress.API,
  amLocalization.Normalization,
  amLocalization.Model,
  amLocalization.Provider,
  amLocalization.TranslationMemory;


// -----------------------------------------------------------------------------
//
// TDataModuleTranslationMemory
//
// -----------------------------------------------------------------------------
type
  TDataModule = TTranslationProviderDataModule;

type
  TDataModuleTranslationMemory = class(TDataModule, ITranslationMemory)
    DataSourceTranslationMemory: TDataSource;
    TableTranslationMemory: TFDMemTable;
    procedure TableTranslationMemoryAfterModify(DataSet: TDataSet);
  private
    FLoaded: boolean;
    FEnabled: boolean;
    FLookupIndex: ITranslationMemoryLookup;
    FLookupLanguage: TLanguageItem;
    FModified: boolean;
    FRefreshEvent: TEvent;
    FProviderHandle: integer;
    FAdding: boolean;
    FImperfectLanguageMatchPrompt: boolean;
    FFieldLanguage: TDictionary<TField, TLanguageItem>;
  private
    function FindField(LanguageItem: TLanguageItem): TField; overload;
    class function FindField(DataSet: TDataSet; LanguageItem: TLanguageItem): TField; overload;
    procedure FieldGetTextEventHandler(Sender: TField; var Text: string; DisplayText: Boolean);
    function AddTerm(SourceField: TField; const SourceValue, SanitizedSourceValue: string; TargetField: TField; const TargetValue: string;
      Duplicates: TDuplicates; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction): TTranslationMemoryDuplicateAction;
    function CreateLookup(Language: TLanguageItem): ITranslationMemoryLookup; overload;
    function Add(SourceField: TField; const SourceValue: string; TargetField: TField; const TargetValue: string; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction = tmDupActionPrompt): TTranslationMemoryDuplicateAction; overload;
  protected
    // Threaded lookup
    type TPopulateDictionaryCallback = reference to procedure(var Continue: boolean);
  protected
    // Threaded lookup
    procedure PopulateDictionary(SourceField, TargetField: TField; Dictionary: TStringList; Callback: TPopulateDictionaryCallback);
    // Protect against TM modifications. It is assumed that the TM table properties (data, fields, etc) are stable outside the lock.
    procedure Lock;
    procedure Unlock;

    property RefreshEvent: TEvent read FRefreshEvent;
  protected
    // ITranslationMemory
    function CreateField(LanguageItem: TLanguageItem): TField;
    function FieldToLanguage(Field: TField): TLanguageItem;
    function SaveTableTranslationMemoryClone: IInterface;
    function GetTranslationMemoryDataSet: TDataSet;
    function ITranslationMemory.AddTerm = AddTerm;
    procedure ITranslationMemory.Lock = Lock;
    procedure ITranslationMemory.Unlock = Unlock;

    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const Filename: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const Filename: string);

    procedure BeginAdd;
    function Add(SourceLanguage: TLanguageItem; const SourceValue: string; TargetLanguage: TLanguageItem; const TargetValue: string; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction = tmDupActionPrompt): TTranslationMemoryDuplicateAction; overload;
    procedure EndAdd;

    function CheckSave: boolean;
    function CheckLoaded(Force: boolean = False): boolean;
    procedure SetLoaded; // For use when loading TMX as main TM

    function GetLanguages: TArray<TLanguageItem>;
    function CreateLookup(Language: TLanguageItem; SanitizeRules: TSanitizeRules; const Progress: IProgress = nil): ITranslationMemoryLookup; overload;
    function CreateBackgroundLookup(SourceLanguage, TargetLanguage: TLanguageItem; AResultHandler: TNotifyEvent): ITranslationMemoryPeek;
    function HasSourceTerm(Prop: TLocalizerProperty; SourceLanguage: TLanguageItem): boolean;
    function FindTerms(Language: TLanguageItem; const Value: string; LookupResult: TTranslationLookupResult; RankResult: boolean = False): boolean;
    function FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean; overload;
    function FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; LookupResult: TTranslationLookupResult): boolean; overload;

    function GetIsLoaded: boolean;
    function GetModified: boolean;
    function GetIsAvailable: boolean;
    function GetHasData: boolean;

    property IsLoaded: boolean read GetIsLoaded;
    property IsAvailable: boolean read GetIsAvailable;
    property HasData: boolean read GetHasData;
    property Modified: boolean read GetModified;
  protected
    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean; override;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean; override;
    procedure EndLookup; override;
    function GetProviderName: string; override;
    function GetEnabled: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Generics.Defaults,
  UITypes,
  Dialogs,
  Controls,
  IOUtils,
  DateUtils,
  StrUtils,
  Variants,
  XMLDoc, XMLIntf,
  Forms,
  Diagnostics,
  cxGraphics,
  dxCoreGraphics, // To avoid inlining hint
  amCursorService,
  amVersionInfo,
  amFileUtils,
  amPath,
  amProgress.Stream,
  amLocalization.Settings,
  amLocalization.Environment,
  amLocalization.Provider.TranslationMemory;

const
  sTMFileSignature: AnsiString = 'amTranslationManagerTM';

  // 2.1        Locale is saved as LCID
  // 2.2        Locale is saved as RFC 4646 locale name
  TMFileVersionMajor = 2;
  TMFileVersionMinor = 2;

type
  TTMStreamTag = (tmDescription, tmLanguages, tmTerms);

// -----------------------------------------------------------------------------
//
// TTranslationMemoryLookup
//
// -----------------------------------------------------------------------------
type
  TTranslationMemoryLookup = class(TInterfacedObject, ITranslationMemoryLookup)
  private
    FLookupIndex: TTranslationMemoryLookupIndex;
  protected
    // ITranslationMemoryLookup
    function Lookup(const Value: string): TTranslationMemoryRecordList;
    function GetValues: TArray<string>;
  public
    constructor Create(DataSet: TDataSet; Language: TLanguageItem; const Progress: IProgress = nil); overload;
    constructor Create(DataSet: TDataSet; Language: TLanguageItem; SanitizeRules: TSanitizeRules; const Progress: IProgress = nil); overload;
    destructor Destroy; override;
  end;

constructor TTranslationMemoryLookup.Create(DataSet: TDataSet; Language: TLanguageItem; const Progress: IProgress);
begin
  Create(DataSet, Language, TranslationManagerSettings.Editor.SanitizeRules, Progress);
end;

constructor TTranslationMemoryLookup.Create(DataSet: TDataSet; Language: TLanguageItem; SanitizeRules: TSanitizeRules; const Progress: IProgress);
var
  Field: TField;
  Clone: TFDMemTable;
  Value: string;
  List: TTranslationMemoryRecordList;
begin
  inherited Create;

  FLookupIndex := TTranslationMemoryLookupIndex.Create([doOwnsValues], TTextComparer.Create);

  if (Progress <> nil) then
    Progress.Progress(psBegin, 0, DataSet.RecordCount);

  Clone := TFDMemTable.Create(nil);
  try
    Clone.CloneCursor(DataSet as TFDDataSet);

    Field := TDataModuleTranslationMemory.FindField(Clone, Language);
    if (Field = nil) then
      Exit;

    Clone.First;

    while (not Clone.EOF) do
    begin
      if (Progress <> nil) then
        Progress.AdvanceProgress;

      if (not Field.IsNull) then
      begin
        Value := SanitizeText(Field.AsString, SanitizeRules);

        if (not FLookupIndex.TryGetValue(Value, List)) then
        begin
          List := TTranslationMemoryRecordList.Create;
          FLookupIndex.Add(Value, List);
        end;
        List.Add(Clone.RecNo);
      end;

      Clone.Next;
    end;

  finally
    Clone.Free;
  end;

  if (Progress <> nil) then
    Progress.Progress(psEnd, 1, 1);
end;

destructor TTranslationMemoryLookup.Destroy;
begin
  FLookupIndex.Free;
  inherited;
end;

function TTranslationMemoryLookup.GetValues: TArray<string>;
begin
  Result := FLookupIndex.Keys.ToArray;
end;

function TTranslationMemoryLookup.Lookup(const Value: string): TTranslationMemoryRecordList;
begin
  if (not FLookupIndex.TryGetValue(Value, Result)) then
    Result := nil;
end;

// -----------------------------------------------------------------------------
//
// TPeekDictionaryThread
//
// -----------------------------------------------------------------------------
type
  TPeekDictionaryThread = class(TThread)
  private
    FTranslationMemory: TDataModuleTranslationMemory;
    FSourceField, FTargetField: TField;
    FQueryQueue: TList<TLocalizerProperty>;
    FResultQueue: TList<TLocalizerProperty>;
    FQueueEvent: TEvent;
    FDictionary: TStringList;
    FResultHandler: TNotifyEvent;
  protected
    procedure Execute; override;
    procedure TerminatedSet; override;

    procedure Prepare;
    procedure ResultReady;
  public
    constructor Create(ATranslationMemory: TDataModuleTranslationMemory; ASourceField, ATargetField: TField; AResultHandler: TNotifyEvent);
    destructor Destroy; override;

    procedure EnqueueQuery(Prop: TLocalizerProperty);
    procedure ClearQueues;

    function DequeueResult: TLocalizerProperty;
  end;

constructor TPeekDictionaryThread.Create(ATranslationMemory: TDataModuleTranslationMemory; ASourceField, ATargetField: TField; AResultHandler: TNotifyEvent);
begin
  inherited Create(True);

  FTranslationMemory := ATranslationMemory;
  FResultHandler := AResultHandler;
  FSourceField := ASourceField;
  FTargetField := ATargetField;

  FQueryQueue := TList<TLocalizerProperty>.Create;
  FResultQueue := TList<TLocalizerProperty>.Create;
  FQueueEvent := TEvent.Create(nil, False, False, '');
  FDictionary := TStringList.Create;
  FDictionary.CaseSensitive := False;
  FDictionary.Sorted := True;
  FDictionary.Duplicates := dupIgnore;
end;

destructor TPeekDictionaryThread.Destroy;
begin
  FQueryQueue.Free;
  FResultQueue.Free;
  FQueueEvent.Free;
  FDictionary.Free;
  inherited;
end;

procedure TPeekDictionaryThread.ClearQueues;
begin
  System.TMonitor.Enter(FQueryQueue);
  try
    FQueryQueue.Clear;
  finally
    System.TMonitor.Exit(FQueryQueue);
  end;

  System.TMonitor.Enter(FResultQueue);
  try
    FResultQueue.Clear;
  finally
    System.TMonitor.Exit(FResultQueue);
  end;
end;

function TPeekDictionaryThread.DequeueResult: TLocalizerProperty;
begin
  System.TMonitor.Enter(FResultQueue);
  try
    if (FResultQueue.Count > 0) then
    begin
      Result := FResultQueue.Last;
      FResultQueue.Count := FResultQueue.Count-1;
    end else
      Result := nil;
  finally
    System.TMonitor.Exit(FResultQueue);
  end;
end;

procedure TPeekDictionaryThread.EnqueueQuery(Prop: TLocalizerProperty);
begin
  System.TMonitor.Enter(FQueryQueue);
  try
    if (FQueryQueue.Contains(Prop)) then
      Exit;

    FQueryQueue.Add(Prop);
  finally
    System.TMonitor.Exit(FQueryQueue);
  end;
  // Signal thread that there's work to do
  FQueueEvent.SetEvent;
end;

procedure TPeekDictionaryThread.Execute;
var
  Prop: TLocalizerProperty;
  WaitObject: THandleObject;
  ProcessQueue: boolean;
begin

  // Initial index load
  Prepare;

  FQueueEvent.SetEvent;

  while (THandleObject.WaitForMultiple([FTranslationMemory.RefreshEvent, FQueueEvent], INFINITE, False, WaitObject) = wrSignaled) and (not Terminated) do
  begin
    if (WaitObject = FTranslationMemory.RefreshEvent) then
    begin
      // TM has changed. Reload index.
      Prepare;
      continue;
    end else
    if (WaitObject <> FQueueEvent) then
      continue;

    ProcessQueue := True;

    while (ProcessQueue) do
    begin

      // Dequeue a job
      System.TMonitor.Enter(FQueryQueue);
      try
        if (FQueryQueue.Count = 0) then
        begin
          // Queue is empty - wait for a query to be queued
          ProcessQueue := False;
          continue;
        end;

        Prop := FQueryQueue.Last;
        FQueryQueue.Count := FQueryQueue.Count-1;
      finally
        System.TMonitor.Exit(FQueryQueue);
      end;

      // Perform lookup
      System.TMonitor.Enter(FDictionary);
      try
        if (FDictionary.IndexOf(SanitizeText(Prop.Value)) = -1) then
          continue;
      finally
        System.TMonitor.Exit(FDictionary);
      end;

      // Found match - put in result queue
      System.TMonitor.Enter(FResultQueue);
      try
        FResultQueue.Add(Prop);
      finally
        System.TMonitor.Exit(FResultQueue);
      end;

      // Notify client
      if (Assigned(FResultHandler)) then
        Queue(ResultReady);

    end;
  end;
end;

procedure TPeekDictionaryThread.Prepare;
begin
  System.TMonitor.Enter(FDictionary);
  try

    FDictionary.Clear;
    //FDictionary.Sorted := False;

    FTranslationMemory.PopulateDictionary(FSourceField, FTargetField, FDictionary,
      procedure(var Continue: boolean)
      begin
        Continue := not Terminated;
      end);

    //FDictionary.Sorted := True;

  finally
    System.TMonitor.Exit(FDictionary);
  end;
end;

procedure TPeekDictionaryThread.ResultReady;
var
  Prop: TLocalizerProperty;
begin
  if (not Assigned(FResultHandler)) then
    Exit;

  Prop := DequeueResult;

  FResultHandler(Prop);
end;

procedure TPeekDictionaryThread.TerminatedSet;
begin
  inherited;

  // Wake thread so it can terminate
  FQueueEvent.SetEvent;
end;

// -----------------------------------------------------------------------------
//
// TTranslationMemoryLookup
//
// -----------------------------------------------------------------------------
type
  TTranslationMemoryPeek = class(TInterfacedObject, ITranslationMemoryPeek)
  private
    FThread: TPeekDictionaryThread;
  protected
    // ITranslationMemoryPeek
    procedure EnqueueQuery(Prop: TLocalizerProperty);
    procedure Cancel;
  public
    constructor Create(ATranslationMemory: TDataModuleTranslationMemory; SourceField, TargetField: TField; AResultHandler: TNotifyEvent);
    destructor Destroy; override;
  end;

constructor TTranslationMemoryPeek.Create(ATranslationMemory: TDataModuleTranslationMemory; SourceField, TargetField: TField; AResultHandler: TNotifyEvent);
begin
  inherited Create;
  FThread := TPeekDictionaryThread.Create(ATranslationMemory, SourceField, TargetField, AResultHandler);
  FThread.Start;
end;

destructor TTranslationMemoryPeek.Destroy;
begin
  FThread.Terminate;
  FThread.WaitFor;
  FThread.Free;
  inherited;
end;

procedure TTranslationMemoryPeek.EnqueueQuery(Prop: TLocalizerProperty);
begin
  FThread.EnqueueQuery(Prop);
end;

procedure TTranslationMemoryPeek.Cancel;
begin
  FThread.ClearQueues;
end;


// -----------------------------------------------------------------------------
//
// TDataModuleTranslationMemory
//
// -----------------------------------------------------------------------------
constructor TDataModuleTranslationMemory.Create(AOwner: TComponent);
begin
  inherited;

  FFieldLanguage := TDictionary<TField, TLanguageItem>.Create;
  FRefreshEvent := TEvent.Create(nil, False, False, '');
  FEnabled := True;
end;

destructor TDataModuleTranslationMemory.Destroy;
begin
  FLookupIndex := nil;
  FLookupLanguage := nil;

  TranslationProviderRegistry.UnregisterProvider(FProviderHandle);

  FRefreshEvent.Free;
  FFieldLanguage.Free;

  inherited;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.GetProviderName: string;
begin
  Result := sProviderNameTM;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.CheckLoaded(Force: boolean): boolean;
var
  Filename: string;
  Res: integer;
resourcestring
  sLocalizerNoTMFileTitle = 'Translation Memory does not exist';
  sLocalizerNoTMFile = 'The Translation Memory database does not exist.'#13#13'Filename: %s'#13#13'A new database will be created when you save the Translation Memory.'#13#13'Do you want to save an new empty database now?';
begin
  if (not FLoaded) and ((Force) or (TranslationManagerSettings.Providers.TranslationMemory.LoadOnDemand)) then
  begin
    if (not FEnabled) and (not Force) then
      Exit(False);

    Filename := EnvironmentVars.ExpandString(TranslationManagerSettings.Providers.TranslationMemory.Filename);
    Filename := PathUtil.PathCombinePath(TranslationManagerSettings.Folders.FolderAppData, Filename);

    if (not TFile.Exists(Filename)) then
    begin
      Res := TaskMessageDlg(sLocalizerNoTMFileTitle, Format(sLocalizerNoTMFile, [Filename]), mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbNo);

      if (Res = mrCancel) then
      begin
        FEnabled := False;
      end else
      if (Res = mrYes) then
      begin
        // Save empty
        SaveToFile(Filename);
        // ...and load it
        LoadFromFile(Filename);
      end else
      begin
        // Pretend we have loaded to avoid further prompts
        FLoaded := True;
        // Mark as dirty so new file will be saved
        FModified := True;
      end;
    end else
      LoadFromFile(Filename);
  end;

  if (FLoaded) then
    FEnabled := True;

  Result := FLoaded;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.CheckSave: boolean;
var
  Res: integer;
  Filename: string;
resourcestring
  sLocalizerSaveTMPromptTitle = 'Translation Memory has not been saved';
  sLocalizerSaveTMPrompt = 'Your changes to the Translation Memory has not been saved.'#13#13'Do you want to save them now?';
begin
  if (IsLoaded) and (Modified) then
  begin
    if (TranslationManagerSettings.Providers.TranslationMemory.PromptToSave) then
    begin
      Res := TaskMessageDlg(sLocalizerSaveTMPromptTitle, sLocalizerSaveTMPrompt,
        mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbCancel);

      if (Res = mrCancel) then
        Exit(False)
      else
      if (Res = mrNo) then
        Exit(True);
    end;

    SaveCursor(crHourGlass);


    Filename := EnvironmentVars.ExpandString(TranslationManagerSettings.Providers.TranslationMemory.Filename);
    Filename := PathUtil.PathCombinePath(TranslationManagerSettings.Folders.FolderAppData, Filename);

    try

      SaveToFile(Filename);

    except
      on E: EAbort do
        Exit(False);
    end;

    Result := (not Modified);
  end else
    Result := True;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.CreateLookup(Language: TLanguageItem): ITranslationMemoryLookup;
begin
  Result := CreateLookup(Language, TranslationManagerSettings.Editor.SanitizeRules);
end;

function TDataModuleTranslationMemory.CreateLookup(Language: TLanguageItem; SanitizeRules: TSanitizeRules; const Progress: IProgress): ITranslationMemoryLookup;
var
  Field: TField;
begin
  Assert(Language <> nil);

  if (not CheckLoaded) then
    Exit(nil);

  Field := FindField(Language);

  if (Field = nil) then
    Exit(nil);

  Result := TTranslationMemoryLookup.Create(TableTranslationMemory, Language, SanitizeRules, Progress);
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.CreateBackgroundLookup(SourceLanguage, TargetLanguage: TLanguageItem; AResultHandler: TNotifyEvent): ITranslationMemoryPeek;
begin
  if (SourceLanguage = TargetLanguage) then
    Exit(nil);

  if (SourceLanguage = nil) or (TargetLanguage = nil) then
    Exit(nil);

  if (not CheckLoaded) then
    Exit(nil);

  var SourceField := FindField(SourceLanguage);
  var TargetField := FindField(TargetLanguage);

  if (SourceField = nil) or (TargetField = nil) then
    Exit(nil);

  Result := TTranslationMemoryPeek.Create(Self, SourceField, TargetField, AResultHandler);
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.CreateField(LanguageItem: TLanguageItem): TField;
begin
  if (LanguageItem = nil) then
    Exit(nil);

  Result := TWideMemoField.Create(TableTranslationMemory);
  FFieldLanguage.Add(Result, LanguageItem);

  Result.DisplayLabel := LanguageItem.DisplayName;
  Result.FieldName := LanguageItem.LocaleName;
  Result.DataSet := TableTranslationMemory;
  Result.DisplayWidth := 100;
  Result.OnGetText := FieldGetTextEventHandler; // Otherwise memo is edited as "(WIDEMEMO)"
end;

function TDataModuleTranslationMemory.FieldToLanguage(Field: TField): TLanguageItem;
begin
  Result := LanguageInfo.FindLocaleName(Field.FieldName);
end;

function TDataModuleTranslationMemory.GetTranslationMemoryDataSet: TDataSet;
begin
  Result := TableTranslationMemory;
end;

type
  TTableTranslationMemoryClone = class(TInterfacedObject)
  private
    FOriginal: TFDMemTable;
    FClone: TFDMemTable;
  public
    constructor Create(AOriginal: TFDMemTable);
    destructor Destroy; override;
  end;

constructor TTableTranslationMemoryClone.Create(AOriginal: TFDMemTable);
begin
  inherited Create;
  FOriginal := AOriginal;
  FOriginal.DisableControls;

  FClone := TFDMemTable.Create(nil);
  try
    if (FOriginal.Fields.Count > 0) then
      FClone.CopyDataSet(FOriginal, [coStructure, coRestart, coAppend]);
  except
    FreeAndNil(FClone);
    raise;
  end;

  FOriginal.Close;
end;

destructor TTableTranslationMemoryClone.Destroy;
begin
  try
    if (FOriginal.Fields.Count > 0) then
      FOriginal.Open;

    if (FClone <> nil) and (FClone.Fields.Count > 0) then
      FOriginal.CopyDataSet(FClone, [coAppend]);
  finally
    FClone.Free;
  end;

  FOriginal.EnableControls;

  inherited;
end;

function TDataModuleTranslationMemory.SaveTableTranslationMemoryClone: IInterface;
begin
  Result := TTableTranslationMemoryClone.Create(TableTranslationMemory);
end;

// -----------------------------------------------------------------------------

procedure TDataModuleTranslationMemory.FieldGetTextEventHandler(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.FindField(LanguageItem: TLanguageItem): TField;
begin
  // Look for perfect language item match
  for var Pair in FFieldLanguage do
    if (LanguageItem = Pair.Value) then
      Exit(Pair.Key);

  // Match on language properties
  Result := FindField(TableTranslationMemory, LanguageItem);
end;

class function TDataModuleTranslationMemory.FindField(DataSet: TDataSet; LanguageItem: TLanguageItem): TField;
begin
  Result := nil;

  // Look for perfect match on locale name
  for var i := 0 to DataSet.FieldCount-1 do
    if (AnsiSameText(LanguageItem.LocaleName, DataSet.Fields[i].FieldName)) then
      Exit(DataSet.Fields[i]);

  var FieldLanguageItems: TArray<TLanguageItem>;
  Setlength(FieldLanguageItems, DataSet.FieldCount);

  // Look for match on ISO 639-1 (language, invariant) and fill lookup while we're at it
  for var i := 0 to High(FieldLanguageItems) do
  begin
    FieldLanguageItems[i] := LanguageInfo.FindLocaleName(DataSet.Fields[i].FieldName);

    if (LanguageItem.ISO639_1Name = FieldLanguageItems[i].ISO639_1Name) then
      Exit(DataSet.Fields[i]);
  end;

  // Look for match on LCID
  if (not LanguageItem.IsCustomLocale) then
    for var i := 0 to High(FieldLanguageItems) do
      if (LanguageItem.LocaleID = FieldLanguageItems[i].LocaleID) then
        Exit(DataSet.Fields[i]);

  // Recursive match on fallback
  if (LanguageItem.Fallback <> nil) then
    Result := FindField(DataSet, LanguageItem.Fallback);
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.GetIsAvailable: boolean;
begin
  Result := (TranslationManagerSettings.Providers.TranslationMemory.Enabled) and ((FLoaded) or ((FEnabled) and (TranslationManagerSettings.Providers.TranslationMemory.LoadOnDemand)));
end;

function TDataModuleTranslationMemory.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.TranslationMemory.Enabled;
end;

function TDataModuleTranslationMemory.GetHasData: boolean;
begin
  Result := (TableTranslationMemory.Active) and (TableTranslationMemory.RecordCount > 0);
end;

function TDataModuleTranslationMemory.GetIsLoaded: boolean;
begin
  Result := FLoaded;
end;

function TDataModuleTranslationMemory.GetLanguages: TArray<TLanguageItem>;
begin
  SetLength(Result, TableTranslationMemory.FieldCount);

  for var i := 0 to TableTranslationMemory.FieldCount-1 do
    Result[i] := FFieldLanguage[TableTranslationMemory.Fields[i]];
end;

function TDataModuleTranslationMemory.GetModified: boolean;
begin
  Result := FModified;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.AddTerm(SourceField: TField; const SourceValue, SanitizedSourceValue: string;
  TargetField: TField; const TargetValue: string;
  Duplicates: TDuplicates;
  var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction): TTranslationMemoryDuplicateAction;

  function Truncate(const Value: string): string;
  begin
    Result := Value.Replace(#13, ' ',  [rfReplaceAll]).Replace(#10, ' ',  [rfReplaceAll]);
    Result := cxGetStringAdjustedToWidth(0, 0, Result, 250, mstEndEllipsis);
  end;

type
  TDuplicateChoice = (ChoiceAbort, ChoiceAdd, ChoiceSkip);
type
  TRankedDuplicate = record
    Rank: integer;
    Duplicate: integer;
  end;
  TRankedDuplicates = array of TRankedDuplicate;
var
  DuplicateTerms: TDuplicateTerms;
  DuplicateValues: TDuplicateValues;
  Duplicate: TDuplicate;
  i: integer;
  s: string;
  DuplicateTermPair: TPair<TField, TDuplicateTerms>;
  SourceLanguage, TargetLanguage: TLanguageItem;
  SourceLanguageName, TargetLanguageName: string;
  DuplicateCount: integer;
  DuplicateChoice: TDuplicateChoice;
const
  MaxDuplicateCount = 5;
resourcestring
  sTranslationMemoryAddDuplicateTitle = 'Duplicates found';
  sTranslationMemoryAddDuplicate = 'You are adding a term that already has %d translation(s) in the dictionary:'+#13#13+
    '%s:'#13+                   // Source language
    #$25CF+'"%s"'+#13#13+              // Source value
    '%s:'+                      // Target language
    '%s'+#13#13+                // Existing values. No bullet or quotes here. They're added in code.
    'New translation:'#13+
    #$25CF+'"%s"'+#13#13+              // New value
    'Do you want to add the translation anyway?';
  sTranslationMemoryAddDuplicateBullet = #$25CF;
  sTranslationMemoryAddDuplicateMore = '   ...and %d more.';
  sTranslationMemoryDuplicateButtonAll = 'Use this choice for all';
begin
  Assert(SourceField <> TargetField);
  Assert(SourceField <> nil);
  Assert(TargetField <> nil);

  Assert(TableTranslationMemory.Active);

  Result := DuplicateAction;

  if (TargetValue.IsEmpty) then
  begin
    Inc(Stats.Skipped);
    Exit;
  end;

  // Get a list of duplicate source terms
  DuplicateTerms := nil;
  if (not Duplicates.TryGetValue(TargetField, DuplicateTerms)) or (not DuplicateTerms.TryGetValue(SanitizedSourceValue, DuplicateValues)) then
    DuplicateValues := nil;

  // Count of source value diplicates with non-empty target values
  var ActualDuplicateCount := 0;

  if (DuplicateValues <> nil) then
    for i := 0 to DuplicateValues.Count-1 do
    begin
      if (AnsiSameText(SourceValue, DuplicateValues[i].SourceValue)) and (AnsiSameText(TargetValue, DuplicateValues[i].Value)) then
      begin
        // We have an exact duplicate. Keep it and do nothing else.
        Inc(Stats.Duplicate);
        Exit;
      end;

      // We have a match on the source value.
      // If the target values isn't empty then we will need to resolve the duplicate.
      if (not DuplicateValues[i].Value.IsEmpty) then
        Inc(ActualDuplicateCount);
    end;

  // Do not prompt for duplicate with only empty target values - just merge it
  if (ActualDuplicateCount > 0) then
  begin
    DuplicateChoice := ChoiceAbort;
    case DuplicateAction of
      tmDupActionAbort:
        Abort;

      tmDupActionAddAll:
        DuplicateChoice := ChoiceAdd;

      tmDupActionRejectAll:
        DuplicateChoice := ChoiceSkip;
    end;

    if (DuplicateAction = tmDupActionPrompt) then
    begin
      s := '';
      DuplicateCount := 0;
      // Bullet list of target values
      for i := 0 to DuplicateValues.Count-1 do
      begin
        if (DuplicateValues[i].Value.IsEmpty) then
          continue;

        s := s + #13 + sTranslationMemoryAddDuplicateBullet + ' "' + Truncate(DuplicateValues[i].Value) + '"';
        Inc(DuplicateCount);
        // If there's room for one more, but potentially two or more to add, then we display "and then some" message instead
        if (ActualDuplicateCount > MaxDuplicateCount) and (DuplicateCount = MaxDuplicateCount-1) then
        begin
          s := s + #13 + Format(sTranslationMemoryAddDuplicateMore, [ActualDuplicateCount-DuplicateCount]);
          break;
        end;
      end;
      Assert(DuplicateCount > 0);

      SourceLanguage := LanguageInfo.FindLocaleName(SourceField.FieldName);
      if (SourceLanguage <> nil) then
        SourceLanguageName := SourceLanguage.LanguageName
      else
        SourceLanguageName := SourceField.FieldName;
      TargetLanguage := LanguageInfo.FindLocaleName(TargetField.FieldName);
      if (TargetLanguage <> nil) then
        TargetLanguageName := TargetLanguage.LanguageName
      else
        TargetLanguageName := TargetField.FieldName;

      var TaskDialog := TTaskDialog.Create(nil);
      try
        TaskDialog.Title := '';
        TaskDialog.Caption := sTranslationMemoryAddDuplicateTitle;
        TaskDialog.Text := Format(sTranslationMemoryAddDuplicate, [ActualDuplicateCount, SourceLanguageName, Truncate(SourceValue), TargetLanguageName, s, Truncate(TargetValue)]);
        TaskDialog.CommonButtons := [tcbYes, tcbNo, tcbCancel];
        TaskDialog.DefaultButton := tcbNo;
        TaskDialog.VerificationText := sTranslationMemoryDuplicateButtonAll;

        TaskDialog.Execute;

        case TaskDialog.ModalResult of
          mrYes:
            begin
              if (tfVerificationFlagChecked in TaskDialog.Flags) then
                Result := tmDupActionAddAll;
              DuplicateChoice := ChoiceAdd;
            end;

          mrNo:
            begin
              if (tfVerificationFlagChecked in TaskDialog.Flags) then
                Result := tmDupActionRejectAll;
              DuplicateChoice := ChoiceSkip;
            end;
        else
          Result := tmDupActionAbort;
        end;

      finally
        TaskDialog.Free;
      end;

    end;

    if (DuplicateChoice = ChoiceSkip) or (Result in [tmDupActionAbort, tmDupActionRejectAll]) then
    begin
      Inc(Stats.Skipped);
      Exit;
    end;
  end;

  // If we have a duplicate source with an empty target value, then we fill out
  // that empty value with the new target value.
  if (DuplicateValues <> nil) and (DuplicateValues.EmptyCount > 0) then
  begin
    // Create a list of empty entries and rank them
    var EmptyEntries: TRankedDuplicates;
    SetLength(EmptyEntries, DuplicateValues.EmptyCount);
    var Index := 0;
    for i := 0 to DuplicateValues.Count-1 do
    begin
      if (not DuplicateValues[i].Value.IsEmpty) then
        continue;
      EmptyEntries[Index].Duplicate := i;
      EmptyEntries[Index].Rank := RankSimilarity(SourceValue, DuplicateValues[i].SourceValue);
    end;
    // Sort to get best ranked entry - or I could just have picked it up during the loop above...
    TArray.Sort<TRankedDuplicate>(EmptyEntries, TComparer<TRankedDuplicate>.Construct(
      function(const Left, Right: TRankedDuplicate): Integer
      begin
        Result := Right.Rank - Left.Rank;
      end));

    // Fill out best ranked empty entry
    Duplicate := DuplicateValues[EmptyEntries[0].Duplicate];
    Duplicate.Value := MakeAlike(Duplicate.SourceValue, TargetValue);
    DuplicateValues[EmptyEntries[0].Duplicate] := Duplicate;
    Dec(DuplicateValues.EmptyCount);

    // Edit existing entry
    Lock;
    try
      TableTranslationMemory.RecNo := Duplicate.RecordID;
      TableTranslationMemory.Resync([rmExact]);
      TableTranslationMemory.Edit;
      try
        // Source field already has the desired value
        // SourceField.AsString := SourceValue;

        TargetField.AsString := Duplicate.Value;

        TableTranslationMemory.Post;

      except
        TableTranslationMemory.Cancel;
        raise;
      end;
    finally
      Unlock;
    end;
    Inc(Stats.Merged);
  end else
  begin
    // Add new entry
    Lock;
    try
      TableTranslationMemory.Append;
      try
        SourceField.AsString := SourceValue;
        TargetField.AsString := TargetValue;

        TableTranslationMemory.Post;

      except
        TableTranslationMemory.Cancel;
        raise;
      end;
    finally
      Unlock;
    end;
    Inc(Stats.Added);

    // Add new to duplicate list and add empty to all other term lists
    Duplicate.SourceValue := SourceValue;
    Duplicate.RecordID := TableTranslationMemory.RecNo;
    for DuplicateTermPair in Duplicates do
    begin
      if (not DuplicateTermPair.Value.TryGetValue(SanitizedSourceValue, DuplicateValues)) then
      begin
        DuplicateValues := TDuplicateValues.Create;
        DuplicateTermPair.Value.Add(SanitizedSourceValue, DuplicateValues);
      end;

      if (DuplicateTermPair.Key = TargetField) then
        Duplicate.Value := TargetValue
      else
      begin
        Duplicate.Value := '';
        Inc(DuplicateValues.EmptyCount);
      end;

      DuplicateValues.Add(Duplicate);
    end;
  end;

  FModified := True;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.Add(SourceField: TField; const SourceValue: string; TargetField: TField; const TargetValue: string; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction = tmDupActionPrompt): TTranslationMemoryDuplicateAction;
var
  Duplicates: TDuplicates;
  DuplicateTerms: TDuplicateTerms;
  DuplicateValues: TDuplicateValues;
  Duplicate: TDuplicate;
  SanitizedSourceValue: string;
begin
  Stats := Default(TTranslationMemoryMergeStats);
  Result := DuplicateAction;

  if (SourceField = TargetField) then
    Exit;

  if (not CheckLoaded) then
    Exit;

  TableTranslationMemory.DisableControls;
  try
    if (not TableTranslationMemory.Active) then
      TableTranslationMemory.Open;

    SanitizedSourceValue := SanitizeText(SourceValue);

    DuplicateTerms := nil;
    DuplicateValues := nil;
    Duplicates := TDuplicates.Create([doOwnsValues]);
    try
      Duplicate.SourceValue := SourceValue;

      TableTranslationMemory.First;
      while (not TableTranslationMemory.EOF) do
      begin
        if (SourceField.IsNull) or (not AnsiSameText(SanitizedSourceValue, SanitizeText(SourceField.AsString))) then
        begin
          TableTranslationMemory.Next;
          continue;
        end;

        if (not TargetField.IsNull) and (AnsiSameText(SourceValue, SourceField.AsString)) and (AnsiSameText(TargetValue, TargetField.AsString)) then
        begin
          Inc(Stats.Duplicate);
          Exit; // Exact duplicate - do nothing
        end;

        // Source same, target differs
        if (DuplicateTerms = nil) then
        begin
          DuplicateTerms := TDuplicateTerms.Create([doOwnsValues], TTextComparer.Create);
          Duplicates.Add(TargetField, DuplicateTerms);

          DuplicateValues := TDuplicateValues.Create;
          DuplicateTerms.Add(SanitizedSourceValue, DuplicateValues);
        end;

        Duplicate.Value := TargetField.AsString;
        Duplicate.RecordID := TableTranslationMemory.RecNo;

        DuplicateValues.Add(Duplicate);

        if (Duplicate.Value.IsEmpty) then
          Inc(DuplicateValues.EmptyCount);

        TableTranslationMemory.Next;
      end;

      Result := AddTerm(SourceField, SourceValue, SanitizedSourceValue, TargetField, TargetValue, Duplicates, Stats, DuplicateAction);

    finally
      Duplicates.Free;
    end;

  finally
    TableTranslationMemory.EnableControls;
  end;
end;

procedure TDataModuleTranslationMemory.BeginAdd;
begin
  if (FAdding) then
    raise Exception.Create('Nested BeginAdd not allowed');
  FAdding := True;
  FImperfectLanguageMatchPrompt := True;
end;

procedure TDataModuleTranslationMemory.EndAdd;
begin
  if (not FAdding) then
    raise Exception.Create('EndAdd without BeginAdd not allowed');
  FAdding := False;
end;

function TDataModuleTranslationMemory.Add(SourceLanguage: TLanguageItem; const SourceValue: string; TargetLanguage: TLanguageItem; const TargetValue: string; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction = tmDupActionPrompt): TTranslationMemoryDuplicateAction;
var
  SourceField: TField;
  TargetField: TField;
  Clone: TFDMemTable;
resourcestring
  sImperfectLanguageMatch = 'The Translation Memory does not contain the exact language you are adding:'#13#13+'  %s - %s'#13#13+
    'Do you want to create this language in the Translation Memory?'#13#13+
    'If you answer No the following existing language will be used instead:'#13#13+'  %s - %s';
begin
  if (not FAdding) then
    raise Exception.Create('BeginAdd has not been called');

  Stats := Default(TTranslationMemoryMergeStats);
  Result := DuplicateAction;

  if (SourceLanguage = TargetLanguage) then
    Exit;

  Assert(SourceLanguage <> nil);
  Assert(TargetLanguage <> nil);

  if (not CheckLoaded) then
    Exit;

  SourceField := FindField(SourceLanguage);
  TargetField := FindField(TargetLanguage);

  if (TargetField <> nil) then
  begin
    var MatchedLanguage := FFieldLanguage[TargetField];
    if (MatchedLanguage <> TargetLanguage) then
    begin
      var Res: integer;

      if (FImperfectLanguageMatchPrompt) then
      begin
        Res := MessageDlg(Format(sImperfectLanguageMatch, [TargetLanguage.LocaleName, TargetLanguage.LanguageName, MatchedLanguage.LocaleName, MatchedLanguage.LanguageName]),
          mtConfirmation, [mbYes, mbNo, mbCancel], 0, mbCancel);

        FImperfectLanguageMatchPrompt := False;

        if (Res = mrCancel) then
          Exit(tmDupActionAbort);

        if (Res = mrYes) then
          TargetField := nil;
      end;
    end;
  end;

  TableTranslationMemory.DisableControls;
  try
    // If neither the source- nor target languages exists in the dataset then we
    // will need to add them.
    if (SourceField = nil) or (TargetField = nil) then
    begin
      Clone := TFDMemTable.Create(nil);
      try
        Lock;
        try
          (*
          ** Save a copy of the dataset, close the original dataset, add the field(s) and
          ** then restore the dataset from the copy.
          *)
          if (TableTranslationMemory.Fields.Count > 0) then
            Clone.CopyDataSet(TableTranslationMemory, [coStructure, coRestart, coAppend]);

          TableTranslationMemory.Close;

          if (SourceField = nil) then
            SourceField := CreateField(SourceLanguage);
          if (TargetField = nil) then
            TargetField := CreateField(TargetLanguage);

          TableTranslationMemory.Open;

          if (Clone.Fields.Count > 0) then
            TableTranslationMemory.CopyDataSet(Clone, [coAppend]);
        finally
          Unlock;
        end;
      finally
        Clone.Free;
      end;
    end;

    Result := Add(SourceField, SourceValue, TargetField, TargetValue, Stats, DuplicateAction);

  finally
    TableTranslationMemory.EnableControls;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDataModuleTranslationMemory.LoadFromFile(const Filename: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDataModuleTranslationMemory.LoadFromStream(Stream: TStream);
var
  VersionMajor, VersionMinor: integer;

  procedure LoadLanguages(Reader: TReader);
  var
    Field: TField;
  begin
    Reader.ReadInteger; // Ignore count

    Reader.ReadListBegin;
    while (not Reader.EndOfList) do
    begin
      Field := TWideMemoField.Create(TableTranslationMemory);

      Reader.ReadListBegin;
      begin
        var LanguageItem: TLanguageItem;
        if (VersionMajor = 2) and (VersionMinor <= 1) then
        begin
          // v2.1 : Locale is a LCID
          var LocaleID := Reader.ReadInteger;
          LanguageItem := LanguageInfo.FindLCID(LocaleID);
        end else
        begin
          // v2.2+ : Locale is a RFC 4646 locale name
          var LocaleName := Reader.ReadString;
          LanguageItem := LanguageInfo.FindLocaleName(LocaleName);
        end;
        Assert(LanguageItem <> nil);
        FFieldLanguage.Add(Field, LanguageItem);

        Reader.ReadString;
        Field.FieldName := LanguageItem.LocaleName;

        Reader.ReadString;
        Field.DisplayLabel := LanguageItem.DisplayName;

        while (not Reader.EndOfList) do
          Reader.SkipValue;
      end;
      Reader.ReadListEnd;

      Field.DataSet := TableTranslationMemory;
      Field.DisplayWidth := 100;
      Field.OnGetText := FieldGetTextEventHandler; // Otherwise memo is edited as "(WIDEMEMO)"
    end;
    Reader.ReadListEnd;
  end;

  procedure LoadTerms(Reader: TReader);
  var
    s: string;
    i: integer;
  begin
    if (TableTranslationMemory.Fields.Count > 0) then
      TableTranslationMemory.CreateDataSet; // Apperently one cannot create a dataset without fields

    TableTranslationMemory.DisableControls;
    try
      Reader.ReadInteger; // Ignore count

      Reader.ReadListBegin;
      while (not Reader.EndOfList) do
      begin
        TableTranslationMemory.Append;
        try

          Reader.ReadListBegin;
          begin
            for i := 0 to TableTranslationMemory.Fields.Count-1 do
            begin
              s := Reader.ReadString;
              if (s <> '') then
                TableTranslationMemory.Fields[i].AsString := s;
            end;
            // Future version might add additional non-field data. E.g. context info or term description
            while (not Reader.EndOfList) do
              Reader.SkipValue;
          end;
          Reader.ReadListEnd;

          TableTranslationMemory.Post;
        except
          TableTranslationMemory.Cancel;
          raise;
        end;
      end;
      Reader.ReadListEnd;
    finally
      TableTranslationMemory.EnableControls;
    end;
  end;

var
  Signature: AnsiString;
  Reader: TReader;
  n: integer;
  Progress: IProgress;
  ProgressStream: TStream;
{$ifdef TM_BENCHMARK}
var
  StopWatch: TStopWatch;
{$endif TM_BENCHMARK}
const
  cMinProgressSize = 4*1024*1024;
begin
  SaveCursor(crHourGlass);

  ProgressStream := nil;
  try
    if (Stream.Size > cMinProgressSize) then
    begin
      Progress := ShowProgress('Loading Translation Memory');
      Progress.EnableAbort := True;
      Progress.RaiseOnAbort := True;
      ProgressStream := TProgressStream.Create(Stream, Progress);
      Stream := ProgressStream;
    end else
      Progress := nil;

{$ifdef TM_BENCHMARK}
  StopWatch := TStopWatch.StartNew;
{$endif TM_BENCHMARK}

    (*
    ** Signature
    *)
    SetLength(Signature, Length(sTMFileSignature));
    if (Stream.Read(Signature[1], Length(sTMFileSignature)) <> Length(sTMFileSignature)) or (Signature <> sTMFileSignature) then
      raise ETranslationMemory.Create('Invalid TM file signature');

    TableTranslationMemory.Close;
    TableTranslationMemory.Fields.Clear;
    TableTranslationMemory.FieldDefs.Clear;
    FFieldLanguage.Clear;

    Reader := TReader.Create(Stream, 8192);
    try
      (*
      ** Stream format version
      *)
      VersionMajor := Reader.ReadInteger;
      VersionMinor := Reader.ReadInteger;

      if (VersionMajor <> TMFileVersionMajor) then
        raise ETranslationMemory.CreateFmt('Unsupported TM file format version: %d.%d', [VersionMajor, VersionMinor]);

      Reader.ReadListBegin;
      begin
        while (not Reader.EndOfList) do
        begin
          // Read tag
          n := Reader.ReadInteger;
          if (n < Ord(Low(TTMStreamTag))) or (n > Ord(High(TTMStreamTag))) then
          begin
            // Unknown tag - skip block
            Reader.SkipValue;
            continue;
          end;

          Reader.ReadListBegin;
          begin
            case TTMStreamTag(n) of
              tmDescription:
                Reader.ReadString;

              tmLanguages:
                LoadLanguages(Reader);

              tmTerms:
                LoadTerms(Reader);

            else
              Reader.SkipValue;
            end;
          end;
          Reader.ReadListEnd;
        end;
      end;
      Reader.ReadListEnd;
    finally
      Reader.Free;
    end;

{$ifdef TM_BENCHMARK}
    StopWatch.Stop;
    OutputDebugString(PChar(Format('Read TM via TReader: %.2nmS (%d rows/mS)', [StopWatch.ElapsedMilliseconds*1.0, TableTranslationMemory.RecordCount div StopWatch.ElapsedMilliseconds])));
{$endif TM_BENCHMARK}

  finally
    ProgressStream.Free;
  end;

  FModified := False;
  FLoaded := True;
end;

procedure TDataModuleTranslationMemory.SaveToFile(const Filename: string);
begin
  if (not SafeReplaceFile(Filename,
    function(const Filename: string): boolean
    var
      Stream: TStream;
    begin
      Stream := TFileStream.Create(Filename, fmCreate);
      try
        SaveToStream(Stream);
      finally
        Stream.Free;
      end;
      Result := True;
    end, TranslationManagerSettings.Backup.SaveBackups)) then
    Abort;
end;

procedure TDataModuleTranslationMemory.SaveToStream(Stream: TStream);
var
  Progress: IProgress;

  procedure WriteLanguages(Writer: TWriter);
  var
    i: integer;
  begin
    Writer.WriteInteger(TableTranslationMemory.Fields.Count);
    Writer.WriteListBegin;
    begin
      for i := 0 to TableTranslationMemory.Fields.Count-1 do
      begin
        Writer.WriteListBegin;
        begin
          var LanguageItem := FFieldLanguage[TableTranslationMemory.Fields[i]];
          Writer.WriteString(LanguageItem.LocaleName); // RFC 4646 locale name
          Writer.WriteString(LanguageItem.LocaleName); // Field.FieldName
          Writer.WriteString(LanguageItem.DisplayName); // Field.DisplayLabel
        end;
        Writer.WriteListEnd;
      end;
    end;
    Writer.WriteListEnd;
  end;

  procedure WriteTerms(Writer: TWriter);
  var
    i: integer;
  begin
    if (TableTranslationMemory.Active) then
    begin
      Writer.WriteInteger(TableTranslationMemory.RecordCount); // Row list
      Writer.WriteListBegin;
      begin
        TableTranslationMemory.DisableControls;
        try
          TableTranslationMemory.First;
          while (not TableTranslationMemory.Eof) do
          begin
            if (Progress <> nil) then
              Progress.AdvanceProgress;

            Writer.WriteListBegin;
            begin
              for i := 0 to TableTranslationMemory.Fields.Count-1 do
                Writer.WriteString(TableTranslationMemory.Fields[i].AsString); // Field value
            end;
            Writer.WriteListEnd;

            TableTranslationMemory.Next;
          end;
        finally
          TableTranslationMemory.EnableControls;
        end;
      end;
      Writer.WriteListEnd;
    end else
    begin
      Writer.WriteInteger(0);
      Writer.WriteListBegin;
      Writer.WriteListEnd;
    end;
  end;

var
  Writer: TWriter;
{$ifdef TM_BENCHMARK}
var
  StopWatch: TStopWatch;
{$endif TM_BENCHMARK}
const
  cMinProgressCount = 100*1024;
begin
  SaveCursor(crHourGlass);

  if (TableTranslationMemory.RecordCount > cMinProgressCount) then
  begin
    Progress := ShowProgress('Saving Translation Memory');
    Progress.EnableAbort := True;
    Progress.RaiseOnAbort := True;
    Progress.Progress(psBegin, 0, TableTranslationMemory.RecordCount);
  end else
    Progress := nil;

{$ifdef TM_BENCHMARK}
  StopWatch := TStopWatch.StartNew;
{$endif TM_BENCHMARK}

  (*
  ** Signature
  *)
  Stream.Write(sTMFileSignature[1], Length(sTMFileSignature));

  Writer := TWriter.Create(Stream, 8192);
  try
    (*
    ** Stream format version
    *)
    Writer.WriteInteger(TMFileVersionMajor);
    Writer.WriteInteger(TMFileVersionMinor);

    Writer.WriteListBegin;
    begin
      (*
      ** Description
      *)
      Writer.WriteInteger(Ord(tmDescription));
      Writer.WriteListBegin;
      begin
        Writer.WriteString('Default Translation Memory'); // TODO : Localize
      end;
      Writer.WriteListEnd;

      (*
      ** Languages
      *)
      Writer.WriteInteger(Ord(tmLanguages));
      Writer.WriteListBegin;
      begin
        WriteLanguages(Writer);
      end;
      Writer.WriteListEnd;

      (*
      ** Terms
      *)
      Writer.WriteInteger(Ord(tmTerms));
      Writer.WriteListBegin;
      begin
        WriteTerms(Writer);
      end;
      Writer.WriteListEnd;
    end;
    Writer.WriteListEnd;
  finally
    Writer.Free;
  end;

{$ifdef TM_BENCHMARK}
  StopWatch.Stop;
  OutputDebugString(PChar(Format('Save TM via TWriter: %.2nmS (%d rows/mS)', [StopWatch.ElapsedMilliseconds*1.0, TableTranslationMemory.RecordCount div StopWatch.ElapsedMilliseconds])));
{$endif TM_BENCHMARK}

  FModified := False;
end;

procedure TDataModuleTranslationMemory.SetLoaded;
begin
  FLoaded := True;
end;

// -----------------------------------------------------------------------------

procedure TDataModuleTranslationMemory.TableTranslationMemoryAfterModify(DataSet: TDataSet);
begin
  FModified := True;
  FRefreshEvent.SetEvent;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.HasSourceTerm(Prop: TLocalizerProperty; SourceLanguage: TLanguageItem): boolean;
var
  SourceField: TField;
  SourceValue: string;
begin
  if (not CheckLoaded) then
    Exit(False);

  if (not HasData) then
    Exit(False);

  SourceField := FindField(SourceLanguage);

  if (SourceField = nil) then
    // Languages doesn't exist in TM
    Exit(False);

  SourceValue := SanitizeText(Prop.Value);

  // Populate list of matching target terms
  TableTranslationMemory.First;

  while (not TableTranslationMemory.EOF) do
  begin
    if (not SourceField.IsNull) then
    begin
      if (AnsiSameText(SourceValue, SanitizeText(SourceField.AsString))) then
        Exit(True);
    end;

    TableTranslationMemory.Next;
  end;

  Result := False;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.FindTerms(Language: TLanguageItem; const Value: string; LookupResult: TTranslationLookupResult;
  RankResult: boolean): boolean;
begin
  if (not CheckLoaded) then
    Exit(False);

  // Do nothing if there is no data
  if (not HasData) then
    Exit(False);

  var Field := FindField(Language);

  if (Field = nil) then
    // Language doesn't exist in TM
    Exit(False);

  var SanitizedValue := SanitizeText(Value);
  Result := False;

  // Populate list of matching target terms
  TableTranslationMemory.First;

  while (not TableTranslationMemory.EOF) do
  begin
    if (not Field.IsNull) then
    begin
      if (AnsiSameText(SanitizedValue, SanitizeText(Field.AsString))) then
      begin
        // Match found
        LookupResult.Add(Field.AsString, '');
        Result := True;
      end;
    end;

    TableTranslationMemory.Next;
  end;

  // Rank result by source value similarity
  if (RankResult) then
    LookupResult.RankTranslations(Value);
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; LookupResult: TTranslationLookupResult): boolean;
var
  SourceField: TField;
  TargetField: TField;
  SourceValue: string;
begin
  if (not CheckLoaded) then
    Exit(False);

  // Do nothing if there is no data but pretend everything is OK so the user gets normal feedback
  if (not HasData) then
    Exit(True);

  SourceField := FindField(SourceLanguage);
  TargetField := FindField(TargetLanguage);

  if (SourceField = nil) or (TargetField = nil) or (SourceField = TargetField) then
    // One or both languages doesn't exist in TM
    Exit(False);

  SourceValue := SanitizeText(Prop.Value);
  Result := False;

  // Populate list of matching target terms
  TableTranslationMemory.First;

  while (not TableTranslationMemory.EOF) do
  begin
    if (not TargetField.IsNull) and (not SourceField.IsNull) then
    begin
      if (AnsiSameText(SourceValue, SanitizeText(SourceField.AsString))) then
      begin
        // Match found
        LookupResult.Add(SourceField.AsString, TargetField.AsString);
        Result := True;
      end;
    end;

    TableTranslationMemory.Next;
  end;
end;

function TDataModuleTranslationMemory.FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
var
  LookupResult: TTranslationLookupResult;
begin
  if (not CheckLoaded) then
    Exit(False);

  // Do nothing if there is no data but pretend everything is OK so the user gets normal feedback
  if (not HasData) then
    Exit(True);

  LookupResult := TTranslationLookupResult.Create;
  try

    Result := FindTranslations(Prop, SourceLanguage, TargetLanguage, LookupResult);

    if (not Result) then
      Exit;

    // Rank by source value similarity
    LookupResult.RankTranslations(Prop.Value);

    LookupResult.AddToStrings(Translations);

  finally
    LookupResult.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
var
  SourceField, TargetField: TField;
  List: TTranslationMemoryRecordList;
  RecordIndex: integer;
  SourceValue, TargetValue: string;
  LookupResult: TTranslationLookupResult;
begin
  Result := False;

  if (SourceLanguage = TargetLanguage) then
    Exit;

  if (not HasData) then
    Exit;

  SourceField := FindField(SourceLanguage);
  TargetField := FindField(TargetLanguage);

  if (SourceField = nil) or (TargetField = nil) then
    Exit;

  Assert(FLookupIndex <> nil);
  Assert(FLookupLanguage = SourceLanguage);

  SourceValue := SanitizeText(Prop.Value);

  List := FLookupIndex.Lookup(SourceValue);
  if (List = nil) then
    Exit;

  LookupResult := TTranslationLookupResult.Create(List.Count);
  try

    for RecordIndex in List do
    begin
      TableTranslationMemory.RecNo := RecordIndex;

      TargetValue := TargetField.AsString;
      if (TargetValue.IsEmpty) then
        continue;

      SourceValue := SourceField.AsString;

      LookupResult.Add(SourceValue, TargetValue);

      Result := True;
    end;

    // Rank by source value similarity
    LookupResult.RankTranslations(Prop.Value);

    LookupResult.AddToStrings(Translations);

  finally
    LookupResult.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDataModuleTranslationMemory.Lock;
begin
  System.TMonitor.Enter(Self);
end;

procedure TDataModuleTranslationMemory.Unlock;
begin
  System.TMonitor.Exit(Self);
end;

procedure TDataModuleTranslationMemory.PopulateDictionary(SourceField, TargetField: TField; Dictionary: TStringList;
  Callback: TPopulateDictionaryCallback);
var
  Clone: TFDMemTable;
  SourceValue: string;
  Continue: boolean;
begin
  // It is the responsibility of the caller to lock Dictionary
  Dictionary.Clear;

  if (SourceField = nil) or (TargetField = nil) or (SourceField = TargetField) then
    Exit;

  Clone := TFDMemTable.Create(nil);
  try
    // Lock for the duration - we need the data to be stable while we iterate through it
    // (clone shares data with source).
    Lock;
    try

      Clone.CloneCursor(TableTranslationMemory);

      SourceField := Clone.Fields.FieldByName(SourceField.FieldName);
      TargetField := Clone.Fields.FieldByName(TargetField.FieldName);

      // Create dictionary of source terms that has translations
      Clone.First;

      Continue := True;
      while (not Clone.EOF) and (Continue) do
      begin
        if (not TargetField.IsNull) and (not SourceField.IsNull) then
        begin
          SourceValue := SanitizeText(SourceField.AsString);

          // if (Dictionary.IndexOf(SourceValue) = -1) then
          Dictionary.Add(SourceValue);
        end;

        Clone.Next;
        Callback(Continue);
      end;

    finally
      Unlock;
    end;


  finally
    Clone.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TDataModuleTranslationMemory.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
var
  SourceField: TField;
  TargetField: TField;
begin
  FLookupIndex := nil;
  FLookupLanguage := nil;

  if (not CheckLoaded) then
    Exit(False);

  if (SourceLanguage = TargetLanguage) then
    Exit(False);

  // Do nothing if there is no data but pretend everything is OK so the user gets normal feedback
  if (not HasData) then
    Exit(True);

  SourceField := FindField(SourceLanguage);
  TargetField := FindField(TargetLanguage);

  if (SourceField = nil) or (TargetField = nil) then
    // One or both languages doesn't exist in TM
    Exit(False);

  FLookupIndex := CreateLookup(SourceLanguage);
  FLookupLanguage := SourceLanguage;

  Result := True;
end;

procedure TDataModuleTranslationMemory.EndLookup;
begin
  FLookupIndex := nil;
  FLookupLanguage := nil;
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

end.
