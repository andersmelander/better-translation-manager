unit amLocalization.Data.Main;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Data.DB,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, dxDateRanges, cxDataControllerConditionalFormattingRulesManagerDialog, cxDBData, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid, dxLayoutLookAndFeels, cxEditRepositoryItems,
  cxDBExtLookupComboBox, cxImageList, cxExtEditRepositoryItems, cxCheckBox, dxScrollbarAnnotations,
  dxCore, cxLookAndFeels, dxSkinsForm,

  amLocalization.Application.API,
  amLocalization.Settings,
  amLocalization.Model;

// -----------------------------------------------------------------------------
//
// TDataModuleMain
//
// -----------------------------------------------------------------------------
type
  TDataModuleMain = class(TDataModule,
      ITranslationManagerApplicationSubscriber
    )
    DataSetLanguages: TFDMemTable;
    DataSetLanguagesLocaleID: TWordField;
    DataSetLanguagesLocaleName: TStringField;
    DataSetLanguagesLanguageName: TStringField;
    DataSetLanguagesCountryName: TStringField;
    DataSourceLanguages: TDataSource;
    GridViewRepository: TcxGridViewRepository;
    GridTableViewLanguages: TcxGridDBTableView;
    GridTableViewLanguagesColumnLocaleID: TcxGridDBColumn;
    GridTableViewLanguagesColumnLocaleName: TcxGridDBColumn;
    GridTableViewLanguagesColumnLanguage: TcxGridDBColumn;
    GridTableViewLanguagesColumnCountry: TcxGridDBColumn;
    GridTableViewFilteredTargetLanguages: TcxGridDBTableView;
    GridTableViewFilteredTargetLanguagesLocaleID: TcxGridDBColumn;
    GridTableViewFilteredTargetLanguagesLocaleName: TcxGridDBColumn;
    GridTableViewFilteredTargetLanguagesLanguage: TcxGridDBColumn;
    GridTableViewFilteredTargetLanguagesCountry: TcxGridDBColumn;
    GridTableViewFilteredApplicationLanguages: TcxGridDBTableView;
    GridTableViewFilteredApplicationLanguagesLocaleID: TcxGridDBColumn;
    GridTableViewFilteredApplicationLanguagesLocaleName: TcxGridDBColumn;
    GridTableViewFilteredApplicationLanguagesLanguage: TcxGridDBColumn;
    GridTableViewFilteredApplicationLanguagesCountry: TcxGridDBColumn;
    LayoutLookAndFeelList: TdxLayoutLookAndFeelList;
    LayoutSkinLookAndFeel: TdxLayoutSkinLookAndFeel;
    LayoutSkinLookAndFeelHeader: TdxLayoutSkinLookAndFeel;
    LayoutSkinLookAndFeelSettings: TdxLayoutSkinLookAndFeel;
    LayoutSkinLookAndFeelURL: TdxLayoutSkinLookAndFeel;
    LayoutSkinLookAndFeelTitle: TdxLayoutSkinLookAndFeel;
    LayoutSkinLookAndFeelTight: TdxLayoutSkinLookAndFeel;
    EditRepository: TcxEditRepository;
    EditRepositoryTextItem: TcxEditRepositoryButtonItem;
    EditRepositoryComboBoxItemLanguage: TcxEditRepositoryExtLookupComboBoxItem;
    EditRepositoryComboBoxItemFilteredTargetLanguage: TcxEditRepositoryExtLookupComboBoxItem;
    EditRepositoryComboBoxItemFilteredApplicationLanguage: TcxEditRepositoryExtLookupComboBoxItem;
    ImageListTree: TcxImageList;
    ImageListState: TcxImageList;
    ImageListSmall: TcxImageList;
    ImageListLarge: TcxImageList;
    StyleRepository: TcxStyleRepository;
    StyleDefault: TcxStyle;
    StyleComplete: TcxStyle;
    StyleNeedTranslation: TcxStyle;
    StyleDontTranslate: TcxStyle;
    StyleHold: TcxStyle;
    StyleSelected: TcxStyle;
    StyleFocused: TcxStyle;
    StyleSelectedInactive: TcxStyle;
    StyleProposed: TcxStyle;
    EditRepositoryCheckComboBoxNormalization: TcxEditRepositoryCheckComboBox;
    StyleDisabled: TcxStyle;
    StyleNeedAction: TcxStyle;
    EditRepositoryComboBoxItemStatus: TcxEditRepositoryImageComboBoxItem;
    EditRepositoryComboBoxItemState: TcxEditRepositoryImageComboBoxItem;
    StyleSynthesized: TcxStyle;
    SkinController: TdxSkinController;
    LookAndFeelControllerMain: TcxLookAndFeelController;
    LayoutSkinLookAndFeelNoPadding: TdxLayoutSkinLookAndFeel;
    StyleOdd: TcxStyle;
    StyleEven: TcxStyle;
    StyleSkinDefault: TcxStyle;
    StyleSkinSelected: TcxStyle;
    StyleSkinSelectedInactive: TcxStyle;
    procedure DataModuleCreate(Sender: TObject);
    procedure GridTableViewTargetLanguagesDataControllerFilterRecord(ADataController: TcxCustomDataController;
      ARecordIndex: Integer; var Accept: Boolean);
    procedure EditRepositoryTextItemPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure GridTableViewFilteredApplicationLanguagesDataControllerFilterRecord(ADataController: TcxCustomDataController;
      ARecordIndex: Integer; var Accept: Boolean);
  strict private
    FHasInitialized: boolean;
    class var FInstance: TDataModuleMain;
  private
    class function Instance: TDataModuleMain;
    class constructor Create;
    class destructor Destroy;
    procedure Initialize;
  private
    FFilterTargetLanguages: boolean;
    FProject: TLocalizerProject;
  private
    // Skin/Color scheme
    procedure ApplySkinSettings;
    function GetSkinName: string;
    function GetColorScheme: string;
    function GetCustomSkinName: string;
    function GetCustomColorScheme: string;
    procedure SetCustomColorScheme(const Value: string);
    function GetColorTheme: TColorTheme;
    procedure SetColorTheme(const Value: TColorTheme);

    // Styles
    procedure ApplyColors;
  protected
    // ITranslationManagerApplicationSubscriber
    procedure TranslationManagerApplicationNotification(Notification: TTranslationManagerApplicationNotification);
  public
    destructor Destroy; override;

    property FilterTargetLanguages: boolean read FFilterTargetLanguages write FFilterTargetLanguages;
    property Project: TLocalizerProject read FProject write FProject;

    function GetImageIndex(Prop: TLocalizerProperty; TranslationLanguage: TTranslationLanguage): integer;
    function GetImageHint(ImageIndex: integer): string;

    function GetContentStyle(Active, Focused, Selected, Editing: boolean; TranslationLanguage: TTranslationLanguage; Prop: TLocalizerProperty; var AStyle: TcxStyle): boolean;

    procedure FontSizeChanged(Size: Integer);

    // Skin & Color scheme
    property ColorTheme: TColorTheme read GetColorTheme write SetColorTheme;
    property SkinName: string read GetSkinName;
    property ColorScheme: string read GetColorScheme;
    procedure SetCustomSkinName(const Value: string);
    property CustomSkinName: string read GetCustomSkinName write SetCustomSkinName;
    property CustomColorScheme: string read GetCustomColorScheme write SetCustomColorScheme;
  end;

