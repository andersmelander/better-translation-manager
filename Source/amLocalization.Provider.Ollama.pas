unit amLocalization.Provider.Ollama;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils,
  System.Classes,

  amLanguageInfo,
  amLocalization.Model,
  amLocalization.Provider;

type
  ITranslationProviderOllama = interface
    ['{8B7C4A2E-F3D1-4B9A-9C5E-1D8A3F6B2E4C}']
    function ValidateConnection(const BaseURL: string; var ErrorMessage: string): boolean;
    function ValidateModel(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
    function TestTranslation(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
  end;

// -----------------------------------------------------------------------------
//
// TTranslationProviderOllama
//
// -----------------------------------------------------------------------------

type
  TTranslationProviderOllama = class(TInterfacedObject, ITranslationProvider, ITranslationProviderOllama)
  private
    function GetOllamaBaseURL: string;
    function GetOllamaModel: string;
    function GetOllamaTimeout: integer;
    function TranslateText(const ASourceLang, ATargetLang, AText: string): string;
    function ExtractTranslation(const RawResponse: string): string;
    function BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
  protected
    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
    procedure EndLookup;
    function GetProviderName: string;

    // ITranslationProviderOllama
    function ValidateConnection(const BaseURL: string; var ErrorMessage: string): boolean;
    function ValidateModel(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
    function TestTranslation(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
  public
    property OllamaBaseURL: string read GetOllamaBaseURL;
    property OllamaModel: string read GetOllamaModel;
    property OllamaTimeout: integer read GetOllamaTimeout;
  end;

implementation

uses
  System.NetEncoding,
  System.Net.HttpClient,
  System.JSON,
  amLocalization.Settings,
  amLocalization.Provider.Ollama.Core;

resourcestring
  sProviderNameOllama = 'Ollama (Local LLM)';

  // Error messages
  sOllamaErrorNoServer = 'Cannot connect to Ollama server at %s';
  sOllamaErrorInvalidURL = 'Invalid Ollama server URL';
  sOllamaErrorModelNotFound = 'Model "%s" not found. Install it with: ollama pull %s';
  sOllamaErrorTimeout = 'Translation timeout after %d seconds. Consider increasing timeout or using a smaller model.';
  sOllamaErrorInvalidResponse = 'Invalid response from Ollama server';
  sOllamaErrorServerError = 'Ollama server error: %s';
  sOllamaErrorEmptyResponse = 'Ollama returned empty response';
  sOllamaErrorConfiguration = 'Ollama configuration incomplete. Please configure Base URL and Model.';
  sOllamaErrorModelRequired = 'Model name is required';
  sOllamaErrorInvalidJSON = 'Invalid JSON response from Ollama server';

type
  EOllamaLocalizationProvider = class(ELocalizationProvider);

// -----------------------------------------------------------------------------
//
// TTranslationProviderOllama
//
// -----------------------------------------------------------------------------

function TTranslationProviderOllama.GetOllamaBaseURL: string;
begin
  Result := TranslationManagerSettings.Providers.Ollama.BaseURL;
end;

function TTranslationProviderOllama.GetOllamaModel: string;
begin
  Result := TranslationManagerSettings.Providers.Ollama.Model;
end;

function TTranslationProviderOllama.GetOllamaTimeout: integer;
begin
  Result := TranslationManagerSettings.Providers.Ollama.Timeout;
end;

function TTranslationProviderOllama.GetProviderName: string;
begin
  Result := sProviderNameOllama;
end;

function TTranslationProviderOllama.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := TOllamaCore.BuildPrompt(ASourceLang, ATargetLang, AText);
end;

function TTranslationProviderOllama.ExtractTranslation(const RawResponse: string): string;
begin
  Result := TOllamaCore.ExtractTranslation(RawResponse);
end;

function TTranslationProviderOllama.ValidateConnection(const BaseURL: string; var ErrorMessage: string): boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  URL: string;
begin
  Result := False;
  ErrorMessage := '';

  if BaseURL.Trim.IsEmpty then
  begin
    ErrorMessage := sOllamaErrorInvalidURL;
    Exit;
  end;

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000; // 5 seconds for connection test
    HTTPClient.ResponseTimeout := 5000;

    // Normalize URL
    URL := BaseURL.TrimRight(['/']) + '/api/tags';

    try
      HTTPResponse := HTTPClient.Get(URL);

      if HTTPResponse.StatusCode = 200 then
      begin
        Result := True;
      end else
      begin
        ErrorMessage := Format(sOllamaErrorServerError, [HTTPResponse.StatusText]);
      end;

    except
      on E: Exception do
        ErrorMessage := Format(sOllamaErrorNoServer, [BaseURL]);
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderOllama.ValidateModel(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  URL: string;
  JSONResponse: TJSONObject;
  JSONModels: TJSONArray;
  JSONModel: TJSONObject;
  I: Integer;
  ModelFound: Boolean;
begin
  Result := False;
  ErrorMessage := '';

  if ModelName.Trim.IsEmpty then
  begin
    ErrorMessage := sOllamaErrorModelRequired;
    Exit;
  end;

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;

    URL := BaseURL.TrimRight(['/']) + '/api/tags';

    try
      HTTPResponse := HTTPClient.Get(URL);

      if HTTPResponse.StatusCode <> 200 then
      begin
        ErrorMessage := Format(sOllamaErrorServerError, [HTTPResponse.StatusText]);
        Exit;
      end;

      JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if JSONResponse = nil then
      begin
        ErrorMessage := sOllamaErrorInvalidJSON;
        Exit;
      end;

      try
        JSONModels := JSONResponse.GetValue('models') as TJSONArray;
        if JSONModels = nil then
        begin
          ErrorMessage := sOllamaErrorInvalidResponse;
          Exit;
        end;

        ModelFound := False;
        for I := 0 to JSONModels.Count - 1 do
        begin
          JSONModel := JSONModels.Items[I] as TJSONObject;
          if JSONModel <> nil then
          begin
            if SameText(JSONModel.GetValue<string>('name'), ModelName) then
            begin
              ModelFound := True;
              Break;
            end;
          end;
        end;

        if ModelFound then
          Result := True
        else
          ErrorMessage := Format(sOllamaErrorModelNotFound, [ModelName, ModelName]);

      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        ErrorMessage := Format(sOllamaErrorNoServer, [BaseURL]);
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderOllama.TestTranslation(const BaseURL, ModelName: string; var ErrorMessage: string): boolean;
var
  Translation: string;
begin
  Result := False;
  ErrorMessage := '';

  try
    Translation := TranslateText('English', 'German', 'Hello world');

    if Translation.Trim.IsEmpty then
    begin
      ErrorMessage := sOllamaErrorEmptyResponse;
      Exit;
    end;

    // Verify we got a different string (not just echoing input)
    if SameText(Translation.Trim, 'Hello world') then
    begin
      ErrorMessage := 'Translation appears to be echoing input. Please verify model is working correctly.';
      Exit;
    end;

    Result := True;

  except
    on E: EOllamaLocalizationProvider do
      ErrorMessage := E.Message;
    on E: Exception do
      ErrorMessage := 'Unexpected error: ' + E.Message;
  end;
end;

function TTranslationProviderOllama.TranslateText(const ASourceLang, ATargetLang, AText: string): string;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  RequestJSON: TJSONObject;
  OptionsJSON: TJSONObject;
  ResponseJSON: TJSONObject;
  RequestContent: TStringStream;
  URL: string;
  Prompt: string;
  RawResponse: string;
begin
  Result := '';

  // Validate configuration
  if OllamaBaseURL.Trim.IsEmpty or OllamaModel.Trim.IsEmpty then
    raise EOllamaLocalizationProvider.Create(sOllamaErrorConfiguration);

  // Build the prompt
  Prompt := BuildPrompt(ASourceLang, ATargetLang, AText);

  // Create JSON request
  RequestJSON := TJSONObject.Create;
  try
    RequestJSON.AddPair('model', OllamaModel);
    RequestJSON.AddPair('prompt', Prompt);
    RequestJSON.AddPair('stream', TJSONBool.Create(False));

    // Add options for consistent translation
    OptionsJSON := TJSONObject.Create;
    OptionsJSON.AddPair('temperature', TJSONNumber.Create(0.1));
    OptionsJSON.AddPair('top_p', TJSONNumber.Create(0.9));
    RequestJSON.AddPair('options', OptionsJSON);

    HTTPClient := THTTPClient.Create;
    try
      HTTPClient.ConnectionTimeout := OllamaTimeout;
      HTTPClient.ResponseTimeout := OllamaTimeout;

      URL := OllamaBaseURL.TrimRight(['/']) + '/api/generate';

      RequestContent := TStringStream.Create(RequestJSON.ToJSON, TEncoding.UTF8);
      try
        try
          HTTPResponse := HTTPClient.Post(URL, RequestContent, nil, [TNetHeader.Create('Content-Type', 'application/json')]);

          if HTTPResponse = nil then
            raise EOllamaLocalizationProvider.Create(sOllamaErrorInvalidResponse);

          case HTTPResponse.StatusCode of
            200:
              begin
                ResponseJSON := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
                if ResponseJSON = nil then
                  raise EOllamaLocalizationProvider.Create(sOllamaErrorInvalidJSON);

                try
                  RawResponse := ResponseJSON.GetValue<string>('response');
                  if RawResponse.Trim.IsEmpty then
                    raise EOllamaLocalizationProvider.Create(sOllamaErrorEmptyResponse);

                  Result := ExtractTranslation(RawResponse);

                finally
                  ResponseJSON.Free;
                end;
              end;

            404:
              raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorModelNotFound, [OllamaModel, OllamaModel]);

          else
            raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorServerError, [HTTPResponse.StatusText]);
          end;

        except
          on E: EOllamaLocalizationProvider do
            raise;
          on E: Exception do
          begin
            if E.Message.Contains('timeout') or E.Message.Contains('timed out') then
              raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorTimeout, [OllamaTimeout div 1000])
            else
              raise EOllamaLocalizationProvider.Create(Format(sOllamaErrorNoServer, [OllamaBaseURL]));
          end;
        end;

      finally
        RequestContent.Free;
      end;

    finally
      HTTPClient.Free;
    end;

  finally
    RequestJSON.Free;
  end;
end;

function TTranslationProviderOllama.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
begin
  Result := True;
end;

procedure TTranslationProviderOllama.EndLookup;
begin
end;

function TTranslationProviderOllama.Lookup(Prop: TLocalizerProperty;
  SourceLanguage, TargetLanguage: TLanguageItem;
  Translations: TStrings): boolean;
var
  SourceText: string;
  TranslatedText: string;
begin
  SourceText := Prop.Value;

  // Use EnglishName for language names in the prompt
  TranslatedText := TranslateText(SourceLanguage.EnglishLanguageName, TargetLanguage.EnglishLanguageName, SourceText);

  Result := (TranslatedText <> '');

  if (Result) then
    Translations.Text := TranslatedText;
end;

var
  ProviderHandle: integer = -1;

initialization
  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameOllama,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderOllama.Create;
    end);

finalization

  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);

end.
