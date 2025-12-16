program TestOllama;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.JSON,
  System.NetEncoding;

const
  DEFAULT_BASE_URL = 'http://localhost:11434';
  DEFAULT_MODEL = 'qwen2.5:7b-instruct-q5_K_M';
  DEFAULT_TIMEOUT = 30000;

type
  TOllamaTest = class
  private
    FBaseURL: string;
    FModelName: string;
    FTimeout: Integer;
  public
    constructor Create(const ABaseURL, AModelName: string; ATimeout: Integer);
    function TestConnection: Boolean;
    function TestModelDetection: Boolean;
    function TestModelValidation: Boolean;
    function TestTranslation: Boolean;
  end;

constructor TOllamaTest.Create(const ABaseURL, AModelName: string; ATimeout: Integer);
begin
  FBaseURL := ABaseURL;
  FModelName := AModelName;
  FTimeout := ATimeout;
end;

function TOllamaTest.TestConnection: Boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  URL: string;
begin
  WriteLn('=== Testing Connection ===');
  WriteLn('Base URL: ', FBaseURL);
  Result := False;

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;
    URL := FBaseURL.TrimRight(['/']) + '/api/tags';

    try
      HTTPResponse := HTTPClient.Get(URL);
      if HTTPResponse.StatusCode = 200 then
      begin
        WriteLn('✓ Connection successful');
        Result := True;
      end
      else
        WriteLn('✗ Connection failed: ', HTTPResponse.StatusText);
    except
      on E: Exception do
        WriteLn('✗ Connection failed: ', E.Message);
    end;
  finally
    HTTPClient.Free;
  end;
  WriteLn;
end;

function TOllamaTest.TestModelDetection: Boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  JSONResponse: TJSONObject;
  JSONModels: TJSONArray;
  JSONModel: TJSONObject;
  I: Integer;
  URL: string;
begin
  WriteLn('=== Testing Model Detection ===');
  WriteLn('Base URL: ', FBaseURL);
  Result := False;

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;
    URL := FBaseURL.TrimRight(['/']) + '/api/tags';

    try
      HTTPResponse := HTTPClient.Get(URL);

      if HTTPResponse.StatusCode <> 200 then
      begin
        WriteLn('✗ Failed to query models: ', HTTPResponse.StatusText);
        Exit;
      end;

      JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if JSONResponse = nil then
      begin
        WriteLn('✗ Invalid JSON response');
        Exit;
      end;

      try
        JSONModels := JSONResponse.GetValue('models') as TJSONArray;
        if JSONModels = nil then
        begin
          WriteLn('✗ No models found in response');
          Exit;
        end;

        WriteLn(Format('✓ Found %d model(s):', [JSONModels.Count]));
        for I := 0 to JSONModels.Count - 1 do
        begin
          JSONModel := JSONModels.Items[I] as TJSONObject;
          if JSONModel <> nil then
            WriteLn('  - ', JSONModel.GetValue<string>('name'));
        end;

        Result := True;
      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        WriteLn('✗ Exception: ', E.Message);
    end;

  finally
    HTTPClient.Free;
  end;
  WriteLn;
end;

function TOllamaTest.TestModelValidation: Boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  JSONResponse: TJSONObject;
  JSONModels: TJSONArray;
  JSONModel: TJSONObject;
  I: Integer;
  URL: string;
  ModelFound: Boolean;