function DataModuleMain: TDataModuleMain;

// -----------------------------------------------------------------------------
//
// Image List Indices
//
// -----------------------------------------------------------------------------
const
  ImageIndexEmpty               = 87;
  ImageIndexAbout               = 57;
  ImageIndexInfo                = 58;
  ImageIndexBookmark0           = 27;
  ImageIndexBookmarkA           = 37;
  ImageIndexModified            = 44;
  ImageIndexNotModified         = -1;
  ImageIndexWarning             = 84;

const
  NodeImageIndexStateWarning    = 0;

const
  NodeImageIndexNew             = 0;
  NodeImageIndexUnused          = 1;
  NodeImageIndexDontTranslate   = 2;
  NodeImageIndexProposed        = 3;
  NodeImageIndexTranslated      = 4;
  NodeImageIndexHold            = 5;
  NodeImageIndexNotTranslated   = 6;
  NodeImageIndexObsolete        = 7;
  NodeImageIndexComplete25      = 8;
  NodeImageIndexComplete50      = 9;
  NodeImageIndexComplete75      = 10;

// And hints corresponding to the above images
resourcestring
  sNodeImageHintNew = 'Not translated. Added by last refresh';
  sNodeImageHintUnused = 'No longer in use';
  sNodeImageHintDontTranslate = 'Should not be translated';
  sNodeImageHintProposed = 'Translation has been proposed';
  sNodeImageHintTranslated = 'Has been translated';
  sNodeImageHintHold = 'Placed on hold';
  sNodeImageHintNotTranslated = 'Not translated';
  sNodeImageHintObsolete = 'Source value has changed since translation';
  sNodeImageHintComplete25 = 'Approximately 25% has been translated';
  sNodeImageHintComplete50 = 'Approximately 50% has been translated';
  sNodeImageHintComplete75 = 'Approximately 75% has been translated';

