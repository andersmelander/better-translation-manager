program amTranslationManager;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

{$R 'EmptyResourceModule.res' 'resources\EmptyResourceModule.rc'}

uses
  {$ifdef MADEXCEPT}
  madExcept,
  madListModules,
  {$endif MADEXCEPT}
  SysUtils,
  IOUtils,
  Vcl.Forms,
  Dialogs,
  UITypes,
  Windows,
  amVersionInfo,
  amSplash,
  amCursorService,
  amProgress,
  amLanguageInfo,
  DelphiDabbler.SingleInstance,
  {$ifdef MADEXCEPT}
  amLocalization.ExceptionHandler.MadExcept,
  {$endif MADEXCEPT}
  amLocalization.ExceptionHandler.API in 'amLocalization.ExceptionHandler.API.pas',
  amLocalization.Dialog in 'amLocalization.Dialog.pas' {FormDialog},
  amLocalization.Dialog.Main in 'amLocalization.Dialog.Main.pas' {FormMain},
  amLocalization.Model in 'amLocalization.Model.pas',
  amLocalization.Dialog.NewProject in 'amLocalization.Dialog.NewProject.pas' {FormNewProject},
  amLocalization.Import.XLIFF in 'amLocalization.Import.XLIFF.pas',
  amLocalization.ResourceWriter in 'amLocalization.ResourceWriter.pas',
  amLocalization.Persistence in 'amLocalization.Persistence.pas',
  amLocalization.Engine in 'amLocalization.Engine.pas',
  amLocalization.Dialog.TextEdit in 'amLocalization.Dialog.TextEdit.pas' {FormTextEditor},
  amLocalization.Dialog.Languages in 'amLocalization.Dialog.Languages.pas' {FormLanguages},
  amLocalization.Dialog.Languages.API in 'amLocalization.Dialog.Languages.API.pas',
  amLocalization.Data.Main in 'amLocalization.Data.Main.pas' {DataModuleMain: TDataModule},
  amLocalization.Dialog.Search in 'amLocalization.Dialog.Search.pas' {FormSearch},
  amLocalization.Dialog.TranslationMemory in 'amLocalization.Dialog.TranslationMemory.pas' {FormTranslationMemory},
  amLocalization.TranslationMemory.Data in 'amLocalization.TranslationMemory.Data.pas' {DataModuleTranslationMemory: TDataModule},
  amLocalization.Utils in 'amLocalization.Utils.pas',
  amLocalization.Dialog.TranslationMemory.SelectDuplicate in 'amLocalization.Dialog.TranslationMemory.SelectDuplicate.pas' {FormSelectDuplicate},
  amLocalization.Settings in 'amLocalization.Settings.pas',
  amLocalization.Dialog.Settings in 'amLocalization.Dialog.Settings.pas' {FormSettings},
  amLocalization.Dialog.Settings.API in 'amLocalization.Dialog.Settings.API.pas',
  amLocalization.Dialog.SelectModule in 'amLocalization.Dialog.SelectModule.pas' {FormSelectModule},
  amLocalization.Dialog.SelectModule.API in 'amLocalization.Dialog.SelectModule.API.pas',
  amLocalization.CommandLine in 'amLocalization.CommandLine.pas',
  amLocalization.System.SingleInst in 'amLocalization.System.SingleInst.pas',
  amLocalization.Shell in 'amLocalization.Shell.pas',
  amLocalization.TranslationMemory.FileFormats.TMX in 'amLocalization.TranslationMemory.FileFormats.TMX.pas',
  amLocalization.TranslationMemory.FileFormats in 'amLocalization.TranslationMemory.FileFormats.pas',
  amLocalization.TranslationMemory.FileFormats.TBX in 'amLocalization.TranslationMemory.FileFormats.TBX.pas',
  amLocalization.TranslationMemory.FileFormats.MSGlossaryCSV in 'amLocalization.TranslationMemory.FileFormats.MSGlossaryCSV.pas',
  amLocalization.Dialog.TargetLanguage in 'amLocalization.Dialog.TargetLanguage.pas' {FormTargetLanguage},
  amLocalization.Provider in 'amLocalization.Provider.pas',
  amLocalization.Provider.Settings in 'amLocalization.Provider.Settings.pas',
  amLocalization.Provider.RateLimiter in 'amLocalization.Provider.RateLimiter.pas',
  amLocalization.Provider.TranslationMemory in 'amLocalization.Provider.TranslationMemory.pas',
  amLocalization.Provider.Microsoft.Version3 in 'amLocalization.Provider.Microsoft.Version3.pas' {TranslationProviderMicrosoftV3: TDataModule},
  amLocalization.Provider.DeepL in 'amLocalization.Provider.DeepL.pas',
  amLocalization.Provider.Ollama in 'amLocalization.Provider.Ollama.pas',
  amLocalization.Provider.Ollama.Core in 'amLocalization.Provider.Ollama.Core.pas',
  amLocalization.Provider.Ollama.API in 'amLocalization.Provider.Ollama.API.pas',
  amLocalization.Provider.Ollama.Settings in 'amLocalization.Provider.Ollama.Settings.pas',
  amLocalization.Provider.Gemini in 'amLocalization.Provider.Gemini.pas',
  amLocalization.Provider.Gemini.API in 'amLocalization.Provider.Gemini.API.pas',
  amLocalization.Provider.Gemini.Settings in 'amLocalization.Provider.Gemini.Settings.pas',
  amLocalization.TranslationMemory.FileFormats.GenericCSV in 'amLocalization.TranslationMemory.FileFormats.GenericCSV.pas',
  amLocalization.Dialog.TranslationMemory.SelectFileFormat in 'amLocalization.Dialog.TranslationMemory.SelectFileFormat.pas' {FormSelectFileFormat},
  amLocalization.Dialog.StopList in 'amLocalization.Dialog.StopList.pas' {FormStopList},
  amLocalization.StopList in 'amLocalization.StopList.pas',
  amLocalization.TranslationMemory in 'amLocalization.TranslationMemory.pas',
  amLocalization.Portable in 'amLocalization.Portable.pas',
  amLocalization.Index in 'amLocalization.Index.pas',
  amLocalization.Export.CSV in 'amLocalization.Export.CSV.pas',
  amLocalization.Import.PO in 'amLocalization.Import.PO.pas',
  amLocalization.System.Restart in 'amLocalization.System.Restart.pas',
  amLocalization.Normalization in 'amLocalization.Normalization.pas',
  amLocalization.Skin in 'amLocalization.Skin.pas',
  amLocalization.Environment in 'amLocalization.Environment.pas',
  amLocalization.ExceptionHandler.Info.Default in 'amLocalization.ExceptionHandler.Info.Default.pas',
  amLocalization.Data.ModuleItemsDataSource in 'amLocalization.Data.ModuleItemsDataSource.pas',
  amLocalization.Dialog.Import.CSV in 'amLocalization.Dialog.Import.CSV.pas' {FormCSVImport},
  amLocalization.Common in 'amLocalization.Common.pas',
  amLocalization.ExceptionHandler.Prompt in 'amLocalization.ExceptionHandler.Prompt.pas',
  amLocalization.Settings.SpellChecker in 'amLocalization.Settings.SpellChecker.pas',
  amLocalization.Settings.Layout.Tree in 'amLocalization.Settings.Layout.Tree.pas',
  amLocalization.TranslationMemory.Data.API in 'amLocalization.TranslationMemory.Data.API.pas',
  amLocalization.Integration.Tracker.API in 'amLocalization.Integration.Tracker.API.pas',
  amLocalization.Integration.Tracker in 'amLocalization.Integration.Tracker.pas',
  amLocalization.Application.API in 'amLocalization.Application.API.pas',
  amLocalization.Utils.AutoGroupByBox in 'amLocalization.Utils.AutoGroupByBox.pas',
  amLocalization.Dialog.ApplySameTranslation in 'amLocalization.Dialog.ApplySameTranslation.pas' {FormApplySameTranslation};

