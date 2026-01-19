unit amLocalization.Provider.Gemini.Settings;

(*
 * Copyright © 2026 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  amLocalization.Provider.Settings,
  amLocalization.Provider.Gemini.API;

type
  TTranslationManagerProviderGeminiSettings = class(TCustomTranslationManagerProviderSettings, ITranslationProviderSettingsGemini)
  private
    FAPIKey: string;
    FModelName: string;
    FTimeout: integer;
    FTemperature: single;
    FRateLimit: integer;
  private
    // ITranslationProviderSettingsGemini
    function GetAPIKey: string;
    function GetModelName: string;
    function GetTimeout: integer;
    function GetTemperature: single;
    function GetRateLimit: integer;
  protected
    procedure ApplyDefault; override;
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property ModelName: string read FModelName write FModelName;
    property Timeout: integer read FTimeout write FTimeout default 30000;
    property Temperature: single read FTemperature write FTemperature;
    property RateLimit: integer read FRateLimit write FRateLimit default 15; // Requests Per Minute
  end;

implementation

{ TTranslationManagerProviderGeminiSettings }

procedure TTranslationManagerProviderGeminiSettings.ApplyDefault;
begin
  inherited;

  FAPIKey := '';
  FModelName := 'gemini-1.5-flash';
  FTimeout := 30000; // 30 seconds
  FTemperature := 0.2;
  FRateLimit := 15;
end;

function TTranslationManagerProviderGeminiSettings.GetAPIKey: string;
begin
  Result := FAPIKey;
end;

function TTranslationManagerProviderGeminiSettings.GetModelName: string;
begin
  Result := FModelName;
end;

function TTranslationManagerProviderGeminiSettings.GetRateLimit: integer;
begin
  Result := FRateLimit;
end;

function TTranslationManagerProviderGeminiSettings.GetTimeout: integer;
begin
  Result := FTimeout;
end;

function TTranslationManagerProviderGeminiSettings.GetTemperature: single;
begin
  Result := FTemperature;
end;

end.