const
  DefaultColorTheme: TColorTheme = ctLight;
  DefaultSkinNames: array[ctLight..ctDark] of string = ('Basic', 'TheBezier');
  DefaultSkinPaletteNames: array[ctLight..ctDark] of string = ('Default', 'Ghost Shark');


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  IOUtils,
  Windows,
  UITypes,
  Graphics,
  GraphUtil,
  Forms,
  dxSkinsCore,
  cxButtonEdit,
  cxLookAndFeelPainters,
  amLanguageInfo,
  amLocalization.Utils,
  amLocalization.Dialog.TextEdit;

function DataModuleMain: TDataModuleMain;
begin
  Result := TDataModuleMain.Instance;
end;

class constructor TDataModuleMain.Create;
begin
  TDataModuleMain.FInstance := TDataModuleMain.Create(Application);
end;

class destructor TDataModuleMain.Destroy;
begin
  FreeAndNil(TDataModuleMain.FInstance);
end;

class function TDataModuleMain.Instance: TDataModuleMain;
begin
  Result := FInstance;
  Result.Initialize;
end;

destructor TDataModuleMain.Destroy;
begin
  FInstance := nil;
  inherited;
end;

procedure TDataModuleMain.Initialize;
begin
  if (FInstance.FHasInitialized) then
    exit;

  FHasInitialized := True;

  TranslationManagerApplication.Subscribe(Self);
  ApplySkinSettings;
  ApplyColors;
end;

type
  TcxCustomGridViewCracker = class(TcxCustomGridView);

procedure TDataModuleMain.DataModuleCreate(Sender: TObject);
begin
  // Clone
  TcxCustomGridViewCracker(GridTableViewFilteredTargetLanguages).AssignPattern(GridTableViewLanguages);

  // Restore filter event handler
  GridTableViewFilteredTargetLanguages.DataController.OnFilterRecord := GridTableViewTargetLanguagesDataControllerFilterRecord;

  FFilterTargetLanguages := True;

  DataSetLanguages.CreateDataSet;
  DataSetLanguages.DisableControls;
  try
    for var LanguageItem in LanguageInfo do
    begin
      DataSetLanguages.Append;
      try
        if (not LanguageItem.IsCustomLocale) then
          DataSetLanguagesLocaleID.Value := LanguageItem.LocaleID;
        DataSetLanguagesLocaleName.AsString := LanguageItem.LocaleName;
        DataSetLanguagesLanguageName.AsString := LanguageItem.DisplayName;
        DataSetLanguagesCountryName.AsString := LanguageItem.CountryName;

        DataSetLanguages.Post;
      except
        DataSetLanguages.Cancel;
        raise;
      end;
    end;
  finally
    DataSetLanguages.EnableControls;
  end;

  LayoutSkinLookAndFeelTitle.ItemOptions.CaptionOptions.Font.Assign(Application.DefaultFont);
  LayoutSkinLookAndFeelTitle.ItemOptions.CaptionOptions.Font.Style := [fsBold];
  LayoutSkinLookAndFeelURL.ItemOptions.CaptionOptions.Font.Assign(LayoutSkinLookAndFeelTitle.ItemOptions.CaptionOptions.Font);

  // Ensure that all styles use the default font and that only Font.Style is applied.
  // By default the styles use Tahoma for some reason...
  for var i := 0 to ComponentCount-1 do
    if (Components[i] is TcxStyleRepository) then
    begin
      var StyleRepository := TcxStyleRepository(Components[i]);

      for var j := 0 to StyleRepository.Count-1 do
      begin
        var Style := TcxStyle(StyleRepository.Items[j]);
        var FontStyle := Style.Font.Style;

        Style.Font.Assign(Application.DefaultFont);
        Style.Font.Style := FontStyle;
      end;
  end;

  // Ensure that we only change the font color, size or style.
  for var i := 0 to LayoutLookAndFeelList.Count-1 do
    if (not TdxCustomLayoutLookAndFeel(LayoutLookAndFeelList.Items[i]).ItemOptions.CaptionOptions.UseDefaultFont) then
      TdxCustomLayoutLookAndFeel(LayoutLookAndFeelList.Items[i]).ItemOptions.CaptionOptions.Font.Name := Application.DefaultFont.Name;
