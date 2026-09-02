unit amLocalization.Provider.Gemini.Core;

(*
 * Copyright © 2026 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils;

type
  TLineBreakType = (lbLF, lbCRLF, lbCR);

  TGeminiCore = class
  public
    /// <summary>
    /// Builds a translation prompt for the Gemini LLM.
    /// </summary>
    class function BuildPrompt(const ASourceLang, ATargetLang, AText: string): string; static;

    /// <summary>
    /// Extracts clean translation from Gemini's raw response.
    /// </summary>
    class function ExtractTranslation(const ARawResponse: string): string; static;

    /// <summary>
    /// Normalizes all line break variations (CRLF, CR) to LF.
    /// </summary>
    class function NormalizeLineBreaks(const AText: string): string; static;

    /// <summary>
    /// Detects the predominant line break type in the text.
    /// </summary>
    class function DetectLineBreakType(const AText: string): TLineBreakType; static;

    /// <summary>
    /// Restores line breaks from LF to the specified type.
    /// </summary>
    class function RestoreLineBreaks(const AText: string; AType: TLineBreakType): string; static;
  end;

implementation

uses
  System.RegularExpressions,
  System.JSON;

{ TGeminiCore }

class function TGeminiCore.NormalizeLineBreaks(const AText: string): string;
begin
  // Replace CRLF with LF
  Result := AText.Replace(#13#10, #10);
  // Replace remaining CR with LF
  Result := Result.Replace(#13, #10);
end;

class function TGeminiCore.DetectLineBreakType(const AText: string): TLineBreakType;
begin
  if AText.Contains(#13#10) then
    Result := lbCRLF
  else
  if AText.Contains(#10) then
    Result := lbLF
  else
    Result := lbCR;
end;

class function TGeminiCore.RestoreLineBreaks(const AText: string; AType: TLineBreakType): string;
begin
  case AType of
    lbCRLF:
      Result := AText.Replace(#10, #13#10);

    lbCR:
      Result := AText.Replace(#10, #13);
  else
    Result := AText;
  end;
end;

class function TGeminiCore.BuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
const
  {$TEXTBLOCK LF}
  sPrompt = '''
    You are a professional translator expert in %s.
    Translate the text delimited by <source> and </source> from %s to %s.

    Strict Rules:
    1. Output ONLY the translated text wrapped in <translation> and </translation> tags.
    2. Do not add a line break after <translation> or before </translation>; The translated text must start immediately after <translation> and end immediately before </translation>.
    3. DO NOT add any commentary, explanations or notes outside the tags..
    4. PRESERVE ALL LINE BREAKS EXACTLY as they appear in the source. This is critical.
    5. DO NOT merge lines. If there is a line break in the source, there MUST be a line break in the translation.
    6. DO NOT merge paragraphs even if they seem like they should be a single paragraph.
    7. Preserve all white space, punctuation, and formatting.
    8. Keep placeholders like %%s, %%d, {0}, etc. unchanged.
    9. Maintain the original tone and level of formality.

    Text to translate:
    <source>%s</source>
    ''';
begin
  Result := Format(sPrompt, [ATargetLang, ASourceLang, ATargetLang, AText]);
end;

class function TGeminiCore.ExtractTranslation(const ARawResponse: string): string;
begin
  Result := ARawResponse.Trim;

  // Try to extract from <translation> tags
  var TagStart := Pos('<translation>', Result);
  var TagEnd := Pos('</translation>', Result);
  if (TagStart > 0) and (TagEnd > TagStart) then
  begin
    Result := Copy(Result, TagStart + 13, TagEnd - (TagStart + 13));
    Exit;
  end;

  // Fallback: Check for JSON just in case
  var LValue := TJSONObject.ParseJSONValue(Result);

  if (LValue <> nil) then
  begin
    try
      if (LValue is TJSONObject) then
      begin
        if TJSONObject(LValue).TryGetValue<string>('translation', Result) then
          Exit;
      end;
    finally
      LValue.Free;
    end;
  end;

  // Remove markdown code blocks
  if Result.StartsWith('```') then
  begin
    var Lines := Result.Split([#10]);

    if (Length(Lines) >= 3) and Lines[0].StartsWith('```') and Lines[High(Lines)].StartsWith('```') then
    begin
      Result := string.Join(#10, Lines, 1, Length(Lines)-2);

      // Try parsing the cleaned JSON again
      var CleanJSON := TJSONObject.ParseJSONValue(Result) as TJSONObject;
      if CleanJSON <> nil then
      begin
        try
          if CleanJSON.TryGetValue<string>('translation', Result) then
            Exit;
        finally
          CleanJSON.Free;
        end;
      end;
    end;
  end;

  // Final fallback to raw string cleaning
  Result := TRegEx.Replace(Result, '^(Translation:|Translated text:|Result:|The translation is:)\s*', '', [roIgnoreCase]);

  if Result.StartsWith('<translation>', True) then
    Delete(Result, 1, 6);
  if Result.EndsWith('</translation>', True) then
    Delete(Result, Result.Length - 6, 7);
(*
  if (Result.Length >= 2) and (Result[1] = '"') and (Result[Result.Length] = '"') then
    Result := Result.Substring(1, Result.Length - 2);
*)
end;

end.
