unit amLocalization.Settings;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

{$WARN SYMBOL_PLATFORM OFF}

// -----------------------------------------------------------------------------
//
// This unit contains settings related stuff.
//
// -----------------------------------------------------------------------------

uses
  Generics.Collections,
  Windows,
  SysUtils,
  Classes,
  Forms,
  Graphics,
  amRegConfig,
  amFileUtils,
  amLocalization.Utils,
  amLocalization.Model,
  amLocalization.StopList,
  amLocalization.Normalization,
  amLocalization.Provider.Ollama.Settings;


//------------------------------------------------------------------------------
//
//      Configuration Persistence
//
//------------------------------------------------------------------------------
var
  TranslationManagerRegistryKey: HKEY = HKEY_CURRENT_USER;
  TranslationManagerRegistryRoot: string = '\Software\Melander\TranslationManager\';
  // Portable registry tree must NOT be below the main root since our portable settings
  // persistence (via Settings.SaveRegistryToStream) basically just dumps a registry
  // tree to a stream and we don't want the portable settings saved as part of the
  // normal settings.
  TranslationManagerPortableRegistryRoot: string = '\Software\Melander\TranslationManager.Portable\';

//------------------------------------------------------------------------------
//
//      Configuration
//
//------------------------------------------------------------------------------

type
  TCustomFormSettings = class(TConfigurationSection)
  strict private
//    FForm: TCustomForm;
    FValid: boolean;
    FMaximized: boolean;
    FVisible: boolean;
    FLeft: integer;
    FHeight: integer;
    FWidth: integer;
    FTop: integer;
  protected
    property Visible: boolean read FVisible write FVisible default True;
    property Height: integer read FHeight write FHeight default -1;
    property Width: integer read FWidth write FWidth default -1;
    property Maximized: boolean read FMaximized write FMaximized default False;
  protected
    procedure ReadSection(const Key: string); override;
    procedure WriteSection(const Key: string); override;
    procedure ApplyDefault; override;
  public
    function ApplySettings(Form: TCustomForm): boolean;
    function PrepareSettings(Form: TCustomForm): boolean;
    procedure ResetSettings;
  published
    property Valid: boolean read FValid write FValid default False;
    property Top: integer read FTop write FTop;
    property Left: integer read FLeft write FLeft;
  end;

  TTranslationManagerFormMainSettings = class(TCustomFormSettings)
  private
  protected
  public
  published
    property Width;
    property Height;
    property Maximized;
  end;

  TTranslationManagerFormsSettings = class(TConfigurationSection)
  private
    FMain: TTranslationManagerFormMainSettings;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
    procedure ResetSettings;
  published
    property Main: TTranslationManagerFormMainSettings read FMain;
  end;


type
  TTranslationManagerFolder = (tmFolderAppData, tmFolderDocuments, tmFolderSpellCheck, tmFolderUserSpellCheck);

type
  TTranslationManagerFolderSettings = class(TConfigurationSection)
  strict private
    FValid: boolean;
    FRecentFiles: TConfigurationStringList;
    FRecentApplications: TConfigurationStringList;
    FFolders: array[TTranslationManagerFolder] of string;
  strict private const
    sFolderDisplayName: array[TTranslationManagerFolder] of string = ( // TODO : Localization
      'Application data',
      'Project default',
      'Spell Check dictionaries (system)',
      'Spell Check dictionaries (user)'
      );
    cFolderReadOnly: array[TTranslationManagerFolder] of boolean = (
      True,
      False,
      True,
      False
      );
    sSpellCheckFolder = 'Dictionaries\';
    sFolderDefault: array[TTranslationManagerFolder] of string = (
      '%DATA%\',
      '%DOCUMENTS%\',
      '%INSTALL%\' + sSpellCheckFolder,
      '%DATA%\' + sSpellCheckFolder
      );
  private
    function GetFolder(Index: TTranslationManagerFolder): string;
    procedure SetFolder(Index: TTranslationManagerFolder; const Value: string);
    function GetFolderName(Index: TTranslationManagerFolder): string;
    function GetFolderReadOnly(Index: TTranslationManagerFolder): boolean;
    function GetFolderDefault(Index: TTranslationManagerFolder): string;
  protected
    procedure ApplyDefault; override;
    procedure ReadSection(const Key: string); override;
    procedure WriteSection(const Key: string); override;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;

    procedure ResetSettings;

    function ValidateFolders: boolean;

    property Folder[Index: TTranslationManagerFolder]: string read GetFolder write SetFolder; default;
    property FolderName[Index: TTranslationManagerFolder]: string read GetFolderName;
    property FolderReadOnly[Index: TTranslationManagerFolder]: boolean read GetFolderReadOnly;
    property FolderDefault[Index: TTranslationManagerFolder]: string read GetFolderDefault;
  published
    property Valid: boolean read FValid write FValid default False;

    property FolderAppData: string index tmFolderAppData read GetFolder write SetFolder;
    property FolderDocuments: string index tmFolderDocuments read GetFolder write SetFolder;
    property FolderSpellCheck: string index tmFolderSpellCheck read GetFolder write SetFolder;
    property FolderUserSpellCheck: string index tmFolderUserSpellCheck read GetFolder write SetFolder;

    property RecentFiles: TConfigurationStringList read FRecentFiles;
    property RecentApplications: TConfigurationStringList read FRecentApplications;
  end;

