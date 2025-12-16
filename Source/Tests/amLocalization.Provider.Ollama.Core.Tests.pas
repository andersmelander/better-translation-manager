unit amLocalization.Provider.Ollama.Core.Tests;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

(*
 * DUnitX tests for Ollama core logic.
 *
 * These tests have no DevExpress dependencies and can run in CI environments
 * without requiring commercial UI framework licenses.
 *)

interface

uses
  DUnitX.TestFramework,
  System.SysUtils;

type
  [TestFixture]
  TTestOllamaCore = class
  public
    // Response filtering tests
    [Test]
    procedure TestExtractTranslation_CleanResponse;
    [Test]
    procedure TestExtractTranslation_WithTranslationPrefix;
    [Test]
    procedure TestExtractTranslation_WithTranslatedTextPrefix;
    [Test]
    procedure TestExtractTranslation_WithHereIsPrefix;
    [Test]
    procedure TestExtractTranslation_WithResultPrefix;
    [Test]
    procedure TestExtractTranslation_WithTheTranslationIsPrefix;
    [Test]
    procedure TestExtractTranslation_WithLanguagePrefix;
    [Test]
    procedure TestExtractTranslation_WithQuotes;
    [Test]
    procedure TestExtractTranslation_WithWhitespace;
    [Test]
    procedure TestExtractTranslation_MultipleNewlines;
    [Test]
    procedure TestExtractTranslation_CombinedPrefixAndQuotes;
    [Test]
    procedure TestExtractTranslation_EmptyString;
    [Test]
    procedure TestExtractTranslation_OnlyWhitespace;
    [Test]
    procedure TestExtractTranslation_QuotedWithWhitespace;

    // Prompt building tests
    [Test]
    procedure TestBuildPrompt_BasicStructure;
    [Test]
    procedure TestBuildPrompt_ContainsLanguages;
    [Test]
    procedure TestBuildPrompt_ContainsText;
    [Test]
    procedure TestBuildPrompt_ContainsRules;
    [Test]
    procedure TestBuildPrompt_SpecialCharacters;
    [Test]
    procedure TestBuildPrompt_MultilineText;
    [Test]
    procedure TestBuildPrompt_EmptyText;
    [Test]
    procedure TestBuildPrompt_LongText;
  end;

implementation

uses
  amLocalization.Provider.Ollama.Core;

{ TTestOllamaCore }

{ Response Filtering Tests }

procedure TTestOllamaCore.TestExtractTranslation_CleanResponse;
var
  Input, Expected, Actual: string;
begin
  Input := 'Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Clean response should be returned as-is');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithTranslationPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Translation: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithTranslatedTextPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translated text: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Translated text: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithHereIsPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Here is the translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Here is the translation: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithResultPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Result: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Result: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithTheTranslationIsPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'The translation is: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'The translation is: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithLanguagePrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'In German: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'In <language>: prefix should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithQuotes;
var
  Input, Expected, Actual: string;
begin
  Input := '"Hallo Welt"';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Surrounding quotes should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_WithWhitespace;
var
  Input, Expected, Actual: string;
begin
  Input := '   Hallo Welt   ';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Leading/trailing whitespace should be trimmed');
end;

procedure TTestOllamaCore.TestExtractTranslation_MultipleNewlines;
var
  Input, Expected, Actual: string;
begin
  Input := #13#10'Hallo Welt'#13#10;
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Newlines should be trimmed');
end;

procedure TTestOllamaCore.TestExtractTranslation_CombinedPrefixAndQuotes;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translation: "Hallo Welt"';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Both prefix and quotes should be removed');
end;

procedure TTestOllamaCore.TestExtractTranslation_EmptyString;
var
  Input, Expected, Actual: string;
begin
  Input := '';
  Expected := '';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Empty string should remain empty');
end;

procedure TTestOllamaCore.TestExtractTranslation_OnlyWhitespace;
var
  Input, Expected, Actual: string;
begin
  Input := '   '#13#10'   ';
  Expected := '';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Whitespace-only string should become empty');
end;

procedure TTestOllamaCore.TestExtractTranslation_QuotedWithWhitespace;
var
  Input, Expected, Actual: string;
begin
  Input := '  "Hallo Welt"  ';
  Expected := 'Hallo Welt';
  Actual := TOllamaCore.ExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Quotes with surrounding whitespace should be handled');
end;

{ Prompt Building Tests }

procedure TTestOllamaCore.TestBuildPrompt_BasicStructure;
var
  Prompt: string;
begin
  Prompt := TOllamaCore.BuildPrompt('English', 'German', 'Hello');
  Assert.IsNotEmpty(Prompt, 'Prompt should not be empty');
  Assert.IsTrue(Prompt.Length > 50, 'Prompt should contain instructions');
end;

procedure TTestOllamaCore.TestBuildPrompt_ContainsLanguages;
var
  Prompt: string;
begin
  Prompt := TOllamaCore.BuildPrompt('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'English', True, 'Prompt should contain source language');
  Assert.Contains(Prompt, 'German', True, 'Prompt should contain target language');
end;

procedure TTestOllamaCore.TestBuildPrompt_ContainsText;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello world';
  Prompt := TOllamaCore.BuildPrompt('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should contain the text to translate');
end;

procedure TTestOllamaCore.TestBuildPrompt_ContainsRules;
var
  Prompt: string;
begin
  Prompt := TOllamaCore.BuildPrompt('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'Rules:', True, 'Prompt should contain rules');
  Assert.Contains(Prompt, 'ONLY the translated text', True, 'Prompt should instruct for clean output');
  Assert.Contains(Prompt, 'formatting', True, 'Prompt should mention formatting preservation');
end;

procedure TTestOllamaCore.TestBuildPrompt_SpecialCharacters;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello & goodbye "world"';
  Prompt := TOllamaCore.BuildPrompt('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should preserve special characters');
end;

procedure TTestOllamaCore.TestBuildPrompt_MultilineText;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Line 1'#13#10'Line 2'#13#10'Line 3';
  Prompt := TOllamaCore.BuildPrompt('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should preserve multiline text');
end;

procedure TTestOllamaCore.TestBuildPrompt_EmptyText;
var
  Prompt: string;
begin
  Prompt := TOllamaCore.BuildPrompt('English', 'German', '');
  Assert.IsNotEmpty(Prompt, 'Prompt should not be empty even with empty text');
  Assert.Contains(Prompt, 'English', True, 'Prompt should still contain languages');
  Assert.Contains(Prompt, 'German', True, 'Prompt should still contain languages');
end;

procedure TTestOllamaCore.TestBuildPrompt_LongText;
var
  Prompt: string;
  TestText: string;
begin
  // Test with a longer text (100+ words)
  TestText := 'This is a longer text that contains multiple sentences. ' +
              'It is designed to test how the prompt builder handles ' +
              'more realistic translation scenarios where the text to ' +
              'translate is not just a single word or short phrase. ' +
              'The prompt should still contain all the necessary instructions ' +
              'and should properly include this entire text without truncation.';
  Prompt := TOllamaCore.BuildPrompt('English', 'French', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should contain the entire long text');
  Assert.Contains(Prompt, 'Rules:', True, 'Prompt should still contain rules even with long text');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOllamaCore);

end.
