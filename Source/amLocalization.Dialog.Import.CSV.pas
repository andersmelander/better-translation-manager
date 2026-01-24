unit amLocalization.Dialog.Import.CSV;

(*
 * Copyright © 2021 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  cxClasses, cxGraphics, cxControls, cxContainer, dxGDIPlusClasses,
  cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxLayoutControl, dxLayoutcxEditAdapters, dxLayoutControlAdapters,
  dxCustomWizardControl, dxWizardControl,
  cxListView, cxLabel, cxEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxButtons, cxMemo, cxSpinEdit,
  cxStyles, cxExtEditRepositoryItems, cxEditRepositoryItems,
  cxData, cxDataStorage, cxCustomData, cxFilter, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxGrid,

  amDataCsvReader,
  amLanguageInfo,
  amLocalization.Model,
  amLocalization.Engine;

const
  MSG_PREVIEW_FILE = WM_USER;
  MSG_PREVIEW_LAYOUT = WM_USER+1;

// -----------------------------------------------------------------------------
//
//              TFormCSVImport
//
// -----------------------------------------------------------------------------
type
  TFormCSVImport = class(TForm)
    WizardControl: TdxWizardControl;
    WizardControlPageFile: TdxWizardControlPage;
    LayoutControlFileGroup_Root: TdxLayoutGroup;
    LayoutControlFile: TdxLayoutControl;
    LayoutItemFileName: TdxLayoutItem;
    EditFilename: TcxButtonEdit;
    ActionList: TActionList;
    ActionFileBrowse: TAction;
    LayoutItemFileEncoding: TdxLayoutItem;
    ComboBoxEncoding: TcxLookupComboBox;
    FDMemTableCodePages: TFDMemTable;
    FDMemTableCodePagesFDMemTableCodePagesFieldCodePage: TIntegerField;
    FDMemTableCodePagesFDMemTableCodePagesFieldName: TStringField;
    DataSourceCodePages: TDataSource;
    LayoutItemFileEncodingWarning: TdxLayoutItem;
    ButtonEncoding: TcxButton;
    dxLayoutGroup1: TdxLayoutGroup;
    ActionFileEncodingWarning: TAction;
    MemoFilePreview: TcxMemo;
    LayoutItemFilePreview: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    WizardControlPageLayout: TdxWizardControlPage;
    LayoutControlLayoutGroup_Root: TdxLayoutGroup;
    LayoutControlLayout: TdxLayoutControl;
    LayoutItemLayoutDelimiter: TdxLayoutItem;
    ComboBoxDelimiter: TcxComboBox;
    LayoutItemLayoutDecimal: TdxLayoutItem;
    ComboBoxDecimal: TcxComboBox;
    LayoutItemLayoutDecimalWarning: TdxLayoutItem;
    ImageDecimalWarning: TImage;
    LayoutGroupLayoutDecimal: TdxLayoutGroup;
    LayoutItemLayoutFirstRow: TdxLayoutItem;
    SpinEditFirstRow: TcxSpinEdit;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    GridLayoutLevel: TcxGridLevel;
    GridLayout: TcxGrid;
    LayoutItemLayoutFields: TdxLayoutItem;
    GridLayoutTableView: TcxGridTableView;
    EditRepository: TcxEditRepository;
    EditRepositoryDataItem: TcxEditRepositoryLabel;
    PopupMenuColumn: TPopupMenu;
    WizardControlPageImport: TdxWizardControlPage;
    WizardControlPageProgress: TdxWizardControlPage;
    WizardControlPageDone: TdxWizardControlPage;
    ButtonImport: TcxButton;
    ListViewProgress: TcxListView;
    LayoutControlDoneGroup_Root: TdxLayoutGroup;
    LayoutControlDone: TdxLayoutControl;
    LayoutLabeledItemCount: TdxLayoutLabeledItem;
    LayoutItemCountAdded: TdxLayoutItem;
    LabelCountAdded: TcxLabel;
    LayoutItemCountUpdated: TdxLayoutItem;
    LabelCountUpdated: TcxLabel;
    LayoutItemCountSkipped: TdxLayoutItem;
    LabelCountSkipped: TcxLabel;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutSeparatorItem3: TdxLayoutSeparatorItem;
    LayoutItemResultWarnings: TdxLayoutItem;
    LayoutLabeledItemLayoutMap: TdxLayoutLabeledItem;
    dxLayoutSeparatorItem4: TdxLayoutSeparatorItem;
    LayoutCheckBoxItemMatchFuzzy: TdxLayoutCheckBoxItem;
    LayoutCheckBoxItemMatchAll: TdxLayoutCheckBoxItem;
    dxLayoutSeparatorItem5: TdxLayoutSeparatorItem;
    LayoutRadioButtonItemMapID: TdxLayoutRadioButtonItem;
    LayoutRadioButtonItemMapBoth: TdxLayoutRadioButtonItem;
    LayoutRadioButtonItemMapValue: TdxLayoutRadioButtonItem;
    dxLayoutGroup3: TdxLayoutGroup;
    LayoutGroupLayoutMap: TdxLayoutGroup;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutGroup7: TdxLayoutGroup;
    LayoutItemLayoutEscapeChar: TdxLayoutItem;
    ComboBoxEscapeChar: TcxComboBox;
    procedure WizardControlPageChanging(Sender: TObject; ANewPage: TdxWizardControlCustomPage; var AAllow: Boolean);
    procedure EditFilenamePropertiesEditValueChanged(Sender: TObject);
    procedure ActionFileBrowseExecute(Sender: TObject);
    procedure ComboBoxEncodingPropertiesEditValueChanged(Sender: TObject);
    procedure ActionFileEncodingWarningExecute(Sender: TObject);
    procedure WizardControlButtonClick(Sender: TObject; AKind: TdxWizardControlButtonKind; var AHandled: Boolean);
    procedure ComboBoxDelimiterPropertiesEditValueChanged(Sender: TObject);
    procedure SpinEditFirstRowPropertiesEditValueChanged(Sender: TObject);
    procedure GridLayoutTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure GridLayoutTableViewColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure ButtonImportClick(Sender: TObject);
    procedure LayoutRadioButtonItemMapValueClick(Sender: TObject);
    procedure LayoutRadioButtonItemMapBothClick(Sender: TObject);
    procedure LayoutRadioButtonItemMapIDClick(Sender: TObject);
    procedure WizardControlInfoPanelClick(Sender: TObject; var AHandled: Boolean);
    procedure ComboBoxEscapeCharPropertiesEditValueChanged(Sender: TObject);
  private type
    TColumnMapKind = (cmNone, cmMetaModule, cmMetaItem, cmMetaProperty, cmValueSource, cmValueTarget);

    TColumnMap = record
      Mapped: boolean;
      Kind: TColumnMapKind;
      Language: TLanguageItem;
    end;

    TMapMode = set of (mmID, mmValue);
  private
    FProject: TLocalizerProject;
    FSettings: TCsvSettings;
    FColumnMap: TArray<TColumnMap>;
    FDetectedCodepage: integer;
    FFilename: string;
    FHasFile: boolean;
    FHasLayout: boolean;
    FHasValidLayout: boolean;
    FMapMode: TMapMode;
    FTranslationCount: TTranslationCounts;
    FUpdateExisting: boolean;
    FLockChanged: integer;
  private
    procedure LoadEncodings;

    function LanguageID(Language: TLanguageItem): string;
    function GetCodepage: integer;
    procedure SetCodepage(const Value: integer);
    function GetFilename: string;
    procedure SetFilename(const Value: string);
  private
    // File preview
    procedure MsgPreviewFile(var Msg: TMessage); message MSG_PREVIEW_FILE;
    procedure QueuePreviewFile;
    procedure PreviewFile;
  private
    // Layout preview and setup
    procedure UnmapColumns(Kind: TColumnMapKind);
    procedure DisplayColumnMapPopupMenu(Column: TcxCustomGridTableItem);
    procedure MsgPreviewLayout(var Msg: TMessage); message MSG_PREVIEW_LAYOUT;
    procedure AutoDetectLayout;
    procedure InvalidatePreviewLayout;
    procedure ValidateLayout;
    procedure PreviewLayout;
  private
    // Import
    procedure Import;
    procedure UpdateTranslation(Prop: TLocalizerProperty; Language: TTranslationLanguage; const Value: string; ApplyMakeAlike: boolean);
    procedure Warning(const Fmt: string; const Args: array of const);
  private
    // Event handlers
    procedure GridLayoutTableViewColumnGetProperties(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AProperties: TcxCustomEditProperties);
    procedure OnColumnMenuItemIgnoreClick(Sender: TObject);
    procedure OnColumnMenuItemMetaClick(Sender: TObject);
    procedure OnColumnMenuItemSourceClick(Sender: TObject);
    procedure OnColumnMenuItemTargetClick(Sender: TObject);
  protected
    property Codepage: integer read GetCodepage write SetCodepage;
  public
    function Execute(AProject: TLocalizerProject): boolean;

    property UpdateExisting: boolean read FUpdateExisting write FUpdateExisting;

    property Filename: string read GetFilename write SetFilename;
  end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

{$R *.dfm}

uses
  Vcl.Consts,
  WinApi.ActiveX,
  System.IOUtils,
  System.Math,
  System.Character,
  System.UITypes,
  amProgress.Stream,
  amProgress.API,
  amLocalization.Common,
  amLocalization.Data.Main,
  amLocalization.Settings,
  amLocalization.Normalization;

resourcestring
  sErrorAccessDenied = 'File or folder is open or in use by another program. Please close the other program and try again';
  sClickToMap = 'Click to map';

resourcestring
  sColumnCaptionIgnore = 'Ignore';
  sColumnCaptionModule = 'Module';
  sColumnCaptionItem = 'Item';
  sColumnCaptionProperty = 'Property';
  sColumnCaptionSourceLanguage = 'Source: %s';
  sColumnCaptionTargetLanguage = 'Target: %s';

  sColumnCaptionRequired = '%s (required)';
  sColumnCaptionOptional = '%s (recommended)';
const
  sColumnCaptions: array[cmMetaModule..cmMetaProperty] of PResStringRec = (@sColumnCaptionModule, @sColumnCaptionItem, @sColumnCaptionProperty);

const
  sDelimiters: array[0..3] of Char = (';', #9, ',', ' ');
  sSeparators: array[0..1] of Char = (',', '.');
  sEscapeChars: array[0..1] of Char = (#0, '\');

// -----------------------------------------------------------------------------
//
//              File signature utilities
//
// -----------------------------------------------------------------------------
// From amResources
// -----------------------------------------------------------------------------

const
  UTF8Signature: AnsiString             = #$EF#$BB#$BF;
  UTF8SignatureMask: AnsiString         = #$ff#$ff#$ff;
  UTF16Signature: AnsiString            = #$FF#$FE; // Little-endian
  UTF16SignatureMask: AnsiString        = #$ff#$ff;
  UTF16BESignature: AnsiString          = #$FE#$FF; // Big-endian
  UTF16BESignatureMask: AnsiString      = #$ff#$ff;
  UTF32Signature: AnsiString            = #$FF#$FE#$00#$00; // Little-endian
  UTF32SignatureMask: AnsiString        = #$ff#$ff#$ff#$ff;
  UTF32BESignature: AnsiString          = #$00#$00#$FE#$FF; // Big-endian
  UTF32BESignatureMask: AnsiString      = #$ff#$ff#$ff#$ff;

function CheckFileSignature(Stream: TStream; const Signature; Size: Cardinal; const Mask; MaskSize: Cardinal; Offset: int64 = 0): boolean; overload;
var
  Buffer: TBytes;
  Count: Cardinal;
  SavePos: int64;
  BufferByte, SigByte, MaskByte: PByte;
begin
  ASSERT(Size >= MaskSize);
  ASSERT(Size > 0);

  SetLength(Buffer, Size);

  SavePos := Stream.Position;
  try
    Stream.Position := Offset;

    if (Stream.Read(Buffer[0], Size) = Int64(Size)) then
    begin
      Result := True;
      BufferByte := @Buffer[0];
      SigByte := PByte(@Signature);
      MaskByte := PByte(@Mask);
      Count := 1;
      while (Result) and (Count <= Size) do
      begin
        if (Count <= MaskSize) then
          Result := ((BufferByte^ and MaskByte^) = (SigByte^ and MaskByte^))
        else
          Result := (BufferByte^ = SigByte^);
        inc(Count);
        inc(BufferByte);
        inc(SigByte);
        inc(MaskByte);
      end;
    end else
      Result := False;

  finally
    Stream.Position := SavePos;
  end;
end;

function CheckFileSignature(Stream: TStream; const Signature; Size: Cardinal; Offset: int64 = 0): boolean; overload;
begin
  Result := CheckFileSignature(Stream, Signature, Size, nil^, 0, Offset);
end;

function CheckFileSignature(Stream: TStream; const Signature, Mask: AnsiString; Offset: int64 = 0): boolean; overload;
begin
  Result := CheckFileSignature(Stream, Signature[1], Length(Signature), Mask[1], Length(Mask), Offset);
end;

function CheckFileSignature(Stream: TStream; const Signature: AnsiString; Offset: int64 = 0): boolean; overload;
begin
  Result := CheckFileSignature(Stream, Signature[1], Length(Signature), Offset);
end;

function CheckFileSignatureWide(Stream: TStream; const Signature: UnicodeString; Offset: int64 = 0): boolean;
var
  AnsiSignature: AnsiString;
begin
  SetLength(AnsiSignature, Length(Signature)*SizeOf(WideChar));
  Move(PWideChar(Signature)^, PAnsiChar(AnsiSignature)^, Length(AnsiSignature));
  Result := CheckFileSignature(Stream, AnsiSignature, '', Offset);
end;

// -----------------------------------------------------------------------------
//
//              Encoding detection
//
// -----------------------------------------------------------------------------
// From amResourceItemString
// -----------------------------------------------------------------------------
type
  TAnsiSet = set of AnsiChar;

const
  MaxSampleANSI = 1024; // Characters
  MaxSampleUnicode = 1024; // Characters

//------------------------------------------------------------------------------

// TODO : Use Windows API functions for this.
function IsASCII(Stream: TStream; Extra: TAnsiSet = []): boolean;
var
  Count: integer;
  Value: AnsiChar;
  SavePos: int64;
  Allowed: set of AnsiChar;
  Terminated: boolean;
begin
  Result := (Stream.Size-Stream.Position >= SizeOf(AnsiChar));

  SavePos := Stream.Position;
  try
    Allowed := [#0, #9, #10, #13, #32..#126]+Extra; // #0 is special - see below
    Terminated := False;
    Count := 0;

    while (Result) and (Count < MaxSampleANSI) do
    begin
      if (Stream.Read(Value, SizeOf(Value)) <> SizeOf(Value)) then
        break;

      Result := (Value in Allowed) and
        // Allow terminating zero if no none-zero characters follow it
        ((not Terminated) or (Value = #0) or (AnsiChar(#0) in Extra));
      Terminated := (Value = #0);
      Inc(Count);
    end;
  finally
    Stream.Position := SavePos;
  end;
end;

//------------------------------------------------------------------------------

function IsAnsi(const Data: UnicodeString): boolean; overload;
var
  UsedDefaultChar: BOOL;
begin
  // From SynUnicode unit:
  WideCharToMultiByte(DefaultSystemCodePage, 0, PWideChar(Data), Length(Data), nil, 0, nil, @UsedDefaultChar);
  Result := not UsedDefaultChar;
end;

function IsANSI(Stream: TStream; Extra: TAnsiSet = []): boolean; overload;
begin
  Result := IsASCII(Stream, Extra + [#128..#255]);
end;

//------------------------------------------------------------------------------

function IsUnicode(Stream: TStream; Extra: TAnsiSet = []): boolean;
var
  Count: integer;
  Value: WideChar;
  SavePos: int64;
  Terminated: boolean;
begin
  Result := (Stream.Size-Stream.Position >= SizeOf(WideChar)) and
    ((Stream.Size-Stream.Position) mod SizeOf(WideChar) = 0);

  if (Result) and (CheckFileSignature(Stream, UTF16Signature, UTF16SignatureMask)) then
    exit;

  SavePos := Stream.Position;
  try
    Count := 0;
    Terminated := False;

    while (Result) and (Count < MaxSampleUnicode) do
    begin
      if (Stream.Read(Value, SizeOf(Value)) <> SizeOf(Value)) then
        break;

      Result := ((Value = #0) or (AnsiChar(Value) in Extra) or
        not(Value.GetUnicodeCategory in [TUnicodeCategory.ucUnassigned, TUnicodeCategory.ucPrivateUse])) and
//        [TUnicodeCategory.ucControl, TUnicodeCategory.ucUnassigned, TUnicodeCategory.ucPrivateUse])) and
        // Allow terminating zero if no none-zero characters follow it
        ((not Terminated) or (Value = #0) or (AnsiChar(#0) in Extra));
      Terminated := (Value = #0);
      Inc(Count);
    end;
  finally
    Stream.Position := SavePos;
  end;
end;

//------------------------------------------------------------------------------

function IsUTF8(Stream: TStream; Extra: TAnsiSet = []): boolean;
// Based on a snippet from Markus Spoettl

  function UTF8CharLength(const c: byte): Integer;
  begin
    // First Byte: 0xxxxxxx
    if ((c and $80) = $00) then
      Result := 1
    // First Byte: 110yyyyy
    else if ((c and $E0) = $C0) then
      Result := 2
    // First Byte: 1110zzzz
    else if ((c and $F0) = $E0) then
       Result := 3
    // First Byte: 11110uuu
    else if ((c and $F8) = $F0) then
      Result := 4
    // not valid, return the error value
    else
      Result := -1;
  end;

  function UTF8IsTrailChar(const c: byte): boolean;
  begin
    // trail bytes have this form: 10xxxxxx
    Result := ((c and $C0) = $80);
  end;

var
  SavePos: int64;
  Count: integer;
  Value: byte;
  c: byte;
  CharCount: integer;
  InBuffer: TBytes;
  OutBuffer: TBytes;
  OutStream: TMemoryStream;
begin
  Result := (Stream.Size-Stream.Position >= SizeOf(Value));

  if (Result) and (CheckFileSignature(Stream, UTF8Signature, UTF8SignatureMask)) then
    exit;

  SavePos := Stream.Position;
  try
    Count := 0;
    CharCount := 0;
    while (Result) and (Count < MaxSampleANSI) do
    begin
      if (Stream.Read(Value, SizeOf(Value)) <> SizeOf(Value)) then
        break;
      Inc(Count);

      // get the length if the current UTF-8 character
      c := UTF8CharLength(Value);

      // check if it's valid and fits into ASize
      if (c >= 1) and (c <= 4) then
      begin
        inc(CharCount);

        // if it's a multi-byte character, check the trail bytes
        while (c > 1) do
        begin
          if (Stream.Read(Value, SizeOf(Value)) <> SizeOf(Value)) or
            (not UTF8IsTrailChar(Value)) then
          begin
            Result := False;
            break;
          end;
          Inc(Count);
          dec(c);
        end;

        if (CharCount >= MaxSampleUnicode) then
          break;

      end else
        Result := False;
    end;

    // Appears to be valid UTF8. Now check if the chars it contains are allowed.
    if (Result) then
    begin
      SetLength(InBuffer, MaxSampleANSI);
      Stream.Position := SavePos;
      Stream.Read(InBuffer[0], MaxSampleANSI);
      OutBuffer := TEncoding.Convert(TEncoding.UTF8, TEncoding.Unicode, InBuffer);
      OutStream := TMemoryStream.Create;
      try
        OutStream.Write(OutBuffer[0], Length(OutBuffer));
        OutStream.Position := 0;
        Result := IsUnicode(OutStream, Extra + [#9, #10, #13]);
      finally
        OutStream.Free;
      end;
    end;
  finally
    Stream.Position := SavePos;
  end;
end;

// -----------------------------------------------------------------------------
//
//              Utilities
//
// -----------------------------------------------------------------------------
var
  CodePagesList: TStrings = nil;

function EnumCodePagesProc(lpCodePageString: PChar): BOOL; stdcall;
var
  CPINFOEX: TCPINFOEX;
  Name: string;
begin
  // Note: Must return 1, not just "True", contrary to Win API documentation.
  integer(Result) := 1;

  var Codepage := StrToIntDef(lpCodePageString, 0);
  if (not GetCPInfoEx(Codepage, 0, CPINFOEX)) then
    exit;

  if (CPINFOEX.CodePageName[0] <> #0) then
  begin
    SetLength(Name, SizeOf(CPINFOEX.CodePageName) div SizeOf(Char));
    StrLCopy(PChar(Name), @CPINFOEX.CodePageName[0], Length(Name));
    SetLength(Name, Length(PChar(Name)));
  end else
    Name := IntToStr(Codepage);

  CodePagesList.AddObject(Name, Pointer(CPINFOEX.Codepage));
end;

// -----------------------------------------------------------------------------

function CodepagesCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := integer(List.Objects[Index1]) - integer(List.Objects[Index2]);
end;


// -----------------------------------------------------------------------------
//
//      Compare two strings, disregarding different linebreak types
//
// -----------------------------------------------------------------------------
function SameTextIgnoreLinebreaks(const A, B: string): boolean;
begin
  var pA := PChar(A);
  var pB := PChar(B);

  var CurrentA := pA^;
  var CurrentB := pB^;

  while (CurrentA <> #0) and (CurrentB <> #0) do
  begin
    Inc(pA);
    Inc(pB);

    var NextA := pA^;
    var NextB := pB^;

    // Convert #13#10 to #13 and #10 to #13
    if (NextA = #10) then
    begin
      if (CurrentA = #13) then
      begin
        // #13#10 - skip #10
        Inc(pA);
        NextA := pA^;
      end else
        // Convert #10 to #13
        NextA := #13;
    end;

    if (NextB = #10) then
    begin
      if (CurrentB = #13) then
      begin
        // #13#10 - skip #10
        Inc(pB);
        NextB := pB^;
      end else
        // Convert #10 to #13
        NextB := #13;
    end;

    // Compare
    if (CurrentA <> CurrentB) then
      Exit(False);

    CurrentA := NextA;
    CurrentB := NextB;
  end;

  Result := (CurrentA = CurrentB); // Both #0 or strings not the same length
end;


// -----------------------------------------------------------------------------
//
//              TPreviewStream
//
// -----------------------------------------------------------------------------
type
  TPreviewStream = class(TStream)
  private
    FStream: TStream;
    FMaxSize: Int64;
  protected
    function GetSize: Int64; override;
  public
    constructor Create(AStream: TStream; AMaxSize: Int64);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  end;

constructor TPreviewStream.Create(AStream: TStream; AMaxSize: Int64);
begin
  FStream := AStream;
  FMaxSize := AMaxSize;
end;

function TPreviewStream.GetSize: Int64;
begin
  Result := Min(FMaxSize, FStream.Size);
end;

function TPreviewStream.Read(var Buffer; Count: Integer): Longint;
begin
  if (Position + Count > FMaxSize) then
    Count := Max(0, FMaxSize - Position);

  Result := FStream.Read(Buffer, Count);
end;

function TPreviewStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := FStream.Seek(Offset, Origin);
end;

function TPreviewStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result := FStream.Seek(Offset, Origin);
end;

function TPreviewStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := FStream.Write(Buffer, Count);
end;

// -----------------------------------------------------------------------------
//
//              TFormCSVImport
//
// -----------------------------------------------------------------------------
procedure TFormCSVImport.MsgPreviewFile(var Msg: TMessage);
begin
  PreviewFile;
end;

procedure TFormCSVImport.MsgPreviewLayout(var Msg: TMessage);
begin
  PreviewLayout;
end;

procedure TFormCSVImport.OnColumnMenuItemIgnoreClick(Sender: TObject);
begin
  FColumnMap[TMenuItem(Sender).Owner.Tag].Mapped := True;
  FColumnMap[TMenuItem(Sender).Owner.Tag].Kind := cmNone;
  GridLayoutTableView.Columns[TMenuItem(Sender).Owner.Tag].Caption := TMenuItem(Sender).Caption;
  ValidateLayout;
end;

procedure TFormCSVImport.OnColumnMenuItemMetaClick(Sender: TObject);
begin
  var Kind := TColumnMapKind(TMenuItem(Sender).Tag);
  UnmapColumns(Kind);
  FColumnMap[TMenuItem(Sender).Owner.Tag].Mapped := True;
  FColumnMap[TMenuItem(Sender).Owner.Tag].Kind := Kind;
  GridLayoutTableView.Columns[TMenuItem(Sender).Owner.Tag].Caption := TMenuItem(Sender).Hint;
  ValidateLayout;
end;

procedure TFormCSVImport.OnColumnMenuItemSourceClick(Sender: TObject);
begin
  UnmapColumns(cmValueSource);
  FColumnMap[TMenuItem(Sender).Owner.Tag].Mapped := True;
  FColumnMap[TMenuItem(Sender).Owner.Tag].Kind := cmValueSource;
  GridLayoutTableView.Columns[TMenuItem(Sender).Owner.Tag].Caption := TMenuItem(Sender).Hint;
  ValidateLayout;
end;

procedure TFormCSVImport.OnColumnMenuItemTargetClick(Sender: TObject);
begin
  FColumnMap[TMenuItem(Sender).Owner.Tag].Mapped := True;
  FColumnMap[TMenuItem(Sender).Owner.Tag].Kind := cmValueTarget;
  FColumnMap[TMenuItem(Sender).Owner.Tag].Language := TLanguageItem(TMenuItem(Sender).Tag);
  GridLayoutTableView.Columns[TMenuItem(Sender).Owner.Tag].Caption := TMenuItem(Sender).Caption;
  ValidateLayout;
end;

procedure TFormCSVImport.QueuePreviewFile;
begin
  PostMessage(Handle, MSG_PREVIEW_FILE, 0, 0);
end;

procedure TFormCSVImport.InvalidatePreviewLayout;
begin
  FHasLayout := False;
  ValidateLayout;
  PostMessage(Handle, MSG_PREVIEW_LAYOUT, 0, 0);
end;

procedure TFormCSVImport.LayoutRadioButtonItemMapValueClick(Sender: TObject);
begin
  FMapMode := [mmValue];
  ValidateLayout;
end;

procedure TFormCSVImport.LayoutRadioButtonItemMapIDClick(Sender: TObject);
begin
  FMapMode := [mmID];
  ValidateLayout;
end;

procedure TFormCSVImport.LayoutRadioButtonItemMapBothClick(Sender: TObject);
begin
  FMapMode := [mmID, mmValue];
  ValidateLayout;
end;

procedure TFormCSVImport.PreviewFile;
const
  MaxLines = 100;
resourcestring
  sImportCsvWrongEncoding = 'The data appears to be encoded in a codepage other than the one you have specified.'+#13#13+
    'You have specified the codepage %d: "%s" but the data appears'+#13+'to be encoded in the codepage %d: "%s".'+#13#13+
    'Click the button to use the codepage %2:d: "%3:s" instead.';
begin
  if (not TFile.Exists(Filename)) then
  begin
    FHasFile := False;
    MemoFilePreview.Lines.Clear;
    LayoutItemFileEncodingWarning.Visible := False;
    WizardControl.Buttons.Next.Enabled := False;
    exit;
  end;

  try
    var Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
    try

      // Detect codepage and display warning if user has selected a codepage other
      // than the one we have detected.
      if (FDetectedCodepage = -1) then
      begin
        Stream.Position := 0;

        if (IsASCII(Stream)) then
          FDetectedCodepage := TEncoding.ASCII.CodePage
        else
        if (IsUTF8(Stream)) then
          FDetectedCodepage := CP_UTF8
        else
        if (IsUnicode(Stream, [#9, #10, #13])) then
          FDetectedCodepage := 1200
        else
          // DetectCodePage can't handle UTF-8 with BOM so we only use it if we have to
          FDetectedCodepage := DetectCodePage(Stream);

        LayoutItemFileEncodingWarning.Visible := (FDetectedCodepage <> 0) and (FDetectedCodepage <> FSettings.Codepage);
        ActionFileEncodingWarning.Hint := Format(sImportCsvWrongEncoding, [FSettings.Codepage, GetCodePageDescription(FSettings.Codepage), FDetectedCodepage, GetCodePageDescription(FDetectedCodepage)]);
      end;

      var Encoding := TEncoding.GetEncoding(Codepage);
      try
        Stream.Position := 0;

        var PreviewStream := TPreviewStream.Create(Stream, 2048);
        try
  //        ProgressStream := TProgressStream.Create(PreviewStream, Progress);
          try
            var Reader := TStreamReader.Create(Stream, Encoding, False);
            try

              MemoFilePreview.Lines.BeginUpdate;
              try
                MemoFilePreview.Lines.Clear;

                var LineCounter := 0;
                while (LineCounter < MaxLines) and (not Reader.EndOfStream) do
                begin
                  MemoFilePreview.Lines.Add(Reader.ReadLine);
                  Inc(LineCounter);
                end;

              finally
                MemoFilePreview.Lines.EndUpdate;
              end;
            finally
              Reader.Free;
            end;
          finally
  //          ProgressStream.Free;
          end;

        finally
          PreviewStream.Free;
        end;
      finally
        Encoding.Free;
      end;
    finally
      Stream.Free;
    end;

    FHasFile := True;
    WizardControl.Buttons.Next.Enabled := True;

  except
    on E: EFOpenError do
    begin
      MessageDlg(sErrorAccessDenied, mtError, [mbOK], -1);
      // Hack to ensure that the EditFilename control 'appears correct'
      WizardControlPageFile.Activate;
      ActiveControl := EditFilename;
    end;
  end;
end;

procedure TFormCSVImport.PreviewLayout;
const
  MaxRows = 100;
begin
  if (FHasLayout) then
    Exit;

  try
    var Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
    try
      var Encoding := TEncoding.GetEncoding(Codepage);
      try
        GridLayoutTableView.BeginUpdate;
        try

          GridLayoutTableView.ClearItems;

          begin
            var ColumnCounter: ICsvReaderRowTarget := TCsvReaderRowTargetColumnCounter.Create;
            TCsvReader.ReadFromStream(Stream, FSettings, ColumnCounter);

            var Count := TCsvReaderRowTargetColumnCounter(ColumnCounter).Count;

            SetLength(FColumnMap, Count);

            for var i := 0 to Count-1 do
            begin
              var Column := GridLayoutTableView.CreateColumn;
              Column.Tag := i;
              Column.Caption := sClickToMap;
              Column.MinWidth := 64;
              Column.BestFitMaxWidth := 150;
              Column.OnGetProperties := GridLayoutTableViewColumnGetProperties;
            end;
          end;

          // Get approximate row count
          begin
            var RowCount := 0;
            Stream.Position := 0;
            var Reader := TStreamReader.Create(Stream, Encoding);
            try
              Reader.EndOfStream;

              while (RowCount < MaxRows) and (not Reader.EndOfStream) do
              begin
                Reader.ReadLine;
                Inc(RowCount);
              end;
            finally
              Reader.Free;
            end;

            // HasMore can be used to enable a "Load more..." button in the grid
            // if we should implement that.
            // var HasMore := (not Reader.EndOfStream);

            GridLayoutTableView.DataController.RecordCount := RowCount;
          end;

          begin
            Stream.Position := 0;
            var ParserCSV := TTextParserCSV.Create(FSettings, Stream, Encoding);
            try

              var Row := 0;
              while (Row < GridLayoutTableView.DataController.RecordCount) and (not ParserCSV.EndOfData) do
              begin
                var Values := ParserCSV.ReadRow;

                for var i := 0 to High(Values) do
                begin
                  if (i >= GridLayoutTableView.ItemCount) then
                    break;
                  GridLayoutTableView.DataController.Values[Row, i] := Values[i];
                end;

                Inc(Row);
              end;

              // Trim grid to actual row count
              GridLayoutTableView.DataController.RecordCount := Row;

              // Only display navigator column if we have any rows. Otherwise the grid will
              // only display the top, left cell and that looks strange.
              GridLayoutTableView.OptionsView.Indicator := (Row > 0);
            finally
              ParserCSV.Free;
            end;
          end;

        finally
          GridLayoutTableView.EndUpdate;
        end;
        // Note: ApplyBestFit must be after Grid.EndUpdate or we will get index out of
        // bounds and AVs because the items hasn't been created yet.
        GridLayoutTableView.ApplyBestFit;
      finally
        Encoding.Free;
      end;
    finally
      Stream.Free;
    end;

    FHasLayout := True;
  except
    on E: EFOpenError do
    begin
      MessageDlg(sErrorAccessDenied, mtError, [mbOK], -1);
      // Hack to ensure that the EditFilename control 'appears correct'
      WizardControlPageFile.Activate;
      ActiveControl := EditFilename;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TFormCSVImport.Execute(AProject: TLocalizerProject): boolean;
begin
  FProject := AProject;
  FSettings := TCsvSettings.Default;
  LoadEncodings;
  Codepage := FSettings.Codepage;
  FMapMode := [mmID];

  Result := (ShowModal = mrOK);
end;

// -----------------------------------------------------------------------------

procedure TFormCSVImport.ActionFileBrowseExecute(Sender: TObject);
begin
  var NewFilename := Filename;

  if (not PromptForFileName(NewFilename, sFileFilterCSV+'|'+sFileTextFilter+'|'+SDefaultFilter, 'csv', '', TranslationManagerSettings.Folders.FolderDocuments, False)) then
    Exit;

  Filename := NewFileName;
end;

// -----------------------------------------------------------------------------

procedure TFormCSVImport.ActionFileEncodingWarningExecute(Sender: TObject);
begin
  if (FDetectedCodepage > 0) then
    Codepage := FDetectedCodepage;
end;

procedure TFormCSVImport.ButtonImportClick(Sender: TObject);
begin
  WizardControl.GoToNextPage;
  try

    Import;

    if (ListViewProgress.Items.Count > 0) then
    begin
      LayoutItemResultWarnings.Control := ListViewProgress;
      LayoutItemResultWarnings.Visible := True;
    end;

    LabelCountAdded.Caption := Format('%.0n', [FTranslationCount.CountAdded * 1.0]);
    LabelCountUpdated.Caption := Format('%.0n', [FTranslationCount.CountUpdated * 1.0]);
    LabelCountSkipped.Caption := Format('%.0n', [FTranslationCount.CountSkipped * 1.0]);

    WizardControl.GoToNextPage;

  except
    WizardControl.ActivePage := WizardControlPageImport;
    raise;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormCSVImport.ComboBoxDelimiterPropertiesEditValueChanged(Sender: TObject);
begin
  if (ComboBoxDelimiter.ItemIndex <> -1) then
    FSettings.DelimiterChar := sDelimiters[ComboBoxDelimiter.ItemIndex]
  else
  begin
    if (ComboBoxDelimiter.Text = '') then
      FSettings.DelimiterChar := #0
    else
      FSettings.DelimiterChar := ComboBoxDelimiter.Text[1];
  end;

  InvalidatePreviewLayout;
end;

procedure TFormCSVImport.ComboBoxEncodingPropertiesEditValueChanged(Sender: TObject);
begin
  FDetectedCodepage := -1;
  FSettings.Codepage := Codepage;
  FHasLayout := False;

  // Update async to give combo a chance to drop up so we can display progress unobscured
  QueuePreviewFile;
end;

procedure TFormCSVImport.ComboBoxEscapeCharPropertiesEditValueChanged(Sender: TObject);
begin
  if (ComboBoxEscapeChar.ItemIndex <> -1) then
    FSettings.DelimiterChar := sEscapeChars[ComboBoxEscapeChar.ItemIndex]
  else
  begin
    if (ComboBoxEscapeChar.Text = '') then
      FSettings.EscapeChar := #0
    else
      FSettings.EscapeChar := ComboBoxEscapeChar.Text[1];
  end;

  InvalidatePreviewLayout;
end;

procedure TFormCSVImport.DisplayColumnMapPopupMenu(Column: TcxCustomGridTableItem);
begin
//  PanelPreviewHint.Hide;

  PopupMenuColumn.Items.Clear;

  var Index := Column.Tag;

  (*
  ** Ignore column
  *)
  begin
    var MenuItem := TMenuItem.Create(PopupMenuColumn);
    MenuItem.Caption := sColumnCaptionIgnore;
    MenuItem.Hint := sColumnCaptionIgnore;
    MenuItem.Tag := Ord(cmNone);
    MenuItem.OnClick := OnColumnMenuItemIgnoreClick;
    MenuItem.RadioItem := True;
    MenuItem.GroupIndex := 1;
    MenuItem.Checked := (FColumnMap[Index].Mapped) and (FColumnMap[Index].Kind = cmNone);
    PopupMenuColumn.Items.Add(MenuItem);

    MenuItem := TMenuItem.Create(Self);
    MenuItem.Caption := cLineCaption;
    PopupMenuColumn.Items.Add(MenuItem);
  end;

  (*
  ** ID columns
  *)
  if (mmID in FMapMode) then
  begin
    for var MapKind := cmMetaModule to cmMetaProperty do
    begin
      var MenuItem := TMenuItem.Create(PopupMenuColumn);
      var Caption := LoadResString(sColumnCaptions[MapKind]);
      MenuItem.Caption := Format(sColumnCaptionRequired, [Caption]);
      MenuItem.Hint := Caption;
      MenuItem.Tag := Ord(MapKind);
      MenuItem.OnClick := OnColumnMenuItemMetaClick;
      MenuItem.RadioItem := True;
      MenuItem.GroupIndex := 1;
      MenuItem.Checked := (FColumnMap[Index].Mapped) and (FColumnMap[Index].Kind = MapKind);
      PopupMenuColumn.Items.Add(MenuItem);
    end;

    var MenuItem := TMenuItem.Create(Self);
    MenuItem.Caption := cLineCaption;
    PopupMenuColumn.Items.Add(MenuItem);
  end;

  (*
  ** Source language
  *)
  begin
    var MenuItem := TMenuItem.Create(PopupMenuColumn);
    MenuItem.Hint := Format(sColumnCaptionSourceLanguage, [LanguageID(FProject.SourceLanguage)]);
    if (mmValue in FMapMode) then
      MenuItem.Caption := Format(sColumnCaptionRequired, [MenuItem.Hint])
    else
      MenuItem.Caption := Format(sColumnCaptionOptional, [MenuItem.Hint]);
    MenuItem.Tag := -1;
    MenuItem.OnClick := OnColumnMenuItemSourceClick;
    MenuItem.RadioItem := True;
    MenuItem.GroupIndex := 1;
    MenuItem.Checked := (FColumnMap[Index].Mapped) and (FColumnMap[Index].Kind = cmValueSource);
    PopupMenuColumn.Items.Add(MenuItem);

    MenuItem := TMenuItem.Create(Self);
    MenuItem.Caption := cLineCaption;
    PopupMenuColumn.Items.Add(MenuItem);
  end;

  (*
  ** Target languages
  *)
  for var Language in FProject.TranslationLanguages do
  begin
    var MenuItem := TMenuItem.Create(PopupMenuColumn);
    MenuItem.Caption := Format(sColumnCaptionTargetLanguage, [LanguageID(Language.Language)]);
    MenuItem.Tag := NativeInt(Language.Language);
    MenuItem.OnClick := OnColumnMenuItemTargetClick;
    MenuItem.RadioItem := True;
    MenuItem.GroupIndex := 1;
    MenuItem.Checked := (FColumnMap[Index].Mapped) and (FColumnMap[Index].Kind = cmValueTarget) and (FColumnMap[Index].Language = Language.Language);
    PopupMenuColumn.Items.Add(MenuItem);
  end;

  // Position menu at top, right corner
  var View :=  TcxGridTableView(Column.GridView);
  var APoint: TPoint;
  APoint.X := View.ViewInfo.HeaderViewInfo.Items[Column.Index].Bounds.Right;
  APoint.Y := View.ViewInfo.HeaderViewInfo.Items[Column.Index].Bounds.Top;
  APoint := View.Site.ClientToScreen(APoint);

  // Limit height of menu
  var MenuInfo: TMenuInfo;
  ZeroMemory(@MenuInfo, SizeOf(MenuInfo));
  MenuInfo.cbSize := SizeOf(MenuInfo);
  MenuInfo.fMask := MIM_MAXHEIGHT;
  var Monitor := Screen.MonitorFromPoint(APoint);
  if (GetMenuInfo(PopupMenuColumn.Handle, MenuInfo)) then
  begin
    MenuInfo.cyMax := Monitor.Height div 2;
    SetMenuInfo(PopupMenuColumn.Handle, MenuInfo);
  end;

  // Display menu
  PopupMenuColumn.Tag := Index; // Save column index so the menu item OnClick handler can determine what column to map
  PopupMenuColumn.Popup(APoint.X, APoint.Y);
end;

procedure TFormCSVImport.WizardControlButtonClick(Sender: TObject; AKind: TdxWizardControlButtonKind; var AHandled: Boolean);
begin
  if (AKind = wcbkFinish) then
    ModalResult := mrOK
  else
  if (AKind = wcbkCancel) then
    ModalResult := mrCancel;
end;

procedure TFormCSVImport.WizardControlInfoPanelClick(Sender: TObject; var AHandled: Boolean);
begin
  LayoutItemLayoutEscapeChar.Visible := True;
  WizardControl.InfoPanel.Enabled := False;
  AHandled := True;
end;

procedure TFormCSVImport.WizardControlPageChanging(Sender: TObject; ANewPage: TdxWizardControlCustomPage; var AAllow: Boolean);
begin
  if (ANewPage = WizardControlPageFile) then
  begin
    WizardControl.Buttons.Next.Enabled := FHasFile;
    WizardControl.InfoPanel.Visible := False;
  end else
  if (ANewPage = WizardControlPageLayout) then
  begin
    PreviewLayout;
    if (WizardControl.ActivePage = WizardControlPageFile) then
      AutoDetectLayout;
    ValidateLayout;
    WizardControl.Buttons.Next.Enabled := FHasValidLayout;
    WizardControl.InfoPanel.Visible := True;
  end else
  if (ANewPage = WizardControlPageImport) then
  begin
    WizardControl.Buttons.Back.Enabled := True;
    WizardControl.Buttons.Next.Enabled := False;
    WizardControl.InfoPanel.Visible := False;
  end else
  if (ANewPage = WizardControlPageProgress) then
  begin
    WizardControl.Buttons.Back.Enabled := False;
    WizardControl.Buttons.Next.Enabled := False;
  end else
  if (ANewPage = WizardControlPageDone) then
  begin
    WizardControl.Buttons.Cancel.Enabled := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormCSVImport.EditFilenamePropertiesEditValueChanged(Sender: TObject);
begin
  FDetectedCodepage := -1;
  FFilename := TcxCustomTextEdit(Sender).Text;
  FHasLayout := False;
  FHasFile := False;

  QueuePreviewFile;
end;

// -----------------------------------------------------------------------------

function TFormCSVImport.LanguageID(Language: TLanguageItem): string;
begin
  Result := Format('%s %s', [Language.LocaleName, Language.LanguageName]);
end;

function TFormCSVImport.GetCodepage: integer;
begin
  if (ComboBoxEncoding.ItemIndex <> -1) then
    Result := ComboBoxEncoding.EditValue
  else
    Result := GetACP;
end;

procedure TFormCSVImport.SetCodepage(const Value: integer);
begin
//  BeginPreview;
  try

    ComboBoxEncoding.EditValue := Value;
    if (ComboBoxEncoding.ItemIndex = -1) then
      ComboBoxEncoding.EditValue := GetACP;

  finally
//    EndPreview;
  end;
  // Note: FSettings are updated through OnEditValueChanged event handler
end;

// -----------------------------------------------------------------------------

function TFormCSVImport.GetFilename: string;
begin
  Result := EditFilename.Text;
end;

procedure TFormCSVImport.GridLayoutTableViewColumnGetProperties(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := EditRepositoryDataItem.Properties;
end;

procedure TFormCSVImport.GridLayoutTableViewColumnHeaderClick(Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  DisplayColumnMapPopupMenu(AColumn);
end;

procedure TFormCSVImport.GridLayoutTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if (ARecord.Index < FSettings.FirstRow-1) then
    AStyle := DataModuleMain.StyleSelectedInactive
  else
  if (not FColumnMap[AItem.Index].Mapped) then
    AStyle := DataModuleMain.StyleNeedAction
  else
  if (FColumnMap[AItem.Index].Kind = cmNone) then
    AStyle := DataModuleMain.StyleDisabled;
end;

procedure TFormCSVImport.SetFilename(const Value: string);
begin
  EditFilename.Text := Value;
  // Note: FSettings are updated through OnEditValueChanged event handler
end;

procedure TFormCSVImport.SpinEditFirstRowPropertiesEditValueChanged(Sender: TObject);
begin
  FSettings.FirstRow := SpinEditFirstRow.Value;
  if (FLockChanged = 0) then
    InvalidatePreviewLayout;
end;

procedure TFormCSVImport.UnmapColumns(Kind: TColumnMapKind);
begin
  for var i := 0 to High(FColumnMap) do
    if (FColumnMap[i].Mapped) and (FColumnMap[i].Kind = Kind) then
    begin
      FColumnMap[i].Mapped := False;
      GridLayoutTableView.Columns[i].Caption := sClickToMap;
    end;
end;

procedure TFormCSVImport.AutoDetectLayout;
var
  HasHeader: boolean;

  procedure FindHeaderField(const Name: string; Kind: TColumnMapKind; Language: TLanguageItem = nil);
  begin
    var Row := GridLayoutTableView.ViewData.Rows[0];

    for var i := 0 to Row.ValueCount-1 do
      if (SameText(Row.Values[i], Name)) then
      begin
        FColumnMap[i].Kind := Kind;
        FColumnMap[i].Mapped := True;

        case Kind of
          cmNone:
            GridLayoutTableView.Columns[i].Caption := sColumnCaptionIgnore;

          cmMetaModule..cmMetaProperty:
            GridLayoutTableView.Columns[i].Caption := LoadResString(sColumnCaptions[Kind]);

          cmValueSource:
            GridLayoutTableView.Columns[i].Caption := Format(sColumnCaptionSourceLanguage, [LanguageID(Language)]);

          cmValueTarget:
            GridLayoutTableView.Columns[i].Caption := Format(sColumnCaptionTargetLanguage, [LanguageID(Language)]);
        end;

        HasHeader := True;
        break;
      end;
  end;

begin
  if (not FHasLayout) or (FHasValidLayout) then
    exit;

  if (GridLayoutTableView.ViewData.RowCount < 1) then
    exit;

  HasHeader := False;

  FindHeaderField('Module', cmMetaModule);
  FindHeaderField('Item', cmMetaItem);
  FindHeaderField('ItemType', cmNone);
  FindHeaderField('Property', cmMetaProperty);
  FindHeaderField(FProject.SourceLanguage.LocaleName, cmValueSource, FProject.SourceLanguage);
  for var TargetLanguage in FProject.TranslationLanguages do
    FindHeaderField(TargetLanguage.Language.LocaleName, cmValueTarget, TargetLanguage.Language);

  if HasHeader then
  begin
    Inc(FLockChanged);
    SpinEditFirstRow.Value := 2;
    Dec(FLockChanged);
  end;
end;

procedure TFormCSVImport.ValidateLayout;

  function FindMapping(Kind: TColumnMapKind): boolean;
  begin
    for var i := 0 to High(FColumnMap) do
      if (FColumnMap[i].Mapped) and (FColumnMap[i].Kind = Kind) then
        Exit(True);
    Result := False;
  end;

begin
  FHasValidLayout := FHasLayout and FindMapping(cmValueTarget);

  if (mmID in FMapMode) then
    FHasValidLayout := FHasValidLayout and FindMapping(cmMetaModule) and FindMapping(cmMetaItem) and FindMapping(cmMetaProperty);

  if (mmValue in FMapMode) then
    FHasValidLayout := FHasValidLayout and FindMapping(cmValueSource);

  if (WizardControl.ActivePage = WizardControlPageLayout) then
    WizardControl.Buttons.Next.Enabled := FHasValidLayout;

  LayoutCheckBoxItemMatchAll.Enabled := (mmValue in FMapMode);
  LayoutCheckBoxItemMatchFuzzy.Enabled := (mmValue in FMapMode);
end;

// -----------------------------------------------------------------------------

procedure TFormCSVImport.LoadEncodings;
var
  ACP: UINT;

  procedure PrioritizeEncoding(var Priority: integer; Codepages: TStrings; Codepage: Cardinal; Force: boolean = False);
  begin
    // Don't move if codepage is the ACP.
    // We use this to lock the ACP at the top of the list.
    if (not Force) and (Codepage = ACP) then
      exit;

    var Index := Codepages.IndexOfObject(Pointer(Codepage));
    if (Index <> -1) then
    begin
      Codepages.Move(Index, Priority);
      Inc(Priority);
    end;
  end;

  procedure SaveEncodings(Codepages: TStrings);
  var
    MultiLanguage: IMultiLanguage2;

    function ParseEncoding(const s: string; Codepage: integer): string;
    begin
      // Try to get codepage description from MLang
      if (MultiLanguage <> nil) then
      begin
        SetLength(Result, 128);
        if (MultiLanguage.GetCodePageDescription(Codepage, GetUserDefaultLCID, PChar(Result), Length(Result)) = S_OK) then
        begin
          Result := PChar(Result);
          exit;
        end;
      end;

      // Try to get codepage description from data returned from EnumSystemCodePages
      var n := Pos('(', s);

      if (n = -1) then
      begin
        Result := s;
      end else
      begin
        Result := trim(Copy(s, n, MaxInt));
        if (Pos('(', Result) = 1) and (LastDelimiter(')', Result) = Length(Result)) then
        begin
          Delete(Result, 1, 1);
          Delete(Result, Length(Result), 1);
        end;
      end;

      // Give up. Just use codepage value.
      if (Result = '') then
        Result := IntToStr(Codepage);
    end;

  begin
    if (CoCreateInstance(CLSID_CMultiLanguage, nil, CLSCTX_INPROC_SERVER, IID_IMultiLanguage2, MultiLanguage) <> S_OK) then
      MultiLanguage := nil;


    FDMemTableCodePages.DisableControls;
    try
      FDMemTableCodePages.EmptyDataSet;

      for var i := 0 to Codepages.Count-1 do
      begin
        FDMemTableCodePages.Append;
        try
          FDMemTableCodePages['Codepage'] := integer(Codepages.Objects[i]);
          FDMemTableCodePages['Name'] := ParseEncoding(Codepages[i], integer(Codepages.Objects[i]));

          FDMemTableCodePages.Post;
        except
          FDMemTableCodePages.Cancel;
          raise;
        end;
      end;
    finally
      FDMemTableCodePages.EnableControls;
    end;
  end;

begin
  var Codepages := TStringList.Create;
  try
    // Get a list of installed codepages
    CodePagesList := Codepages;
    try
      EnumSystemCodePages(@EnumCodePagesProc, CP_INSTALLED);
    finally
      CodePagesList := nil;
    end;

    // Bizzarely, EnumSystemCodePages doesn't return the native unicode
    // code pages 1200 and 1201, so we need to add those manually.
    Codepages.AddObject(TEncoding.Unicode.EncodingName, Pointer(TEncoding.Unicode.Codepage));
    Codepages.AddObject(TEncoding.BigEndianUnicode.EncodingName, Pointer(TEncoding.BigEndianUnicode.Codepage));

    // Order list by ordinal codepage value
    Codepages.CustomSort(CodepagesCompareStrings);

    ACP := GetACP;
    // Reorder list so the most common are first
    var Priority := 0;
    PrioritizeEncoding(Priority, Codepages, ACP, True); // Active Code Page
    PrioritizeEncoding(Priority, Codepages, CP_UTF8);
    PrioritizeEncoding(Priority, Codepages, 1200); // Unicode
    PrioritizeEncoding(Priority, Codepages, 1201); // Big Endian unicode
    PrioritizeEncoding(Priority, Codepages, 1252); // ANSI Latin 1; Western European (Windows)
    PrioritizeEncoding(Priority, Codepages, 1250); // ANSI Central European; Central European (Windows)
    PrioritizeEncoding(Priority, Codepages, 20127); // US-ASCII
    PrioritizeEncoding(Priority, Codepages, CP_UTF7);

    // Parse codepage list and save to dataset
    SaveEncodings(Codepages);
  finally
    Codepages.Free;
  end;
end;

procedure TFormCSVImport.Warning(const Fmt: string; const Args: array of const);
begin
  var Item := ListViewProgress.Items.Add;
  Item.Caption := Format(Fmt, Args);
  Item.ImageIndex := ImageIndexWarning;
  ListViewProgress.Update;
end;

procedure TFormCSVImport.UpdateTranslation(Prop: TLocalizerProperty; Language: TTranslationLanguage; const Value: string; ApplyMakeAlike: boolean);
begin
  var TargetValue := Value;

  var Translation: TLocalizerTranslation;
  if (Prop.Translations.TryGetTranslation(Language, Translation)) then
  begin
    if (FUpdateExisting) then
    begin
      if (ApplyMakeAlike) then
        TargetValue := MakeAlike(Prop.Value, TargetValue);

      if (Translation.Value <> TargetValue) and (not SameTextIgnoreLinebreaks(Translation.Value, TargetValue)) then
      begin
        Translation.Update(TargetValue);
        Inc(FTranslationCount.CountUpdated);
      end else
        Inc(FTranslationCount.CountSkipped);
    end else
      Inc(FTranslationCount.CountSkipped);
  end else
  begin
    if (ApplyMakeAlike) then
      TargetValue := MakeAlike(Prop.Value, TargetValue);

    Prop.TranslatedValue[Language] := TargetValue;
    Inc(FTranslationCount.CountAdded);
  end;
end;

procedure TFormCSVImport.Import;
type
  TMatchness = (MatchNone, MatchSanitized, MatchSame, MatchExact);

  TTargetColumn = record
    Index: integer;
    Language: TTranslationLanguage;
  end;

var
  FProjectPropertyLookup: ILocalizerProjectPropertyLookup;

  function FindMapping(Kind: TColumnMapKind): integer;
  begin
    for var i := 0 to High(FColumnMap) do
      if (FColumnMap[i].Mapped) and (FColumnMap[i].Kind = Kind) then
        Exit(i);
    Result := -1;
  end;

  function ProjectPropertyLookup: ILocalizerProjectPropertyLookup;
  begin
    if (FProjectPropertyLookup = nil) then
      FProjectPropertyLookup := FProject.CreatePropertyLookup(TranslationManagerSettings.Editor.SanitizeRules);

    Result := FProjectPropertyLookup;
  end;

  procedure UpdateTranslations(Prop: TLocalizerProperty; const Translations: TArray<TTargetColumn>; const SourceValue: string;
    const Values: TArray<string>; ApplyMakeAlike: boolean);
  begin
    for var i := 0 to High(Translations) do
    begin
      var TargetValue := Values[Translations[i].Index];

      if (TargetValue = '') or (TargetValue = SourceValue) then
      begin
        Inc(FTranslationCount.CountSkipped);
        continue;
      end;

      UpdateTranslation(Prop, Translations[i].Language, TargetValue, ApplyMakeAlike);
    end;
  end;

  function GetMatchness(Prop: TLocalizerProperty; const SourceValue: string; Matchness: TMatchness = MatchNone): TMatchness;
  begin
    if (Prop.EffectiveStatus <> ItemStatusTranslate) then
      Exit(MatchNone);

    Result := Matchness;

    if (Prop.Value = SourceValue) then
      Result := MatchExact
    else
    if (Result >= MatchSame) then
      exit
    else
    if (SameTextIgnoreLinebreaks(Prop.Value, SourceValue)) then
//    if (AnsiSameText(Prop.Value, SourceValue)) then
      Result := MatchSame
    else
    if (Matchness >= MatchSanitized) then
      exit
    else
      Result := MatchSanitized;
  end;

resourcestring
  sImportCSV = 'Importing CSV';
begin
  FProjectPropertyLookup := nil;

  var ModuleIndex := FindMapping(cmMetaModule);
  var ItemIndex := FindMapping(cmMetaItem);
  var PropIndex := FindMapping(cmMetaProperty);
  var SourceIndex := FindMapping(cmValueSource);

  // Determine number of target columns
  var Translations: TArray<TTargetColumn>;
  var n := 0;
  for var i := 0 to High(FColumnMap) do
    if (FColumnMap[i].Mapped) and (FColumnMap[i].Kind = cmValueTarget) then
      Inc(n);
  SetLength(Translations, n);

  // Save target column indices
  n := 0;
  for var i := 0 to High(FColumnMap) do
    if (FColumnMap[i].Mapped) and (FColumnMap[i].Kind = cmValueTarget) then
    begin
      Translations[n].Index := i;
      Translations[n].Language := FProject.TranslationLanguages.Find(FColumnMap[i].Language);
      Inc(n);
    end;

  try
    var Progress := ShowProgress(sImportCsv);
    Progress.EnableAbort := True;
    Progress.RaiseOnAbort := True;
    Progress.Show;

    var Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
    try

      // Create lookup now if we know that we will need it
      if (FMapMode = [mmValue]) then
        ProjectPropertyLookup;

      var ProgressStream := TProgressStream.Create(Stream, Progress);
      try
        var Encoding := TEncoding.GetEncoding(Codepage);
        try
          var ParserCSV := TTextParserCSV.Create(FSettings, ProgressStream, Encoding, False);
          try

            var RowCounter := 0;
            while (not ParserCSV.EndOfData) do
            begin
              var Values := ParserCSV.ReadRow;
              Inc(RowCounter);

              // Ignore header rows
              if (RowCounter < FSettings.FirstRow) then
                continue;

              // Ignore invalid rows (too few columns)
              if (Length(Values) < Length(FColumnMap)) then
                continue;

              var SourceValue: string;
              var Prop: TLocalizerProperty := nil;
              var Skip := False;
              var Found: boolean := False;
              var Matchness: TMatchness := MatchNone;

              if (mmID in FMapMode) then
              begin
                var ModuleName := Values[ModuleIndex];
                Progress.UpdateMessage(ModuleName);

                var Module := FProject.FindModule(ModuleName);
                if (Module <> nil) then
                begin

                  var Item := Module.FindItem(Values[ItemIndex]);
                  if (Item <> nil) then
                  begin

                    Prop := Item.FindProperty(Values[PropIndex]);
                    if (Prop <> nil) then
                    begin
                      Found := True;
                      if (Prop.EffectiveStatus = ItemStatusTranslate) then
                      begin
                        Matchness := MatchExact;

                        if (SourceIndex <> -1) then
                        begin
                          SourceValue := Values[SourceIndex];

                          if (SourceValue <> Prop.Value) then
                          begin
                            // CSV import cannot represent different linebreak types so an
                            // imported linebreak might not match the original line break
                            // type. Compare the string again while disregarding linebreak
                            // type:
                            if (not SameTextIgnoreLinebreaks(SourceValue, Prop.Value)) then
                            begin
                              // Do not import obsolete translations
                              Warning('Source value changed; Translation obsolete: %s.%s.%s', [ModuleName, Values[ItemIndex], Values[PropIndex]]);
                              Prop := nil;
                              Skip := True;
                            end;
                          end;
                        end else
                          SourceValue := Prop.Value;
                      end else
                        Skip := True;
                    end else
                      Warning('Property not found: %s.%s.%s', [ModuleName, Values[ItemIndex], Values[PropIndex]]);

                  end else
                    Warning('Item not found: %s.%s', [ModuleName, Values[ItemIndex]]);

                end else
                  Warning('Module not found: %s', [ModuleName]);

                if (Skip) then
                  Inc(FTranslationCount.CountSkipped);
              end;

              // Find source by value if we failed to find it by ID
              if (mmValue in FMapMode) and (not Found) and (not Skip) then
              begin
                SourceValue := Values[SourceIndex];

                // TODO : Source lookup adapted from TLocalizerPOImport.ProcessTerm
                // Maybe refactor this into a common function

                // Try to locate term in project
                var SanitizedText := SanitizeText(SourceValue);
                var List := ProjectPropertyLookup.Lookup(SanitizedText);

                if (List <> nil) and (List.Count > 0) then
                begin
                  Found := True;

                  if (LayoutCheckBoxItemMatchAll.Checked) then
                  begin
                    for Prop in List do
                    begin
                      Matchness := GetMatchness(Prop, SourceValue);
                      if (Matchness <> MatchNone) and ((Matchness = MatchExact) or (LayoutCheckBoxItemMatchFuzzy.Checked)) then
                        UpdateTranslations(Prop, Translations, SourceValue, Values, (Matchness = MatchSanitized))
                      else
                        Inc(FTranslationCount.CountSkipped);
                    end;
                    Skip := True;
                  end else
                  begin
                    for var TestProp in List do
                    begin
                      var NewMatchness := GetMatchness(TestProp, SourceValue, Matchness);

                      if (NewMatchness > Matchness) then
                      begin
                        Prop := TestProp;
                        Matchness := NewMatchness;
                      end;
                      if (Matchness = MatchExact) then
                        break;
                    end;
                  end;

                  if (not Found) and (not Skip) then
                    Inc(FTranslationCount.CountSkipped);
                end;

                if (not Found) and (not Skip) then
                  Warning('Value not found: %s', [SourceValue]);
              end;

              if (Prop <> nil) and (not Skip) then
              begin
                if (Matchness <> MatchNone) and ((Matchness = MatchExact) or (LayoutCheckBoxItemMatchFuzzy.Checked)) then
                  UpdateTranslations(Prop, Translations, SourceValue, Values, (Matchness = MatchSanitized));
              end;

            end;

          finally
            ParserCSV.Free;
          end;
        finally
          Encoding.Free;
        end;
      finally
        ProgressStream.Free;
      end;
    finally
      Stream.Free;
    end;
  except
    on E: EFOpenError do
    begin
      MessageDlg(sErrorAccessDenied, mtError, [mbOK], -1);
      WizardControl.ActivePageIndex := WizardControl.ActivePageIndex-1;
    end;
  end;
end;

end.
