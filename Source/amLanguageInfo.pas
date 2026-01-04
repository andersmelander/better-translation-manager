unit amLanguageInfo;

(*
 * Copyright © 2014 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Generics.Collections,
  System.Generics.Defaults,
  System.Classes,
  WinApi.Windows,
  WinApi.ActiveX,
  VCL.Graphics;

type
//------------------------------------------------------------------------------
//
//      TLanguageItem
//
//------------------------------------------------------------------------------
  TLanguageItem = class
  private
    FLocaleName: string; // Primary key. All other values are derived from this.

    FLocale: LCID;
    FISO3166Name: string;
    FCountryName: string;
    FFlag: TBitmap;
    FDisplayName: string;
    FLanguageName: string;
    FLanguageShortName: string;
    FFallbackName: string;
    FFallback: TLanguageItem;
    FCharSet: integer;
    FReadingLayout: integer;
    FInvariant: boolean;
    FIgnore: boolean;
    FTag: NativeInt;
  protected
    function GetFlag: TBitmap;
    function GetLocaleID: LCID;
    function GetIsCustomLocale: boolean;
    function GetLanguageID: LangID;
    function GetPrimaryLanguageID: Word;
    function GetSubLanguageID: Word;
    function GetISO3166Name: string;
    function GetISO639_1Name: string;
    function GetISO639_2Name: string;
    function GetDisplayName: string;
    function GetEnglishDisplayName: string;
    function GetLanguageName: string;
    function GetEnglishLanguageName: string;
    function GetLanguageShortName: string;
    function GetFallbackName: string;
    function GetFallback: TLanguageItem;
    function GetCountryCode: integer;
    function GetCountryName: string;
    function GetEnglishCountryName: string;
    function GetAnsiCodePage: integer;
    function GetCharSet: integer;
    function GetReadingLayout: integer;
    function GetIsLeftToRight: boolean;
    function GetIsRightToLeft: boolean;
  public
    // ALocaleName = RFC4646 code (e.g. en-Us)
    constructor Create(const ALocaleName: string);
    destructor Destroy; override;

    function ReleaseFlag: TBitmap;
    procedure DestroyFlag;

    class function GetLocaleData(const ALocaleName: string; Flag: DWORD): string; overload; static;
    class function GetLocaleDataInt(const ALocaleName: string; Flag: DWORD): DWORD; overload; static;

    function GetLocaleData(Flag: DWORD): string; overload;
    function GetLocaleDataInt(Flag: DWORD): DWORD; overload;

    /// <summary>LocaleName: The RFC 4646 language-region code.
    /// E.g. en-US, en-GB, da-DK, de-DE etc.</summary>
    property LocaleName: string read FLocaleName;

    property Flag: TBitmap read GetFlag; // Note: Include amFlags unit to include flag resources

    property LocaleID: LCID read GetLocaleID;
    property PrimaryLanguageID: Word read GetPrimaryLanguageID;
    property SubLanguageID: Word read GetSubLanguageID;
    property LanguageID: LangID read GetLanguageID;
    property IsCustomLocale: boolean read GetIsCustomLocale;

    /// <summary>ISO3166Name: The ISO3166-1 alpha-2 two letter country code.
    /// E.g. US, GB, DK, DE etc.</summary>
    property ISO3166Name: string read GetISO3166Name;

    /// <summary>ISO639_1Name: The ISO639-1 two letter language code.
    /// E.g. EN, DA, DE etc.</summary>
    property ISO639_1Name: string read GetISO639_1Name;

    /// <summary>ISO639_2Name: The ISO639-2 three letter language/region code.
    /// E.g. ENG, DAN, DEU etc.</summary>
    property ISO639_2Name: string read GetISO639_2Name;

    /// <summary>DisplayName: Localized display name.
    /// E.g. Deutsch (Deutschland)</summary>
    property DisplayName: string read GetDisplayName;
    /// <summary>EnglishDisplayName: Display name of the locale in English.
    /// E.g. German (Germany)</summary>
    property EnglishDisplayName: string read GetEnglishDisplayName;

    /// <summary>LanguageName: Localized primary language name.
    /// E.g. Deutsch</summary>
    property LanguageName: string read GetLanguageName;
    /// <summary>EnglishLanguageName: English name of the language in English.
    /// E.g. German</summary>
    property EnglishLanguageName: string read GetEnglishLanguageName;

    /// <summary>LanguageShortName: Abbreviated, three letter language-region code.
    /// E.g. ENU, ENG, DAN, DEU etc.
    /// Note: Not identical to ISO639-2.</summary>
    property LanguageShortName: string read GetLanguageShortName;
    function HasLanguageShortName: boolean;

    /// <summary>Fallback: Fallback locale.
    /// E.g. EN for ENU, DE for DEU, etc.
    /// Note: FallbackName is not guaranteed to map to an actual locale in which
    /// case Fallback is nil.</summary>
    property Fallback: TLanguageItem read GetFallback;
    property FallbackName: string read GetFallbackName;

    /// <summary>CountryCode: IBM country code.</summary>
    property CountryCode: integer read GetCountryCode;

    /// <summary>LanguageName: Localized country name.
    /// E.g. Deutschland</summary>
    property CountryName: string read GetCountryName;
    /// <summary>EnglishLanguageName: English name of the country/region.
    /// E.g. Germany</summary>
    property EnglishCountryName: string read GetEnglishCountryName;

    /// <summary>AnsiCodePage: Default code page for non-unicode applications.</summary>
    property AnsiCodePage: integer read GetAnsiCodePage;

    property CharSet: integer read GetCharSet;
    property ReadingLayout: integer read GetReadingLayout;
    property IsLeftToRight: boolean read GetIsLeftToRight;
    property IsRightToLeft: boolean read GetIsRightToLeft;

    /// <summary>Invariant: Neutral locale data, that is, data defined by language only. Country/region data uses the default.</summary>
    property Invariant: boolean read FInvariant write FInvariant;

    /// <summary>Tag: Custom data. Not touched by the library.</summary>
    property Tag: NativeInt read FTag write FTag;
    /// <summary>Ignore: Custom data. Not touched by the library.</summary>
    property Ignore: boolean read FIgnore write FIgnore;
  end;

//------------------------------------------------------------------------------
//
//      LanguageInfo
//
//------------------------------------------------------------------------------
  TLanguageInfo = record
  private
    class var
      FLanguageItems: TDictionary<string, TLanguageItem>;
      FLCIDToLanguage: TDictionary<LCID, TLanguageItem>;
  private
    procedure AddItem(LanguageItem: TLanguageItem);
    procedure LoadLanguageItems;
    function GetCount: integer;
  strict private
    class constructor Create;
    class destructor Destroy;
  public
    function FindLCID(Value: LCID): TLanguageItem;

    // FindName: Search for DisplayName.
    function FindName(const Value: string): TLanguageItem;

    // FindLocale: If the value is numeric calls FindLCID. Otherwise calls
    // FindLocaleName.
    function FindLocale(const Value: string): TLanguageItem;

    // FindLocaleName: Search by LocaleName, then by ISO639_1Name
    function FindLocaleName(const Value: string; Exact: boolean = False): TLanguageItem;

    function FindCountry(const Value: string): TLanguageItem;
    function FindLanguageName(const Value: string): TLanguageItem;
    function FindLanguageShortName(const Value: string): TLanguageItem;
    function FindISO639_1Name(const Value: string): TLanguageItem;
    function FindISO3166Name(const Value: string): TLanguageItem;

    // Wraps the ResolveLocaleName API function
    function ResolveLocaleName(const Value: string): TLanguageItem;

    // Wraps the GetUserDefaultLocaleName API function
    function UserDefaultLocale: TLanguageItem;
    // Wraps the GetSystemDefaultLocaleName  API function
    function SystemDefaultLocale: TLanguageItem;
    // Same as UserDefaultLocale with fallback to SystemDefaultLocale
    function DefaultLocale: TLanguageItem;

    property Count: integer read GetCount;

    function GetEnumerator: TEnumerator<TLanguageItem>;
  end;

var
  LanguageInfo: TLanguageInfo;

const
  LOCALE_SLANGDISPLAYNAME = $0000006f;
  LOCALE_SLOCALIZEDLANGUAGENAME = $0000006f;

//------------------------------------------------------------------------------
//
//      Utilities
//
//------------------------------------------------------------------------------
function LocaleName: string; deprecated 'Use LanguageInfo.DefaultLocale';
function LocaleISO3166Name: string; deprecated 'Use LanguageInfo.DefaultLocale';
function LocaleMonetaryGrouping(Index: integer): integer;
procedure ClearLocale;
procedure SetLocale(Locale: LCID);
function MakeLangID(Primary, Region: Word ): Word;
function TryLocaleToISO639_1Name(Locale: LCID; var Value: string): boolean; deprecated 'Avoid use of LCID';
function LocaleToISO639_1Name(Locale: LCID; const Default: string = ''): string; deprecated 'Avoid use of LCID';
function TryISO639_1NameToLocale(const Name: string; var Value: LCID): boolean; deprecated 'Avoid use of LCID';
function ISO639_1NameToLocale(const Name: string; Default: LCID = 0): TLCID; deprecated 'Avoid use of LCID';

function LoadNewResourceModule(Locale: LCID): HModule; overload;
function LoadNewResourceModule(const LocaleName: string): HModule; overload;
function LoadNewResourceModule(LocaleItem: TLanguageItem): HModule; overload;
function LoadNewResourceModule(LocaleItem: TLanguageItem; var ModuleFilename: string): HModule; overload;

var
  // Semi-colon delimited list of paths that LoadNewResourceModule will search
  // when loading a resource module.
  // Relative paths are relative to the application folder.
  // Leave empty to only search the application folder.
  ResourceModulePaths: string = '';


//------------------------------------------------------------------------------
//
//      MLang
//
//------------------------------------------------------------------------------
const
  IID_IMultiLanguage2: TGUID = '{DCCFC164-2B38-11D2-B7EC-00C04F8F5D9A}';
  CLSID_CMultiLanguage: TGUID = '{275C23E2-3747-11D0-9FEA-00AA003F8646}';

type
  tagMIMECPINFO = packed record
    dwFlags: LongWord;
    uiCodePage: SYSUINT;
    uiFamilyCodePage: SYSUINT;
    wszDescription: array[0..63] of WideChar;
    wszWebCharset: array[0..49] of WideChar;
    wszHeaderCharset: array[0..49] of WideChar;
    wszBodyCharset: array[0..49] of WideChar;
    wszFixedWidthFont: array[0..31] of WideChar;
    wszProportionalFont: array[0..31] of WideChar;
    bGDICharset: Byte;
    padding : array [0..2] of Byte;
  end;

  tagMIMECSETINFO = packed record
    uiCodePage: SYSUINT;
    uiInternetEncoding: SYSUINT;
    wszCharset: array[0..49] of WideChar;
  end;

  tagRFC1766INFO = packed record
    lcid: LongWord;
    wszRfc1766: array[0..5] of WideChar;
    wszLocaleName: array[0..31] of WideChar;
  end;

  tagDetectEncodingInfo = packed record
    nLangID: SYSUINT;
    nCodePage: SYSUINT;
    nDocPercent: SYSINT;
    nConfidence: SYSINT;
  end;

  __MIDL_IWinTypes_0009 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: Integer);
  end;

  _RemotableHandle = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0009;
  end;

  tagSCRIPTINFO = packed record
    ScriptId: Byte;
    uiCodePage: SYSUINT;
    wszDescription: array[0..47] of WideChar;
    wszFixedWidthFont: array[0..31] of WideChar;
    wszProportionalFont: array[0..31] of WideChar;
  end;

