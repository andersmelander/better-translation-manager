unit amLocalization.Provider;

(*
 * Minimal stub for testing purposes
 * This provides only the interfaces needed for Ollama provider testing
 *)

interface

uses
  Classes,
  SysUtils;

type
  // Minimal exception class
  ELocalizationProvider = class(Exception);

  // Stub for TranslationProviderRegistry
  TTranslationProviderFactory = reference to function(): IInterface;

  TranslationProviderRegistry = class abstract
  public
    class function RegisterProvider(const ProviderName: string; ProviderFactory: TTranslationProviderFactory): integer;
    class procedure UnregisterProvider(ProviderHandle: integer);
  end;

implementation

class function TranslationProviderRegistry.RegisterProvider(const ProviderName: string; ProviderFactory: TTranslationProviderFactory): integer;
begin
  Result := 0; // Stub implementation
end;

class procedure TranslationProviderRegistry.UnregisterProvider(ProviderHandle: integer);
begin
  // Stub implementation
end;

end.
