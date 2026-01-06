unit amLocalization.Provider.Ollama;

(*
 * Copyright © 2025 Basti-Fantasti
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
  amLocalization.Provider,
  amLocalization.Provider.Ollama.API;

// -----------------------------------------------------------------------------
//
// TTranslationProviderOllama
//
// -----------------------------------------------------------------------------

type
  TTranslationProviderOllama = class(TInterfacedObject, ITranslationProvider, ITranslationProviderOllama)
  private
    FSettings: ITranslationProviderSettingsOllama;

  private
    function GetBaseURL: string;
    function GetModelName: string;
    function GetTimeout: integer;
    function TranslateText(const ASourceLang, ATargetLang, AText: string): string;
    function ExtractTranslation(const ARawResponse: string): string;
    function BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;

  private
    // ITranslationProvider
    function BeginLookup(ASourceLanguage, ATargetLanguage: TLanguageItem): boolean;
    function Lookup(AProp: TLocalizerProperty; ASourceLanguage, ATargetLanguage: TLanguageItem; ATranslations: TStrings): boolean;
    procedure EndLookup;
    function GetProviderName: string;
    function GetEnabled: boolean;

  private
    // ITranslationProviderOllama
    function ValidateConnection(var AErrorMessage: string): boolean;
    function ValidateModel(var AErrorMessage: string): boolean;
    function TestTranslation(var AErrorMessage: string): boolean;
    function GetModels(AModelNames: TStrings; var AErrorMessage: string): boolean;

  private
    property BaseURL: string read GetBaseURL;
    property ModelName: string read GetModelName;
    property Timeout: integer read GetTimeout;
  public
    constructor Create(const ASettings: ITranslationProviderSettingsOllama = nil);
  end;

implementation

uses
  System.Generics.Collections, // inlining
  System.NetEncoding,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.JSON,
  amLocalization.Settings,
  amLocalization.Provider.Ollama.Core;

resourcestring
  sProviderNameOllama = 'Ollama (Local LLM)';

  // Error messages
  sOllamaErrorNoServer = 'Cannot connect to Ollama server at %s';
  sOllamaErrorInvalidURL = 'Invalid Ollama server URL';
  sOllamaErrorModelNotFound = 'Model "%0:s" not found. Install it with: ollama pull %0:s';
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

function TTranslationProviderOllama.GetBaseURL: string;
begin
  Result := FSettings.BaseURL;
end;

function TTranslationProviderOllama.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.Ollama.Enabled;
end;

function TTranslationProviderOllama.GetModelName: string;
begin
  Result := FSettings.ModelName;
end;

function TTranslationProviderOllama.GetModels(AModelNames: TStrings; var AErrorMessage: string): boolean;
begin
  Result := False;
  AModelNames.Clear;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := Timeout;
    HTTPClient.ResponseTimeout := Timeout;

    var URL := BaseURL.TrimRight(['/']) + '/api/tags';

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode <> 200) then
      begin
        AErrorMessage := Format('Failed to query models: %s', [HTTPResponse.StatusText]);
        Exit;
      end;

      var JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;

      if (JSONResponse = nil) then
      begin
        AErrorMessage := 'Invalid JSON response from Ollama server.';
        Exit;
      end;

      try
        var JSONModels := JSONResponse.GetValue('models') as TJSONArray;

        if (JSONModels = nil) then
        begin
          AErrorMessage := 'No models found in response.';
          Exit;
        end;

        for var Item in JSONModels do
        begin
          var JSONModel := Item as TJSONObject;

          if (JSONModel <> nil) then
          begin
            var ModelName := JSONModel.GetValue<string>('name');
            AModelNames.Add(ModelName);
          end;
        end;

        Result := True;

      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        AErrorMessage := Format('Failed to connect to Ollama server: %s', [E.Message]);
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderOllama.GetTimeout: integer;
begin
  Result := FSettings.Timeout;
end;

function TTranslationProviderOllama.GetProviderName: string;
begin
  Result := sProviderNameOllama;
end;

function TTranslationProviderOllama.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := TOllamaCore.BuildPrompt(ASourceLang, ATargetLang, AText);
end;

constructor TTranslationProviderOllama.Create(const ASettings: ITranslationProviderSettingsOllama);
begin
  inherited Create;

  if (ASettings <> nil) then
    FSettings := ASettings
  else
    FSettings := TranslationManagerSettings.Providers.Ollama;
end;

function TTranslationProviderOllama.ExtractTranslation(const ARawResponse: string): string;
begin
  Result := TOllamaCore.ExtractTranslation(ARawResponse);
end;

