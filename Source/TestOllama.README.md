# Ollama Provider Test Application

## Overview

This standalone console application tests the Ollama translation provider functionality without requiring the DevExpress VCL controls needed by the main application.

## Building

Build the TesOllama.dpr using the Delphi IDE or command-line compiler.

This test application is completely standalone and has no dependencies on the main application or DevExpress libraries.

The executable will be created as `TestOllama.exe` in the Source directory.

## Usage

### Interactive Mode

Run without parameters for an interactive test session:

```bash
TestOllama.exe
```

The application will prompt you for:
1. Ollama Base URL (default: `http://localhost:11434`)
2. Model name (default: `qwen2.5:7b-instruct-q5_K_M`)
3. Whether to run translation tests

### Automated Mode

Run with parameters for automated testing:

```bash
TestOllama.exe http://localhost:11434 qwen2.5:7b-instruct-q5_K_M
```

Parameters:
- **Argument 1**: Ollama Base URL
- **Argument 2**: Model name

## Tests Performed

1. **Connection Validation**
   - Tests if the Ollama server is reachable
   - Validates the `/api/tags` endpoint

2. **Model Detection**
   - Queries available models from the Ollama server
   - Lists all installed models

3. **Model Validation**
   - Checks if the specified model exists
   - Returns helpful error message if model is not installed

4. **Translation Test**
   - Performs a test translation ("Hello world" from English to German)
   - Validates that the model returns a valid response
   - Checks that the translation is different from the input

## Prerequisites

1. **Ollama Server Running**
   - Install Ollama from https://ollama.ai
   - Start the server: `ollama serve`
   - Verify it's running: `curl http://localhost:11434/api/tags`

2. **Model Installed**
   - Install a model: `ollama pull qwen2.5:7b-instruct-q5_K_M`
   - Or use any other compatible model

## Expected Output

Successful test run:

```
===========================================
Ollama Provider Test Application
===========================================

Enter Ollama Base URL [http://localhost:11434]:
=== Testing Connection Validation ===
Base URL: http://localhost:11434
✓ Connection successful

=== Testing Model Detection ===
Base URL: http://localhost:11434
✓ Found 2 model(s):
  - qwen2.5:7b-instruct-q5_K_M
  - llama3.2:latest

Enter model name to test [qwen2.5:7b-instruct-q5_K_M]:
=== Testing Model Validation ===
Base URL: http://localhost:11434
Model: qwen2.5:7b-instruct-q5_K_M
✓ Model is available

Run translation test? (y/n) [y]: y
NOTE: This test may take 10-30 seconds depending on your model...
=== Testing Translation ===
Base URL: http://localhost:11434
Model: qwen2.5:7b-instruct-q5_K_M
Test phrase: "Hello world" (English -> German)
✓ Translation test passed

===========================================
Tests completed. Press Enter to exit.
```

## Troubleshooting

### Connection Failures

If connection tests fail:
- Verify Ollama is running: `ollama serve`
- Check the base URL is correct
- Ensure no firewall is blocking port 11434

### Model Not Found

If model validation fails:
- List available models: `ollama list`
- Pull the model: `ollama pull <model-name>`
- Use the exact model name shown by `ollama list`

### Translation Failures

If translation tests fail:
- Check model is fully downloaded
- Ensure model supports text generation
- Try a smaller/faster model like `qwen2.5:3b`
- Increase timeout in the settings (default is 30 seconds)

## Implementation Status

### Completed

- Ollama provider implementation (`amLocalization.Provider.Ollama.pas`)
- Settings classes and registry persistence (`amLocalization.Settings.pas`)
- Settings UI dialog controls and handlers (`amLocalization.Dialog.Settings.pas/.dfm`)
- Standalone test application (`TestOllama.dpr`)

### Known Issues

- Main project cannot be compiled due to missing DevExpress trial controls
- UI dialog has not been visually tested (controls added but not verified)
- Settings persistence to registry has not been tested end-to-end

### Next Steps

1. Test with full DevExpress license or mock missing controls
2. Visual verification of the Settings dialog UI layout
3. Integration testing with the main application
4. Unit tests (DUnitX test suite - see PRD)

## Related Files

- Provider implementation: `amLocalization.Provider.Ollama.pas`
- Settings classes: `amLocalization.Settings.pas`
- Settings dialog: `amLocalization.Dialog.Settings.pas` and `.dfm`
- Test application: `TestOllama.dpr` (this application)
- Project requirements: `PRD-Ollama-Translation-Provider.md`
