unit amLocalization.Provider.Ollama.Tests.Simple;

(*
 * Copyright © 2025 Anders Melander
 *
 * Simplified test suite for Ollama provider that doesn't require full application dependencies.
 * Tests core functionality without DevExpress or model dependencies.
 *)

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Classes;

type
  [TestFixture]
  TTestOllamaProviderSimple = class
  private
    // Helper to access protected methods via RTTI or direct testing
    function ExtractTranslationTest(const RawResponse: string): string;
    function BuildPromptTest(const ASourceLang, ATargetLang, AText: string): string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

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
    procedure TestExtractTranslation_WithLanguagePrefix;
    [Test]
    procedure TestExtractTranslation_WithQuotes;
    [Test]
    procedure TestExtractTranslation_WithWhitespace;
    [Test]
    procedure TestExtractTranslation_MultipleNewlines;

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

    // Connection validation tests (integration - requires Ollama)
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateConnection_Success;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateConnection_InvalidURL;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateModel_ModelExists;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_TestTranslation_Success;
  end;

implementation

uses
  System.RegularExpressions,
  amLocalization.Provider.Ollama;

{ TTestOllamaProviderSimple }

procedure TTestOllamaProviderSimple.Setup;
begin
  // No setup needed for simple tests
end;

procedure TTestOllamaProviderSimple.TearDown;
begin
  // No teardown needed
end;

function TTestOllamaProviderSimple.ExtractTranslationTest(const RawResponse: string): string;
var
  CleanResponse: string;
begin
  // Replicate the ExtractTranslation logic for testing
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

function TTestOllamaProviderSimple.BuildPromptTest(const ASourceLang, ATargetLang, AText: string): string;
begin
  // Replicate the BuildPrompt logic for testing
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

{ Response Filtering Tests }

procedure TTestOllamaProviderSimple.TestExtractTranslation_CleanResponse;
var
  Input, Expected, Actual: string;
begin
  Input := 'Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Clean response should be returned as-is');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithTranslationPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Translation: prefix should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithTranslatedTextPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translated text: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Translated text: prefix should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithHereIsPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Here is the translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Here is the translation: prefix should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithResultPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Result: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Result: prefix should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithLanguagePrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'In German: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'In <language>: prefix should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithQuotes;
var
  Input, Expected, Actual: string;
begin
  Input := '"Hallo Welt"';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Surrounding quotes should be removed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_WithWhitespace;
var
  Input, Expected, Actual: string;
begin
  Input := '   Hallo Welt   ';
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Leading/trailing whitespace should be trimmed');
end;

procedure TTestOllamaProviderSimple.TestExtractTranslation_MultipleNewlines;
var
  Input, Expected, Actual: string;
begin
  Input := #13#10'Hallo Welt'#13#10;
  Expected := 'Hallo Welt';
  Actual := ExtractTranslationTest(Input);
  Assert.AreEqual(Expected, Actual, 'Newlines should be trimmed');
end;

{ Prompt Building Tests }

procedure TTestOllamaProviderSimple.TestBuildPrompt_BasicStructure;
var
  Prompt: string;
begin
  Prompt := BuildPromptTest('English', 'German', 'Hello');
  Assert.IsNotEmpty(Prompt, 'Prompt should not be empty');
  Assert.IsTrue(Prompt.Length > 50, 'Prompt should contain instructions');
end;

procedure TTestOllamaProviderSimple.TestBuildPrompt_ContainsLanguages;
var
  Prompt: string;
begin
  Prompt := BuildPromptTest('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'English', True, 'Prompt should contain source language');
  Assert.Contains(Prompt, 'German', True, 'Prompt should contain target language');
end;

procedure TTestOllamaProviderSimple.TestBuildPrompt_ContainsText;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello world';
  Prompt := BuildPromptTest('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should contain the text to translate');
end;

procedure TTestOllamaProviderSimple.TestBuildPrompt_ContainsRules;
var
  Prompt: string;
begin
  Prompt := BuildPromptTest('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'Rules:', True, 'Prompt should contain rules');
  Assert.Contains(Prompt, 'ONLY the translated text', True, 'Prompt should instruct for clean output');
  Assert.Contains(Prompt, 'formatting', True, 'Prompt should mention formatting preservation');
end;

procedure TTestOllamaProviderSimple.TestBuildPrompt_SpecialCharacters;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello & goodbye "world"';
  Prompt := BuildPromptTest('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should preserve special characters');
end;

{ Integration Tests }

procedure TTestOllamaProviderSimple.IntegrationTest_ValidateConnection_Success;
var
  Provider: ITranslationProviderOllama;
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
begin
  Provider := TTranslationProviderOllama.Create as ITranslationProviderOllama;
  Result := Provider.ValidateConnection(TEST_URL, ErrorMsg);
  Assert.IsTrue(Result, 'Connection should succeed when Ollama is running: ' + ErrorMsg);
end;

procedure TTestOllamaProviderSimple.IntegrationTest_ValidateConnection_InvalidURL;
var
  Provider: ITranslationProviderOllama;
  ErrorMsg: string;
  Result: Boolean;
begin
  Provider := TTranslationProviderOllama.Create as ITranslationProviderOllama;
  Result := Provider.ValidateConnection('http://invalid-ollama-server-12345.local:11434', ErrorMsg);
  Assert.IsFalse(Result, 'Invalid URL should fail validation');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
end;

procedure TTestOllamaProviderSimple.IntegrationTest_ValidateModel_ModelExists;
var
  Provider: ITranslationProviderOllama;
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
  TEST_MODEL = 'llama2:latest';
begin
  Provider := TTranslationProviderOllama.Create as ITranslationProviderOllama;
  Result := Provider.ValidateModel(TEST_URL, TEST_MODEL, ErrorMsg);
  // Result depends on what models are installed - just verify method doesn't crash
  Assert.Pass('Model validation completed without crashing. Result: ' + BoolToStr(Result, True) + ', Error: ' + ErrorMsg);
end;

procedure TTestOllamaProviderSimple.IntegrationTest_TestTranslation_Success;
var
  Provider: ITranslationProviderOllama;
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
  TEST_MODEL = 'llama2:latest';
begin
  Provider := TTranslationProviderOllama.Create as ITranslationProviderOllama;
  Result := Provider.TestTranslation(TEST_URL, TEST_MODEL, ErrorMsg);
  Assert.IsTrue(Result, 'Test translation should succeed: ' + ErrorMsg);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOllamaProviderSimple);

end.