{$R *.res}

type
  TCommandLineGUILogger = class(TInterfacedObject, ICommandLineLogger)
  private
    FMessages: string;
    FHasWarnings: boolean;
    FHasErrors: boolean;
  protected
    procedure DisplayMessages;
  private
    // ICommandLineLogger
    procedure Message(const Msg: string);
    procedure Error(const Msg: string);
    procedure Warning(const Msg: string);
  public
    destructor Destroy; override;
  end;

destructor TCommandLineGUILogger.Destroy;
begin
  DisplayMessages;
  inherited;
end;

procedure TCommandLineGUILogger.DisplayMessages;
var
  DialogType: TMsgDlgType;
begin
  if (FMessages = '') then
    Exit;

  if (FHasErrors) then
    DialogType := mtError
  else
  if (FHasWarnings) then
    DialogType := mtWarning
  else
    DialogType := mtInformation;

  MessageDlg(FMessages, DialogType, [mbOK], 0);

  FMessages := '';
  FHasErrors := False;
  FHasWarnings := False;
end;

procedure TCommandLineGUILogger.Error(const Msg: string);
begin
  FMessages := FMessages + Format('Error: %s', [Msg]);
  FHasErrors := True;

  DisplayMessages;

  Halt(1);
end;

procedure TCommandLineGUILogger.Message(const Msg: string);
begin
  FMessages := FMessages + Msg;
