unit amLocalization.Utils;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Windows,
  amLanguageInfo;

type
  TModuleNameScheme = (
    mnsISO639_2, // Actually, not ISO639-2 since the Delphi RTL uses LOCALE_SABBREVLANGNAME to generate the identifier
    mnsISO639_1,
    mnsRFC4646
  );

type
  TLoadModuleOptions = set of (
    lmoValidateVersion,
    lmoValidateTimeStamp
  );

type
  LocalizationTools = record
    class function LoadResourceModule(LanguageItem: TLanguageItem; AOptions: TLoadModuleOptions = [lmoValidateVersion, lmoValidateTimeStamp]): boolean; overload; static;
    class function LoadResourceModule(LocaleID: LCID; AOptions: TLoadModuleOptions = [lmoValidateVersion, lmoValidateTimeStamp]): boolean; overload; static;
    class function LoadResourceModule(const LocaleName: string): boolean; overload; static;
    class function BuildModuleFilename(const BaseFilename: string; LanguageItem: TLanguageItem; ModuleNameScheme: TModuleNameScheme): string; overload; static;
    class function BuildModuleFilename(const BaseFilename: string; LocaleID: LCID; ModuleNameScheme: TModuleNameScheme): string; overload; static;
    class function BuildModuleFilename(const BaseFilename: string; const LocaleName: string; ModuleNameScheme: TModuleNameScheme): string; overload; static;
  end;

var
  // Max allowed timestamp difference, in minutes, between exe-file and resource module.
  ResourceModuleMaxAgeDifference: integer =
{$ifdef DEBUG}
    // Allow module being a bit out of date during development
    60
{$else DEBUG}
    // Allow a small difference so files having been extracted from a zip by Windows explorer
    // (which doesn't preserve the original timestamps) doesn't cause failure.
    5
{$endif DEBUG}
    ;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  Math,
  UITypes,
  Dialogs,
  Controls,
  SysUtils,
  DateUtils,
  IOUtils,
  amVersionInfo;

// -----------------------------------------------------------------------------

class function LocalizationTools.BuildModuleFilename(const BaseFilename: string;
  LanguageItem: TLanguageItem; ModuleNameScheme: TModuleNameScheme): string;
begin
  case ModuleNameScheme of

    mnsISO639_2:
      Result := TPath.ChangeExtension(BaseFilename, '.'+LanguageItem.LanguageShortName);

    mnsISO639_1:
      Result := TPath.ChangeExtension(BaseFilename, '.'+LanguageItem.ISO639_1Name);

    mnsRFC4646:
      Result := TPath.ChangeExtension(BaseFilename, '.'+LanguageItem.LocaleName);

  end;
end;

class function LocalizationTools.BuildModuleFilename(const BaseFilename: string;
  LocaleID: LCID; ModuleNameScheme: TModuleNameScheme): string;
begin
  var LanguageItem := LanguageInfo.FindLCID(LocaleID);

  if (LanguageItem <> nil) then
    Result := BuildModuleFilename(BaseFilename, LanguageItem, ModuleNameScheme)
  else
    Result := '';
end;

class function LocalizationTools.BuildModuleFilename(const BaseFilename: string;
  const LocaleName: string; ModuleNameScheme: TModuleNameScheme): string;
begin
  var LanguageItem := LanguageInfo.FindLocaleName(LocaleName);

  if (LanguageItem <> nil) then
    Result := BuildModuleFilename(BaseFilename, LanguageItem, ModuleNameScheme)
  else
    Result := '';
end;

// -----------------------------------------------------------------------------

class function LocalizationTools.LoadResourceModule(LanguageItem: TLanguageItem; AOptions: TLoadModuleOptions): boolean;

  function AppendString(const s, value: string): string;
  begin
    if (s <> '') then
      Result := s + ', ' + value
    else
      Result := value;
  end;

  function AgeToString(AgeInMinutes: integer): string;
  begin
    Result := '';
    var n: UInt64;
    var Remainder: UInt64;

    DivMod(AgeInMinutes, 60*24, n, Remainder);
    if (n <> 0) then
      Result := AppendString(Result, Format('%d days', [n]));

    DivMod(Remainder, 60, n, Remainder);
    if (n <> 0) then
      Result := AppendString(Result, Format('%d hours', [n]));

    if (Remainder <> 0) then
      Result := AppendString(Result, Format('%d minutes', [Remainder]));
  end;