type
  TTranslationManagerProviderMicrosoftTranslatorV3Settings = class(TConfigurationSection)
  private
    FAPIKey: string;
    FAPIKeyValidated: boolean;
    FRegion: string;
  protected
    procedure ApplyDefault; override;
  public
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property APIKeyValidated: boolean read FAPIKeyValidated write FAPIKeyValidated;
    property Region: string read FRegion write FRegion;
  end;

  TTranslationManagerProviderTM = class(TConfigurationSection)
  private
    FFilename: string;
    FLoadOnDemand: boolean;
    FBackgroundQuery: boolean;
    FPromptToSave: boolean;
  protected
    procedure ApplyDefault; override;
  public
  published
    property Filename: string read FFilename write FFilename;
    property LoadOnDemand: boolean read FLoadOnDemand write FLoadOnDemand default True;
    property PromptToSave: boolean read FPromptToSave write FPromptToSave default False;
    property BackgroundQuery: boolean read FBackgroundQuery write FBackgroundQuery default True;
  end;

  TTranslationManagerProviderDeepLSettings = class(TConfigurationSection)
  private
    FAPIKey: string;
    FProVersion: boolean;
  public
  published
    property APIKey: string read FAPIKey write FAPIKey;
    property ProVersion: boolean read FProVersion write FProVersion;
  end;

  TTranslationManagerProviderSettings = class(TConfigurationSection)
  private
    FMicrosoftV3: TTranslationManagerProviderMicrosoftTranslatorV3Settings;
    FTranslationMemory: TTranslationManagerProviderTM;
    FDeepL: TTranslationManagerProviderDeepLSettings;
    FOllama: TTranslationManagerProviderOllamaSettings;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
    procedure ResetSettings;
  published
    property MicrosoftTranslatorV3: TTranslationManagerProviderMicrosoftTranslatorV3Settings read FMicrosoftV3;
    property TranslationMemory: TTranslationManagerProviderTM read FTranslationMemory;
    property DeepL: TTranslationManagerProviderDeepLSettings read FDeepL;
    property Ollama: TTranslationManagerProviderOllamaSettings read FOllama;
  end;

  TTranslationManagerProofingSettings = class(TConfigurationSection)
  private
    FValid: boolean;
  published
    property Valid: boolean read FValid write FValid;
  end;

  TTranslationManagerLayoutGridSettings = class(TConfigurationSection)
  private
    FValid: boolean;
  public
  published
    property Valid: boolean read FValid write FValid;
  end;

  TTranslationManagerLayoutTreeSettings = class(TTranslationManagerLayoutGridSettings);

  TTranslationManagerLayoutSettings = class(TConfigurationSection)
  private
    FModuleTree: TTranslationManagerLayoutTreeSettings;
    FItemGrid: TTranslationManagerLayoutGridSettings;
    FTranslationMemory: TTranslationManagerLayoutGridSettings;
    FBlackList: TTranslationManagerLayoutGridSettings;
    FSearchResult: TTranslationManagerLayoutGridSettings;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
  published
    property ModuleTree: TTranslationManagerLayoutTreeSettings read FModuleTree;
    property ItemGrid: TTranslationManagerLayoutGridSettings read FItemGrid;
    property TranslationMemory: TTranslationManagerLayoutGridSettings read FTranslationMemory;
    property StopList: TTranslationManagerLayoutGridSettings read FBlackList;
    property SearchResult: TTranslationManagerLayoutGridSettings read FSearchResult;
  end;


  TTranslationManagerBackupSettings = class(TConfigurationSection)
  private
    FAutoRecoverInterval: integer;
    FMaxCount: integer;
    FMaxSize: int64;
    FAutoRecover: boolean;
    FSaveBackups: boolean;
  public
  published
    property SaveBackups: boolean read FSaveBackups write FSaveBackups default True;
    property MaxCount: integer read FMaxCount write FMaxCount default 5;
    property MaxSize: int64 read FMaxSize write FMaxSize default 10; // In Mb
    property AutoRecover: boolean read FAutoRecover write FAutoRecover;
    property AutoRecoverInterval: integer read FAutoRecoverInterval write FAutoRecoverInterval;
  end;

  TListStyle = (ListStyleDefault, ListStyleSelected, ListStyleInactive, ListStyleFocused, ListStyleNotTranslated, ListStyleProposed, ListStyleTranslated, ListStyleHold, ListStyleDontTranslate, ListStyleSynthesized);

  TTranslationManagerListStyleSettings = class(TConfigurationSection)
  private
    FColorText: TColor;
    FColorBackground: TColor;
    FBold: integer;
    FListStyle: TListStyle;
  protected
    function GetStyleName: string;
  public
    constructor Create(AOwner: TConfigurationSection; AListStyle: TListStyle); reintroduce;
    property Name: string read GetStyleName;
  published
    property ColorText: TColor read FColorText write FColorText default clDefault;
    property ColorBackground: TColor read FColorBackground write FColorBackground default clDefault;
    property Bold: integer read FBold write FBold default -1;
  end;

  TTranslationManagerStyleSettings = class(TConfigurationSection)
  private
    FStyles: array[TListStyle] of TTranslationManagerListStyleSettings;
    FValid: boolean;
  protected
    procedure ReadSection(const Key: string); override;
    procedure ApplyDefault; override;
    function GetStyle(Index: TListStyle): TTranslationManagerListStyleSettings;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;

    procedure ResetSettings;

    property Styles[Style: TListStyle]: TTranslationManagerListStyleSettings read GetStyle; default;
  published
    property Valid: boolean read FValid write FValid;
    property StyleDefault: TTranslationManagerListStyleSettings index ListStyleDefault read GetStyle;
    property StyleSelected: TTranslationManagerListStyleSettings index ListStyleSelected read GetStyle;
    property StyleInactive: TTranslationManagerListStyleSettings index ListStyleInactive read GetStyle;
    property StyleFocused: TTranslationManagerListStyleSettings index ListStyleFocused read GetStyle;
    property StyleNotTranslated: TTranslationManagerListStyleSettings index ListStyleNotTranslated read GetStyle;
    property StyleProposed: TTranslationManagerListStyleSettings index ListStyleProposed read GetStyle;
    property StyleTranslated: TTranslationManagerListStyleSettings index ListStyleTranslated read GetStyle;
    property StyleHold: TTranslationManagerListStyleSettings index ListStyleHold read GetStyle;
    property StyleDontTranslate: TTranslationManagerListStyleSettings index ListStyleDontTranslate read GetStyle;
    property StyleSynthesized: TTranslationManagerListStyleSettings index ListStyleSynthesized read GetStyle;
  end;

  TTranslationAutoApply = (aaNever, aaAlways, aaPrompt);

  TTranslationManagerEditorSettings = class(TConfigurationSection)
  private
    FStyle: TTranslationManagerStyleSettings;
    FDisplayStatusGlyphs: boolean;
    FStatusGlyphHints: boolean;
    FUseProposedStatus: boolean;
    FEditBiDiMode: boolean;
    FAutoApplyTranslations: TTranslationAutoApply;
    FAutoApplyTranslationsSimilar: TTranslationAutoApply;
    FEqualizerRules: TMakeAlikeRules;
    FSanitizeRules: TSanitizeRules;
    FAutoApplyTranslationsExisting: boolean;
    FAutoShowMultiLineEditor: boolean;
  protected
    procedure ApplyDefault; override;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
  published
    property Style: TTranslationManagerStyleSettings read FStyle;
    property DisplayStatusGlyphs: boolean read FDisplayStatusGlyphs write FDisplayStatusGlyphs default True;
    property StatusGlyphHints: boolean read FStatusGlyphHints write FStatusGlyphHints default False;

    property UseProposedStatus: boolean read FUseProposedStatus write FUseProposedStatus default True;
    property EditBiDiMode: boolean read FEditBiDiMode write FEditBiDiMode default True;
    property AutoShowMultiLineEditor: boolean read FAutoShowMultiLineEditor write FAutoShowMultiLineEditor default True;
    property AutoApplyTranslations: TTranslationAutoApply read FAutoApplyTranslations write FAutoApplyTranslations default aaAlways;
    property AutoApplyTranslationsSimilar: TTranslationAutoApply read FAutoApplyTranslationsSimilar write FAutoApplyTranslationsSimilar default aaAlways;
    property AutoApplyTranslationsExisting: boolean read FAutoApplyTranslationsExisting write FAutoApplyTranslationsExisting default False;
    property EqualizerRules: TMakeAlikeRules read FEqualizerRules write FEqualizerRules;
    property SanitizeRules: TSanitizeRules read FSanitizeRules write FSanitizeRules;
  end;

  TTranslationManagerSearchSettings = class(TConfigurationSection)
  private
    FHistory: TConfigurationStringList;
    FScope: integer;
    FSynchronize: boolean;
  protected
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
  published
    property History: TConfigurationStringList read FHistory;
    property Scope: integer read FScope write FScope default 8; // Translation
    property Synchronize: boolean read FSynchronize write FSynchronize;
  end;

  TTranslationManagerStopListGroupSettings = class(TConfigurationStringList)
  private
    FExpanded: boolean;
  published
    property Expanded: boolean read FExpanded write FExpanded default False;
  end;

  TTranslationManagerStopListSettings = class(TConfigurationSectionValues<TTranslationManagerStopListGroupSettings>)
  strict private
    FValid: boolean;
    FVersion: integer;
    FStopList: TStopListItemList;
    FExpandedState: TDictionary<string, boolean>;
  protected
    function GetGroupExpanded(const Name: string): boolean;
    procedure SetGroupExpanded(const Name: string; const Value: boolean);
    procedure WriteSection(const Key: string); override;
    procedure ReadSection(const Key: string); override;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;

    property StopList: TStopListItemList read FStopList;
    property Expanded[const Name: string]: boolean read GetGroupExpanded write SetGroupExpanded;
  published
    property Valid: boolean read FValid write FValid;
    property Version: integer read FVersion write FVersion;
  end;

  TColorTheme = (ctLight, ctDark, ctCustom);

  TTranslationManagerSystemSettings = class(TConfigurationSection)
  private
    FBooting: boolean;
    FBootCount: integer;
    FFirstRun: boolean;
    FFirstRunThisVersion: boolean;
    FLastBootCompleted: boolean;
  private
    FHideFeedback: boolean;
  private
    FSingleInstance: boolean;
    FSkin: string;
    FColorScheme: string;
    FColorTheme: TColorTheme;
    FIncludeVersionInfo: boolean;
    FModuleNameScheme: TModuleNameScheme;
    FDefaultSourceLocale: string;
    FDefaultTargetLocale: string;
    FApplicationLanguage: LCID;
    FSafeMode: boolean;
    FAutoApplyStopList: boolean;
    FPortable: boolean;
    FPortablePurge: boolean;
  protected
    procedure WriteSection(const Key: string); override;
    procedure ReadSection(const Key: string); override;
  public
    constructor Create(AOwner: TConfigurationSection); override;

    procedure BeginBoot;
    procedure EndBoot;

    property Booting: boolean read FBooting;
    property LastBootCompleted: boolean read FLastBootCompleted;

    property SafeMode: boolean read FSafeMode;
    property Portable: boolean read FPortable write FPortable;

    /// <summary>FirstRun is True if the application has never run before.</summary>
    property FirstRun: boolean read FFirstRun;

    /// <summary>FirstRunThisVersion is True if the current major version of the application has never run before.</summary>
    property FirstRunThisVersion: boolean read FFirstRunThisVersion;

    procedure SetSafeMode;

    // HideFeedback: Experimental. Not yet persisted
    property HideFeedback: boolean read FHideFeedback write FHideFeedback;
  published
    property SingleInstance: boolean read FSingleInstance write FSingleInstance default False;

    property Skin: string read FSkin write FSkin;
    property ColorScheme: string read FColorScheme write FColorScheme;
    property ColorTheme: TColorTheme read FColorTheme write FColorTheme;

    property AutoApplyStopList: boolean read FAutoApplyStopList write FAutoApplyStopList default True;

    property IncludeVersionInfo: boolean read FIncludeVersionInfo write FIncludeVersionInfo default True;
    // ModuleNameScheme: Used to default to mnsISO639_2 but that scheme produces duplicates with Windows 10+
    property ModuleNameScheme: TModuleNameScheme read FModuleNameScheme write FModuleNameScheme default mnsRFC4646;

    property ApplicationLanguage: LCID read FApplicationLanguage write FApplicationLanguage;
    property DefaultSourceLocale: string read FDefaultSourceLocale write FDefaultSourceLocale;
    property DefaultTargetLocale: string read FDefaultTargetLocale write FDefaultTargetLocale;


    property PortablePurge: boolean read FPortablePurge write FPortablePurge;
  end;

