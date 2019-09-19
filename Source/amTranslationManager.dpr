﻿program amTranslationManager;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

uses
  madExcept,
  madListModules,
  SysUtils,
  IOUtils,
  Vcl.Forms,
  Dialogs,
  UITypes,
  Windows,
  amLocale,
  amVersionInfo,
  amSplash,
  DelphiDabbler.SingleInstance,
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
  amLocalization.Data.Main in 'amLocalization.Data.Main.pas' {DataModuleMain: TDataModule},
  amLocalization.Translator.Microsoft.Version3 in 'amLocalization.Translator.Microsoft.Version3.pas' {DataModuleTranslatorMicrosoftV3: TDataModule},
  amLocalization.Dialog.Search in 'amLocalization.Dialog.Search.pas' {FormSearch},
  amLocalization.Dialog.TranslationMemory in 'amLocalization.Dialog.TranslationMemory.pas' {FormTranslationMemory},
  amLocalization.Translator.TM in 'amLocalization.Translator.TM.pas' {DataModuleTranslationMemory: TDataModule},
  amLocalization.Utils in 'amLocalization.Utils.pas',
  amLocalization.Dialog.TranslationMemory.SelectDuplicate in 'amLocalization.Dialog.TranslationMemory.SelectDuplicate.pas' {FormSelectDuplicate},
  amLocalization.Translator in 'amLocalization.Translator.pas',
  amLocalization.Settings in 'amLocalization.Settings.pas',
  amLocalization.Dialog.Settings in 'amLocalization.Dialog.Settings.pas' {FormSettings},
  amLocalization.Dialog.SelectModule in 'amLocalization.Dialog.SelectModule.pas' {FormSelectModule},
  amLocalization.CommandLine in 'amLocalization.CommandLine.pas',
  amLocalization.System.SingleInst in 'amLocalization.System.SingleInst.pas',
  amLocalization.Dialog.Feedback in 'amLocalization.Dialog.Feedback.pas' {FormFeedback},
  amLocalization.Shell in 'amLocalization.Shell.pas',
  amLocalization.TranslationMemory.FileFormats.TMX in 'amLocalization.TranslationMemory.FileFormats.TMX.pas',
  amLocalization.TranslationMemory.FileFormats in 'amLocalization.TranslationMemory.FileFormats.pas',
  amLocalization.TranslationMemory.FileFormats.TBX in 'amLocalization.TranslationMemory.FileFormats.TBX.pas';

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

procedure LoadResourceModule;
var
  LocaleItem: TLocaleItem;
  Module: HModule;
  ModuleFilename: string;
  ApplicationVersion, ModuleVersion: string;
resourcestring
  sResourceModuleUnknownLanguage = 'Unknown language ID: %d'+#13#13+
    'The default language will be used instead.';
const
  // Do not localize
  sResourceModuleOutOfSync = 'The resource module for the current language (%s) appears to be out of sync with the application.'+#13#13+
    'Application version: %s'+#13+
    'Resource module version: %s'+#13#13+
    'The default language will be used instead.';
begin
  if (TranslationManagerSettings.System.SafeMode) then
    Exit;

  if (TranslationManagerSettings.System.ApplicationLanguage = 0) then
    Exit;

  LocaleItem := TLocaleItems.FindLCID(TranslationManagerSettings.System.ApplicationLanguage);
  if (LocaleItem = nil) then
  begin
    MessageDlg(Format(sResourceModuleUnknownLanguage, [TranslationManagerSettings.System.ApplicationLanguage]), mtWarning, [mbOK], 0);
    Exit;
  end;

  Module := LoadNewResourceModule(LocaleItem.LanguageShortName, ModuleFilename);

  if (Module <> 0) and (ModuleFilename <> '') then
  begin
    ApplicationVersion := TVersionInfo.FileVersionString(Application.ExeName);
    // Note: GetModuleFileName (used by GetModuleName) can not be used with modules loaded with LOAD_LIBRARY_AS_DATAFILE
    ModuleVersion := TVersionInfo.FileVersionString(ModuleFilename);

    if (ApplicationVersion <> ModuleVersion) then
    begin
      LoadNewResourceModule('');
      MessageDlg(Format(sResourceModuleOutOfSync, [LocaleItem.LanguageName, ApplicationVersion, ModuleVersion]), mtWarning, [mbOK], 0);
    end;
  end else
    // Use default application language if we failed to load a resource module
    LoadNewResourceModule('');
end;

procedure InitializeFonts;
begin
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
end;

procedure DoAcquireRestartSemaphore;
var
  Res: TModalResult;
begin
  while (not AcquireRestartSemaphore) do
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
  if (ParamCount = 0) or ((ParamCount = 1) and (TFile.Exists(ParamStr(1)))) then
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

begin
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

  LoadResourceModule;

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

  if (ParamCount = 0) then//and (not IsDebuggerPresent) then
  begin
    with TFormSplash.Create(nil) do
      Execute;
  end;

  Application.CreateForm(TFormMain, FormMain);
  // Make sure main form does not activate when it is shown as this would cause the
  // splash to hide itself.
  ShowWindow(FormMain.Handle, SW_SHOWNA);
  Application.Run;
end.