begin
  WriteLn('=== Testing Model Validation ===');
  WriteLn('Base URL: ', FBaseURL);
  WriteLn('Model: ', FModelName);
  Result := False;

  if FModelName.Trim.IsEmpty then
  begin
    WriteLn('✗ Model name is required');
    Exit;
  end;

  HTTPClient := THTTPClient.Create;
  try
    HTTPClient.ConnectionTimeout := 5000;
    HTTPClient.ResponseTimeout := 5000;
    URL := FBaseURL.TrimRight(['/']) + '/api/tags';

    try
      HTTPResponse := HTTPClient.Get(URL);

      if HTTPResponse.StatusCode <> 200 then
      begin
        WriteLn('✗ Failed to query models: ', HTTPResponse.StatusText);
        Exit;
      end;

      JSONResponse := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
      if JSONResponse = nil then
      begin
        WriteLn('✗ Invalid JSON response');
        Exit;
      end;

      try
        JSONModels := JSONResponse.GetValue('models') as TJSONArray;
        if JSONModels = nil then
        begin
          WriteLn('✗ Invalid response format');
          Exit;
        end;

        ModelFound := False;
        for I := 0 to JSONModels.Count - 1 do
        begin
          JSONModel := JSONModels.Items[I] as TJSONObject;
          if JSONModel <> nil then
          begin
            if SameText(JSONModel.GetValue<string>('name'), FModelName) then
            begin
              ModelFound := True;
              Break;
            end;
          end;
        end;

        if ModelFound then
        begin
          WriteLn('✓ Model is available');
          Result := True;
        end
        else
          WriteLn('✗ Model not found. Install it with: ollama pull ', FModelName);

      finally
        JSONResponse.Free;
      end;

    except
      on E: Exception do
        WriteLn('✗ Exception: ', E.Message);
    end;

  finally
    HTTPClient.Free;
  end;
  WriteLn;
end;

function TOllamaTest.TestTranslation: Boolean;
var
  HTTPClient: THTTPClient;
  HTTPResponse: IHTTPResponse;
  RequestJSON: TJSONObject;
  OptionsJSON: TJSONObject;
  ResponseJSON: TJSONObject;
  RequestContent: TStringStream;
  URL: string;
  Prompt: string;
  RawResponse: string;
begin
  WriteLn('=== Testing Translation ===');
  WriteLn('Base URL: ', FBaseURL);
  WriteLn('Model: ', FModelName);
  WriteLn('Test: "Hello world" (English -> German)');
  WriteLn('NOTE: This may take 10-30 seconds...');
  Result := False;

  // Build prompt
  Prompt := 'Translate the following text from English to German.'#13#10 +
            'Rules:'#13#10 +
            '- Output ONLY the translated text'#13#10 +
            '- Do not add explanations, notes, or comments'#13#10 +
            '- Preserve the original formatting and punctuation'#13#10 +
            '- Maintain the same level of formality'#13#10 +
            #13#10 +
            'Text to translate:'#13#10 +
            'Hello world';

  RequestJSON := TJSONObject.Create;
  try
    RequestJSON.AddPair('model', FModelName);
    RequestJSON.AddPair('prompt', Prompt);
    RequestJSON.AddPair('stream', TJSONBool.Create(False));

    OptionsJSON := TJSONObject.Create;
    OptionsJSON.AddPair('temperature', TJSONNumber.Create(0.1));
    OptionsJSON.AddPair('top_p', TJSONNumber.Create(0.9));
    RequestJSON.AddPair('options', OptionsJSON);

    HTTPClient := THTTPClient.Create;
    try
      HTTPClient.ConnectionTimeout := FTimeout;
      HTTPClient.ResponseTimeout := FTimeout;
      URL := FBaseURL.TrimRight(['/']) + '/api/generate';

      RequestContent := TStringStream.Create(RequestJSON.ToJSON, TEncoding.UTF8);
      try
        try
          HTTPResponse := HTTPClient.Post(URL, RequestContent, nil,
            [TNetHeader.Create('Content-Type', 'application/json')]);

          if HTTPResponse = nil then
          begin
            WriteLn('✗ No response from server');
            Exit;
          end;

          case HTTPResponse.StatusCode of
            200:
              begin
                ResponseJSON := TJSONObject.ParseJSONValue(HTTPResponse.ContentAsString(TEncoding.UTF8)) as TJSONObject;
                if ResponseJSON = nil then
                begin
                  WriteLn('✗ Invalid JSON response');
                  Exit;
                end;

                try
                  RawResponse := ResponseJSON.GetValue<string>('response');
                  if RawResponse.Trim.IsEmpty then
                  begin
                    WriteLn('✗ Empty response from model');
                    Exit;
                  end;

                  WriteLn('Response: ', RawResponse.Trim);

                  // Verify we got a different string (not echoing input)
                  if SameText(RawResponse.Trim, 'Hello world') then
                  begin
                    WriteLn('✗ Model appears to be echoing input');
                    Exit;
                  end;

                  WriteLn('✓ Translation test passed');
                  Result := True;

                finally
                  ResponseJSON.Free;
                end;
              end;

            404:
              WriteLn('✗ Model not found: ', FModelName);

          else
            WriteLn('✗ Server error: ', HTTPResponse.StatusText);
          end;

        except
          on E: Exception do
          begin
            if (Pos('timeout', LowerCase(E.Message)) > 0) or
               (Pos('timed out', LowerCase(E.Message)) > 0) then
              WriteLn('✗ Translation timeout. Try a smaller model or increase timeout.')
            else
              WriteLn('✗ Exception: ', E.Message);
          end;
        end;

      finally
        RequestContent.Free;
      end;

    finally
      HTTPClient.Free;
    end;

  finally
    RequestJSON.Free;
  end;
  WriteLn;