function TTranslationProviderOllama.ValidateConnection(var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  if BaseURL.Trim.IsEmpty then
  begin
    AErrorMessage := sOllamaErrorInvalidURL;
    Exit;
  end;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000; // 5 seconds for connection test
    HTTPClient.ResponseTimeout := 5000;

    // Normalize URL
    var URL := BaseURL.TrimRight(['/']) + '/api/tags';

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode = 200) then
        Result := True
      else
        AErrorMessage := Format(sOllamaErrorServerError, [HTTPResponse.StatusText]);

    except
      on E: Exception do
        AErrorMessage := Format(sOllamaErrorNoServer, [BaseURL]);
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderOllama.ValidateModel(var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  if ModelName.Trim.IsEmpty then
  begin
    AErrorMessage := sOllamaErrorModelRequired;
    Exit;
  end;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;

    var URL := BaseURL.TrimRight(['/']) + '/api/tags';

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode <> 200) then
      begin
        AErrorMessage := Format(sOllamaErrorServerError, [HTTPResponse.StatusText]);
        Exit;
      end;

      var JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;

      if (JSONResponse = nil) then
      begin
        AErrorMessage := sOllamaErrorInvalidJSON;
        Exit;
      end;

      try
        var JSONModels := JSONResponse.GetValue('models') as TJSONArray;

        if (JSONModels = nil) then
        begin
          AErrorMessage := sOllamaErrorInvalidResponse;
          Exit;
        end;

        for var Item in JSONModels do
        begin
          var JSONModel := Item as TJSONObject;

          if (JSONModel <> nil) and (SameText(JSONModel.GetValue<string>('name'), ModelName)) then
          begin
            Result := True;
            Exit;
          end;
        end;

        AErrorMessage := Format(sOllamaErrorModelNotFound, [ModelName, ModelName]);

      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        AErrorMessage := Format(sOllamaErrorNoServer, [BaseURL]);
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderOllama.TestTranslation(var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  try
    var Translation := TranslateText('English', 'German', 'Hello world');

    if Translation.Trim.IsEmpty then
    begin
      AErrorMessage := sOllamaErrorEmptyResponse;
      Exit;
    end;

    // Verify we got a different string (not just echoing input)
    if SameText(Translation.Trim, 'Hello world') then
    begin
      AErrorMessage := 'Translation appears to be echoing input. Please verify model is working correctly.';
      Exit;
    end;

    Result := True;

  except
    on E: EOllamaLocalizationProvider do
      AErrorMessage := E.Message;
    on E: Exception do
      AErrorMessage := 'Unexpected error: ' + E.Message;
  end;
end;

function TTranslationProviderOllama.TranslateText(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := '';

  // Validate configuration
  if BaseURL.Trim.IsEmpty or ModelName.Trim.IsEmpty then
    raise EOllamaLocalizationProvider.Create(sOllamaErrorConfiguration);

  // Build the prompt
  var Prompt := BuildPrompt(ASourceLang, ATargetLang, AText);

  // Create JSON request
  var RequestJSON := TJSONObject.Create;
  try
    RequestJSON.AddPair('model', ModelName);
    RequestJSON.AddPair('prompt', Prompt);
    RequestJSON.AddPair('stream', TJSONBool.Create(False));

    // Add options for consistent translation
    var OptionsJSON := TJSONObject.Create;
    OptionsJSON.AddPair('temperature', TJSONNumber.Create(0.1));
    OptionsJSON.AddPair('top_p', TJSONNumber.Create(0.9));
    RequestJSON.AddPair('options', OptionsJSON);

    var HTTPClient := THTTPClient.Create;
    try
      HTTPClient.ConnectionTimeout := Timeout;
      HTTPClient.ResponseTimeout := Timeout;

      var URL := BaseURL.TrimRight(['/']) + '/api/generate';

      var RequestContent := TStringStream.Create(RequestJSON.ToJSON, TEncoding.UTF8);
      try
        try
          var HTTPResponse := HTTPClient.Post(URL, RequestContent, nil, [TNetHeader.Create('Content-Type', 'application/json')]);

          if (HTTPResponse = nil) then
            raise EOllamaLocalizationProvider.Create(sOllamaErrorInvalidResponse);

          case HTTPResponse.StatusCode of
            200:
              begin
                var ResponseJSON := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
                if (ResponseJSON = nil) then
                  raise EOllamaLocalizationProvider.Create(sOllamaErrorInvalidJSON);

                try

                  var RawResponse := ResponseJSON.GetValue<string>('response');
                  if (RawResponse.Trim.IsEmpty) then
                    raise EOllamaLocalizationProvider.Create(sOllamaErrorEmptyResponse);

                  Result := ExtractTranslation(RawResponse);

                finally
                  ResponseJSON.Free;
                end;
              end;

            404:
              raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorModelNotFound, [ModelName]);

          else
            raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorServerError, [HTTPResponse.StatusText]);
          end;

        except
          on E: EOllamaLocalizationProvider do
            raise;

          on E: Exception do
          begin
            if E.Message.Contains('timeout') or E.Message.Contains('timed out') then
              raise EOllamaLocalizationProvider.CreateFmt(sOllamaErrorTimeout, [Timeout div 1000])
            else
              raise EOllamaLocalizationProvider.Create(Format(sOllamaErrorNoServer, [BaseURL]));
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

function TTranslationProviderOllama.BeginLookup(ASourceLanguage, ATargetLanguage: TLanguageItem): boolean;
begin
  Result := True;
end;

procedure TTranslationProviderOllama.EndLookup;
begin
end;

function TTranslationProviderOllama.Lookup(AProp: TLocalizerProperty;
  ASourceLanguage, ATargetLanguage: TLanguageItem;
  ATranslations: TStrings): boolean;
begin
  var SourceText := AProp.Value;

  // Use EnglishName for language names in the prompt
  var TranslatedText := TranslateText(ASourceLanguage.EnglishLanguageName, ATargetLanguage.EnglishLanguageName, SourceText);

  Result := (TranslatedText <> '');

  if (Result) then
    ATranslations.Text := TranslatedText;
end;

var
  ProviderHandle: integer = -1;

initialization

  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameOllama,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderOllama.Create;
    end,
    function(): boolean
    begin
      Result := TranslationManagerSettings.Providers.Ollama.Enabled;
    end);

finalization

  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);

end.
