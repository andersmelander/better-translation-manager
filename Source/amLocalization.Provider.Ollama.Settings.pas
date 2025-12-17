unit amLocalization.Provider.Ollama.Settings;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  amRegConfig,
  amLocalization.Provider.Ollama.API;

type
  TTranslationManagerProviderOllamaSettings = class(TConfigurationSection, ITranslationProviderSettingsOllama)
  private
    FBaseURL: string;
    FModelName: string;
    FTimeout: integer;
  private
    // ITranslationProviderSettingsOllama
    function GetBaseURL: string;
    function GetModelName: string;
    function GetTimeout: integer;
  protected
    procedure ApplyDefault; override;
  published
    property BaseURL: string read FBaseURL write FBaseURL;
    property ModelName: string read FModelName write FModelName;
    property Timeout: integer read FTimeout write FTimeout default 30000;
  end;

implementation

{ TTranslationManagerProviderOllamaSettings }

procedure TTranslationManagerProviderOllamaSettings.ApplyDefault;
begin
  inherited;

  FBaseURL := 'http://localhost:11434';
  FModelName := '';
  FTimeout := 30000; // 30 seconds
end;

function TTranslationManagerProviderOllamaSettings.GetBaseURL: string;
begin
  Result := FBaseURL;
end;

function TTranslationManagerProviderOllamaSettings.GetModelName: string;
begin
  Result := FModelName;
end;

function TTranslationManagerProviderOllamaSettings.GetTimeout: integer;
begin
  Result := FTimeout;
end;

end.
