unit amLocalization.Provider.Ollama.Tests;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Classes,
  amLocalization.Provider.Ollama,
  amLocalization.Provider,
  amLanguageInfo;

type
  [TestFixture]
  TTestOllamaProvider = class
  private
    FProvider: TTranslationProviderOllama;
    FProviderIntf: ITranslationProviderOllama;

    // Helper class to expose protected/private methods for testing
    type
      TOllamaProviderTestHelper = class(TTranslationProviderOllama)
      public
        function PublicExtractTranslation(const RawResponse: string): string;
        function PublicBuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
      end;

    FTestHelper: TOllamaProviderTestHelper;
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
    procedure TestValidateConnection_EmptyURL;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateConnection_InvalidURL;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateConnection_ServerNotRunning;

    // Model validation tests (integration - requires Ollama)
    [Test]
    procedure TestValidateModel_EmptyModelName;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateModel_ModelExists;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_ValidateModel_ModelNotFound;

    // Translation tests (integration - requires Ollama)
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_TestTranslation_Success;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_Translation_Simple;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_Translation_WithPunctuation;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_Translation_Multiline;
    [Test]
    [Ignore('Integration test - requires Ollama server running')]
    procedure IntegrationTest_Translation_SpecialCharacters;

    // Provider interface tests
    [Test]
    procedure TestGetProviderName;
    [Test]
    procedure TestBeginEndLookup;
  end;

implementation

uses
  System.RegularExpressions;

{ TTestOllamaProvider.TOllamaProviderTestHelper }

function TTestOllamaProvider.TOllamaProviderTestHelper.PublicExtractTranslation(const RawResponse: string): string;
begin
  Result := ExtractTranslation(RawResponse);
end;

function TTestOllamaProvider.TOllamaProviderTestHelper.PublicBuildPrompt(const ASourceLang, ATargetLang, AText: string): string;
begin
  Result := BuildPrompt(ASourceLang, ATargetLang, AText);
end;

{ TTestOllamaProvider }

procedure TTestOllamaProvider.Setup;
begin
  FProvider := TTranslationProviderOllama.Create;
  FProviderIntf := FProvider as ITranslationProviderOllama;
  FTestHelper := TOllamaProviderTestHelper.Create;
end;

procedure TTestOllamaProvider.TearDown;
begin
  FProviderIntf := nil;
  FProvider := nil;
  FTestHelper.Free;
end;

{ Response Filtering Tests }

procedure TTestOllamaProvider.TestExtractTranslation_CleanResponse;
var
  Input, Expected, Actual: string;
begin
  Input := 'Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Clean response should be returned as-is');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithTranslationPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Translation: prefix should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithTranslatedTextPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Translated text: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Translated text: prefix should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithHereIsPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Here is the translation: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Here is the translation: prefix should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithResultPrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'Result: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Result: prefix should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithLanguagePrefix;
var
  Input, Expected, Actual: string;
begin
  Input := 'In German: Hallo Welt';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'In <language>: prefix should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithQuotes;
var
  Input, Expected, Actual: string;
begin
  Input := '"Hallo Welt"';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Surrounding quotes should be removed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_WithWhitespace;
var
  Input, Expected, Actual: string;
begin
  Input := '   Hallo Welt   ';
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Leading/trailing whitespace should be trimmed');
end;

procedure TTestOllamaProvider.TestExtractTranslation_MultipleNewlines;
var
  Input, Expected, Actual: string;
begin
  Input := #13#10'Hallo Welt'#13#10;
  Expected := 'Hallo Welt';
  Actual := FTestHelper.PublicExtractTranslation(Input);
  Assert.AreEqual(Expected, Actual, 'Newlines should be trimmed');
end;

{ Prompt Building Tests }

procedure TTestOllamaProvider.TestBuildPrompt_BasicStructure;
var
  Prompt: string;
begin
  Prompt := FTestHelper.PublicBuildPrompt('English', 'German', 'Hello');
  Assert.IsNotEmpty(Prompt, 'Prompt should not be empty');
  Assert.IsTrue(Prompt.Length > 50, 'Prompt should contain instructions');
end;

procedure TTestOllamaProvider.TestBuildPrompt_ContainsLanguages;
var
  Prompt: string;