end;

procedure TCommandLineGUILogger.Warning(const Msg: string);
begin
  FMessages := FMessages + Format('Warning: %s', [Msg]);
  FHasWarnings := True;
end;

procedure InitializeFonts;
begin
{$if (CompilerVersion < 35.0) } // Segoe UI is default in Delphi 11+
  if (CheckWin32Version(6, 0)) then
  begin
    // Application.DefaultFont is the font used when TForm.ParentFont=True.
    // It is Tahoma by default but should be Segoe UI on Vista and later (according to MS UI guide lines).
    // See InitDefFontData() in graphics.pas
    Application.DefaultFont.Assign(Screen.MessageFont);
    //Application.DefaultFont.Name := Screen.MessageFont.Name;
    // DefFontData.Name specifies the default font for everything that doesn't specify a specific font.
    // For now we leave it as is (Tahoma). At some point it should follow the system default like above:
    // DefFontData.Name := Screen.MessageFont.Name;
  end;
{$ifend}
end;

procedure DoAcquireRestartSemaphore;
var
  Res: TModalResult;
begin
  while (not RestartSemaphore.Acquire) do
  begin
    Res := mrAbort;
    try

      RaiseLastOSError;

    except
      on E: Exception do
      begin
        BringWindowToTop(Application.Handle);
        Res := TaskMessageDlg('Failed to restart', 'A timeout occured waiting for the application to terminate during restart.', mtWarning, [mbCancel, mbRetry], 0, mbRetry);
        if (Res = mrAbort) then
          raise;
      end;
    end;

    if (Res = mrRetry) then
      continue;

    Halt;
  end;
end;

function ProcessCommandLine: boolean;
var
  CommandLineTool: TLocalizationCommandLineTool;
begin
  if (ParamCount = 0) or
    (((not TLocalizationCommandLineTool.OptionBuild) or (TLocalizationCommandLineTool.ProjectFilename = '')) and
     (not TLocalizationCommandLineTool.OptionHelp)) then
    Exit(False);

  CommandLineTool := TLocalizationCommandLineTool.Create(TCommandLineGUILogger.Create);
  try

    CommandLineTool.Execute;

  finally
    CommandLineTool.Free;
  end;

  Result := True;
end;

procedure CheckLastBootCompleted;
var
  Res: integer;
const
  // Do not localize
  sSafeModePromptTitle = 'Start in Safe Mode?';
  sSafeModePrompt = 'The application has detected that you are holding down the [Ctrl] key.'#13#13'Do you want to start in Safe Mode?';
  sLastBootFailed = 'The application failed to start correctly last time it ran.'+#13#13+
    'Starting the application in Safe Mode can help you correct or isolate a startup problem in order to successfully start the program.'+#13+
    'Some functionality may be disabled or reduced in this mode.'+#13#13+
    'Do you want to start the application in Safe Mode?';
