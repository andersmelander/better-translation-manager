unit amLocalization.Provider.Ollama.Core;

(*
 * Copyright © 2025 Basti-Fantasti
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

(*
 * Core Ollama provider logic without UI dependencies.
 *
 * This unit contains pure functions for building prompts and extracting
 * translations from Ollama responses. It has no dependencies on DevExpress
 * or other UI frameworks, making it suitable for unit testing in CI environments.
 *)

interface

uses
  System.SysUtils;

type
  TOllamaCore = class
  public
    /// <summary>
    /// Builds a translation prompt for the Ollama LLM.
    /// </summary>
    /// <param name="ASourceLang">Source language name (e.g., "English")</param>
    /// <param name="ATargetLang">Target language name (e.g., "German")</param>
    /// <param name="AText">Text to translate</param>
    /// <returns>Complete prompt string for Ollama</returns>
    class function BuildPrompt(const ASourceLang, ATargetLang, AText: string): string; static;

    /// <summary>
    /// Extracts clean translation from Ollama's raw response.
    /// Removes common LLM prefixes, quotes, and whitespace.
    /// </summary>
    /// <param name="RawResponse">Raw response from Ollama</param>
    /// <returns>Cleaned translation text</returns>
    class function ExtractTranslation(const RawResponse: string): string; static;
  end;

implementation

uses
  System.RegularExpressions;

{ TOllamaCore }

class function TOllamaCore.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := Format(
    'Translate the following text from %s to %s.'#13#10 +
    'Rules:'#13#10 +
    '- Output ONLY the translated text'#13#10 +
    '- Do not add explanations, notes, or comments'#13#10 +
    '- Preserve the original formatting and punctuation'#13#10 +
    '- Maintain the same level of formality'#13#10 +
    #13#10 +
    'Text to translate:'#13#10 +
    '%s',
    [ASourceLang, ATargetLang, AText]);
end;

class function TOllamaCore.ExtractTranslation(const RawResponse: string): string;
var
  CleanResponse: string;
begin
  CleanResponse := RawResponse.Trim;

  // Remove common prefixes that LLMs often add
  CleanResponse := TRegEx.Replace(CleanResponse, '^(Translation:|Translated text:|Here is the translation:|Result:|The translation is:|In \w+:|>\s*)', '', [roIgnoreCase]);

  // Trim again after removing prefixes
  CleanResponse := CleanResponse.Trim;

  // Remove surrounding quotes if present
  if (CleanResponse.Length >= 2) and
     ((CleanResponse[1] = '"') and (CleanResponse[CleanResponse.Length] = '"')) then
    CleanResponse := CleanResponse.Substring(1, CleanResponse.Length - 2);

  Result := CleanResponse;
end;

end.