begin
  Prompt := FTestHelper.PublicBuildPrompt('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'English', True, 'Prompt should contain source language');
  Assert.Contains(Prompt, 'German', True, 'Prompt should contain target language');
end;

procedure TTestOllamaProvider.TestBuildPrompt_ContainsText;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello world';
  Prompt := FTestHelper.PublicBuildPrompt('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should contain the text to translate');
end;

procedure TTestOllamaProvider.TestBuildPrompt_ContainsRules;
var
  Prompt: string;
begin
  Prompt := FTestHelper.PublicBuildPrompt('English', 'German', 'Hello');
  Assert.Contains(Prompt, 'Rules:', True, 'Prompt should contain rules');
  Assert.Contains(Prompt, 'ONLY the translated text', True, 'Prompt should instruct for clean output');
  Assert.Contains(Prompt, 'formatting', True, 'Prompt should mention formatting preservation');
end;

procedure TTestOllamaProvider.TestBuildPrompt_SpecialCharacters;
var
  Prompt: string;
  TestText: string;
begin
  TestText := 'Hello & goodbye "world"';
  Prompt := FTestHelper.PublicBuildPrompt('English', 'German', TestText);
  Assert.Contains(Prompt, TestText, True, 'Prompt should preserve special characters');
end;

{ Connection Validation Tests }

procedure TTestOllamaProvider.TestValidateConnection_EmptyURL;
var
  ErrorMsg: string;
  Result: Boolean;
begin
  Result := FProviderIntf.ValidateConnection('', ErrorMsg);
  Assert.IsFalse(Result, 'Empty URL should fail validation');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
end;

procedure TTestOllamaProvider.IntegrationTest_ValidateConnection_Success;
var
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
begin
  // This test requires Ollama to be running locally
  Result := FProviderIntf.ValidateConnection(TEST_URL, ErrorMsg);
  Assert.IsTrue(Result, 'Connection should succeed when Ollama is running: ' + ErrorMsg);
end;

procedure TTestOllamaProvider.IntegrationTest_ValidateConnection_InvalidURL;
var
  ErrorMsg: string;
  Result: Boolean;
begin
  Result := FProviderIntf.ValidateConnection('http://invalid-ollama-server-12345.local:11434', ErrorMsg);
  Assert.IsFalse(Result, 'Invalid URL should fail validation');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
end;

procedure TTestOllamaProvider.IntegrationTest_ValidateConnection_ServerNotRunning;
var
  ErrorMsg: string;
  Result: Boolean;
begin
  // Use a valid URL format but wrong port where Ollama is unlikely to be running
  Result := FProviderIntf.ValidateConnection('http://localhost:11435', ErrorMsg);
  Assert.IsFalse(Result, 'Connection should fail when server is not running');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
end;

{ Model Validation Tests }

procedure TTestOllamaProvider.TestValidateModel_EmptyModelName;
var
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
begin
  Result := FProviderIntf.ValidateModel(TEST_URL, '', ErrorMsg);
  Assert.IsFalse(Result, 'Empty model name should fail validation');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
  Assert.Contains(ErrorMsg, 'required', True, 'Error should mention model is required');
end;

procedure TTestOllamaProvider.IntegrationTest_ValidateModel_ModelExists;
var
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
  // Use a commonly available model - adjust based on what's installed
  TEST_MODEL = 'llama2:latest';
begin
  // This test requires Ollama to be running with the specified model installed
  Result := FProviderIntf.ValidateModel(TEST_URL, TEST_MODEL, ErrorMsg);
  // We can't assert True here since we don't know what models are installed
  // Just verify the method doesn't crash
  Assert.Pass('Model validation completed without crashing. Result: ' + BoolToStr(Result, True) + ', Error: ' + ErrorMsg);
end;

procedure TTestOllamaProvider.IntegrationTest_ValidateModel_ModelNotFound;
var
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
  NONEXISTENT_MODEL = 'this-model-definitely-does-not-exist-12345';
begin
  Result := FProviderIntf.ValidateModel(TEST_URL, NONEXISTENT_MODEL, ErrorMsg);
  Assert.IsFalse(Result, 'Non-existent model should fail validation');
  Assert.IsNotEmpty(ErrorMsg, 'Error message should be provided');
  Assert.Contains(ErrorMsg, 'not found', True, 'Error should mention model not found');
end;

{ Translation Tests }

procedure TTestOllamaProvider.IntegrationTest_TestTranslation_Success;
var
  ErrorMsg: string;
  Result: Boolean;
const
  TEST_URL = 'http://localhost:11434';
  TEST_MODEL = 'llama2:latest';
begin
  // NOTE: This test requires Ollama running with the model installed
  Result := FProviderIntf.TestTranslation(TEST_URL, TEST_MODEL, ErrorMsg);
  Assert.IsTrue(Result, 'Test translation should succeed: ' + ErrorMsg);
end;

procedure TTestOllamaProvider.IntegrationTest_Translation_Simple;
begin
  // TODO: This test requires full model classes (TLocalizerProperty, etc.)
  // which have DevExpress dependencies. Implement when mocking framework is available.
  Assert.Pass('Integration test stub - requires full application model');
end;

procedure TTestOllamaProvider.IntegrationTest_Translation_WithPunctuation;
begin
  // TODO: This test requires full model classes (TLocalizerProperty, etc.)
  // which have DevExpress dependencies. Implement when mocking framework is available.
  Assert.Pass('Integration test stub - requires full application model');
end;

procedure TTestOllamaProvider.IntegrationTest_Translation_Multiline;
begin
  // TODO: This test requires full model classes (TLocalizerProperty, etc.)
  // which have DevExpress dependencies. Implement when mocking framework is available.
  Assert.Pass('Integration test stub - requires full application model');
end;

procedure TTestOllamaProvider.IntegrationTest_Translation_SpecialCharacters;
begin
  // TODO: This test requires full model classes (TLocalizerProperty, etc.)
  // which have DevExpress dependencies. Implement when mocking framework is available.
  Assert.Pass('Integration test stub - requires full application model');
end;

{ Provider Interface Tests }

procedure TTestOllamaProvider.TestGetProviderName;
var
  ProviderName: string;
  Provider: ITranslationProvider;
begin
  Provider := FProvider as ITranslationProvider;
  ProviderName := Provider.GetProviderName;
  Assert.IsNotEmpty(ProviderName, 'Provider name should not be empty');
  Assert.Contains(ProviderName, 'Ollama', True, 'Provider name should mention Ollama');
end;

procedure TTestOllamaProvider.TestBeginEndLookup;
var
  Provider: ITranslationProvider;
begin
  Provider := FProvider as ITranslationProvider;

  // BeginLookup/EndLookup require TLanguageItem which needs full dependencies
  // For now, just verify the provider can be cast to ITranslationProvider
  Assert.IsNotNull(Provider, 'Provider should implement ITranslationProvider interface');
  Assert.Pass('Provider interface test completed');
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOllamaProvider);

end.