type
  tagMIMECONTF = (
    MIMECONTF_MAILNEWS = $00000001,
    MIMECONTF_BROWSER = $00000002,
    MIMECONTF_MINIMAL = $00000004,
    MIMECONTF_IMPORT = $00000008,
    MIMECONTF_SAVABLE_MAILNEWS = $00000100,
    MIMECONTF_SAVABLE_BROWSER = $00000200,
    MIMECONTF_EXPORT = $00000400,
    MIMECONTF_PRIVCONVERTER = $00010000,
    MIMECONTF_VALID = $00020000,
    MIMECONTF_VALID_NLS = $00040000,
    MIMECONTF_MIME_IE4 = $10000000,
    MIMECONTF_MIME_LATEST = $20000000,
    MIMECONTF_MIME_REGISTRY = $40000000
  );

// *********************************************************************//
// Interface: IEnumCodePage
// Flags:     (0)
// GUID:      {275C23E3-3747-11D0-9FEA-00AA003F8646}
// *********************************************************************//
  IEnumCodePage = interface(IUnknown)
    ['{275C23E3-3747-11D0-9FEA-00AA003F8646}']
    function Clone(out ppEnum: IEnumCodePage): HResult; stdcall;
    function Next(celt: LongWord; out rgelt: tagMIMECPINFO; out pceltFetched: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumRfc1766
// Flags:     (0)
// GUID:      {3DC39D1D-C030-11D0-B81B-00C04FC9B31F}
// *********************************************************************//
  IEnumRfc1766 = interface(IUnknown)
    ['{3DC39D1D-C030-11D0-B81B-00C04FC9B31F}']
    function Clone(out ppEnum: IEnumRfc1766): HResult; stdcall;
    function Next(celt: LongWord; out rgelt: tagRFC1766INFO; out pceltFetched: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMLangConvertCharset
// Flags:     (0)
// GUID:      {D66D6F98-CDAA-11D0-B822-00C04FC9B31F}
// *********************************************************************//
  IMLangConvertCharset = interface(IUnknown)
    ['{D66D6F98-CDAA-11D0-B822-00C04FC9B31F}']
    function Initialize(uiSrcCodePage: SYSUINT; uiDstCodePage: SYSUINT; dwProperty: LongWord): HResult; stdcall;
    function GetSourceCodePage(out puiSrcCodePage: SYSUINT): HResult; stdcall;
    function GetDestinationCodePage(out puiDstCodePage: SYSUINT): HResult; stdcall;
    function GetProperty(out pdwProperty: LongWord): HResult; stdcall;
    function DoConversion(var pSrcStr: Byte; var pcSrcSize: SYSUINT; var pDstStr: Byte;
      var pcDstSize: SYSUINT): HResult; stdcall;
    function DoConversionToUnicode(var pSrcStr: Shortint; var pcSrcSize: SYSUINT; var pDstStr: Smallint;
      var pcDstSize: SYSUINT): HResult; stdcall;
    function DoConversionFromUnicode(var pSrcStr: Smallint; var pcSrcSize: SYSUINT; var pDstStr: Shortint;
      var pcDstSize: SYSUINT): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumScript
// Flags:     (0)
// GUID:      {AE5F1430-388B-11D2-8380-00C04F8F5DA1}
// *********************************************************************//
  IEnumScript = interface(IUnknown)
    ['{AE5F1430-388B-11D2-8380-00C04F8F5DA1}']
    function Clone(out ppEnum: IEnumScript): HResult; stdcall;
    function Next(celt: LongWord; out rgelt: tagSCRIPTINFO; out pceltFetched: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMultiLanguage2
// Flags:     (0)
// GUID:      {DCCFC164-2B38-11D2-B7EC-00C04F8F5D9A}
// *********************************************************************//
  IMultiLanguage2 = interface(IUnknown)
    ['{DCCFC164-2B38-11D2-B7EC-00C04F8F5D9A}']
    function GetNumberOfCodePageInfo(out pcCodePage: SYSUINT): HResult; stdcall;
    function GetCodePageInfo(uiCodePage: SYSUINT; LangId: Word; out pCodePageInfo: tagMIMECPINFO): HResult; stdcall;
    function GetFamilyCodePage(uiCodePage: SYSUINT; out puiFamilyCodePage: SYSUINT): HResult; stdcall;
    function EnumCodePages(grfFlags: LongWord; LangId: Word; out ppEnumCodePage: IEnumCodePage): HResult; stdcall;
    function GetCharsetInfo(const Charset: WideString; out pCharsetInfo: tagMIMECSETINFO): HResult; stdcall;
    function IsConvertible(dwSrcEncoding: LongWord; dwDstEncoding: LongWord): HResult; stdcall;
    function ConvertString(var pdwMode: LongWord; dwSrcEncoding: LongWord; dwDstEncoding: LongWord;
      var pSrcStr: Byte; var pcSrcSize: SYSUINT; var pDstStr: Byte; var pcDstSize: SYSUINT): HResult; stdcall;
    function ConvertStringToUnicode(var pdwMode: LongWord; dwEncoding: LongWord; var pSrcStr: Shortint;
      var pcSrcSize: SYSUINT; var pDstStr: Smallint; var pcDstSize: SYSUINT): HResult; stdcall;
    function ConvertStringFromUnicode(var pdwMode: LongWord; dwEncoding: LongWord; var pSrcStr: Smallint;
      var pcSrcSize: SYSUINT; var pDstStr: Shortint; var pcDstSize: SYSUINT): HResult; stdcall;
    function ConvertStringReset: HResult; stdcall;
    function GetRfc1766FromLcid(locale: LongWord; out pbstrRfc1766: WideString): HResult; stdcall;
    function GetLcidFromRfc1766(out plocale: LongWord; const bstrRfc1766: WideString): HResult; stdcall;
    function EnumRfc1766(LangId: Word; out ppEnumRfc1766: IEnumRfc1766): HResult; stdcall;
    function GetRfc1766Info(locale: LongWord; LangId: Word; out pRfc1766Info: tagRFC1766INFO): HResult; stdcall;
    function CreateConvertCharset(uiSrcCodePage: SYSUINT; uiDstCodePage: SYSUINT; dwProperty: LongWord;
      out ppMLangConvertCharset: IMLangConvertCharset): HResult; stdcall;
    function ConvertStringInIStream(var pdwMode: LongWord; dwFlag: LongWord; var lpFallBack: Smallint;
      dwSrcEncoding: LongWord; dwDstEncoding: LongWord; const pstmIn: IStream; const pstmOut: IStream): HResult; stdcall;
    function ConvertStringToUnicodeEx(var pdwMode: LongWord; dwEncoding: LongWord; var pSrcStr: Shortint;
      var pcSrcSize: SYSUINT; var pDstStr: Smallint; var pcDstSize: SYSUINT; dwFlag: LongWord;
      var lpFallBack: Smallint): HResult; stdcall;
    function ConvertStringFromUnicodeEx(var pdwMode: LongWord; dwEncoding: LongWord; var pSrcStr: Smallint;
      var pcSrcSize: SYSUINT; var pDstStr: Shortint; var pcDstSize: SYSUINT; dwFlag: LongWord;
      var lpFallBack: Smallint): HResult; stdcall;
    function DetectCodepageInIStream(dwFlag: LongWord; dwPrefWinCodePage: LongWord; const pstmIn: IStream;
      var lpEncoding: tagDetectEncodingInfo; var pnScores: SYSINT): HResult; stdcall;
    function DetectInputCodepage(dwFlag: LongWord; dwPrefWinCodePage: LongWord; var pSrcStr: Shortint;
      var pcSrcSize: SYSINT; var lpEncoding: tagDetectEncodingInfo; var pnScores: SYSINT): HResult; stdcall;
    function ValidateCodePage(uiCodePage: SYSUINT; var hwnd: _RemotableHandle): HResult; stdcall;
    function GetCodePageDescription(uiCodePage: SYSUINT; lcid: LongWord; lpWideCharStr: PWideChar;
      cchWideChar: SYSINT): HResult; stdcall;
    function IsCodePageInstallable(uiCodePage: SYSUINT): HResult; stdcall;
    function SetMimeDBSource(dwSource: tagMIMECONTF): HResult; stdcall;
    function GetNumberOfScripts(out pnScripts: SYSUINT): HResult; stdcall;
    function EnumScripts(dwFlags: LongWord; LangId: Word; out ppEnumScript: IEnumScript): HResult; stdcall;
    function ValidateCodePageEx(uiCodePage: SYSUINT; var hwnd: _RemotableHandle; dwfIODControl: LongWord): HResult; stdcall;
  end;

function GetSystemDefaultUILanguage: LANGID; stdcall; external kernel32 name 'GetSystemDefaultUILanguage';


//------------------------------------------------------------------------------
//
//      MLang wrappers
//
//------------------------------------------------------------------------------
function DetectCodePage(Stream: TStream): integer;
function GetCodePageDescription(Codepage: integer): string;


//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.SyncObjs;

var
  LanguageInfoLock: TCriticalSection;

//------------------------------------------------------------------------------
//
//      Utilities
//
//------------------------------------------------------------------------------
function SetResourceHInstance(NewInstance: HModule): HModule;
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  Result := 0;
  while (CurModule <> nil) do
  begin
    if CurModule.Instance = HInstance then
    begin
      if (CurModule.ResInstance <> CurModule.Instance) then
        FreeLibrary(CurModule.ResInstance);
      CurModule.ResInstance := NewInstance;
      Result := NewInstance;
      Exit;
    end;
    CurModule := CurModule.Next;
  end;
end;

//------------------------------------------------------------------------------

function LoadNewResourceModule(Locale: LCID): HModule;
begin
  var LocaleItem := LanguageInfo.FindLCID(Locale);
  if (LocaleItem = nil) then
    raise Exception.CreateFmt('Invalid language ID: %.4X', [Locale]);
  Result := LoadNewResourceModule(LocaleItem);
end;

function LoadNewResourceModule(const LocaleName: string): HModule; overload;
begin
  var LocaleItem := LanguageInfo.FindLocaleName(LocaleName);
  if (LocaleItem = nil) then
    raise Exception.CreateFmt('Invalid locale name: %s', [LocaleName]);
  Result := LoadNewResourceModule(LocaleItem);
end;

function LoadNewResourceModule(LocaleItem: TLanguageItem): HModule;
var
  Filename: string;
begin
  Result := LoadNewResourceModule(LocaleItem, Filename);
end;

function LoadNewResourceModule(LocaleItem: TLanguageItem; var ModuleFilename: string): HModule; overload;
const
  LOAD_LIBRARY_AS_IMAGE_RESOURCE = $00000020;

  function FindResourceModule(var ModuleFilename: string): boolean;
  begin
    var Directory := TPath.GetDirectoryName(ModuleFilename);
    var Filename := TPath.GetFileName(ModuleFilename);

    // Search the list of sub-folders for the resource module
    var SubFolders := ResourceModulePaths.Split([';']);

    // If no sub-folders then just look in the application folder
    if (Length(SubFolders) = 0) then
    begin
      Result := TFile.Exists(ModuleFilename);
      exit;
    end;

    for var SubFolder in SubFolders do
    begin
      ModuleFilename := TPath.Combine(TPath.Combine(Directory, SubFolder), Filename);

      if (TFile.Exists(ModuleFilename)) then
        Exit(True);
    end;

    Result := False;
  end;

  function LoadResourceModule(const Filename: string; const FileType: string; var ModuleFilename: string): HModule;
  begin
    ModuleFilename := TPath.ChangeExtension(Filename, '.'+FileType);

    if (not FindResourceModule(ModuleFilename)) then
      Exit(0);

    Result := LoadLibraryEx(PChar(ModuleFilename), 0, LOAD_LIBRARY_AS_DATAFILE or LOAD_LIBRARY_AS_IMAGE_RESOURCE);
  end;

var
  Filename: string;
  NewInst: HModule;
begin
  Result := 0;

  if (LocaleItem <> nil) then
  begin
    Filename := GetModuleName(HInstance);

    if (Filename <> '') then
    begin
      // Try to load resource modules in the following order (example for Danish):
      // 1) filename.DAN (ISO639-2)
      // 2) filename.da-DK (RFC 4646 = "ISO639-1"-"IISO3166" = IETF Language Culture)
      // 3) filename.DA (ISO639-1)
      NewInst := LoadResourceModule(Filename, LocaleItem.LanguageShortName, ModuleFilename);
      if (NewInst = 0) then
        NewInst := LoadResourceModule(Filename, LocaleItem.LocaleName, ModuleFilename);
      if (NewInst = 0) then
        NewInst := LoadResourceModule(Filename, LocaleItem.ISO639_1Name, ModuleFilename);
    end else
      NewInst := 0;

    if (NewInst = 0) then
      ModuleFilename := '';
  end else
    NewInst := hInstance;

  if (NewInst <> 0) then
  begin
    Result := SetResourceHInstance(NewInst);
{$if RTLVersion >= 34}
    ResStringCleanupCache;
{$endif}
  end;
end;

//------------------------------------------------------------------------------

function MakeLangID(Primary, Region: Word ): Word;
begin
  Result := (Region shl 10) or Primary;
end;

//------------------------------------------------------------------------------

procedure SetLocale(Locale: LCID);
begin
  Win32Check(SetThreadLocale(Locale));
  GetFormatSettings;
  ClearLocale;
end;

//------------------------------------------------------------------------------

var
  FISO3166Name: string = '';

function LocaleISO3166Name: string;
begin
  if (FISO3166Name = '') then
  begin
    var LocaleItem := LanguageInfo.FindLCID(GetThreadLocale);
    if (LocaleItem <> nil) then
      FISO3166Name := LocaleItem.ISO639_1Name;
  end;
  Result := FISO3166Name;
end;

//------------------------------------------------------------------------------

function LocaleName: string;
begin
  var LocaleItem := LanguageInfo.FindLCID(GetThreadLocale);
  if (LocaleItem <> nil) then
    Result := LocaleItem.LanguageName
  else
    Result := '';
end;

//------------------------------------------------------------------------------

(*
LOCALE_SMONGROUPING
Sizes for each group of digits to the left of the decimal. The maximum
number of characters allowed for this string is ten, including a terminating
null character. An explicit size is needed for each group, and sizes are
separated by semicolons. If the last value is zero, the preceding value is
repeated. For example, to group thousands, specify 3;0. Indic locales group
the first thousand and then group by hundreds. For example, 12,34,56,789 is
represented by 3;2;0
*)
type
  TMonetaryGrouping = array of integer;

var
  FMonetaryGrouping: TMonetaryGrouping;

function LocaleMonetaryGrouping(Index: integer): integer;
var
  Grouping: string;
  i: integer;
  p: PChar;
  Group: integer;
begin
  if (Length(FMonetaryGrouping) = 0) then
  begin
    Grouping := GetLocaleStr(GetThreadLocale, LOCALE_SMONGROUPING , '3;0');
    // Count number of groups
    p := PChar(Grouping);
    i := 0;
    while (p^ <> #0) do
    begin
      if (p^ = ';') then
        inc(i);
      inc(p);
    end;

    if (i = 0) then
    begin
      i := 1;
      Grouping := '3;0';
    end;

    SetLength(FMonetaryGrouping, i+1);

    // Get groups
    p := PChar(Grouping);
    i := 0;
    while (p^ <> #0) do
    begin
      if (p^ <> ';') then
      begin
        Group := ord(p^)-ord('0');
        FMonetaryGrouping[i] := Group;
      end else
        inc(i);
      inc(p);
    end;
  end;

  if (Index >= Length(FMonetaryGrouping)-1) then
  begin
    if (Length(FMonetaryGrouping) > 1) and (FMonetaryGrouping[Length(FMonetaryGrouping)-1] = 0) then
      Result := FMonetaryGrouping[Length(FMonetaryGrouping)-2]
    else
      Result := 0;
  end else
    Result := FMonetaryGrouping[Index];
end;

//------------------------------------------------------------------------------
//
//      TLanguageInfo
//
//------------------------------------------------------------------------------
function EnumLocalesCallback(ALocaleName: PChar; Flags: DWORD; Param: LPARAM): DWORD; stdcall;
begin
  Result := 1;

  // Discard Locale Invariant - it doesn't make sense here
  if (ALocaleName = nil) or (ALocaleName^ = #0) then
    exit;

  var LocaleName: string := ALocaleName;

  var LanguageItem := TLanguageItem.Create(LocaleName);
  try

    LanguageItem.Invariant := (Flags and LOCALE_NEUTRALDATA = LOCALE_NEUTRALDATA);

    LanguageInfo.AddItem(LanguageItem);

  except
    LanguageItem.Free;
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------

class constructor TLanguageInfo.Create;
begin
  FLanguageItems := nil;
  FLCIDToLanguage := nil;
end;

class destructor TLanguageInfo.Destroy;
begin
  FreeAndNil(FLanguageItems);
  FreeAndNil(FLCIDToLanguage);
end;

//------------------------------------------------------------------------------

procedure TLanguageInfo.LoadLanguageItems;
begin
  if (FLanguageItems <> nil) then
    exit;

  if (not CheckWin32Version(6)) then
    raise Exception.Create('LanguageItems requires Windows Vista or later');

  LanguageInfoLock.Enter;
  try

    if (FLanguageItems <> nil) then
      exit;

    FLanguageItems := TObjectDictionary<string, TLanguageItem>.Create([doOwnsValues]);

    // Get list of all locales supported by system
    EnumSystemLocalesEx(@EnumLocalesCallback, LOCALE_WINDOWS or LOCALE_NEUTRALDATA, 0, nil);

  finally
    LanguageInfoLock.Leave;
  end;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.ResolveLocaleName(const Value: string): TLanguageItem;
begin
  var Size := WinAPI.Windows.ResolveLocaleName(PChar(Value), nil, 0);
  if (Size = 0) and (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
    RaiseLastOSError;

  var LocaleName: string;
  SetLength(LocaleName, Size-1);
  if (Size > 1) and (WinAPI.Windows.ResolveLocaleName(PChar(Value), PChar(LocaleName), Size) = 0) then
    RaiseLastOSError;

  Result := FindLocaleName(LocaleName, True);
end;

function TLanguageInfo.SystemDefaultLocale: TLanguageItem;
begin
  var LocaleName: string;
  SetLength(LocaleName, LOCALE_NAME_MAX_LENGTH-1);

  var Size := GetSystemDefaultLocaleName(PChar(LocaleName), Length(LocaleName)+1);

  if (Size = 0) then
    RaiseLastOSError;

  SetLength(LocaleName, Size-1);

  Result := FindLocaleName(LocaleName, True);
end;

function TLanguageInfo.UserDefaultLocale: TLanguageItem;
begin
  var LocaleName: string;
  SetLength(LocaleName, LOCALE_NAME_MAX_LENGTH-1);

  var Size := GetUserDefaultLocaleName(PChar(LocaleName), Length(LocaleName)+1);

  if (Size = 0) then
    RaiseLastOSError;

  SetLength(LocaleName, Size-1);

  Result := FindLocaleName(LocaleName, True);
end;

function TLanguageInfo.DefaultLocale: TLanguageItem;
begin
  Result := UserDefaultLocale;

  // If the user locale isn't a real locale we fall back to the system default locale
  // Note: The following values denotes custom locales (which we do not support):
  //       $1000, $2000, $2400, $2800, $2C00, $3000, $3400, $3800, $3C00, $4000, $4400, $4800, $4C00

  if (Result = nil) then
    Result := SystemDefaultLocale;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.GetCount: integer;
begin
  LoadLanguageItems;
  Result := FLanguageItems.Count;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.GetEnumerator: TEnumerator<TLanguageItem>;
begin
  LoadLanguageItems;
  Result := FLanguageItems.Values.GetEnumerator;
end;

//------------------------------------------------------------------------------

procedure TLanguageInfo.AddItem(LanguageItem: TLanguageItem);
begin
  if (LanguageItem.ISO3166Name <> '') then
    FLanguageItems.Add(LanguageItem.LocaleName.ToLower, LanguageItem)
  else
    LanguageItem.Free;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindCountry(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  for var Item in Self do
    if (AnsiSameText(Item.CountryName, Value)) then
      Exit(Item);
  Result := nil;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindISO3166Name(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  for var Item in Self do
    if (AnsiSameText(Item.ISO3166Name, Value)) then
      Exit(Item);
  Result := nil;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindISO639_1Name(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  Result := nil;
  for var Item in Self do
    if (AnsiSameText(Item.ISO639_1Name, Value)) then
    begin
      Result := Item;
      break;
    end;

  // An ISO639_1 name can map to many different locales (eg en -> en-us, en-gb, en-au)
  // so attempt to find the major one (the one with the lowest LCID value).
  //
  // This logic fails for the two languages spoken in Norway: Bokmål & Nynorsk.
  //
  //   - The PRIMARYLANGID for both "nb" and "nn" is LANG_NORWEGIAN.
  //
  //   - nb-NO (Bokmål) is LANG_NORWEGIAN, SUBLANG_NORWEGIAN_BOKMAL
  //
  //   - nn-NO (Nynorsk) is LANG_NORWEGIAN,SUBLANG_NORWEGIAN_NYNORSK
  //
  //   - Since SUBLANG_NORWEGIAN_BOKMAL < SUBLANG_NORWEGIAN_NYNORSK the "major"
  //     locale for "nn" will become "nb-NO" which is incorrect.
  //
  // In order to work around this problem we only consider sub-languages that
  // also satisfies the test for ISO639-1 name.
  if (Result <> nil) and (Result.SubLanguageID <> 1) then
  begin
    // We should probably start with 1, but no harm's done
    for var SubLanguage := 0 to Result.SubLanguageID-1 do
    begin
      var LCID := MAKELANGID(Result.PrimaryLanguageID, SubLanguage);

      var BetterLocaleItem := FindLCID(LCID);

      if (BetterLocaleItem <> nil) and (AnsiSameText(BetterLocaleItem.ISO639_1Name, Value)) then
      begin
        Result := BetterLocaleItem;
        break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindLanguageName(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  for var Item in Self do
    if (AnsiSameText(Item.LanguageName, Value)) then
      Exit(Item);
  Result := nil;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindLanguageShortName(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  for var Item in Self do
    if (AnsiSameText(Item.LanguageShortName, Value)) then
      Exit(Item);
  Result := nil;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindLCID(Value: LCID): TLanguageItem;
begin
  LoadLanguageItems;

  // Since LCID lookup is fairly common we cache it with a dictionary
  if (FLCIDToLanguage = nil) then
  begin
    LanguageInfoLock.Enter;
    try

      if (FLCIDToLanguage = nil) then
      begin
        FLCIDToLanguage := TDictionary<LCID, TLanguageItem>.Create;

        for var Item in Self do
        begin
          // Since there's a one to many mapping between LCID and locale name
          // we try to cache the most specific mapping by giving priority to
          // variant locales over invariant ones.
          if (not Item.Invariant) then
          begin
            var ExistingItem: TLanguageItem;
            // Item is variant - Only add if no variant mapping already exist
            if (not FLCIDToLanguage.TryGetValue(Item.LocaleID, ExistingItem)) then
              FLCIDToLanguage.Add(Item.LocaleID, Item)
            else
            if (ExistingItem.Invariant) then
              FLCIDToLanguage.AddOrSetValue(Item.LocaleID, Item);
          end else
          // Item is invariant - Only add if no mapping already exist
          if (not FLCIDToLanguage.ContainsKey(Item.LocaleID)) then
            FLCIDToLanguage.Add(Item.LocaleID, Item);
        end;
      end;

    finally
      LanguageInfoLock.Leave;
    end;
  end;

  if (not FLCIDToLanguage.TryGetValue(Value, Result)) then
    Result := nil;
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindLocale(const Value: string): TLanguageItem;
begin
  var n: integer;
  if (TryStrToInt(Value, n)) then
    Result := FindLCID(LCID(n))
  else
    Result := FindLocaleName(Value);
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindLocaleName(const Value: string; Exact: boolean): TLanguageItem;
begin
  LoadLanguageItems;
  // Search for RFC 4646 match
  if (FLanguageItems.TryGetValue(Value.ToLower, Result)) then
    exit;

  if (Exact) then
    exit(nil);

  // Exact match on language-region (e.g. "en-US") failed.
  // If value is a two part language-region value (i.e. it contains a "-") then
  // look for the region invariant ISO639-1 (e.g. "en") part instead.
  // Note that this logic fails on some languages. For example for
  // Norwegian (nb-NO & nn-NO) the invariant part is NO.
  var Language := Value;
  var i := Pos('-', Language);
  if (i > 0) then
    Delete(Language, i, MaxInt);

  Result := FindISO639_1Name(Language);
end;

//------------------------------------------------------------------------------

function TLanguageInfo.FindName(const Value: string): TLanguageItem;
begin
  LoadLanguageItems;
  for var Item in Self do
    if (AnsiSameText(Item.DisplayName, Value)) then
      Exit(Item);
  Result := nil;
end;


//------------------------------------------------------------------------------
//
//      TLanguageItem
//
//------------------------------------------------------------------------------
constructor TLanguageItem.Create(const ALocaleName: string);
begin
  inherited Create;
  FLocaleName := ALocaleName;

  FLocale := LCID(-1);
  FCharSet := -1;
  FReadingLayout := -1;
end;

//------------------------------------------------------------------------------

destructor TLanguageItem.Destroy;
begin
  DestroyFlag;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TLanguageItem.DestroyFlag;
begin
  FreeAndNil(FFlag);
end;

function TLanguageItem.ReleaseFlag: TBitmap;
begin
  Result := FFlag;
  FFlag := nil;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetLocaleData(Flag: DWORD): string;
begin
  Result := GetLocaleData(LocaleName, Flag);
end;

function TLanguageItem.GetLocaleDataInt(Flag: DWORD): DWORD;
begin
  Result := GetLocaleDataInt(LocaleName, Flag);
end;

class function TLanguageItem.GetLocaleDataInt(const ALocaleName: string; Flag: DWORD): DWORD;
begin
  if (GetLocaleInfoEx(PChar(ALocaleName), Flag or LOCALE_RETURN_NUMBER, PChar(@Result), SizeOf(Result) div SizeOf(Char)) = 0) then
    RaiseLastOSError;
end;

class function TLanguageItem.GetLocaleData(const ALocaleName: string; Flag: DWORD): string;
begin
  var Size := GetLocaleInfoEx(PChar(ALocaleName), Flag, nil, 0);
  if (Size = 0) and (GetLastError <> ERROR_INSUFFICIENT_BUFFER) then
    RaiseLastOSError;

  SetLength(Result, Size-1);
  if (Size > 1) and (GetLocaleInfoEx(PChar(ALocaleName), Flag, PChar(Result), Size) = 0) then
      RaiseLastOSError;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetFlag: TBitmap;
var
  HResInfo: THandle;
  Name: string;
begin
  if (FFlag = nil) then
  begin
    Name := Format('flag_%s', [Lowercase(ISO3166Name)]);
    HResInfo := FindResource(HInstance, PChar(Name), RT_BITMAP);
    if (HResInfo <> 0) then
    begin
      FFlag := TBitmap.Create;
      FFlag.LoadFromResourceName(hInstance, Name);
    end;
  end;
  Result := FFlag;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetLocaleID: LCID;
begin
  // Do not use GetLocaleDataInt(LOCALE_ILANGUAGE) !
  if (FLocale = LCID(-1)) then
  begin
    if (CheckWin32Version(7)) then
      FLocale := LocaleNameToLCID(PChar(FLocaleName), LOCALE_ALLOW_NEUTRAL_NAMES)
    else
      FLocale := LocaleNameToLCID(PChar(FLocaleName), 0);
  end;
  Result := FLocale;
end;

function TLanguageItem.GetIsCustomLocale: boolean;
begin
  (*
  LOCALE_CUSTOM_UNSPECIFIED
  An unspecified custom locale, used to identify all supplemental locales except
  the locale for the current user. Supplemental locales cannot be distinguished
  from one another by their locale identifiers, but can be distinguished by
  their locale names. Certain NLS functions can return this constant to indicate
  that they cannot provide a useful identifier for a particular locale.
  The value of LOCALE_CUSTOM_UNSPECIFIED is 0x1000 (4096).
  *)
  Result := (LocaleID = LOCALE_CUSTOM_UNSPECIFIED);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetLanguageID: LangID;
begin
  // http://msdn2.microsoft.com/en-us/library/ms776294(VS.85).aspx
  Result := LocaleID and $3FF;
end;

function TLanguageItem.GetPrimaryLanguageID: Word;
begin
  Result := PRIMARYLANGID(LocaleID);
end;

function TLanguageItem.GetSubLanguageID: Word;
begin
  Result := SUBLANGID(LocaleID);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetISO3166Name: string;
begin
  (*
  LOCALE_SISO3166CTRYNAME
  Country/region name, based on ISO Standard 3166, for example, "US" for the
  United States. The maximum number of characters allowed for this string is
  nine, including a terminating null character.
  *)
  if (FISO3166Name = '') then
    FISO3166Name := GetLocaleData(LOCALE_SISO3166CTRYNAME);
  Result := FISO3166Name;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetISO639_1Name: string;
begin
  (*
  LOCALE_SISO639LANGNAME
  The abbreviated name of the language based entirely on the ISO Standard 639
  values, in lowercase form, such as "en" for English. This can be a 3-letter
  code for languages that don't have a 2-letter code, such as "haw" for
  Hawaiian. The maximum number of characters allowed for this string is nine,
  including a terminating null character.
  *)
  Result := GetLocaleData(LOCALE_SISO639LANGNAME);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetISO639_2Name: string;
begin
  (*
  LOCALE_SISO639LANGNAME2
  Three-letter ISO language name, in lowercase form (ISO 639-2 three-letter
  code for the language), such as "eng" for English. The maximum number of
  characters allowed for this string is nine, including a terminating null
  character.
  *)
  Result := GetLocaleData(LOCALE_SISO639LANGNAME2);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetDisplayName: string;
begin
  (*
  LOCALE_SLANGDISPLAYNAME (pre Windows 7)
  LOCALE_SLOCALIZEDDISPLAYNAME (Windows 7 and later)
  Full localized name of the locale for the user interface language, for
  example, Deutsch (Deutschland) for German (Germany)" There is no limit on the
  number of characters allowed for this string. Since this name is based on the
  localization of the product, it changes for each localized version.
  *)
  if (FDisplayName = '') then
  begin
    if (CheckWin32Version(7)) then
      FDisplayName := GetLocaleData(LOCALE_SLOCALIZEDDISPLAYNAME)
    else
      FDisplayName := GetLocaleData(LOCALE_SLANGDISPLAYNAME)
  end;

  Result := FDisplayName;
end;

function TLanguageItem.GetEnglishDisplayName: string;
begin
  (*
  LOCALE_SENGLISHDISPLAYNAME (Windows 7 and later)
  Display name of the locale in English. Usually the display name consists of
  the language and the country/region, for example, German (Germany) for
  Deutsch (Deutschland).
  *)
  if (CheckWin32Version(7)) then
    Result := GetLocaleData(LOCALE_SENGLISHDISPLAYNAME)
  else
    Result := GetDisplayName; // Fall back to localized
end;

//------------------------------------------------------------------------------

function TLanguageItem.HasLanguageShortName: boolean;
begin
  // Apparently LOCALE_SABBREVLANGNAME has been deprecated in Windows 10.
  // It returns ZZZ for language entries added since, probably, Windows 8.
  // It also returns ZZZ for custom and supplemental locales (See IsCustomLocale).
  // https://github.com/tpn/winsdk-10/blob/master/Include/10.0.16299.0/um/WinNls.h#L750
  Result := (LanguageShortName <> 'ZZZ'); // Unfortunately not documented anywhere
end;

function TLanguageItem.GetLanguageShortName: string;
begin
  (*
  LOCALE_SABBREVLANGNAME
  Abbreviated name of the language. In most cases, the name is created by taking
  the two-letter language abbreviation from ISO Standard 639 and adding a third
  letter, as appropriate, to indicate the sublanguage. For example, the
  abbreviated name for the language corresponding to the English (United States)
  locale is ENU.
  http://archives.miloush.net/michkap/archive/2005/02/17/375235.html
  http://archives.miloush.net/michkap/archive/2006/09/27/773341.html
  *)
  if (FLanguageShortName = '') then
    FLanguageShortName := GetLocaleData(LOCALE_SABBREVLANGNAME);
  Result := FLanguageShortName;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetLanguageName: string;
begin
  (*
  LOCALE_SLANGUAGE (pre Windows 7)
  LOCALE_SLOCALIZEDLANGUAGENAME (Windows 7 and later)
  Full localized primary name of the user interface language included in a
  localized display name, for example, Deutsch representing German. Since this
  name is based on the localization of the product, it changes for each
  localized version.
  *)
  if (FLanguageName = '') then
  begin
    if (CheckWin32Version(7)) then
      FLanguageName := GetLocaleData(LOCALE_SLOCALIZEDLANGUAGENAME)
    else
      FLanguageName := GetLocaleData(LOCALE_SLANGUAGE);
  end;
  Result := FLanguageName;
end;

function TLanguageItem.GetEnglishLanguageName: string;
begin
  (*
  LOCALE_SENGLANGUAGE (pre Windows 7)
  LOCALE_SENGLISHLANGUAGENAME (Windows 7 and later)
  English name of the language in English, for example, German for Deutsch,
  from International ISO Standard 639. This name is always restricted to
  characters that can be mapped into the ASCII 127-character subset.
  *)
  if (CheckWin32Version(7)) then
    Result := GetLocaleData(LOCALE_SENGLISHLANGUAGENAME)
  else
    Result := GetLocaleData(LOCALE_SENGLANGUAGE);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetFallback: TLanguageItem;
begin
  if (FFallback = nil) then
    FFallback := LanguageInfo.FindLocaleName(FallbackName);
  Result := FFallback;
end;

function TLanguageItem.GetFallbackName: string;
begin
  if (FFallbackName = '') then
    FFallbackName := GetLocaleData(LOCALE_SPARENT);
  Result := FFallbackName;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetCountryCode: integer;
const
  LOCALE_IDIALINGCODE = LOCALE_ICOUNTRY; // Defined for Windows 10+
begin
  (*
  LOCALE_ICOUNTRY
  Country/region code, based on international phone codes, also referred to as
  IBM country/region codes. The maximum number of characters allowed for this
  string is six, including a terminating null character.
  *)
  Result := GetLocaleDataInt(LOCALE_IDIALINGCODE);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetCountryName: string;
begin
  (*
  LOCALE_SCOUNTRY (pre Windows 7)
  LOCALE_SLOCALIZEDCOUNTRYNAME (Windows 7 and later)
  Full localized name of the country/region, for example, Deutschland for
  Germany. The maximum number of characters allowed for this string is 80,
  including a terminating null character. Since this name is based on the
  localization of the product, it changes for each localized version.
  *)
  if (FCountryName = '') then
    if (CheckWin32Version(7)) then
      FCountryName := GetLocaleData(LOCALE_SLOCALIZEDCOUNTRYNAME)
    else
      FCountryName := GetLocaleData(LOCALE_SCOUNTRY);
  Result := FCountryName;
end;

function TLanguageItem.GetEnglishCountryName: string;
begin
  (*
  LOCALE_SENGCOUNTRY (pre Windows 7)
  LOCALE_SENGLISHCOUNTRYNAME (Windows 7 and later)
  English name of the country/region, for example, Germany for Deutschland.
  This name is always restricted to characters that can be mapped into the
  ASCII 127-character subset.
  *)
  if (CheckWin32Version(7)) then
    Result := GetLocaleData(LOCALE_SENGLISHCOUNTRYNAME)
  else
    Result := GetLocaleData(LOCALE_SENGCOUNTRY);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetAnsiCodePage: integer;
begin
  (*
  LOCALE_IDEFAULTANSICODEPAGE
  The ANSI code page used by a locale for applications that do not support
  Unicode. The maximum number of characters allowed for this string is six,
  including a terminating null character. If no ANSI code page is available,
  only Unicode can be used for the locale. In this case, the value is CP_ACP (0).
  *)
  Result := GetLocaleDataInt(LOCALE_IDEFAULTANSICODEPAGE);
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetCharSet: integer;
const
  TCI_SRCLOCALE = $1000;
var
  CharsetInfo: TCharsetInfo;
begin
  if (FCharset = -1) then
  begin
    var ALocale := LocaleID;
    if (not TranslateCharsetInfo(ALocale, CharsetInfo, TCI_SRCLOCALE)) then
    begin
      // For some strage reason TranslateCharsetInfo fails on some locales
      if (GetLastError <> ERROR_INVALID_PARAMETER) then
        RaiseLastOSError;
      FCharset := DEFAULT_CHARSET;
    end else
      FCharset := CharsetInfo.ciCharset;
  end;
  Result := FCharset;
end;

//------------------------------------------------------------------------------

function TLanguageItem.GetReadingLayout: integer;
begin
  if (FReadingLayout = -1) then
    FReadingLayout := GetLocaleDataInt(LOCALE_IREADINGLAYOUT);
  Result := FReadingLayout;
end;

function TLanguageItem.GetIsLeftToRight: boolean;
begin
  Result := (ReadingLayout = 0);
end;

function TLanguageItem.GetIsRightToLeft: boolean;
begin
  Result := (ReadingLayout = 1);
end;

//------------------------------------------------------------------------------
//
//      MLang
//
//------------------------------------------------------------------------------
function DetectCodePage(Stream: TStream): integer;
var
  MultiLanguage: IMultiLanguage2;
  ComStream: IStream;
  EncodingInfo: TArray<tagDetectEncodingInfo>;
  Count: integer;
  SavePos: Int64;
const
  MLDETECTCP_NONE = 0;
begin
  Result := 0;

  if (CoCreateInstance(CLSID_CMultiLanguage, nil, CLSCTX_INPROC_SERVER, IID_IMultiLanguage2, MultiLanguage) <> S_OK) then
    exit;

  SavePos := Stream.Position;
  try
    ComStream := TStreamAdapter.Create(Stream);
    try
      Count := 4;
      SetLength(EncodingInfo, Count);
      if (MultiLanguage.DetectCodepageInIStream(MLDETECTCP_NONE, 0, ComStream, EncodingInfo[0], Count) <> S_OK) then
        exit;

      Result := EncodingInfo[0].nCodePage;
    finally
      ComStream := nil;
    end;
  finally
    Stream.Position := SavePos;
  end;
end;

//------------------------------------------------------------------------------

function GetCodePageDescription(Codepage: integer): string;
var
  MultiLanguage: IMultiLanguage2;
begin
  Result := '';

  if (CoCreateInstance(CLSID_CMultiLanguage, nil, CLSCTX_INPROC_SERVER, IID_IMultiLanguage2, MultiLanguage) <> S_OK) then
    exit;

  SetLength(Result, 128);
  if (MultiLanguage.GetCodePageDescription(Codepage, GetUserDefaultLCID, PChar(Result), Length(Result)) <> S_OK) then
  begin
    Result := '';
    exit;
  end;

  Result := PChar(Result);
end;

//------------------------------------------------------------------------------

function TryLocaleToISO639_1Name(Locale: LCID; var Value: string): boolean;
begin
  var LocaleItem := LanguageInfo.FindLCID(Locale);

  if (LocaleItem <> nil) then
  begin
    Result := True;
    Value := LocaleItem.ISO639_1Name;
  end else
  begin
    Result := False;
    Value := '';
  end;
end;

//------------------------------------------------------------------------------

function LocaleToISO639_1Name(Locale: LCID; const Default: string = ''): string;
begin
  if (not TryLocaleToISO639_1Name(Locale, Result)) then
    Result := Default;
end;

//------------------------------------------------------------------------------

function TryISO639_1NameToLocale(const Name: string; var Value: LCID): boolean;
begin
  var LocaleItem := LanguageInfo.FindISO639_1Name(Name);

  if (LocaleItem <> nil) then
  begin
    Result := True;
    Value := LocaleItem.LocaleID;
  end else
  begin
    Result := False;
    Value := 0;
  end;
end;

//------------------------------------------------------------------------------

function ISO639_1NameToLocale(const Name: string; Default: LCID = 0): TLCID;
begin
  if (not TryISO639_1NameToLocale(Name, Result)) then
    Result := Default;
end;

//------------------------------------------------------------------------------

procedure ClearLocale;
begin
  FISO3166Name := '';
  SetLength(FMonetaryGrouping, 0);
end;

//------------------------------------------------------------------------------

initialization
  LanguageInfoLock := TCriticalSection.Create;
  ClearLocale;
finalization
  LanguageInfoLock.Free;
end.
