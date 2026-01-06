unit amLocalization.Provider.TranslationMemory;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Generics.Collections,
  System.SysUtils, System.Classes,

  amLanguageInfo,
  amLocalization.Model,
  amLocalization.Provider,
  amLocalization.TranslationMemory;

// -----------------------------------------------------------------------------
//
// TTranslationProviderTranslationMemory
//
// -----------------------------------------------------------------------------
type
  TTranslationProviderTranslationMemory = class(TInterfacedObject, ITranslationProvider)
  private
    FTranslationMemory: TList<ITranslationProvider>;
  protected
    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
    procedure EndLookup;
    function GetProviderName: string;
    function GetEnabled: boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

resourcestring
  sProviderNameTM = 'Translation Memory';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------


implementation

uses
  amLocalization.Settings;

// -----------------------------------------------------------------------------
//
// TTranslationProviderTranslationMemory
//
// -----------------------------------------------------------------------------
constructor TTranslationProviderTranslationMemory.Create;
begin
  inherited;

  FTranslationMemory := TList<ITranslationProvider>.Create;
  FTranslationMemory.Add(TranslationMemory.PrimaryProvider as ITranslationProvider);
end;

destructor TTranslationProviderTranslationMemory.Destroy;
begin
  FTranslationMemory.Free;

  inherited;
end;

// -----------------------------------------------------------------------------

function TTranslationProviderTranslationMemory.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
var
  i: integer;
begin
  Result := True;

  i := 0;
  while (i < FTranslationMemory.Count) do
  begin
    if (not FTranslationMemory[i].BeginLookup(SourceLanguage, TargetLanguage)) then
    begin
      Result := False;
      break;
    end;
    Inc(i);
  end;

  if (not Result) then
    while (i >= 0) do
    begin
      FTranslationMemory[i].EndLookup;
      Dec(i);
    end;
end;

procedure TTranslationProviderTranslationMemory.EndLookup;
var
  TranslationProvider: ITranslationProvider;
begin
  for TranslationProvider in FTranslationMemory do
    TranslationProvider.EndLookup;
end;

function TTranslationProviderTranslationMemory.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.TranslationMemory.Enabled;
end;

function TTranslationProviderTranslationMemory.GetProviderName: string;
begin
  Result := sProviderNameTM;
end;

function TTranslationProviderTranslationMemory.Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
var
  TranslationProvider: ITranslationProvider;
begin
  Result := False;
  for TranslationProvider in FTranslationMemory do
    Result := TranslationProvider.Lookup(Prop, SourceLanguage, TargetLanguage, Translations) or Result;
end;

// -----------------------------------------------------------------------------

var
  ProviderHandle: integer = -1;

initialization
  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameTM,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderTranslationMemory.Create;
    end,
    function(): boolean
    begin
      Result := TranslationManagerSettings.Providers.TranslationMemory.Enabled;
    end);

finalization
  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);
end.
