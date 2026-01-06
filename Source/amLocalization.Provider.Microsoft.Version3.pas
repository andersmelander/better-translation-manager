unit amLocalization.Provider.Microsoft.Version3;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils, System.Classes,
  IPPeerClient, REST.Client, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,

  amLanguageInfo,
  amLocalization.Model,
  amLocalization.Provider;

type
  ITranslationProviderMicrosoftV3 = interface
    ['{BCB967CF-9D86-404E-824F-3952F31B4AEC}']
    function ValidateAPIKey(const APIKey, Region: string; var ErrorMessage: string): boolean;
  end;

// -----------------------------------------------------------------------------
//
// TTranslationProviderMicrosoftV3
//
// -----------------------------------------------------------------------------
type
  TDataModule = TTranslationProviderDataModule;

type
  TTranslationProviderMicrosoftV3 = class(TDataModule, ITranslationProviderMicrosoftV3)
    RESTRequestTranslate: TRESTRequest;
    RESTResponseResult: TRESTResponse;
    RESTClient: TRESTClient;
    RESTRequestLanguages: TRESTRequest;
    RESTRequestValidateAPIKey: TRESTRequest;
  private
  protected
    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean; override;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean; override;
    function GetProviderName: string; override;
    function GetEnabled: boolean; override;

    // ITranslationProviderMicrosoftV3
    function ValidateAPIKey(const APIKey, Region: string; var ErrorMessage: string): boolean;
  public
  end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  Generics.Collections,
  SyncObjs,
  System.json,
  System.json.Types,
  System.json.Writers,
  Dialogs,
  amLocalization.Normalization,
  amLocalization.Settings;


{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

resourcestring
  sProviderNameMSTranslator = 'Microsoft Translation Service';

// -----------------------------------------------------------------------------
//
// TTranslationProviderMicrosoftV3
//
// -----------------------------------------------------------------------------
function TTranslationProviderMicrosoftV3.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
resourcestring
  sPrompMicrosoftV3APIKey = 'You must register an API key before the Microsoft Translator v3 service can be used.';
begin
  if (TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey = '') then
  begin
    ShowMessage(sPrompMicrosoftV3APIKey);
    Exit(False);
  end else
    RESTClient.Params[0].Value := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey;

  RESTClient.Params[1].Value := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Region;

  Result := True;
end;

function TTranslationProviderMicrosoftV3.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Enabled;
end;

function TTranslationProviderMicrosoftV3.GetProviderName: string;
begin
  Result := sProviderNameMSTranslator;
end;

function TTranslationProviderMicrosoftV3.Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
var
  JsonResultArray: TJsonArray;
  JsonTranslationItem: TJsonObject;
  JsonTranslationItemArray: TJsonArray;
  JsonError: TJsonObject;
  Msg: string;
  SourceValue: string;
  TargetValue: string;
begin
  SourceValue := SanitizeText(Prop.Value);

  RESTRequestTranslate.Params[0].Value := SourceLanguage.LocaleName;
  RESTRequestTranslate.Params[1].Value := TargetLanguage.LocaleName;

  RESTRequestTranslate.Body.ClearBody;
  RESTRequestTranslate.Body.JSONWriter.WriteStartArray;
  RESTRequestTranslate.Body.JSONWriter.WriteStartObject;
  RESTRequestTranslate.Body.JSONWriter.WritePropertyName('Text');
  RESTRequestTranslate.Body.JSONWriter.WriteValue(SourceValue);
  RESTRequestTranslate.Body.JSONWriter.WriteEndObject;
  RESTRequestTranslate.Body.JSONWriter.WriteEndArray;

  // Call web service
  RESTRequestTranslate.Execute;

  // Get result
  if (RESTResponseResult.JSONValue.TryGetValue<TJsonObject>('error', JsonError)) then
  begin
    Msg := JsonError.GetValue<string>('message');
    raise Exception.CreateFmt('REST call failed'#13'Error message: %s'#13#13'%s', [Msg, RESTResponseResult.Content]);
    TargetValue := JsonError.Value;

    Result := False;
  end else
  begin
    // API key is valid - Save it if we haven't already
    if (TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey = '') then
      TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey := RESTClient.Params[0].Value;
    if (TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Region = '') then
      TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Region := RESTClient.Params[1].Value;

    JsonResultArray := RESTResponseResult.JSONValue as TJsonArray;
    JsonTranslationItem := JsonResultArray.items[0] as TJsonObject;
    JsonTranslationItemArray := JsonTranslationItem.GetValue('translations') as TJsonArray;
    TargetValue :=  JsonTranslationItemArray.Items[0].GetValue<string>('text');

    // Service does not explicitly state if no translation was found but instead just returns Target=Source
    Result := (not AnsiSameText(SourceValue, TargetValue));

    if (Result) then
    begin
      TargetValue := MakeAlike(Prop.Value, TargetValue);

      Translations.Add(TargetValue);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TTranslationProviderMicrosoftV3.ValidateAPIKey(const APIKey, Region: string; var ErrorMessage: string): boolean;
var
  JsonError: TJsonObject;
begin
  // Call web service
  RESTClient.Params[0].Value := APIKey;
  RESTClient.Params[1].Value := Region;

  RESTRequestValidateAPIKey.Body.ClearBody;
  RESTRequestValidateAPIKey.Body.JSONWriter.WriteStartArray;
  RESTRequestValidateAPIKey.Body.JSONWriter.WriteStartObject;
  RESTRequestValidateAPIKey.Body.JSONWriter.WritePropertyName('Text');
  RESTRequestValidateAPIKey.Body.JSONWriter.WriteValue('hello world');
  RESTRequestValidateAPIKey.Body.JSONWriter.WriteEndObject;
  RESTRequestValidateAPIKey.Body.JSONWriter.WriteEndArray;

  RESTRequestValidateAPIKey.Execute;

  // Get result
  if (RESTResponseResult.JSONValue.TryGetValue<TJsonObject>('error', JsonError)) then
  begin
    ErrorMessage := JsonError.GetValue<string>('message');
    Exit(False);
  end;

  ErrorMessage := '';
  Result := True;
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

var
  ProviderHandle: integer = -1;

initialization
  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameMSTranslator,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderMicrosoftV3.Create(nil);
    end,
    function(): boolean
    begin
      Result := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Enabled;
    end);

finalization
  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);
end.