type
  TTranslationManagerProjectSettings = class(TConfigurationSection)
  private
    FSaveDontTranslate: boolean;
    FSaveNewState: boolean;
    FSaveSorted: boolean;
    FSaveTransient: boolean;
  published
    property SaveDontTranslate: boolean read FSaveDontTranslate write FSaveDontTranslate default True;
    property SaveNewState: boolean read FSaveNewState write FSaveNewState default False;
    property SaveSorted: boolean read FSaveSorted write FSaveSorted default True;
    property SaveTransient: boolean read FSaveTransient write FSaveTransient default False;
  end;

type
  TTranslationManagerParserSynthesizeSettings = class(TConfigurationStringList)
  strict private type
    TRequiredPropertyRule = record
      TypeMask: string;
      PropertyName: string;
      PropertyValue: string;
    end;
    TRules = TList<TRequiredPropertyRule>;
  private
    FValid: boolean;
    FVersion: integer;
    FEnabled: boolean;
    FRules: TRules;
  protected
    procedure WriteSection(const Key: string); override;
    procedure ReadSection(const Key: string); override;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;

    property Rules: TRules read FRules;
    procedure AddRule(const TypeMask, PropertyName, PropertyValue: string);
  published
    property Valid: boolean read FValid write FValid;
    property Version: integer read FVersion write FVersion;

    property Enabled: boolean read FEnabled write FEnabled;
  end;

  TTranslationManagerParserSettings = class(TConfigurationSection)
  private
    FSynthesize: TTranslationManagerParserSynthesizeSettings;
    FStringListHandling: TStringListHandling;
    function GetStringListHandling: TStringListHandling;
  public
    constructor Create(AOwner: TConfigurationSection); override;
    destructor Destroy; override;
  published
    property StringListHandling: TStringListHandling read GetStringListHandling write FStringListHandling stored False default slSplit;
    property Synthesize: TTranslationManagerParserSynthesizeSettings read FSynthesize;
  end;

