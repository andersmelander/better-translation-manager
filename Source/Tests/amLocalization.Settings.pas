unit amLocalization.Settings;

(*
 * Minimal stub for testing purposes
 * This provides only the Ollama provider settings without DevExpress dependencies
 *)

interface

type
  // Minimal Ollama settings structure for testing
  TOllamaProviderSettings = class
  private
    FBaseURL: string;
    FModel: string;
    FTimeout: Integer;
  public
    constructor Create;
    property BaseURL: string read FBaseURL write FBaseURL;
    property Model: string read FModel write FModel;
    property Timeout: Integer read FTimeout write FTimeout;
  end;

  TProvidersSettings = class
  private
    FOllama: TOllamaProviderSettings;
  public
    constructor Create;
    destructor Destroy; override;
    property Ollama: TOllamaProviderSettings read FOllama;
  end;

  TTranslationManagerSettings = class
  private
    class var FProviders: TProvidersSettings;
    class constructor Create;
    class destructor Destroy;
  public
    class property Providers: TProvidersSettings read FProviders;
  end;

var
  TranslationManagerSettings: TTranslationManagerSettings;

implementation

{ TOllamaProviderSettings }

constructor TOllamaProviderSettings.Create;
begin
  inherited;
  FBaseURL := 'http://localhost:11434';
  FModel := 'llama2:latest';
  FTimeout := 30000;
end;

{ TProvidersSettings }

constructor TProvidersSettings.Create;
begin
  inherited;
  FOllama := TOllamaProviderSettings.Create;
end;

destructor TProvidersSettings.Destroy;
begin
  FOllama.Free;
  inherited;
end;

{ TTranslationManagerSettings }

class constructor TTranslationManagerSettings.Create;
begin
  FProviders := TProvidersSettings.Create;
end;

class destructor TTranslationManagerSettings.Destroy;
begin
  FProviders.Free;
end;

initialization
  TranslationManagerSettings := TTranslationManagerSettings.Create;

finalization
  TranslationManagerSettings.Free;

end.