var
  ModuleFilename: string;
const
  // Do not localize - localizations has not yet been loaded
  sResourceModuleOutOfSync = 'The resource module for the current language (%s) appears to be out of sync with the application.'+#13#13+
    'Application version: %s'+#13+
    'Resource module version: %s';
  sResourceModuleTooOld = 'The timestamp of the resource module for the current language (%s) does not match the timestamp of the application (difference: %s).';
  sResourceModuleFallback = #13#13+'The default language will be used instead.';
begin
  Result := False;

  // LanguageItem=nil means "Use default"
  if (LanguageItem <> nil) then
  begin
    var Module := LoadNewResourceModule(LanguageItem, ModuleFilename);

    Result := (Module <> 0) and (ModuleFilename <> '');

    // Verify VersionInfo
    if (Result) and (lmoValidateVersion in AOptions) then
    begin

      var ApplicationVersion := TVersionInfo.FileVersionString(ParamStr(0));
      // Note: GetModuleFileName (used by GetModuleName) can not be used with modules loaded with LOAD_LIBRARY_AS_DATAFILE
      var ModuleVersion: string;
      var VersionInfo := TVersionInfo.Create(ModuleFilename);
      try
        if (VersionInfo.Valid) then
          ModuleVersion := TVersionInfo.VersionToString(VersionInfo.FileVersion)
        else
          ModuleVersion := '(VersionInfo missing)';
      finally
        VersionInfo.Free;
      end;

      if (ApplicationVersion <> ModuleVersion) then
      begin
        // Revert to default application language before we call anything that might use resourcestrings
        LoadNewResourceModule(nil, ModuleFilename);

        MessageDlg(Format(sResourceModuleOutOfSync, [LanguageItem.LanguageName, ApplicationVersion, ModuleVersion])+sResourceModuleFallback, mtWarning, [mbOK], 0);
        Exit(False);
      end;
    end;

    // Verify timestamp
    if (Result) and (lmoValidateTimeStamp in AOptions) then
    begin

      var AgeDifference := MinutesBetween(TFile.GetLastWriteTime(ParamStr(0)), TFile.GetLastWriteTime(ModuleFilename));

      if (AgeDifference > ResourceModuleMaxAgeDifference) then
      begin
        // Revert to default application language before we call anything that might use resourcestrings
        LoadNewResourceModule(nil, ModuleFilename);

        var s := AgeToString(AgeDifference);
        MessageDlg(Format(sResourceModuleTooOld, [LanguageItem.LanguageName, s])+sResourceModuleFallback, mtWarning, [mbOK], 0);
        Exit(False);
      end;
    end;
  end;
end;

class function LocalizationTools.LoadResourceModule(LocaleID: LCID; AOptions: TLoadModuleOptions): boolean;
const
  // Do not localize - localizations has not yet been loaded
  sResourceModuleUnknownLanguage = 'Unknown language ID: %d'+#13#13+
    'The default language will be used instead.';
begin
  var LanguageItem: TLanguageItem := nil;

  // LocaleID=0 means "Use default"
  if (LocaleID <> 0) then
  begin
    LanguageItem := LanguageInfo.FindLCID(LocaleID);

    if (LanguageItem = nil) then
      MessageDlg(Format(sResourceModuleUnknownLanguage, [LocaleID]), mtWarning, [mbOK], 0);
  end;

  Result := LoadResourceModule(LanguageItem, AOptions);
end;

class function LocalizationTools.LoadResourceModule(const LocaleName: string): boolean;
const
  // Do not localize - localizations has not yet been loaded
  sResourceModuleUnknownLanguage = 'Unknown language: %s'+#13#13+
    'The default language will be used instead.';
begin
  var LanguageItem: TLanguageItem := nil;

  // LocaleName='' means "Use default"
  if (LocaleName <> '') then
  begin
    LanguageItem := LanguageInfo.FindLocaleName(LocaleName);

    if (LanguageItem = nil) then
      MessageDlg(Format(sResourceModuleUnknownLanguage, [LocaleName]), mtWarning, [mbOK], 0);
  end;

  Result := LoadResourceModule(LanguageItem);
end;

end.