type
  TTranslationManagerSettings = class;
  TTranslationManagerSettingsEvent = reference to procedure(Settings: TTranslationManagerSettings);

  TTranslationManagerSettings = class(TConfiguration)
  strict private class var
    FOnSettingsCreating: TTranslationManagerSettingsEvent;
    FOnSettingsDestroying: TTranslationManagerSettingsEvent;
  strict private
    FValid: boolean;
    FVersion: string;
    FSystem: TTranslationManagerSystemSettings;
    FForms: TTranslationManagerFormsSettings;
    FFolders: TTranslationManagerFolderSettings;
    FProviders: TTranslationManagerProviderSettings;
    FProofing: TTranslationManagerProofingSettings;
    FLayout: TTranslationManagerLayoutSettings;
    FBackup: TTranslationManagerBackupSettings;
    FEditor: TTranslationManagerEditorSettings;
    FSearch: TTranslationManagerSearchSettings;
    FStopList: TTranslationManagerStopListSettings;
    FProject: TTranslationManagerProjectSettings;
    FParser: TTranslationManagerParserSettings;
    FMessages: TConfigurationStringValues;
  private
    class function GetFolderInstall: string; static;
  protected
    procedure ReadSection(const Key: string); override;
  public
    constructor Create(Root: HKEY; const APath: string; AAccess: LongWord = KEY_ALL_ACCESS); override;
    destructor Destroy; override;

    procedure ResetSettings;

    class property FolderInstall: string read GetFolderInstall;
    class property OnSettingsCreating: TTranslationManagerSettingsEvent read FOnSettingsCreating write FOnSettingsCreating;
    class property OnSettingsDestroying: TTranslationManagerSettingsEvent read FOnSettingsDestroying write FOnSettingsDestroying;
  published
    property Valid: boolean read FValid write FValid default False;
    property Version: string read FVersion write FVersion;

    property System: TTranslationManagerSystemSettings read FSystem;
    property Folders: TTranslationManagerFolderSettings read FFolders;
    property Forms: TTranslationManagerFormsSettings read FForms;
    property Providers: TTranslationManagerProviderSettings read FProviders;
    property Proofing: TTranslationManagerProofingSettings read FProofing;
    property Layout: TTranslationManagerLayoutSettings read FLayout;
    property Backup: TTranslationManagerBackupSettings read FBackup;
    property Editor: TTranslationManagerEditorSettings read FEditor;
    property Search: TTranslationManagerSearchSettings read FSearch;
    property StopList: TTranslationManagerStopListSettings read FStopList;
    property Project: TTranslationManagerProjectSettings read FProject;
    property Parser: TTranslationManagerParserSettings read FParser;
    property Messages: TConfigurationStringValues read FMessages;
  end;

function TranslationManagerSettings: TTranslationManagerSettings;
function TranslationManagerSettingsLoaded: boolean;


implementation

uses
  IOUtils,
  StrUtils,
  Math,
  Types,
  Registry,
  amVersionInfo,
  amLanguageInfo,
  amLocalization.Environment,
  amLocalization.TranslationMemory.Data.API;

//------------------------------------------------------------------------------
//
//      TCustomFormSettings
//
//------------------------------------------------------------------------------
type
  TFormCracker = class(TCustomForm);

procedure TCustomFormSettings.ApplyDefault;
begin
  inherited;

  FValid := False;
//  FLeft := FForm.ExplicitLeft;
//  FTop := FForm.ExplicitTop;
  FWidth := -1;
  FHeight := -1;
  FMaximized := False;
end;

function TCustomFormSettings.ApplySettings(Form: TCustomForm): boolean;
var
  Monitor: TMonitor;
  WorkareaRect: TRect;
  NewTop, NewLeft, NewWidth, NewHeight: integer;
begin
  Result := Valid;

  if (not Result) then
    exit;

  TFormCracker(Form).SetDesigning(True, False); // To avoid RecreateWnd
  try

    TFormCracker(Form).Position := poDesigned;
    TFormCracker(Form).DefaultMonitor := dmDesktop;

  finally
    TFormCracker(Form).SetDesigning(False, False);
  end;

  // Find the monitor containing the top/left corner.
  // If the point is outside available monitors then the nearest monitor is used.
  Monitor := Screen.MonitorFromPoint(Point(Left, Top), mdNearest);

  WorkareaRect := Monitor.WorkareaRect;

  if (Height <> -1) then
    NewHeight := Min(MulDiv(Height, Form.PixelsPerInch, 96), WorkareaRect.Height)
  else
    NewHeight := TFormCracker(Form).Height;
  if (Width <> -1) then
    NewWidth := Min(MulDiv(Width, Form.PixelsPerInch, 96), WorkareaRect.Width)
  else
    NewWidth := TFormCracker(Form).Width;

  if (PtInRect(WorkareaRect, Point(Left, Top))) then
  begin
    NewTop := Top;
    NewLeft := Left;
  end else
  begin
    // Center on monitor if top/left is outside screen (e.g. if a monitor has been removed)
    NewTop := WorkareaRect.Top + (WorkareaRect.Height - NewHeight) div 2;
    NewLeft := WorkareaRect.Left + (WorkareaRect.Width - NewWidth) div 2;
  end;

  Form.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);

