unit amLocalization.Provider.DeepL;

(*
 * Copyright © 2023 atiburzi
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils,
  System.Classes,
  System.Diagnostics,

  amLanguageInfo,
  amLocalization.Model,
  amLocalization.Provider;

type
  ITranslationProviderDeepL = interface
    ['{0C0FEE40-4DB1-4462-A3EA-9CE4D5F1B49B}']
    function ValidateAPIKey(const APIKey: string; Pro: boolean; var ErrorMessage: string): boolean;
  end;

// -----------------------------------------------------------------------------
//
// TTranslationProviderDeepL
//
// -----------------------------------------------------------------------------

type
  TTranslationProviderDeepL = class(TInterfacedObject, ITranslationProvider, ITranslationProviderDeepL)
  public const
    DeepLAPIAddressFree = 'https://api-free.deepl.com/v2/translate';
    DeepLAPIAddressPro = 'https://api.deepl.com/v2/translate';
  private
    FMinRequestInterval: integer; // Min delay between requests
    FLastRequest: TStopWatch; // Time of last request
    FBackoffCooldown: integer; // Number of requests until backoff recovery
  private const
    ThrottleBackoffFactor = 2.0;
    ThrottleRecoverFactor = 0.5;
    ThrottleMinRequestInterval = 250; // Minimal delay between requests if rate error occurs
    ThrottleMaxRequestInterval = 8000; // Max delay between requests
    ThrottleCooldownCount = 5; // After X requests, start recovery
  private
    function GetDeepLAPIAddress: string;
    function GetDeepLAPIKey: string;
    function TranslateText(const ASourceLang, ATargetLang, AText: string): string;
  protected
    // ITranslationProvider
    function BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
    function Lookup(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean;
    procedure EndLookup;
    function GetProviderName: string;
    function GetEnabled: boolean;
  protected
    // ITranslationProviderDeepL
    function ValidateAPIKey(const APIKey: string; Pro: boolean; var ErrorMessage: string): boolean;
  public
    property DeepLAPIAddress: string read GetDeepLAPIAddress;
    property DeepLAPIKey: string read GetDeepLAPIKey;
  end;

implementation

uses
  Vcl.Dialogs,
  System.StrUtils,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding,
  System.JSON,
  System.Generics.Collections,
  System.Math,
  amLocalization.Normalization,
  amLocalization.Settings;

resourcestring
  sProviderNameDeepL = 'DeepL Translation Service';

const
  DeepLValidLanguages: array of string = ['BG', 'CS', 'DA', 'DE', 'EL', 'EN', 'ES',
    'ET', 'FI', 'FR', 'HU', 'ID', 'IT', 'JA', 'KO', 'LT', 'LV', 'NB', 'NL',
    'PL', 'PT', 'RO', 'RU', 'SK', 'SL', 'SV', 'TR', 'UK', 'ZH'];

type
  EDeepLLocalizationProvider = class(ELocalizationProvider);

resourcestring
  sDeepLErrorInvalidAPIKey = 'Invalid API Key. Please verify the DeepL configuration settings';
  sDeepLErrorInvalidSourceLang = 'Unsupported source language for the traslation (%s)';
  sDeepLErrorInvalidTargetLang = 'Unsupported target language for the traslation (%s)';
  sDeepLErrorMoreThanOneTranslation = 'DeepL server returned none or more than one translation';
  sDeepLErrorInvalidTranslation = 'DeepL server returned an invalid translation';
  sDeepLErrorInvalidResponse = 'DeepL server returned an invalid response';
  sDeepLErrorEmptyResponse = 'DeepL server returned an empty response';
  sDeepLErrorTooManyRequests = 'Too many requests for the DeepL server. Please wait and send your request again.';
  sDeepLErrorGeneralException = 'DeepL server invalid Response - Code: %s - %s';
  sDeepLErrorUnefinedResponse = 'Undefined response from DeepL server.';
  sDeepLErrorForbidden = 'DeepL server rejected the request (forbidden access), please check the validity or the version of the API Key';


// -----------------------------------------------------------------------------
//
// TTranslationProviderDeepL
//
// -----------------------------------------------------------------------------
function TTranslationProviderDeepL.ValidateAPIKey(const APIKey: string; Pro: boolean; var ErrorMessage: string): boolean;
begin
  Result := (RightStr(APIKey, 3) = ':fx');
  if (not Result) then
    ErrorMessage := sDeepLErrorInvalidAPIKey;
end;

function TTranslationProviderDeepL.TranslateText(const ASourceLang, ATargetLang, AText: string): string;
var
  Msg: string;

  RequestClient: THTTPClient;
  RequestParams: TStringList;
  RespStream: TStringStream;
  Headers: TNetHeaders;
  HTTPResponse: IHTTPResponse;

  JSONResponse, JSONTranslationItem: TJSONObject;
  JSONResultArray: TJSONArray;
  TextResponse: string;
begin

  Result := '';

  // Verify the validity of the input parameters
  if (not ValidateAPIKey(DeepLAPIKey, TranslationManagerSettings.Providers.DeepL.ProVersion, Msg)) then
    raise EDeepLLocalizationProvider.Create(Msg);

  if not MatchText(ASourceLang, DeepLValidLanguages) then
    raise EDeepLLocalizationProvider.CreateFmt(sDeepLErrorInvalidSourceLang, [ASourceLang]);

  if not MatchText(ATargetLang, DeepLValidLanguages) then
    raise EDeepLLocalizationProvider.CreateFmt(sDeepLErrorInvalidTargetLang, [ASourceLang]);

  RequestClient := THTTPClient.Create;

  try
    RequestParams := TStringList.Create;
    RespStream := TStringStream.Create('', TEncoding.UTF8);

    try
      // Authentication Header
      SetLength(Headers, 2);
      Headers[0].Name := 'Authorization';
      Headers[0].Value := 'DeepL-Auth-Key ' + DeepLAPIKey;
      Headers[1].Name := 'Content-Type';
      Headers[1].Value := 'application/x-www-form-urlencoded';

      // POST Parameters
      RequestParams.Clear;
      RequestParams.Add('text=' + AText);
      RequestParams.Add('source_lang=' + ASourceLang);
      RequestParams.Add('target_lang=' + ATargetLang);
      RequestParams.Add('split_sentences=0');
      RequestParams.Add('preserve_formatting=1');
      RequestParams.Add('formality=default');

      while True do
      begin
        // Throttle requests
        if (FLastRequest.IsRunning) and
           (FLastRequest.ElapsedMilliseconds < FMinRequestInterval) then
          Sleep(FMinRequestInterval);

        // Call web service
        HTTPResponse := RequestClient.Post(
          DeepLAPIAddress,
          RequestParams,
          RespStream,
          TEncoding.UTF8,
          Headers
        );

        FLastRequest := TStopWatch.StartNew;

        if (HTTPResponse <> nil) and (HTTPResponse.StatusCode = 429) then
        begin

          FBackoffCooldown := ThrottleCooldownCount;

          if FMinRequestInterval = 0 then
            FMinRequestInterval := ThrottleMinRequestInterval
          else if FMinRequestInterval < ThrottleMaxRequestInterval then
            FMinRequestInterval := Min(
              ThrottleMaxRequestInterval,
              Trunc(FMinRequestInterval * ThrottleBackoffFactor)
            )
          else
            Break;
        end
        else
          Break;
      end;

      // Checks the possible exceptions on the result
      if HTTPResponse = nil then
        raise EDeepLLocalizationProvider.Create(sDeepLErrorUnefinedResponse);

      case HTTPResponse.StatusCode of

        200: // Response ok
          begin

            TextResponse := RespStream.DataString;

            if TextResponse.IsEmpty then
              raise EDeepLLocalizationProvider.Create(sDeepLErrorEmptyResponse);

            JSONResponse := TJSONObject.ParseJSONValue(TextResponse) as TJSONObject;
            if JSONResponse = nil then
              raise EDeepLLocalizationProvider.Create(sDeepLErrorInvalidResponse);

            try
              JSONResultArray := JSONResponse.GetValue('translations') as TJSONArray;
              if (JSONResultArray = nil) or (JSONResultArray.Count = 0) then
                raise EDeepLLocalizationProvider.Create(sDeepLErrorInvalidResponse);

              JSONTranslationItem := JSONResultArray.Items[0] as TJSONObject;
              Result := JSONTranslationItem.GetValue<string>('text');

            finally
              JSONResponse.Free;
            end;

            // Throttling backoff recovery
            if FBackoffCooldown > 0 then
            begin
              Dec(FBackoffCooldown);

              if FBackoffCooldown = 0 then
              begin
                FMinRequestInterval := Max(
                  ThrottleMinRequestInterval,
                  Trunc(FMinRequestInterval * ThrottleRecoverFactor)
                );

                if FMinRequestInterval > ThrottleMinRequestInterval then
                  FBackoffCooldown := ThrottleCooldownCount; // Start counter for next recovery
              end;
            end;
          end;

        429: // Other responses
          raise EDeepLLocalizationProvider.Create(sDeepLErrorTooManyRequests);

        403:
          raise EDeepLLocalizationProvider.Create(sDeepLErrorForbidden);

      else
        raise EDeepLLocalizationProvider.CreateFmt(
          sDeepLErrorGeneralException,
          [HTTPResponse.StatusCode.ToString, HTTPResponse.StatusText]
        );
      end;

    finally
      RespStream.Free;
      RequestParams.Free;
    end;

  finally
    RequestClient.Free;
  end;

end;

function TTranslationProviderDeepL.BeginLookup(SourceLanguage, TargetLanguage: TLanguageItem): boolean;
begin
  Result := True;
end;

procedure TTranslationProviderDeepL.EndLookup;
begin
end;

function TTranslationProviderDeepL.GetDeepLAPIAddress: string;
begin
  if TranslationManagerSettings.Providers.DeepL.ProVersion then
    Result := DeepLAPIAddressPro
  else
    Result := DeepLAPIAddressFree;
end;

function TTranslationProviderDeepL.GetDeepLAPIKey: string;
begin
  Result := TranslationManagerSettings.Providers.DeepL.APIKey;
end;

function TTranslationProviderDeepL.GetEnabled: boolean;
begin
  Result := TranslationManagerSettings.Providers.DeepL.Enabled;
end;

function TTranslationProviderDeepL.GetProviderName: string;
begin
  Result := sProviderNameDeepL;
end;

function TTranslationProviderDeepL.Lookup(Prop: TLocalizerProperty;
  SourceLanguage, TargetLanguage: TLanguageItem;
  Translations: TStrings): boolean;
var
  SourceText: string;
  TranslatedText: string;
begin
  SourceText := Prop.Value;

  TranslatedText := TranslateText(SourceLanguage.ISO639_1Name, TargetLanguage.ISO639_1Name, SourceText);

  Result := (TranslatedText <> '');

  if (Result) then
    Translations.Text := TranslatedText;
end;

var
  ProviderHandle: integer = -1;

initialization
  ProviderHandle := TranslationProviderRegistry.RegisterProvider(sProviderNameDeepL,
    function(): ITranslationProvider
    begin
      Result := TTranslationProviderDeepL.Create;
    end,
    function(): boolean
    begin
      Result := TranslationManagerSettings.Providers.DeepL.Enabled;
    end);

finalization

  TranslationProviderRegistry.UnregisterProvider(ProviderHandle);

end.
