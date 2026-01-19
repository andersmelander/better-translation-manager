unit amLocalization.Provider.Gemini;

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
  amLocalization.Provider,
  amLocalization.Provider.Gemini.API;

// -----------------------------------------------------------------------------
//
// TTranslationProviderGemini
//
// -----------------------------------------------------------------------------

type
  TTranslationProviderGemini = class(TInterfacedObject, ITranslationProvider, ITranslationProviderGemini)
  private
    FSettings: ITranslationProviderSettingsGemini;

  private
    function GetAPIKey: string;
    function GetModelName: string;
    function GetTimeout: integer;
    function GetTemperature: single;
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
    // ITranslationProviderGemini
    function ValidateAPIKey(const AAPIKey: string; var AErrorMessage: string): boolean;
    function ValidateModel(var AErrorMessage: string): boolean;
    function TestTranslation(var AErrorMessage: string): boolean;
    function GetModels(AModelNames: TStrings; var AErrorMessage: string): boolean;

  private
    property APIKey: string read GetAPIKey;
    property ModelName: string read GetModelName;
    property Timeout: integer read GetTimeout;
    property Temperature: single read GetTemperature;
  public
    constructor Create(const ASettings: ITranslationProviderSettingsGemini = nil);
  end;

implementation

uses
  System.Generics.Collections,
  System.NetEncoding,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.JSON,
  amLocalization.Settings,
  amLocalization.Provider.Gemini.Core;

resourcestring
  sProviderNameGemini = 'Google Gemini';

  // Error messages
  sGeminiErrorNoAPIKey = 'Google Gemini API Key is missing';
  sGeminiErrorInvalidAPIKey = 'Invalid Google Gemini API Key';
  sGeminiErrorModelNotFound = 'Model "%s" not found or not available for your API key';
  sGeminiErrorTimeout = 'Translation timeout after %d seconds';
  sGeminiErrorInvalidResponse = 'Invalid response from Google Gemini API';
  sGeminiErrorServerError = 'Google Gemini API error: %s';
  sGeminiErrorEmptyResponse = 'Google Gemini returned empty response';
  sGeminiErrorConfiguration = 'Google Gemini configuration incomplete';
  sGeminiErrorInvalidJSON = 'Invalid JSON response from Google Gemini API';
  sGeminiErrorSafetyFilter = 'Translation was blocked by Google Gemini safety filters';
  sGeminiErrorBlocked = 'Translation was blocked. Reason: %s';

type
  EGeminiLocalizationProvider = class(ELocalizationProvider);

// -----------------------------------------------------------------------------
//
// TTranslationProviderGemini
//
// -----------------------------------------------------------------------------

function TTranslationProviderGemini.GetAPIKey: string;
begin
  Result := FSettings.APIKey;
end;

function TTranslationProviderGemini.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.Ollama.Enabled;
end;

function TTranslationProviderGemini.GetModelName: string;
begin
  Result := FSettings.ModelName;
end;

function TTranslationProviderGemini.GetTemperature: single;
begin
  Result := FSettings.Temperature;
end;

function TTranslationProviderGemini.GetModels(AModelNames: TStrings; var AErrorMessage: string): boolean;
begin
  Result := False;
  AModelNames.Clear;

  if APIKey.Trim.IsEmpty then
  begin
    AErrorMessage := sGeminiErrorNoAPIKey;
    Exit;
  end;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := Timeout;
    HTTPClient.ResponseTimeout := Timeout;

    var URL := 'https://generativelanguage.googleapis.com/v1beta/models?key=' + APIKey;

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode <> 200) then
      begin
        var JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
        if (JSONResponse <> nil) then
        try
          var ErrorObj := JSONResponse.GetValue('error') as TJSONObject;
          if (ErrorObj <> nil) then
            AErrorMessage := ErrorObj.GetValue<string>('message')
          else
            AErrorMessage := HTTPResponse.StatusText;
        finally
          JSONResponse.Free;
        end else
          AErrorMessage := HTTPResponse.StatusText;
        Exit;
      end;

      var JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if (JSONResponse = nil) then
      begin
        AErrorMessage := sGeminiErrorInvalidJSON;
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
            var Name := JSONModel.GetValue<string>('name');
            // Name is usually "models/gemini-1.5-flash", we might want to strip "models/"
            if Name.StartsWith('models/') then
              Name := Name.Substring(7);

            // Only add models that support content generation
            var SupportedMethods := JSONModel.GetValue('supportedGenerationMethods') as TJSONArray;
            if (SupportedMethods <> nil) then
            begin
              for var Method in SupportedMethods do
                if Method.Value = 'generateContent' then
                begin
                  AModelNames.Add(Name);
                  break;
                end;
            end;
          end;
        end;

        Result := True;

      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        AErrorMessage := E.Message;
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderGemini.GetTimeout: integer;
begin
  Result := FSettings.Timeout;