(* Altering WindowState of a DevExpress ribbon form before form has been shown breaks it (RecreateWnd called).
  if (Maximized) then
    TFormCracker(Form).WindowState := wsMaximized
  else
    TFormCracker(Form).WindowState := wsNormal;
*)
end;

function TCustomFormSettings.PrepareSettings(Form: TCustomForm): boolean;
var
  wp: TWindowPlacement;
begin
  Valid := True;

  wp.length := Sizeof(wp);
  GetWindowPlacement(Form.Handle, @wp);
  Left := wp.rcNormalPosition.Left;
  Top := wp.rcNormalPosition.Top;
  Height := MulDiv(wp.rcNormalPosition.Bottom-Top, 96, Form.PixelsPerInch);
  Width := MulDiv(wp.rcNormalPosition.Right-Left, 96, Form.PixelsPerInch);
  Maximized := (Form.WindowState = wsMaximized);
  Visible := Form.Visible;

  Result := True;
end;

procedure TCustomFormSettings.ReadSection(const Key: string);
begin
  inherited;
  if (not Valid) then
    ResetSettings;
end;

procedure TCustomFormSettings.WriteSection(const Key: string);
begin
  if (Valid) then
    inherited;
end;

procedure TCustomFormSettings.ResetSettings;
begin
  Reset;
end;

//------------------------------------------------------------------------------
//
//      TTranslationManagerFolderSettings
//
//------------------------------------------------------------------------------
procedure TTranslationManagerFolderSettings.ApplyDefault;
var
  Folder: TTranslationManagerFolder;
begin
  inherited;

  for Folder := Low(TTranslationManagerFolder) to High(TTranslationManagerFolder) do
    FFolders[Folder] := FolderDefault[Folder];
end;

constructor TTranslationManagerFolderSettings.Create(AOwner: TConfigurationSection);
begin
  inherited Create(AOwner);
  FRecentFiles := TConfigurationStringList.Create(Self);
  FRecentApplications := TConfigurationStringList.Create(Self);
end;

destructor TTranslationManagerFolderSettings.Destroy;
begin
  FRecentFiles.Free;
  FRecentApplications.Free;
  inherited;
end;

//------------------------------------------------------------------------------

procedure TTranslationManagerFolderSettings.ResetSettings;
begin
  Reset;
end;

procedure TTranslationManagerFolderSettings.ReadSection(const Key: string);
begin
  inherited;
  if (not Valid) then
    ResetSettings;
end;

procedure TTranslationManagerFolderSettings.WriteSection(const Key: string);
begin
  Valid := True;
  inherited;
end;

//------------------------------------------------------------------------------

function TTranslationManagerFolderSettings.GetFolder(Index: TTranslationManagerFolder): string;
begin
  Result := FFolders[Index];
  if (Result <>'') then
    Result := IncludeTrailingPathDelimiter(Result);
end;

function TTranslationManagerFolderSettings.GetFolderName(Index: TTranslationManagerFolder): string;
begin
  Result := sFolderDisplayName[Index];
end;

function TTranslationManagerFolderSettings.GetFolderReadOnly(Index: TTranslationManagerFolder): boolean;
begin
  Result := cFolderReadOnly[Index];
end;

procedure TTranslationManagerFolderSettings.SetFolder(Index: TTranslationManagerFolder; const Value: string);
begin
  FFolders[Index] := Value;
end;

function TTranslationManagerFolderSettings.GetFolderDefault(Index: TTranslationManagerFolder): string;
begin
  Result := sFolderDefault[Index];
end;

function TTranslationManagerFolderSettings.ValidateFolders: boolean;
var
  Folder: TTranslationManagerFolder;
  Path: string;
begin
  Result := True;

  for Folder := Low(TTranslationManagerFolder) to High(TTranslationManagerFolder) do
  begin
    Path := FFolders[Folder];

    if (CheckDirectory(FolderName[Folder], FolderDefault[Folder], Path, not FolderReadOnly[Folder],
      function(const Filename: string): string
      begin
        Result := EnvironmentVars.ExpandString(Filename);
      end)) then
      FFolders[Folder] := Path
    else
      Exit(False);
  end;
end;


//------------------------------------------------------------------------------
//
//      TTranslationManagerFormsSettings
//
//------------------------------------------------------------------------------
constructor TTranslationManagerFormsSettings.Create(AOwner: TConfigurationSection);
begin
  inherited Create(AOwner);
  FMain := TTranslationManagerFormMainSettings.Create(Self);
end;

destructor TTranslationManagerFormsSettings.Destroy;
begin
  FMain.Free;
  inherited;
end;

procedure TTranslationManagerFormsSettings.ResetSettings;
begin
  ApplyDefault;

  FMain.ResetSettings;
end;

//------------------------------------------------------------------------------
//
//      TTranslationManagerSettings
//
//------------------------------------------------------------------------------
constructor TTranslationManagerSettings.Create(Root: HKEY; const APath: string; AAccess: LongWord = KEY_ALL_ACCESS);
begin
  inherited Create(Root, APath, AAccess);

  FSystem := TTranslationManagerSystemSettings.Create(Self);
  FForms := TTranslationManagerFormsSettings.Create(Self);
  FFolders := TTranslationManagerFolderSettings.Create(Self);
  FProviders := TTranslationManagerProviderSettings.Create(Self);
  FProofing := TTranslationManagerProofingSettings.Create(Self);
  FLayout := TTranslationManagerLayoutSettings.Create(Self);
  FBackup := TTranslationManagerBackupSettings.Create(Self);
  FEditor := TTranslationManagerEditorSettings.Create(Self);
  FSearch := TTranslationManagerSearchSettings.Create(Self);
  FStopList := TTranslationManagerStopListSettings.Create(Self);
  FProject := TTranslationManagerProjectSettings.Create(Self);
  FParser := TTranslationManagerParserSettings.Create(Self);
  FMessages := TConfigurationStringValues.Create(Self);

  if (Assigned(FOnSettingsCreating)) then
    FOnSettingsCreating(Self);
end;

destructor TTranslationManagerSettings.Destroy;
begin
  if (Assigned(FOnSettingsDestroying)) then
    FOnSettingsDestroying(Self);

  FSystem.Free;
  FForms.Free;
  FFolders.Free;
  FProviders.Free;
  FProofing.Free;
  FLayout.Free;
  FBackup.Free;
  FEditor.Free;
  FSearch.Free;
  FStopList.Free;
  FProject.Free;
  FParser.Free;
  FMessages.Free;

  inherited;