end;

procedure TDataModuleMain.FontSizeChanged(Size: Integer);
begin
  // TODO : Does not appear to be necessary anymore
  for var i := 0 to StyleRepository.Count-1 do
    if (TcxStyleValue.svFont in TcxStyle(StyleRepository.Items[i]).AssignedValues) then
      TcxStyle(StyleRepository.Items[i]).Font.Size := Size;
end;

type
  TcxCustomEditCracker = class(TcxCustomEdit);

procedure TDataModuleMain.EditRepositoryTextItemPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  TextEditor: TFormTextEditor;
begin
  TextEditor := TFormTextEditor.Create(nil);
  try
//    TextEditor.SourceText := FocusedProperty.Value;
    TextEditor.Text := TcxButtonEdit(Sender).EditingText;
    if (TcxButtonEdit(Sender).Tag <> 0) then
      TextEditor.TargetLanguage := TLanguageItem(TcxButtonEdit(Sender).Tag);

    if (TextEditor.Execute(False)) then
    begin
      // Write new value back to inner edit control. The OnChange event will occur as normally when the user exits the cell.
      TcxCustomEditCracker(Sender).InnerEdit.EditValue := TextEditor.Text;
      TcxCustomEdit(Sender).ModifiedAfterEnter := True;
    end;
  finally
    TextEditor.Free;
  end;
end;

function TDataModuleMain.GetContentStyle(Active, Focused, Selected, Editing: boolean; TranslationLanguage: TTranslationLanguage; Prop: TLocalizerProperty; var AStyle: TcxStyle): boolean;
var
  Translation: TLocalizerTranslation;
