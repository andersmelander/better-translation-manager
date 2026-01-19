unit amLocalization.Provider.Gemini.Core;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils;

type
  TGeminiCore = class
  public
    /// <summary>
    /// Builds a translation prompt for the Gemini LLM.
    /// </summary>
    class function BuildPrompt(const ASourceLang, ATargetLang, AText: string): string; static;

    /// <summary>
    /// Extracts clean translation from Gemini's raw response.
    /// </summary>
    class function ExtractTranslation(const RawResponse: string): string; static;
  end;

implementation

uses
  System.RegularExpressions;

{ TGeminiCore }

class function TGeminiCore.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := Format(
    'You are a professional translator.'#13#10 +
    'Translate the following text from %s to %s.'#13#10 +
    #13#10 +
    'Rules:'#13#10 +
    '- Output ONLY the translated text'#13#10 +
    '- Do not add explanations, notes, or any other additional text'#13#10 +
    '- Preserve the original formatting and punctuation'#13#10 +
    '- Maintain the same level of formality'#13#10 +
    '- Keep any placeholders (e.g. %%s, %%d, {0}) exactly as they are'#13#10 +
    #13#10 +
    'Text to translate:'#13#10 +
    '%s',
    [ASourceLang, ATargetLang, AText]);
end;

class function TGeminiCore.ExtractTranslation(const RawResponse: string): string;
var
  CleanResponse: string;
begin
  CleanResponse := RawResponse.Trim;

  // Remove common prefixes if any (Gemini usually follows instructions well)
  CleanResponse := TRegEx.Replace(CleanResponse, '^(Translation:|Translated text:|Result:|The translation is:)', '', [roIgnoreCase]);

  // Trim again
  CleanResponse := CleanResponse.Trim;

  // Remove surrounding quotes if the model added them
  if (CleanResponse.Length >= 2) and
     ((CleanResponse[1] = '"') and (CleanResponse[CleanResponse.Length] = '"')) then
    CleanResponse := CleanResponse.Substring(1, CleanResponse.Length - 2);

  Result := CleanResponse;
end;

end.
