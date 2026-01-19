unit amLocalization.Provider.Gemini.API;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Classes;

type
  ITranslationProviderGemini = interface
    ['{7D4B2A3E-E2C1-4C9A-8D5F-2E8B3F6C2E4D}']
    function ValidateAPIKey(const AAPIKey: string; var ErrorMessage: string): boolean;
    function ValidateModel(var ErrorMessage: string): boolean;
    function TestTranslation(var ErrorMessage: string): boolean;

    function GetModels(AModelNames: TStrings; var ErrorMessage: string): boolean;
  end;

type
  ITranslationProviderSettingsGemini = interface
    ['{C062E220-F5DF-4474-AB5C-DD04B54F468D}']
    function GetAPIKey: string;
    function GetModelName: string;
    function GetTimeout: integer;
    function GetTemperature: single;

    property APIKey: string read GetAPIKey;
    property ModelName: string read GetModelName;
    property Timeout: integer read GetTimeout;
    property Temperature: single read GetTemperature;
  end;

implementation

end.