end;


//------------------------------------------------------------------------------

class function TTranslationManagerSettings.GetFolderInstall: string;
begin
  Result := IncludeTrailingPathDelimiter(TPath.GetDirectoryName(ParamStr(0)));
end;

//------------------------------------------------------------------------------

procedure TTranslationManagerSettings.ReadSection(const Key: string);
begin
  inherited;

  // Migrate Filters to StopList
  if (not StopList.Valid) and (Registry.KeyExists(KeyPath+'Filters')) then
  begin
    // The Filters section did not encode the string values.
    StopList.Version := cStopListVersionNoEncoded;

    StopList.ReadSection('Filters\');

    if (StopList.Valid) then
    begin
      StopList.WriteSection(StopList.Name+'\');
      TRegistry(Registry).DeleteKey(KeyPath+'Filters');
    end;
  end;
end;

procedure TTranslationManagerSettings.ResetSettings;
begin
  ApplyDefault;

  FForms.ResetSettings;
  FFolders.ResetSettings;
end;

//------------------------------------------------------------------------------
//
//      TranslationManagerSettings
//
//------------------------------------------------------------------------------
var
  FTranslationManagerSettings: TTranslationManagerSettings = nil;

function TranslationManagerSettingsLoaded: boolean;
begin
  Result := (FTranslationManagerSettings <> nil);
end;

function TranslationManagerSettings: TTranslationManagerSettings;
begin
  if (FTranslationManagerSettings = nil) then
  begin
    FTranslationManagerSettings := TTranslationManagerSettings.Create(TranslationManagerRegistryKey, TranslationManagerRegistryRoot);

    FTranslationManagerSettings.ReadConfig;
    if (not FTranslationManagerSettings.Valid) then
      FTranslationManagerSettings.ResetSettings;
  end;
  Result := FTranslationManagerSettings;
end;

//------------------------------------------------------------------------------

{ TTranslationManagerProviderSettings }

constructor TTranslationManagerProviderSettings.Create(AOwner: TConfigurationSection);
begin
  inherited;
  FMicrosoftV3 := TTranslationManagerProviderMicrosoftTranslatorV3Settings.Create(Self);
  FTranslationMemory := TTranslationManagerProviderTM.Create(Self);
  FDeepL := TTranslationManagerProviderDeepLSettings.Create(Self);
  FOllama := TTranslationManagerProviderOllamaSettings.Create(Self);
end;

destructor TTranslationManagerProviderSettings.Destroy;
begin
  FOllama.Free;
  FDeepL.Free;
  FMicrosoftV3.Free;
  FTranslationMemory.Free;
  inherited;
end;

procedure TTranslationManagerProviderSettings.ResetSettings;
begin
  Reset; // This recurses to call ApplyDefault on child sections
end;

{ TTranslationManagerProviderTM }

procedure TTranslationManagerProviderTM.ApplyDefault;
begin
  inherited;

  FFilename := '%DATA%\' + sTranslationMemoryFilename;
end;

{ TTranslationManagerLayoutSettings }

constructor TTranslationManagerLayoutSettings.Create(AOwner: TConfigurationSection);
begin
  inherited;

  FModuleTree := TTranslationManagerLayoutTreeSettings.Create(Self);
  FItemGrid := TTranslationManagerLayoutGridSettings.Create(Self);
  FTranslationMemory := TTranslationManagerLayoutGridSettings.Create(Self);
  FBlackList := TTranslationManagerLayoutGridSettings.Create(Self);
  FSearchResult := TTranslationManagerLayoutGridSettings.Create(Self);
end;

destructor TTranslationManagerLayoutSettings.Destroy;
begin
  FModuleTree.Free;
  FItemGrid.Free;
  FTranslationMemory.Free;
  FBlackList.Free;
  FSearchResult.Free;

  inherited;
end;

{ TTranslationManagerSystemSettings }

constructor TTranslationManagerSystemSettings.Create(AOwner: TConfigurationSection);
begin
  inherited;

  FFirstRun := True;
  FFirstRunThisVersion := True;
  FHideFeedback := True;
  FModuleNameScheme := mnsRFC4646;
end;

procedure TTranslationManagerSystemSettings.BeginBoot;
begin
  Inc(FBootCount);

  if (FBootCount = 1) then
  begin
    FBooting := True;

    // Set boot marker
    Registry.WriteBoolean(Key, 'Booting', True);
  end;
end;

procedure TTranslationManagerSystemSettings.EndBoot;
begin
  Dec(FBootCount);

  if (FBootCount = 0) then
  begin
    FBooting := False;

    // Clear boot marker
    Registry.WriteBool(Key, 'Booting', False);

    // Boot complete - clear safe mode
    Registry.WriteBoolean(Key, 'SafeMode', False);
    // Set first run marker
    Registry.WriteBoolean(Key, 'HasBeenRun', True);
  end;
end;

procedure TTranslationManagerSystemSettings.ReadSection(const Key: string);
var
  SavedVersionMajor: Word;
  ThisVersionMajor: Word;
  VersionInfo: TVersionInfo;
begin
  // Import deprecated DefaultSourceLanguage and DefaultTargetLanguage values
  var LocaleID: DWORD := DWORD(Registry.ReadInteger(Key, 'DefaultSourceLanguage', -1));
  if (LocaleID <> DWORD(-1)) then
  begin
    var Language := LanguageInfo.FindLCID(LocaleID);
    if (Language <> nil) then
      FDefaultSourceLocale := Language.LocaleName;
  end;

  LocaleID := DWORD(Registry.ReadInteger(Key, 'DefaultTargetLanguage', -1));
  if (LocaleID <> DWORD(-1)) then
  begin
    var Language := LanguageInfo.FindLCID(LocaleID);
    if (Language <> nil) then
      FDefaultTargetLocale := Language.LocaleName;
  end;

  inherited ReadSection(Key);

  FSafeMode := Registry.ReadBoolean(Key, 'SafeMode', FSafeMode);
  FLastBootCompleted := not Registry.ReadBoolean(Key, 'Booting', False);
  FFirstRun := not Registry.ReadBoolean(Key, 'HasBeenRun', False);

  SavedVersionMajor := TVersionInfo.VersionMajor(TVersionInfo.StringToVersion(TTranslationManagerSettings(Owner).Version));
  VersionInfo := TVersionInfo.Create(Application.ExeName);
  try
    ThisVersionMajor := TVersionInfo.VersionMajor(VersionInfo.FileVersion);
  finally
    VersionInfo.Free;
  end;
  FFirstRunThisVersion := (FFirstRunThisVersion) or (FFirstRun) or (ThisVersionMajor <> SavedVersionMajor);
end;

procedure TTranslationManagerSystemSettings.WriteSection(const Key: string);
begin
  inherited WriteSection(Key);

  Registry.WriteBoolean(Key, 'SafeMode', False);
  Registry.WriteBoolean(Key, 'HasBeenRun', True);

  // Remove deprecated settings
  Registry.DeleteKey(Key, 'DefaultSourceLanguage');
  Registry.DeleteKey(Key, 'DefaultTargetLanguage');
end;

procedure TTranslationManagerSystemSettings.SetSafeMode;
begin
  FSafeMode := True;
  Registry.WriteBoolean(Key, 'SafeMode', True);
end;

{ TTranslationManagerStyleSettings }

procedure TTranslationManagerStyleSettings.ApplyDefault;
begin
  inherited;

  StyleDefault.ColorText := clBlack;
  StyleDefault.ColorBackground := clWhite;
  StyleDefault.Bold := 0;

  StyleSelected.ColorText := clHighlightText;
  StyleSelected.ColorBackground := clHighlight;
  StyleSelected.Bold := -1;

  StyleInactive.ColorText := clDefault;
  StyleInactive.ColorBackground := $00C4996F;
  StyleInactive.Bold := -1;

  StyleFocused.ColorText := clHighlightText;
  StyleFocused.ColorBackground := clHighlight;
  StyleFocused.Bold := 1;

  StyleNotTranslated.ColorText := clDefault;
  StyleNotTranslated.ColorBackground := clDefault;
  StyleNotTranslated.Bold := -1;

  StyleProposed.ColorText := $00FF7900;
  StyleProposed.ColorBackground := clDefault;
  StyleProposed.Bold := -1;

  StyleTranslated.ColorText := $00FF7900;
  StyleTranslated.ColorBackground := $00FFF8F0;
  StyleTranslated.Bold := -1;

  StyleHold.ColorText := clDefault;
  StyleHold.ColorBackground := $00F4F4FF;
  StyleHold.Bold := -1;

  StyleDontTranslate.ColorText := clGray;
  StyleDontTranslate.ColorBackground := $00F4F4FF;
  StyleDontTranslate.Bold := -1;

  StyleSynthesized.ColorText := clDefault;
  StyleSynthesized.ColorBackground := $00ECFFEC;
  StyleSynthesized.Bold := -1;
end;

constructor TTranslationManagerStyleSettings.Create(AOwner: TConfigurationSection);
var
  ListStyle: TListStyle;
begin
  inherited Create(AOwner);

  for ListStyle := Low(TListStyle) to High(TListStyle) do
    FStyles[ListStyle] := TTranslationManagerListStyleSettings.Create(Self, ListStyle);
end;

destructor TTranslationManagerStyleSettings.Destroy;
var
  ListStyle: TListStyle;
begin
  for ListStyle := Low(TListStyle) to High(TListStyle) do
    FStyles[ListStyle].Free;

  inherited;
end;

function TTranslationManagerStyleSettings.GetStyle(Index: TListStyle): TTranslationManagerListStyleSettings;
begin
  Result := FStyles[Index];
end;

procedure TTranslationManagerStyleSettings.ReadSection(const Key: string);
begin
  inherited ReadSection(Key);

  if (not Valid) then
    ApplyDefault;

  Valid := True;
end;

procedure TTranslationManagerStyleSettings.ResetSettings;
begin
  Reset;
end;

{ TTranslationManagerEditorSettings }

procedure TTranslationManagerEditorSettings.ApplyDefault;
begin
  inherited;

  FEqualizerRules := [Low(TMakeAlikeRule)..High(TMakeAlikeRule)]-[EqualizeSpace];
  FSanitizeRules := [Low(TSanitizeRule)..High(TSanitizeRule)]-[skFormat];
end;

constructor TTranslationManagerEditorSettings.Create(AOwner: TConfigurationSection);
begin
  inherited Create(AOwner);
  FStyle := TTranslationManagerStyleSettings.Create(Self);
end;

destructor TTranslationManagerEditorSettings.Destroy;
begin
  FStyle.Free;
  inherited;
end;

{ TTranslationManagerListStyleSettings }

constructor TTranslationManagerListStyleSettings.Create(AOwner: TConfigurationSection; AListStyle: TListStyle);
begin
  inherited Create(AOwner);
  FListStyle := AListStyle;
end;

function TTranslationManagerListStyleSettings.GetStyleName: string;
const
  // TODO : Localization
  sStyleNames: array[TListStyle] of string = (
    'Default',
    'Selected',
    'Inactive',
    'Focused',
    'Not translated',
    'Proposed',
    'Translated',
    'Hold',
    'Don''t translate',
    'Synthesized'
  );
begin
  Result := sStyleNames[FListStyle];
end;

{ TTranslationManagerFiltersSettings }

constructor TTranslationManagerStopListSettings.Create(AOwner: TConfigurationSection);
begin
  inherited Create(AOwner);
  PurgeOnWrite := True;
  FStopList := TStopListItemList.Create;
  FExpandedState := TDictionary<string, boolean>.Create;

  // cStopListVersionUrlEncoded was the last version that didn't store the version value.
  // If the value is stored it will be set to the correct version by ReadSection.
  FVersion := cStopListVersionUrlEncoded;
end;

destructor TTranslationManagerStopListSettings.Destroy;
begin
  FStopList.Free;
  FExpandedState.Free;
  inherited;
end;

function TTranslationManagerStopListSettings.GetGroupExpanded(const Name: string): boolean;
var
  Group: string;
begin
  Group := Name;
  if (Group = '') then
    Group := sStopListGroupGeneral;
  if (not FExpandedState.TryGetValue(Group, Result)) then
    Result := False;
end;

procedure TTranslationManagerStopListSettings.ReadSection(const Key: string);

  procedure StringToStopList(const Group, Value: string);
  var
    s: string;
    StopListItem: TStopListItem;
  begin
    StopListItem := TStopListItem.Create;
    FStopList.Add(StopListItem);

    StopListItem.LoadFromString(Value, False, FVersion);

    s := Group;
    if (s = sStopListGroupGeneral) then
      s := '';
    StopListItem.Group := s;
  end;

var
  i, j: integer;
  Group: string;
  GroupSection: TTranslationManagerStopListGroupSettings;
begin
  inherited ReadSection(Key);

  FStopList.Clear;
  FExpandedState.Clear;

  if (not Valid) then
  begin
    // Add a few filters just to get us going
    // Don't translate
    StringToStopList('', '1/3/0/Font.Name');
    StringToStopList('', '1/4/0/TAction.Category');
    StringToStopList('', '1/5/1/Lorem ipsum');
    StringToStopList('DevExpress', '1/2/0/TdxLayoutEmptySpaceItem');
    StringToStopList('DevExpress', '1/2/0/TdxLayoutSeparatorItem');
    StringToStopList('DevExpress', '1/2/0/TcxImageList');
    StringToStopList('DevExpress', '1/3/0/Properties.KeyFieldNames');
    StringToStopList('DevExpress', '1/3/0/DataBinding.ValueType');
    Exit;
  end;

  if (FVersion < cStopListVersion) then
  begin
    // Upgrade older version
    // ...
  end;

  for i := 0 to Count-1 do
  begin
    Group := Names[i];
    GroupSection := Items[Group];

    for j := 0 to GroupSection.Count-1 do
      StringToStopList(Group, GroupSection[j]);

    if (Group = '') then
      Group := sStopListGroupGeneral;
    FExpandedState.AddOrSetValue(Group, GroupSection.Expanded);
  end;
end;

procedure TTranslationManagerStopListSettings.SetGroupExpanded(const Name: string; const Value: boolean);
var
  Group: string;
begin
  Group := Name;
  if (Group = '') then
    Group := sStopListGroupGeneral;
  FExpandedState.AddOrSetValue(Group, Value);
end;

procedure TTranslationManagerStopListSettings.WriteSection(const Key: string);
var
  StopListItem: TStopListItem;
  Group: string;
  GroupSection: TTranslationManagerStopListGroupSettings;
  i: integer;
  Expanded: boolean;
begin
  Clear;

  for StopListItem in FStopList do
  begin
    Group := StopListItem.Group;
    if (Group = '') then
      Group := sStopListGroupGeneral;
    GroupSection := FindOrAdd(Group);
    GroupSection.Add(StopListItem.SaveToString(False));
  end;

  for i := 0 to Count-1 do
  begin
    Group := Names[i];
    if (Group = '') then
      Group := sStopListGroupGeneral;
    if (not FExpandedState.TryGetValue(Group, Expanded)) then
      Expanded := False;

    Items[i].Expanded := Expanded;
  end;

  FValid := True;
  FVersion := cStopListVersion;

  inherited WriteSection(Key);
end;


{ TTranslationManagerProviderMicrosoftTranslatorV3Settings }

procedure TTranslationManagerProviderMicrosoftTranslatorV3Settings.ApplyDefault;
begin
  inherited;
  FRegion := 'global';
end;

{ TTranslationManagerSearchSettings }

constructor TTranslationManagerSearchSettings.Create(AOwner: TConfigurationSection);
begin
  inherited;
  FHistory := TConfigurationStringList.Create(Self);
end;

destructor TTranslationManagerSearchSettings.Destroy;
begin
  FHistory.Free;
  inherited;
end;

{ TTranslationManagerParserSettings }

constructor TTranslationManagerParserSettings.Create(AOwner: TConfigurationSection);
begin
  inherited;
  FSynthesize := TTranslationManagerParserSynthesizeSettings.Create(Self);
end;

destructor TTranslationManagerParserSettings.Destroy;
begin
  FSynthesize.Free;
  inherited;
end;

function TTranslationManagerParserSettings.GetStringListHandling: TStringListHandling;
begin
  Result := amLocalization.Model.StringListHandling;
end;

{ TTranslationManagerParserSynthesizeSettings }

procedure TTranslationManagerParserSynthesizeSettings.AddRule(const TypeMask, PropertyName, PropertyValue: string);
begin
  var Rule: TRequiredPropertyRule;
  Rule.TypeMask := TypeMask;
  Rule.PropertyName := PropertyName;
  Rule.PropertyValue := PropertyValue;
  FRules.Add(Rule);
end;

constructor TTranslationManagerParserSynthesizeSettings.Create( AOwner: TConfigurationSection);
begin
  inherited;
  FRules := TList<TRequiredPropertyRule>.Create;
end;

destructor TTranslationManagerParserSynthesizeSettings.Destroy;
begin
  FRules.Free;
  inherited;
end;

procedure TTranslationManagerParserSynthesizeSettings.ReadSection(const Key: string);
const
  DefaultRules: array[0..0] of TRequiredPropertyRule = (
    (TypeMask: '^T([A-Z][a-z]+)+Field$'; PropertyName: 'DisplayLabel'; PropertyValue: '@FieldName')
  );
begin
  FRules.Clear;

  inherited ReadSection(Key);

  if (not Valid) then
  begin
    for var Rule in DefaultRules do
      FRules.Add(Rule);
    exit;
  end;

  if (FVersion < 0) then
    {upgrade};

  for var RuleString in Strings do
  begin
    var SplitRule := RuleString.Split(['/']);
    if (Length(SplitRule) <> 3) then
      continue;
    var Rule: TRequiredPropertyRule;
    Rule.TypeMask := SplitRule[0];
    Rule.PropertyName := SplitRule[1];
    Rule.PropertyValue := SplitRule[2];
    FRules.Add(Rule);
  end;
end;

procedure TTranslationManagerParserSynthesizeSettings.WriteSection(const Key: string);
begin
  Clear;

  FValid := True;
  FVersion := 0;

  for var Rule in FRules do
  begin
    var RuleString := Rule.TypeMask + '/' + Rule.PropertyName + '/' + Rule.PropertyValue;
    Strings.Add(RuleString);
  end;

  inherited WriteSection(Key);
end;

initialization
//  ConfigurationServiceRegistryKey := TranslationManagerRegistryKey;
//  ConfigurationServiceRegistryRoot := TranslationManagerRegistryRoot;
finalization
  FreeAndNil(FTranslationManagerSettings);
end.