begin
  Result := True;

  if (Selected) and (not Active) then
  begin
    AStyle := StyleSelectedInactive;
    Exit;
  end else
  if (Selected) and (not Focused) then
  begin
    AStyle := StyleSelected;
    Exit;
  end else
  if (Active) and (Focused) and (not Editing) then
  begin
    AStyle := StyleFocused;
    Exit;
  end;

  if (Prop <> nil) then
  begin
    if (Prop.IsUnused) or (Prop.EffectiveStatus = ItemStatusDontTranslate) then
    begin
      AStyle := StyleDontTranslate;
      Exit;
    end;

    if (Prop.EffectiveStatus = ItemStatusHold) then
    begin
      AStyle := StyleHold;
      Exit;
    end;

    if (not Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
      Translation := nil;

    if (Translation <> nil) and (Translation.IsTranslated) then
    begin
      if (Translation.Status = TTranslationStatus.tStatusProposed) then
        AStyle := StyleProposed
      else
        AStyle := StyleComplete;
    end else
    if (Prop.Synthesized) then
    begin
      AStyle := StyleSynthesized;
      Exit;
    end else
      AStyle := StyleNeedTranslation;
  end else
    Result := False;
end;

function TDataModuleMain.GetImageHint(ImageIndex: integer): string;
begin
  case ImageIndex of
    NodeImageIndexNew:          Result := sNodeImageHintNew;
    NodeImageIndexUnused:       Result := sNodeImageHintUnused;
    NodeImageIndexDontTranslate:Result := sNodeImageHintDontTranslate;
    NodeImageIndexProposed:     Result := sNodeImageHintProposed;
    NodeImageIndexTranslated:   Result := sNodeImageHintTranslated;
    NodeImageIndexHold:         Result := sNodeImageHintHold;
    NodeImageIndexNotTranslated:Result := sNodeImageHintNotTranslated;
    NodeImageIndexObsolete:     Result := sNodeImageHintObsolete;
    NodeImageIndexComplete25:   Result := sNodeImageHintComplete25;
    NodeImageIndexComplete50:   Result := sNodeImageHintComplete50;
    NodeImageIndexComplete75:   Result := sNodeImageHintComplete75;
  else
    Result := '';
  end;
end;

function TDataModuleMain.GetImageIndex(Prop: TLocalizerProperty; TranslationLanguage: TTranslationLanguage): integer;
var
  Translation: TLocalizerTranslation;
begin
  Result := -1;

  if (Prop = nil) or (not TranslationManagerSettings.Editor.DisplayStatusGlyphs) then
    Exit;

  if (not Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
    Translation := nil;

  // Note: Image indicates effective status

  if (Prop.IsUnused) then
    Result := NodeImageIndexUnused
  else
  if (ItemStateNew in Prop.State) and (Prop.EffectiveStatus = ItemStatusTranslate) and (Translation = nil) then
    Result := NodeImageIndexNew
  else
  if (Prop.EffectiveStatus = ItemStatusDontTranslate) then
    Result := NodeImageIndexDontTranslate
  else
  if (Prop.EffectiveStatus = ItemStatusHold) then
    Result := NodeImageIndexHold
  else
  if (Translation <> nil) and (Translation.Status <> tStatusPending) then
  begin
    if (Translation.Status = tStatusProposed) then
      Result := NodeImageIndexProposed
    else
    if (Translation.Status = tStatusTranslated) then
      Result := NodeImageIndexTranslated
    else
    if (Translation.Status = tStatusObsolete) then
      Result := NodeImageIndexObsolete
    else
      Result := -1; // Should never happen
  end else
    Result := NodeImageIndexNotTranslated;
end;

procedure TDataModuleMain.GridTableViewFilteredApplicationLanguagesDataControllerFilterRecord(
  ADataController: TcxCustomDataController; ARecordIndex: Integer; var Accept: Boolean);
begin
  var Language := LanguageInfo.FindLocaleName(ADataController.Values[ARecordIndex, GridTableViewFilteredApplicationLanguagesLocaleName.Index]);

  if (Language = nil) then
  begin
    Accept := False;
    Exit;
  end;

  // Native application language is en-US
  if (Language <> nil) and (Language.LocaleID = MakeLangID(LANG_ENGLISH, SUBLANG_ENGLISH_US)) then //  $00000409
  begin
    Accept := True;
    Exit;
  end;

  // Accept row if resource module exist with any of the supported file names.
  for var ModuleNameScheme := Low(TModuleNameScheme) to High(TModuleNameScheme) do
  begin
    var Filename := LocalizationTools.BuildModuleFilename(ParamStr(0), Language, ModuleNameScheme);

    if (TFile.Exists(Filename)) then
    begin
      Accept := True;
      Exit;
    end;
  end;
  Accept := False;
end;

procedure TDataModuleMain.GridTableViewTargetLanguagesDataControllerFilterRecord(ADataController: TcxCustomDataController;
  ARecordIndex: Integer; var Accept: Boolean);
begin
  if (not FFilterTargetLanguages) or (FProject = nil) then
    Exit;

  var Language := LanguageInfo.FindLocaleName(ADataController.Values[ARecordIndex, GridTableViewFilteredTargetLanguagesLocaleName.Index]);
  Accept := (Language <> nil) and (FProject.TranslationLanguages.Contains(Language));
end;

procedure TDataModuleMain.ApplyColors;
var
  DefaultTextColorLuminance: integer;
  DefaultBrushColorLuminance: integer;

  function Luminance(Color: TColor): integer;
  // Rec. 709
  const
    LuminanceMultR = 54;
    LuminanceMultG = 184;
    LuminanceMultB = 18;
  begin
    Result := (TColorRec(Color).R * LuminanceMultR + TColorRec(Color).G * LuminanceMultG + TColorRec(Color).B * LuminanceMultB) shr 8;
  end;

  procedure CheckBrushColorContrast(Style: TcxStyle);
  begin
    // Calculate a suitable text color if contrast between our brush color
    // and the default text color is poor
    var BrushLuminance := Luminance(Style.Color);
    if (Abs(BrushLuminance - DefaultTextColorLuminance) < 127) then
    begin
      // Contrast is too poor. Use a text color with better contrast.
      if (Abs(BrushLuminance - DefaultBrushColorLuminance) >= 127) then
        // Use default brush color if we can so we use a color in the color scheme
        Style.TextColor := RootLookAndFeel.Painter.GridLikeControlContentColor
      else
      if (BrushLuminance >= 128) then
        Style.TextColor := clBlack
      else
        Style.TextColor := clWhite;
    end;
  end;

  procedure CheckTextColorContrast(Style: TcxStyle);
  begin
    // Calculate a suitable brush color if contrast between our text color
    // and the default brush color is poor
    var TextLuminance := Luminance(Style.TextColor);
    if (Abs(TextLuminance - DefaultBrushColorLuminance) < 127) then
    begin
      // Contrast is too poor. Use a brush color with better contrast.
      if (Abs(TextLuminance - DefaultTextColorLuminance) >= 127) then
        // Use default text color if we can so we use a color in the color scheme
        Style.Color := RootLookAndFeel.Painter.GridLikeControlContentTextColor
      else
      if (TextLuminance >= 128) then
        Style.Color := clBlack
      else
        Style.Color := clWhite;
    end;
  end;

  procedure ApplyListStyle(AListStyle: TListStyle; Style: TcxStyle);
  var
    ListStyle: TTranslationManagerListStyleSettings;
  begin
    ListStyle := TranslationManagerSettings.Editor.Style[AListStyle];

    if (ListStyle.ColorBackground <> clDefault) then
      Style.Color := ListStyle.ColorBackground
    else
    if (TranslationManagerSettings.Editor.Style[ListStyleDefault].ColorBackground <> clDefault) then
      Style.Color := TranslationManagerSettings.Editor.Style[ListStyleDefault].ColorBackground
    else
      Style.Color := RootLookAndFeel.Painter.GridLikeControlContentColor;

    if (ListStyle.ColorText <> clDefault) then
      Style.TextColor := ListStyle.ColorText
    else
    if (TranslationManagerSettings.Editor.Style[ListStyleDefault].ColorText <> clDefault) then
      Style.TextColor := TranslationManagerSettings.Editor.Style[ListStyleDefault].ColorText
    else
      Style.TextColor := RootLookAndFeel.Painter.GridLikeControlContentTextColor;

    if (ListStyle.Bold <> -1) then
    begin
      if (ListStyle.Bold = 1) then
        Style.Font.Style := Style.Font.Style + [fsBold]
      else
        Style.Font.Style := Style.Font.Style - [fsBold];
    end else
    if (TranslationManagerSettings.Editor.Style[ListStyleDefault].Bold = 1) then
      Style.Font.Style := Style.Font.Style + [fsBold]
    else
      Style.Font.Style := Style.Font.Style - [fsBold];

    CheckBrushColorContrast(Style);
  end;

  procedure CheckSelectionStyle;
  begin
    // Ensure that Inactive Selection style is slightly darker than Active Selection.
    // Additionally the default Inactive Selection color is too similar to the content
    // color for most skins.

    var SelectedColor: TColor;
    if (TcxStyleValue.svColor in StyleSelected.AssignedValues) then
      SelectedColor := StyleSelected.Color
    else
      SelectedColor := RootLookAndFeel.Painter.DefaultSelectionColor;

    var SelectedLuminance := Luminance(SelectedColor);
    var InactiveLuminance := Luminance(RootLookAndFeel.Painter.DefaultInactiveColor);

    if (Abs(SelectedLuminance - DefaultBrushColorLuminance) < 40) or
      (Abs(SelectedLuminance - InactiveLuminance) < 40) or
      (Abs(InactiveLuminance - Luminance(RootLookAndFeel.Painter.DefaultContentEvenColor)) < 40) or
      (Abs(InactiveLuminance - Luminance(RootLookAndFeel.Painter.DefaultContentOddColor)) < 40) then
      StyleSelectedInactive.Color := GetShadowColor(SelectedColor, -40)
    else
      StyleSelectedInactive.AssignedValues := [];
  end;

begin
(*
  // Hyperlink style. Used for link labels.
  // Hot style is lighter and underlined.
  StyleControllerURL.Style.TextColor := RootLookAndFeel.Painter.DefaultHyperlinkTextColor;
  StyleControllerURL.StyleHot.TextColor := GetHighLightColor(StyleControllerURL.Style.TextColor);
*)

  // StyleSkin* are skins colors that have not been modified in any way.
  // For use in OnGet*Style event handlers
  StyleSkinDefault.Color := RootLookAndFeel.Painter.GridLikeControlContentColor;
  StyleSkinDefault.TextColor := RootLookAndFeel.Painter.GridLikeControlContentTextColor;
  StyleSkinSelected.Color := RootLookAndFeel.Painter.DefaultSelectionColor;
  StyleSkinSelected.TextColor := RootLookAndFeel.Painter.DefaultSelectionTextColor;
  StyleSkinSelectedInactive.Color := RootLookAndFeel.Painter.DefaultInactiveColor;
  StyleSkinSelectedInactive.TextColor := RootLookAndFeel.Painter.DefaultInactiveTextColor;

  // Default odd/even colors as a style for use in OnGetContentStyle event handlers
  StyleOdd.Color := RootLookAndFeel.Painter.GridLikeControlContentOddColor;
  StyleEven.Color := RootLookAndFeel.Painter.GridLikeControlContentEvenColor;

  // Default colors which will have user customization applied
  StyleDefault.Color := RootLookAndFeel.Painter.GridLikeControlContentColor;
  StyleDefault.TextColor := RootLookAndFeel.Painter.GridLikeControlContentTextColor;

  DefaultTextColorLuminance := Luminance(RootLookAndFeel.Painter.GridLikeControlContentTextColor);
  DefaultBrushColorLuminance := Luminance(RootLookAndFeel.Painter.GridLikeControlContentColor);

  ApplyListStyle(ListStyleDefault, DataModuleMain.StyleDefault);
  ApplyListStyle(ListStyleSelected, DataModuleMain.StyleSelected);
  ApplyListStyle(ListStyleInactive, DataModuleMain.StyleSelectedInactive);
  ApplyListStyle(ListStyleFocused, DataModuleMain.StyleFocused);
  ApplyListStyle(ListStyleNotTranslated, DataModuleMain.StyleNeedTranslation);
  ApplyListStyle(ListStyleProposed, DataModuleMain.StyleProposed);
  ApplyListStyle(ListStyleTranslated, DataModuleMain.StyleComplete);
  ApplyListStyle(ListStyleHold, DataModuleMain.StyleHold);
  ApplyListStyle(ListStyleDontTranslate, DataModuleMain.StyleDontTranslate);
  ApplyListStyle(ListStyleSynthesized, DataModuleMain.StyleSynthesized);

  CheckSelectionStyle;

  // Ensure that all colors which only have one of Color or TextColor assigned
  // will have good contrast against the default text/background color.
  // Note: If a style is changed because of this it will not be changed again
  // at a later check because by then it will have both Color and TextColor
  // assigned. Since we will maintain good contrast regardless this
  // doesn't really matter much.
  for var i := 0 to ComponentCount-1 do
    if (Components[i] is TcxStyleRepository) then
    begin
      var StyleRepository := TcxStyleRepository(Components[i]);

      for var j := 0 to StyleRepository.Count-1 do
      begin
        var Style := TcxStyle(StyleRepository.Items[j]);

        if (Style.AssignedValues * [TcxStyleValue.svColor, TcxStyleValue.svTextColor] = [TcxStyleValue.svTextColor]) then
          CheckTextColorContrast(Style)
        else
        if (Style.AssignedValues * [TcxStyleValue.svColor, TcxStyleValue.svTextColor] = [TcxStyleValue.svColor]) then
          CheckBrushColorContrast(Style);
      end;
    end;
end;

procedure TDataModuleMain.ApplySkinSettings;

  function DetectRemoteSession: boolean;
  const
    SM_REMOTECONTROL      = $2001; // This system metric is used in a Terminal
                                   // Services environment. Its value is nonzero
                                   // if the current session is remotely
                                   // controlled; otherwise, 0.

    SM_REMOTESESSION      = $1000; // This system metric is used in a Terminal
                                   // Services environment. If the calling process
                                   // is associated with a Terminal Services
                                   // client session, the return value is nonzero.
                                   // If the calling process is associated with
                                   // the Terminal Server console session, the
                                   // return value is 0. The console session is
                                   // not necessarily the physical console.
  var
    Mode: string;
  begin
    Result := (GetSystemMetrics(SM_REMOTESESSION) <> 0) or (GetSystemMetrics(SM_REMOTECONTROL) <> 0);

    // Test for emulated local/remote mode
    if (FindCmdLineSwitch('Session', Mode, True)) then
    begin
      if (SameText(Mode, 'Remote')) then
        Result := True
      else
      if (SameText(Mode, 'Local')) then
        Result := False;
    end;
  end;

begin
  // In safe mode we just store the skin values, but doesn't act on them.
  // This enables the user to modify the skin setting without any immediate consequences.
  if (TranslationManagerSettings.System.SafeMode) then
    exit;

  // Apply configured skin
  var SkinName := GetSkinName;
  var SkinPaletteName := GetColorScheme;

  // Fall back in case configured skin doesn't exist
  if (cxLookAndFeelPaintersManager.GetPainter(SkinName) = nil) then
  begin
    SkinName := DefaultSkinNames[DefaultColorTheme];
    SkinPaletteName := DefaultSkinPaletteNames[DefaultColorTheme];
  end;

  // With DevExpress 25.2.x It has become impossible to change the skin properties inside BeginUpdate..EndUpdate
  // SkinController.BeginUpdate;
  try
    SkinController.SkinName := SkinName;
    SkinController.UseSkins := (SkinName <> ''); // Causes splash to flicker if skinned
    LookAndFeelControllerMain.SkinName := SkinController.SkinName;
    if (SkinPaletteName <> '') then
      SkinController.SkinPaletteName := SkinPaletteName;

    // Switch to Alternate skin mode (use Fills instead of BitBlts) if remote session
    if (DetectRemoteSession) then
      SkinController.UseImageSet := imsAlternate;

  finally
    // SkinController.EndUpdate;
  end;
end;

function TDataModuleMain.GetColorScheme: string;
begin
  if (TranslationManagerSettings.System.ColorTheme <> ctCustom) then
    Result := DefaultSkinPaletteNames[TranslationManagerSettings.System.ColorTheme]
  else
    Result := GetCustomColorScheme;
end;

function TDataModuleMain.GetColorTheme: TColorTheme;
begin
  Result := TranslationManagerSettings.System.ColorTheme;
end;

function TDataModuleMain.GetCustomColorScheme: string;
begin
  Result := TranslationManagerSettings.System.ColorScheme;
  if (Result = '') then
    Result  := DefaultSkinPaletteNames[DefaultColorTheme];
end;

function TDataModuleMain.GetCustomSkinName: string;
begin
  Result := TranslationManagerSettings.System.Skin;
  if (Result = '') then
    Result  := DefaultSkinNames[DefaultColorTheme];
end;

function TDataModuleMain.GetSkinName: string;
begin
  if (TranslationManagerSettings.System.ColorTheme <> ctCustom) then
    Result := DefaultSkinNames[TranslationManagerSettings.System.ColorTheme]
  else
    Result := GetCustomSkinName;
end;

procedure TDataModuleMain.SetColorTheme(const Value: TColorTheme);
begin
  TranslationManagerSettings.System.ColorTheme := Value;
end;

procedure TDataModuleMain.SetCustomColorScheme(const Value: string);
begin
  if (not AnsiSameText(TranslationManagerSettings.System.ColorScheme, Value)) then
    TranslationManagerSettings.System.ColorScheme := Value;
end;

procedure TDataModuleMain.SetCustomSkinName(const Value: string);
begin
  if (not AnsiSameText(TranslationManagerSettings.System.Skin, Value)) then
    TranslationManagerSettings.System.Skin := Value;
end;

procedure TDataModuleMain.TranslationManagerApplicationNotification(
  Notification: TTranslationManagerApplicationNotification);
begin
  case Notification of
    tmaSettingsChanged:
      begin
        ApplySkinSettings;
        ApplyColors;
      end;

    tmaShutdown:
      TranslationManagerApplication.Unsubscribe(Self);
  end;
end;

end.
