unit amLocalization.Provider.Ollama.API;

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
  ITranslationProviderOllama = interface
    ['{8B7C4A2E-F3D1-4B9A-9C5E-1D8A3F6B2E4C}']
    function ValidateConnection(var ErrorMessage: string): boolean;
    function ValidateModel(var ErrorMessage: string): boolean;
    function TestTranslation(var ErrorMessage: string): boolean;

    function GetModels(AModelNames: TStrings; var ErrorMessage: string): boolean;
  end;

type
  ITranslationProviderSettingsOllama = interface
    ['{BF61E119-E4CE-4363-9A4B-CCF3A43E357C}']
    function GetBaseURL: string;
    function GetModelName: string;
    function GetTimeout: integer;

    property BaseURL: string read GetBaseURL;
    property ModelName: string read GetModelName;
    property Timeout: integer read GetTimeout;
  end;

implementation

end.