end;

function TTranslationProviderGemini.GetProviderName: string;
begin
  Result := sProviderNameGemini;
end;

function TTranslationProviderGemini.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := TGeminiCore.BuildPrompt(ASourceLang, ATargetLang, AText);
end;

constructor TTranslationProviderGemini.Create(const ASettings: ITranslationProviderSettingsGemini);
begin
  inherited Create;

  if (ASettings <> nil) then
    FSettings := ASettings
  else
    FSettings := TranslationManagerSettings.Providers.Gemini;
end;

function TTranslationProviderGemini.ExtractTranslation(const ARawResponse: string): string;
begin
  Result := TGeminiCore.ExtractTranslation(ARawResponse);
end;

function TTranslationProviderGemini.ValidateAPIKey(const AAPIKey: string; var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  if AAPIKey.Trim.IsEmpty then
  begin
    AErrorMessage := sGeminiErrorNoAPIKey;
    Exit;
  end;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;

    // Use a simple API call to validate the key
    var URL := 'https://generativelanguage.googleapis.com/v1beta/models?key=' + AAPIKey;

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode = 200) then
        Result := True
      else
        AErrorMessage := sGeminiErrorInvalidAPIKey;

    except
      on E: Exception do
        AErrorMessage := E.Message;
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderGemini.ValidateModel(var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  if ModelName.Trim.IsEmpty then
  begin
    AErrorMessage := 'Model name is required';
    Exit;
  end;

  var HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;

    var ModelPath := ModelName;
    if not ModelPath.StartsWith('models/') then
      ModelPath := 'models/' + ModelPath;

    var URL := Format('https://generativelanguage.googleapis.com/v1beta/%s?key=%s', [ModelPath, APIKey]);

    try
      var HTTPResponse := HTTPClient.Get(URL);

      if (HTTPResponse.StatusCode = 200) then
        Result := True
      else
        AErrorMessage := Format(sGeminiErrorModelNotFound, [ModelName]);

    except
      on E: Exception do
        AErrorMessage := E.Message;
    end;

  finally
    HTTPClient.Free;
  end;
end;

function TTranslationProviderGemini.TestTranslation(var AErrorMessage: string): boolean;
begin
  Result := False;
  AErrorMessage := '';

  try
    var Translation := TranslateText('English', 'German', 'Hello world');

    if Translation.Trim.IsEmpty then
    begin
      AErrorMessage := sGeminiErrorEmptyResponse;
      Exit;
    end;

    Result := True;

  except
    on E: ELocalizationProvider do
      AErrorMessage := E.Message;
    on E: Exception do
      AErrorMessage := 'Unexpected error: ' + E.Message;
  end;
end;

function TTranslationProviderGemini.TranslateText(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := '';

  if APIKey.Trim.IsEmpty or ModelName.Trim.IsEmpty then
    raise EGeminiLocalizationProvider.Create(sGeminiErrorConfiguration);

  var Prompt := BuildPrompt(ASourceLang, ATargetLang, AText);

  // Create JSON request for Gemini API
  var RequestJSON := TJSONObject.Create;
  try
    var ContentsArray := TJSONArray.Create;
    RequestJSON.AddPair('contents', ContentsArray);

    var ContentObj := TJSONObject.Create;
    ContentsArray.AddElement(ContentObj);

    var PartsArray := TJSONArray.Create;
    ContentObj.AddPair('parts', PartsArray);

    var PartObj := TJSONObject.Create;
    PartsArray.AddElement(PartObj);
    PartObj.AddPair('text', Prompt);

    var GenerationConfig := TJSONObject.Create;
    RequestJSON.AddPair('generationConfig', GenerationConfig);
    GenerationConfig.AddPair('temperature', TJSONNumber.Create(Temperature));

    var HTTPClient := THTTPClient.Create;
    try
      HTTPClient.ConnectionTimeout := Timeout;
      HTTPClient.ResponseTimeout := Timeout;

      var ModelPath := ModelName;
      if not ModelPath.StartsWith('models/') then
        ModelPath := 'models/' + ModelPath;

      var URL := Format('https://generativelanguage.googleapis.com/v1beta/%s:generateContent?key=%s', [ModelPath, APIKey]);

      var RequestContent := TStringStream.Create(RequestJSON.ToJSON, TEncoding.UTF8);
      try
        try
          var HTTPResponse := HTTPClient.Post(URL, RequestContent, nil, [TNetHeader.Create('Content-Type', 'application/json')]);

          if (HTTPResponse = nil) then
            raise EGeminiLocalizationProvider.Create(sGeminiErrorInvalidResponse);

          if (HTTPResponse.StatusCode <> 200) then
          begin
            var JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
            if (JSONResponse <> nil) then
            try
              var ErrorObj := JSONResponse.GetValue('error') as TJSONObject;
              if (ErrorObj <> nil) then
                raise EGeminiLocalizationProvider.Create(ErrorObj.GetValue<string>('message'))
              else
                raise EGeminiLocalizationProvider.Create(HTTPResponse.StatusText);
            finally
              JSONResponse.Free;
            end else
              raise EGeminiLocalizationProvider.Create(HTTPResponse.StatusText);
          end;

          var ResponseJSON := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
          if (ResponseJSON = nil) then
            raise EGeminiLocalizationProvider.Create(sGeminiErrorInvalidJSON);

          try
            // Check for candidates
            var Candidates := ResponseJSON.GetValue('candidates') as TJSONArray;
            if (Candidates = nil) or (Candidates.Count = 0) then
            begin
                // Check if it was blocked
                var PromptFeedback := ResponseJSON.GetValue('promptFeedback') as TJSONObject;
                if (PromptFeedback <> nil) then
                begin
                    var BlockReason := PromptFeedback.GetValue<string>('blockReason');
                    if not BlockReason.IsEmpty then
                        raise EGeminiLocalizationProvider.CreateFmt(sGeminiErrorBlocked, [BlockReason]);
                end;
                raise EGeminiLocalizationProvider.Create(sGeminiErrorEmptyResponse);
            end;

            var Candidate := Candidates.Items[0] as TJSONObject;

            // Check finish reason
            var FinishReason := Candidate.GetValue<string>('finishReason');
            if (FinishReason <> 'STOP') and (FinishReason <> '') then
            begin
                if FinishReason = 'SAFETY' then
                    raise EGeminiLocalizationProvider.Create(sGeminiErrorSafetyFilter)
                else
                    raise EGeminiLocalizationProvider.CreateFmt(sGeminiErrorBlocked, [FinishReason]);
            end;

            var Content := Candidate.GetValue('content') as TJSONObject;
            if (Content = nil) then
                raise EGeminiLocalizationProvider.Create(sGeminiErrorEmptyResponse);

            var Parts := Content.GetValue('parts') as TJSONArray;
            if (Parts = nil) or (Parts.Count = 0) then
                raise EGeminiLocalizationProvider.Create(sGeminiErrorEmptyResponse);

            var Part := Parts.Items[0] as TJSONObject;
            var RawResponse := Part.GetValue<string>('text');

            if (RawResponse.Trim.IsEmpty) then
              raise EGeminiLocalizationProvider.Create(sGeminiErrorEmptyResponse);

            Result := ExtractTranslation(RawResponse);

          finally
            ResponseJSON.Free;
          end;

        except
          on E: EGeminiLocalizationProvider do
            raise;

          on E: Exception do
          begin
            if E.Message.Contains('timeout') or E.Message.Contains('timed out') then
              raise EGeminiLocalizationProvider.CreateFmt(sGeminiErrorTimeout, [Timeout div 1000])
            else
              raise;
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

function TTranslationProviderGemini.BeginLookup(ASourceLanguage, ATargetLanguage: TLanguageItem): boolean;
begin
  Result := True;
end;

procedure TTranslationProviderGemini.EndLookup;
begin
end;

function TTranslationProviderGemini.Lookup(AProp: TLocalizerProperty;
  ASourceLanguage, ATargetLanguage: TLanguageItem;
  ATranslations: TStrings): boolean;
begin
  var SourceText := AProp.Value;

  var TranslatedText := TranslateText(ASourceLanguage.EnglishLanguageName, ATargetLanguage.EnglishLanguageName, SourceText);

  Result := (TranslatedText <> '');

  if (Result) then
    ATranslations.Text := TranslatedText;
end;

var
  ProviderHandle: integer = -1;

initialization

  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameGemini,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderGemini.Create;
    end,
    function(): boolean
    begin
      Result := TranslationManagerSettings.Providers.Gemini.Enabled;
    end);

finalization

  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);

end.