end;

procedure RunInteractiveTests;
var
  BaseURL: string;
  ModelName: string;
  Choice: string;
  OllamaTest: TOllamaTest;
begin
  WriteLn('===========================================');
  WriteLn('Ollama Provider Test Application');
  WriteLn('===========================================');
  WriteLn;

  // Get configuration
  Write('Enter Ollama Base URL [', DEFAULT_BASE_URL, ']: ');
  ReadLn(BaseURL);
  if BaseURL.Trim.IsEmpty then
    BaseURL := DEFAULT_BASE_URL;

  // Get model name
  Write('Enter model name to test [', DEFAULT_MODEL, ']: ');
  ReadLn(ModelName);
  if ModelName.Trim.IsEmpty then
    ModelName := DEFAULT_MODEL;

  OllamaTest := TOllamaTest.Create(BaseURL, ModelName, DEFAULT_TIMEOUT);
  try
    // Run tests
    if not OllamaTest.TestConnection then
      Exit;

    OllamaTest.TestModelDetection;

    if not OllamaTest.TestModelValidation then
      Exit;

    // Ask about translation test
    Write('Run translation test? (y/n) [y]: ');
    ReadLn(Choice);
    if (Choice.Trim.IsEmpty) or (Choice.ToLower = 'y') then
      OllamaTest.TestTranslation;

  finally
    OllamaTest.Free;
  end;

  WriteLn('===========================================');
  WriteLn('Tests completed. Press Enter to exit.');
  ReadLn;
end;

procedure RunAutomatedTests(const BaseURL, ModelName: string);
var
  OllamaTest: TOllamaTest;
  AllPassed: Boolean;
begin
  WriteLn('===========================================');
  WriteLn('Ollama Provider Automated Tests');
  WriteLn('===========================================');
  WriteLn;

  OllamaTest := TOllamaTest.Create(BaseURL, ModelName, DEFAULT_TIMEOUT);
  try
    AllPassed := True;

    if not OllamaTest.TestConnection then
      AllPassed := False;

    OllamaTest.TestModelDetection;

    if not OllamaTest.TestModelValidation then
      AllPassed := False;

    if not OllamaTest.TestTranslation then
      AllPassed := False;

    WriteLn('===========================================');
    if AllPassed then
      WriteLn('✓ All tests passed')
    else
      WriteLn('✗ Some tests failed');
    WriteLn('===========================================');

  finally
    OllamaTest.Free;
  end;
end;

var
  BaseURL: string;
  ModelName: string;

begin
  try
    // Check command line parameters
    if ParamCount >= 2 then
    begin
      BaseURL := ParamStr(1);
      ModelName := ParamStr(2);
      RunAutomatedTests(BaseURL, ModelName);
    end
    else
    begin
      if ParamCount > 0 then
      begin
        WriteLn('Usage: TestOllama [BaseURL] [ModelName]');
        WriteLn('  Example: TestOllama http://localhost:11434 qwen2.5:7b-instruct-q5_K_M');
        WriteLn('  or run without parameters for interactive mode');
        WriteLn;
      end;
      RunInteractiveTests;
    end;

  except
    on E: Exception do
    begin
      WriteLn('ERROR: ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