begin
  if (TranslationManagerSettings.System.SafeMode) then
  begin
    Application.BringToFront;
    MessageDlg('The application is running in Safe Mode.'#13#13'Some functionality may be disabled or reduced in this mode.', mtWarning, [mbOK], 0);
    exit;
  end;

  // Prompt for Safe Mode if last startup didn't complete
  if (not TranslationManagerSettings.System.LastBootCompleted) then
  begin
    Application.BringToFront;
    Res := TaskMessageDlg(sSafeModePromptTitle, sLastBootFailed, mtConfirmation, [mbYes, mbNo], 0, mbNo);

    if (Res = mrYes) then
      TranslationManagerSettings.System.SetSafeMode;
  end else
  // Press and hold [Ctrl] during startup to prompt for Safe Mode
  if (GetAsyncKeyState(VK_CONTROL) and $8000 <> 0) then
  begin
    Application.BringToFront;
    Res := TaskMessageDlg(sSafeModePromptTitle, sSafeModePrompt, mtConfirmation, [mbYes, mbNo], 0, mbNo);

    if (Res = mrYes) then
      TranslationManagerSettings.System.SetSafeMode;
  end else
  // Start with /safe paremeter to force Safe Mode
  if (FindCmdLineSwitch('safe')) then
    TranslationManagerSettings.System.SetSafeMode;
end;

function GetApplicationTitle: string;
var
  VersionInfo: TVersionInfo;
begin
  VersionInfo := TVersionInfo.Create(Application.ExeName);
  try

    Result := VersionInfo['FileDescription'];
    if (Result.IsEmpty) then
      Result := VersionInfo['ProductName'];

  finally
    VersionInfo.Free;
  end;
end;

procedure DisplaySplash;
var
  Splash: TFormSplash;
begin
  if (ParamCount = 0) then//and (not IsDebuggerPresent) then
  begin
    Splash := TFormSplash.Create(nil);
    try
//      Splash.Version := TVersionInfo.FileVersionString(Application.ExeName);
//      Splash.DisplayBannerResource('CREDITS', 'TEXT', sbStatic);
      Splash.DisplayBanner(TVersionInfo.FileVersionString(Application.ExeName), sbStatic);

      Splash.Font.Size := 9;
      Splash.Font.Style := [];
      Splash.Execute;

    except
      Splash.Free;
      raise;
    end;
  end;
end;

var
  CursorRecall: ICursorRecall;
begin
  CheckSkins;

  // Grab restart semaphore.
  // If we were restarted then a previous instance of the application will have grabbed the semaphore before lauching this instance
  // and will be holding on to it until it has completed shutting down. Once the previous instance releases the semaphore we
  // will acquire it and continue from here.
  // If we timeout (after 60 seconds) waiting for the semaphore (e.g. previous instance hung during shutdown) we just
  // continue without further ado.
  DoAcquireRestartSemaphore;

  // We could have released the semaphore again immediately, but instead we release the semaphore in the main form constructor.
  // This way we can use the semaphore to protect against a race condition with SingleInstance:
  // SingleInstance only works once the main form window handle has been created.

  TranslationManagerSettings.System.BeginBoot; // Final EndBoot is performed in FormMain.OnAfterShow. Do not put this in try...finally
  CheckLastBootCompleted;

  if (not TranslationManagerSettings.System.SafeMode) then
    LocalizationTools.LoadResourceModule(TranslationManagerSettings.System.ApplicationLanguage);

  InitializeFonts;

  if (TranslationManagerSettings.System.SingleInstance) and (not SingleInstance.CanStartApp) and (not TranslationManagerSettings.System.SafeMode) then
  begin
    TranslationManagerSettings.System.EndBoot;
    exit;
  end;

  if (not TranslationManagerSettings.System.SafeMode) and (ProcessCommandLine) then
  begin
    TranslationManagerSettings.System.EndBoot;
    exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := GetApplicationTitle;

  DisplaySplash;
  CursorRecall := SaveCursorScoped(crAppStart, True);

  Application.CreateForm(TFormMain, FormMain);
  // Make sure main form does not activate when it is shown as this would cause the
  // splash to hide itself.
  if (Application.ShowMainForm) then
    ShowWindow(FormMain.Handle, SW_SHOWNA);

  CursorRecall := nil;

  Application.Run;
end.
