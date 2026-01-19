unit amLocalization.Dialog.Settings;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.ExtCtrls, Vcl.ComCtrls,

  dxSkinsCore, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxLayoutContainer,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxLabel, cxButtonEdit, cxCheckBox, cxMemo, cxImage,
  cxImageList, cxGridCustomPopupMenu, cxGridPopupMenu, dxLayoutLookAndFeels, cxClasses,
  dxGDIPlusClasses, cxGridViewLayoutContainer,
  cxGridLayoutView, cxGridCustomLayoutView, cxTextEdit, cxListView, cxCheckComboBox, cxSpinEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridCustomView, cxGrid, cxDropDownEdit, Vcl.StdCtrls, cxButtons, cxMaskEdit, cxImageComboBox, dxLayoutControl,
  cxPC, dxColorEdit, cxLookupEdit, cxDBLookupEdit, cxDBExtLookupComboBox, dxColorDialog, dxScrollbarAnnotations, dxCoreGraphics,

  dxRibbonSkins,
  dxSpellChecker,

  amLocalization.Settings,
  amLocalization.Provider.Ollama.API,
  amLocalization.Provider.Gemini.API,
  amLocalization.Dialog,
  amLocalization.Dialog.Settings.API;

type
  // TcxButton interposer
  // Do not draw dropdown arrow for an Office Button.
  TcxButton = class(cxButtons.TcxButton)
  protected
    function CreateViewInfo: TcxButtonViewInfo; override;
  public
    procedure Click; override;
  end;

type
  TFormSettings = class(TFormDialog, IDialogSettings, ITranslationProviderSettingsOllama, ITranslationProviderSettingsGemini)
    ActionFoldersModify: TAction;
    ActionFolderReset: TAction;
    ActionFoldersExplorer: TAction;
    ActionFolderResetAll: TAction;
    ActionProofingAdd: TAction;
    ActionProofingReplace: TAction;
    ActionProofingDelete: TAction;
    ImageListSkin: TcxImageList;
    ImageListSkinLarge: TcxImageList;
    CheckBoxEditUseProposed: TcxCheckBox;
    CheckBoxAtstart: TcxCheckBox;
    ImageComboBoxSkin: TcxImageComboBox;
    ButtonDialogsSuppressReset: TcxButton;
    LayoutControlGeneralItem2: TdxLayoutItem;
    LayoutGroupEditing: TdxLayoutGroup;
    LayoutControlGeneralItem12: TdxLayoutItem;
    LayoutGroupStartup: TdxLayoutGroup;
    LayoutItemUserInterfaceSkin: TdxLayoutItem;
    LayoutGroupUserInterfaceTheme: TdxLayoutGroup;
    LayoutControlGeneralItem11: TdxLayoutItem;
    CheckBoxProofingIgnoreNumbers: TcxCheckBox;
    CheckBoxProofingIgnoreRepeatWords: TcxCheckBox;
    ComboBoxProofingLanguages: TcxCheckComboBox;
    ButtonProofingEditCustomDictionary: TcxButton;
    CheckBoxProofingSpellCheck: TcxCheckBox;
    CheckBoxProofingIgnoreUppercase: TcxCheckBox;
    CheckBoxProofingIgnoreMixedCase: TcxCheckBox;
    CheckBoxProofingCorrectSentenceCaps: TcxCheckBox;
    CheckBoxProofingCorrectCapsLock: TcxCheckBox;
    CheckBoxProofingDisableCapsLock: TcxCheckBox;
    CheckBoxProofingCorrectAutoReplace: TcxCheckBox;
    ListViewProofingAutoCorrectReplacements: TcxListView;
    ButtonProofingAutoCorrectAdd: TcxButton;
    ButtonProofingAutoCorrectDelete: TcxButton;
    CheckBoxProofingCorrectAutomaticallyUseSuggestions: TcxCheckBox;
    EditProofingAutoCorrectReplacementFrom: TcxTextEdit;
    EditProofingAutoCorrectReplacementTo: TcxTextEdit;
    CheckBoxProofingAutoCorrect: TcxCheckBox;
    ButtonProofingAutoCorrectExceptions: TcxButton;
    CheckBoxProofingCorrectInitialCaps: TcxCheckBox;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutGroup4: TdxLayoutGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    dxLayoutItem8: TdxLayoutItem;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem11: TdxLayoutItem;
    dxLayoutItem13: TdxLayoutItem;
    dxLayoutItem14: TdxLayoutItem;
    dxLayoutItem10: TdxLayoutItem;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    dxLayoutItem18: TdxLayoutItem;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutItem19: TdxLayoutItem;
    dxLayoutItem20: TdxLayoutItem;
    dxLayoutItem21: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    EditProofingAutoCorrectReplace: TdxLayoutItem;
    dxLayoutItem17: TdxLayoutItem;
    dxLayoutSeparatorItem2: TdxLayoutSeparatorItem;
    dxLayoutItem22: TdxLayoutItem;
    LayoutGroupProofingAutoCorrect: TdxLayoutGroup;
    dxLayoutItem15: TdxLayoutItem;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    dxLayoutItem12: TdxLayoutItem;
    dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup;
    LabelAutoUpdateIntro: TcxLabel;
    CheckBoxSingleInstance: TcxCheckBox;
    ButtonRegisterFiletypes: TcxButton;
    CheckBoxAutoUpdateEnabled: TcxCheckBox;
    ButtonAutoUpdateNow: TcxButton;
    ButtonAutoUpdateReset: TcxButton;
    LayoutControlAdvancedItem1: TdxLayoutItem;
    LayoutControlAdvancedItem3: TdxLayoutItem;
    LayoutControlAdvancedGroup2: TdxLayoutGroup;
    LayoutControlAdvancedGroup4: TdxLayoutGroup;
    LayoutControlAdvancedItem7: TdxLayoutItem;
    LayoutControlAdvancedItem8: TdxLayoutItem;
    LayoutControlAdvancedGroup5: TdxLayoutGroup;
    LayoutControlAdvancedGroup6: TdxLayoutGroup;
    LayoutControlAdvancedItem9: TdxLayoutItem;
    LayoutControlAdvancedItem10: TdxLayoutItem;
    LayoutControlAdvancedGroup7: TdxLayoutGroup;
    LayoutControlAdvancedGroup9: TdxLayoutGroup;
    PopupMenuFolderReset: TPopupMenu;
    Reset1: TMenuItem;
    Resetall1: TMenuItem;
    StyleRepository: TcxStyleRepository;
    StyleBackground: TcxStyle;
    StyleDisabled: TcxStyle;
    LayoutGroupTranslatorTM: TdxLayoutGroup;
    dxLayoutItem23: TdxLayoutItem;
    CheckBoxTMLoadOnDemand: TcxCheckBox;
    LayoutGroupTranslatorMS: TdxLayoutGroup;
    dxLayoutItem25: TdxLayoutItem;
    EditTranslatorMSAPIKey: TcxButtonEdit;
    ImageList: TcxImageList;
    LayoutItemRestart: TdxLayoutLabeledItem;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutItem32: TdxLayoutItem;
    GridFolders: TcxGrid;
    GridFoldersTableView: TcxGridTableView;
    GridFoldersTableViewColumnName: TcxGridColumn;
    GridFoldersTableViewColumnPath: TcxGridColumn;
    GridFoldersTableViewColumnReadOnly: TcxGridColumn;
    GridFoldersLevel: TcxGridLevel;
    dxLayoutItem33: TdxLayoutItem;
    ButtonFilesReset: TcxButton;
    dxLayoutItem34: TdxLayoutItem;
    ButtonFilesModify: TcxButton;
    dxLayoutGroup12: TdxLayoutGroup;
    dxLayoutGroup13: TdxLayoutGroup;
    dxLayoutItem36: TdxLayoutItem;
    CheckBoxAutoRecovery: TcxCheckBox;
    dxLayoutItem37: TdxLayoutItem;
    EditAutoRecoveryInterval: TcxSpinEdit;
    LayoutGroupRecovery: TdxLayoutGroup;
    dxLayoutItem40: TdxLayoutItem;
    CheckBoxHistoryBackup: TcxCheckBox;
    LayoutGroupBackup: TdxLayoutGroup;
    dxLayoutItem41: TdxLayoutItem;
    EditHistoryBackupMaxFiles: TcxSpinEdit;
    dxLayoutItem42: TdxLayoutItem;
    EditHistoryBackupMaxSize: TcxSpinEdit;
    dxLayoutGroup16: TdxLayoutGroup;
    dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem;
    LayoutGroupResourceModules: TdxLayoutGroup;
    dxLayoutItem27: TdxLayoutItem;
    CheckBoxResourceModulesIncludeVersionInfo: TcxCheckBox;
    dxLayoutItem43: TdxLayoutItem;
    ComboBoxSourceLanguage: TcxExtLookupComboBox;
    dxLayoutItem28: TdxLayoutItem;
    ComboBoxTargetLanguage: TcxExtLookupComboBox;
    dxLayoutItem38: TdxLayoutItem;
    CheckBoxTMBackgroundQuery: TcxCheckBox;
    dxLayoutItem44: TdxLayoutItem;
    CheckBoxTMPromptToSave: TcxCheckBox;
    dxLayoutItem45: TdxLayoutItem;
    CheckBoxSaveBackup: TcxCheckBox;
    dxLayoutGroup18: TdxLayoutGroup;
    GridColorsLevel: TcxGridLevel;
    GridColors: TcxGrid;
    dxLayoutItem49: TdxLayoutItem;
    GridColorsTableView: TcxGridTableView;
    GridColorsTableViewColumnName: TcxGridColumn;
    GridColorsTableViewColumnText: TcxGridColumn;
    GridColorsTableViewColumnBackground: TcxGridColumn;
    GridColorsTableViewColumnSample: TcxGridColumn;
    GridColorsTableViewColumnBold: TcxGridColumn;
    ColorDialog: TdxColorDialog;
    dxLayoutItem50: TdxLayoutItem;
    CheckBoxDisplayStatusGlyphs: TcxCheckBox;
    dxLayoutSeparatorItem5: TdxLayoutSeparatorItem;
    dxLayoutItem51: TdxLayoutItem;
    ButtonStyleReset: TcxButton;
    dxLayoutItem53: TdxLayoutItem;
    CheckBoxStatusGlyphHint: TcxCheckBox;
    ActionEditStatusGlyphs: TAction;
    ActionEditStatusHint: TAction;
    dxLayoutItem54: TdxLayoutItem;
    CheckBoxEditBiDiMode: TcxCheckBox;
    dxLayoutItem57: TdxLayoutItem;
    cxCheckBox1: TcxCheckBox;
    dxLayoutItem58: TdxLayoutItem;
    cxSpinEdit1: TcxSpinEdit;
    dxLayoutItem59: TdxLayoutItem;
    cxSpinEdit2: TcxSpinEdit;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    dxLayoutLabeledItem2: TdxLayoutLabeledItem;
    dxLayoutGroup20: TdxLayoutGroup;
    dxLayoutGroup21: TdxLayoutGroup;
    dxLayoutGroup22: TdxLayoutGroup;
    dxLayoutItem61: TdxLayoutItem;
    CheckBoxProjectAutoApplyStopList: TcxCheckBox;
    LayoutGroupProject: TdxLayoutGroup;
    dxLayoutItem62: TdxLayoutItem;
    ComboBoxModuleNameScheme: TcxImageComboBox;
    dxLayoutItem63: TdxLayoutItem;
    CheckBoxPortable: TcxCheckBox;
    EditProviderTMFilename: TcxButtonEdit;
    dxLayoutItem64: TdxLayoutItem;
    ActionProviderTMFilename: TAction;
    ComboBoxEqualization: TcxCheckComboBox;
    dxLayoutItem65: TdxLayoutItem;
    dxLayoutItem66: TdxLayoutItem;
    ComboBoxNormalization: TcxCheckComboBox;
    EditTranslatorMSAPIRegion: TcxComboBox;
    dxLayoutItem67: TdxLayoutItem;
    ComboBoxAutoApplyTranslations: TcxComboBox;
    dxLayoutItem68: TdxLayoutItem;
    ComboBoxAutoApplyTranslationsSimilar: TcxComboBox;
    dxLayoutItem69: TdxLayoutItem;
    LayoutGroupAutoApplyTranslations: TdxLayoutGroup;
    CheckBoxAutoApplyTranslationsExisting: TcxCheckBox;
    dxLayoutItem55: TdxLayoutItem;
    dxLayoutGroup25: TdxLayoutGroup;
    dxLayoutItem70: TdxLayoutItem;
    CheckBoxFileProjectOmitDontTranslate: TcxCheckBox;
    dxLayoutItem71: TdxLayoutItem;
    CheckBoxFileProjectSort: TcxCheckBox;
    dxLayoutGroup27: TdxLayoutGroup;
    dxLayoutItem73: TdxLayoutItem;
    ComboBoxStringListHandling: TcxComboBox;
    LayoutCheckBoxItemSynthesize: TdxLayoutCheckBoxItem;
    dxLayoutEmptySpaceItem3: TdxLayoutEmptySpaceItem;
    GridSynthesizeLevel: TcxGridLevel;
    GridSynthesize: TcxGrid;
    dxLayoutItem74: TdxLayoutItem;
    LayoutGroupSynthesize: TdxLayoutGroup;
    GridSynthesizeTableView: TcxGridTableView;
    GridSynthesizeTableViewColumnMask: TcxGridColumn;
    GridSynthesizeTableViewColumnName: TcxGridColumn;
    GridSynthesizeTableViewColumnValue: TcxGridColumn;
    ActionColorThemeLight: TAction;
    ActionColorThemeDark: TAction;
    ActionColorThemeCustom: TAction;
    ImageListColorSchemePreview: TcxImageList;
    ImageListColorSchemesLarge: TcxImageList;
    ImageListColorSchemesSmall: TcxImageList;
    LayoutItemUILanguage: TdxLayoutItem;
    ComboBoxApplicationLanguage: TcxExtLookupComboBox;
    dxLayoutItem30: TdxLayoutItem;
    CheckBoxAutoShowMultiLineEditor: TcxCheckBox;
    dxLayoutItem52: TdxLayoutItem;
    CheckBoxFileProjectSaveNewState: TcxCheckBox;
    LayoutGroupCategoryButtons: TdxLayoutGroup;
    LayoutGroupCategoryGeneral: TdxLayoutGroup;
    LayoutGroupCategoryAppearance: TdxLayoutGroup;
    LayoutGroupCategoryProviders: TdxLayoutGroup;
    LayoutGroupCategoryParser: TdxLayoutGroup;
    LayoutGroupCategoryFiles: TdxLayoutGroup;
    LayoutGroupCategoryProofing: TdxLayoutGroup;
    LayoutGroupCategoryAdvanced: TdxLayoutGroup;
    LayoutGroupCategories: TdxLayoutGroup;
    dxLayoutEmptySpaceItem4: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem5: TdxLayoutEmptySpaceItem;
    dxLayoutEmptySpaceItem6: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem7: TdxLayoutEmptySpaceItem;
    dxLayoutEmptySpaceItem8: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem9: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem10: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup;
    dxLayoutItem1: TdxLayoutItem;
    ButtonThemeLight: TcxButton;
    dxLayoutItem9: TdxLayoutItem;
    ButtonThemeDark: TcxButton;
    dxLayoutItem16: TdxLayoutItem;
    ButtonThemeCustom: TcxButton;
    LayoutGroupUserInterfaceLanguage: TdxLayoutGroup;
    LayoutGroupUserInterfaceThemeAdvanced: TdxLayoutGroup;
    dxLayoutEmptySpaceItem11: TdxLayoutEmptySpaceItem;
    dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup;
    dxLayoutItem24: TdxLayoutItem;
    ComboBoxColorScheme: TcxImageComboBox;
    LayoutItemColorSample: TdxLayoutItem;
    PaintBoxColorSample: TPaintBox;
    dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup;
    EditTranslatorDeepLAPIKey: TcxButtonEdit;
    LayoutGroupTranslatorDeepL: TdxLayoutGroup;
    LayoutRadioButtonItemDeepLLicenseFree: TdxLayoutRadioButtonItem;
    LayoutRadioButtonItemDeepLLicensePro: TdxLayoutRadioButtonItem;
    LayoutItemTranslatorDeepLAPIKey: TdxLayoutItem;
    ActionProviderDeepLLicenseFree: TAction;
    ActionProviderDeepLLicensePro: TAction;
    dxLayoutLabeledItem3: TdxLayoutLabeledItem;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutItem26: TdxLayoutItem;
    CheckBoxFileProjectSaveTransient: TcxCheckBox;
    EditOllamaBaseURL: TcxButtonEdit;
    ComboBoxOllamaModel: TcxComboBox;
    EditOllamaTimeout: TcxSpinEdit;
    ButtonOllamaDetectModels: TcxButton;
    ButtonOllamaTest: TcxButton;
    LayoutGroupTranslatorOllama: TdxLayoutGroup;
    LayoutItemOllamaBaseURL: TdxLayoutItem;
    LayoutItemOllamaModel: TdxLayoutItem;
    LayoutItemOllamaTimeout: TdxLayoutItem;
    LayoutItemOllamaDetectModels: TdxLayoutItem;
    LayoutItemOllamaTest: TdxLayoutItem;
    ActionOllamaDetectModels: TAction;
    ActionOllamaTest: TAction;
    dxLayoutSeparatorItem3: TdxLayoutSeparatorItem;
    LayoutGroupOllamaButtons: TdxLayoutGroup;
    LayoutGroupTranslatorGemini: TdxLayoutGroup;
    LayoutItemGeminiAPIKey: TdxLayoutItem;
    EditGeminiAPIKey: TcxButtonEdit;
    LayoutItemGeminiModel: TdxLayoutItem;
    ComboBoxGeminiModel: TcxComboBox;
    LayoutItemGeminiTemperature: TdxLayoutItem;
    EditGeminiTemperature: TcxSpinEdit;
    LayoutItemGeminiTimeout: TdxLayoutItem;
    EditGeminiTimeout: TcxSpinEdit;
    LayoutGroupGeminiButtons: TdxLayoutGroup;
    LayoutItemGeminiDetectModels: TdxLayoutItem;
    ButtonGeminiDetectModels: TcxButton;
    LayoutItemGeminiTest: TdxLayoutItem;
    ButtonGeminiTest: TcxButton;
    ActionGeminiDetectModels: TAction;
    ActionGeminiTest: TAction;
    procedure TextEditTranslatorMSAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure TextEditTranslatorMSAPIKeyPropertiesChange(Sender: TObject);
    procedure ActionCategoryExecute(Sender: TObject);
    procedure ActionCategoryUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonCategoryEnter(Sender: TObject);
    procedure ButtonProofingAutoCorrectExceptionsClick(Sender: TObject);
    procedure ButtonProofingEditCustomDictionaryClick(Sender: TObject);
    procedure CheckBoxProofingAutoCorrectPropertiesChange(Sender: TObject);
    procedure EditProofingAutoCorrectReplacementFromPropertiesChange(Sender: TObject);
    procedure ActionProofingAddExecute(Sender: TObject);
    procedure ActionProofingAddUpdate(Sender: TObject);
    procedure ActionProofingDeleteExecute(Sender: TObject);
    procedure ActionProofingDeleteUpdate(Sender: TObject);
    procedure ListViewProofingAutoCorrectReplacementsClick(Sender: TObject);
    procedure ActionProofingReplaceExecute(Sender: TObject);
    procedure ActionProofingReplaceUpdate(Sender: TObject);
    procedure ActionFolderResetUpdate(Sender: TObject);
    procedure ActionFolderResetExecute(Sender: TObject);
    procedure ActionFolderResetAllExecute(Sender: TObject);
    procedure ActionFoldersExplorerExecute(Sender: TObject);
    procedure ActionFoldersModifyExecute(Sender: TObject);
    procedure ActionFoldersModifyUpdate(Sender: TObject);
    procedure GridFoldersTableViewColumnPathGetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure GridFoldersTableViewColumnPathGetCellHint(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      ACellViewInfo: TcxGridTableDataCellViewInfo; const AMousePos: TPoint; var AHintText: TCaption; var AIsHintMultiLine: Boolean;
      var AHintTextRect: TRect);
    procedure GridFoldersTableViewCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure GridFoldersTableViewColumnPathPropertiesEditValueChanged(Sender: TObject);
    procedure GridFoldersTableViewEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem; var AAllow: Boolean);
    procedure GridFoldersTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure ComboBoxApplicationLanguagePropertiesEditValueChanged(Sender: TObject);
    procedure CheckBoxSingleInstancePropertiesChange(Sender: TObject);
    procedure ButtonRegisterFiletypesClick(Sender: TObject);
    procedure GridColorsTableViewColumnTextCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure GridColorsTableViewColumnBackgroundCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure GridColorsTableViewColumnSampleCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure GridColorsTableViewColumnColorPropertiesInitPopup(Sender: TObject);
    procedure GridColorsTableViewDataControllerAfterPost(ADataController: TcxCustomDataController);
    procedure GridColorsTableViewInitEdit(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
    procedure ButtonStyleResetClick(Sender: TObject);
    procedure ActionDummyExecute(Sender: TObject);
    procedure ActionEditStatusHintUpdate(Sender: TObject);
    procedure CheckBoxPortableClick(Sender: TObject);
    procedure ActionProviderTMFilenameExecute(Sender: TObject);
    procedure ComboBoxAutoApplyTranslationsPropertiesChange(Sender: TObject);
    procedure GridSynthesizeTableViewColumnValidate(
      Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure LayoutCheckBoxItemSynthesizeClick(Sender: TObject);
    procedure GridSynthesizeTableViewDataControllerBeforePost(
      ADataController: TcxCustomDataController);
    procedure GridSynthesizeTableViewColumnValidateDrawValue(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      const AValue: Variant; AData: TcxEditValidateInfo);
    procedure ActionColorThemeLightExecute(Sender: TObject);
    procedure ActionColorThemeLightUpdate(Sender: TObject);
    procedure ActionColorThemeDarkExecute(Sender: TObject);
    procedure ActionColorThemeDarkUpdate(Sender: TObject);
    procedure ActionColorThemeCustomExecute(Sender: TObject);
    procedure ActionColorThemeCustomUpdate(Sender: TObject);
    procedure ImageComboBoxSkinPropertiesChange(Sender: TObject);
    procedure ComboBoxColorSchemePropertiesChange(Sender: TObject);
    procedure PaintBoxColorSamplePaint(Sender: TObject);
    procedure EditTranslatorDeepLAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure EditTranslatorDeepLAPIKeyPropertiesChange(Sender: TObject);
    procedure EditOllamaBaseURLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure EditOllamaBaseURLPropertiesChange(Sender: TObject);
    procedure ActionOllamaDetectModelsExecute(Sender: TObject);
    procedure ActionOllamaTestExecute(Sender: TObject);
    procedure LayoutGroupTranslatorTMCheckBoxStateChanged(Sender: TObject);
    procedure EditGeminiAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure EditGeminiAPIKeyPropertiesChange(Sender: TObject);
    procedure ActionGeminiDetectModelsExecute(Sender: TObject);
    procedure ActionGeminiTestExecute(Sender: TObject);
    procedure ActionGeminiHasKeyUpdate(Sender: TObject);
  private
    FSpellCheckerAutoCorrectOptions: TdxSpellCheckerAutoCorrectOptions;
    FRestartRequired: boolean;
    FSpellChecker: TdxSpellChecker;
    FRibbonStyle: TdxRibbonStyle;
  private
    function TranslateStyleBold(Index: integer): TFontStyles;
    function TranslateStyleColor(Index: integer; TextColor: boolean): TColor; overload;
    function TranslateStyleColor(ColorValue: Variant; TextColor: boolean): TColor; overload;
    procedure OnColorsEditColorDefaultHandler(Sender: TObject);
    procedure OnCustomColorClickHandler(Sender: TObject; AButtonIndex: Integer);
  private
    type
      TPreviewColors = (pcFrame, pcWindow, pcText, pcSelect);

      TSkinColorScheme = record
        Name: string;
        Index: integer;
        Colors: TArray<TColor>;
        PreviewColors: array[TPreviewColors] of TColor;
        Dark: boolean;
        Hue: integer;
        Lightness: integer;
      end;
      PSkinColorScheme = ^TSkinColorScheme;

      TSkinDetails = record
        Name: string;
        Group: string;
        DisplayName: string;
        Index: integer;
        GlyphSmall: TBitmap;
        GlyphLarge: TBitmap;
        ColorSchemes: TArray<TSkinColorScheme>;
      end;
  private
    FSkinList: TList<TSkinDetails>;
    FColorTheme: TColorTheme;
  private
    procedure PopulateSkins;
    procedure PopulateColorSchemes(Items: TcxImageComboBoxItems);
    function GetSkin: string;
    procedure SetSkin(const value: string);
  protected
    procedure RequireRestart;
  protected
    procedure LoadProofing(SpellChecker: TdxSpellChecker);
    procedure ApplyProofing(SpellChecker: TdxSpellChecker);

    procedure LoadFolders;
    procedure ApplyFolders;

    procedure LoadStyles;
    procedure ApplyStyles;

    procedure LoadSynthesizeRules;
    procedure ApplySynthesizeRules;
  protected
    procedure LoadSettings;
    procedure ApplySettings;

  private
    // IDialogSettings
    function Execute(ASpellChecker: TdxSpellChecker; ARibbonStyle: TdxRibbonStyle): boolean;
    function GetRestartRequired: boolean;

  private
    // ITranslationProviderSettingsOllama
    function GetOllamaBaseURL: string;
    function GetOllamaModelName: string;
    function GetOllamaTimeout: integer;
    function ITranslationProviderSettingsOllama.GetBaseURL = GetOllamaBaseURL;
    function ITranslationProviderSettingsOllama.GetModelName = GetOllamaModelName;
    function ITranslationProviderSettingsOllama.GetTimeout = GetOllamaTimeout;

  private
    // ITranslationProviderSettingsGemini
    function GetGeminiAPIKey: string;
    function GetGeminiModelName: string;
    function GetGeminiTimeout: integer;
    function GetGeminiTemperature: single;
    function ITranslationProviderSettingsGemini.GetAPIKey = GetGeminiAPIKey;
    function ITranslationProviderSettingsGemini.GetModelName = GetGeminiModelName;
    function ITranslationProviderSettingsGemini.GetTimeout = GetGeminiTimeout;
    function ITranslationProviderSettingsGemini.GetTemperature = GetGeminiTemperature;

  public
    constructor Create(Awner: TComponent); override;
    destructor Destroy; override;
  end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

{$R *.dfm}

uses
  Generics.Defaults,
  Types, UITypes,
  IOUtils,
  Math,
  System.NetEncoding,
  System.Net.HttpClient,
  System.JSON,

  dxSkinsdxRibbonPainter,

  dxSpellCheckerCore,
  dxSpellCheckerDialogs,
  dxSpellCheckerAutoCorrectOptionsDialog,

  cxStorage,
  dxColorGallery,
  dxSkinInfo,
  dxSkinsStrs,

  amShell,
  amPath,
  amCursorService,
  amLanguageInfo,
  amDialog.Manager.API,
  amLocalization.Utils,
  amLocalization.Model,
  amLocalization.Settings.SpellChecker,
  amLocalization.Persistence,
  amLocalization.Skin,
  amLocalization.Normalization,
  amLocalization.Shell,
  amLocalization.Data.Main,
  amLocalization.Environment,
  amLocalization.Provider.Microsoft.Version3,
  amLocalization.Provider.DeepL,
  amLocalization.Provider.Ollama,
  amLocalization.Provider.Gemini;

resourcestring
  sValueRequired = 'Value required';
  sTranslatorAPIKeyValid = 'The API key has been validated.';
  sTranslatorAPIKeyInvalid = 'The API key could not be validated:'#13#13'%s';

const
  FolderOrder: array[Ord(Low(TTranslationManagerFolder))..Ord(High(TTranslationManagerFolder))] of TTranslationManagerFolder =
    (tmFolderAppData, tmFolderDocuments, tmFolderSpellCheck, tmFolderUserSpellCheck);

// -----------------------------------------------------------------------------

type
  TcxExtLookupComboBoxCracker = class(TcxExtLookupComboBox);

constructor TFormSettings.Create(Awner: TComponent);
var
  Style: TListStyle;
resourcestring
  sLanguageSystemDefault = '(system default)';
begin
  inherited;

  FSkinList := TList<TSkinDetails>.Create;

  TcxExtLookupComboBoxCracker(ComboBoxSourceLanguage).TextHint := sLanguageSystemDefault;
  TcxExtLookupComboBoxCracker(ComboBoxTargetLanguage).TextHint := sLanguageSystemDefault;
  TcxExtLookupComboBoxCracker(ComboBoxApplicationLanguage).TextHint := sLanguageSystemDefault;

  GridColorsTableView.DataController.RecordCount := Ord(High(TListStyle))+1;
  for Style := Low(TListStyle) to High(TListStyle) do
    GridColorsTableView.DataController.Values[Ord(Style), 0] := TranslationManagerSettings.Editor.Style[Style].Name;

  // Ensure that all provider groups are collapsed in case we forgot to do it
  // at design-time.
  for var i := 0 to LayoutGroupCategoryProviders.Count-1 do
    if (LayoutGroupCategoryProviders[i] is TdxLayoutGroup) then
      TdxLayoutGroup(LayoutGroupCategoryProviders[i]).Expanded := False;
end;

destructor TFormSettings.Destroy;
begin
  FSpellCheckerAutoCorrectOptions.Free;
  FSkinList.Free;

  inherited;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.FormCreate(Sender: TObject);
begin
  // Make sure Actions, Buttons and Tabsheet pages are in sync
  for var i := 0 to LayoutGroupCategories.Count-1 do
  begin
    var Action := TAction.Create(Self);
    Action.Caption := LayoutGroupCategories.Items[i].CaptionOptions.Text;
    Action.OnExecute := ActionCategoryExecute;
    Action.OnUpdate := ActionCategoryUpdate;

    var Button := TcxButton.Create(Self);
    Button.Action := Action;
    Button.Width := 100;
    Button.OptionsImage.Margin := 8; // Makes text left aligned

    var ButtonItem := LayoutGroupCategoryButtons.CreateItemForControl(Button);

    Action.Tag := ButtonItem.Index;
    Action.ShortCut := ShortCut(Ord('1')+ButtonItem.Index, [ssCtrl]);
  end;

  // Tabs can be visible at design time to ease development, but we hide them at run time.
  LayoutGroupCategories.TabbedOptions.HideTabs := True;
  // Start with first category active (in case we forgot to set it at design time).
  LayoutGroupCategories.ItemIndex := 0;

  PopulateSkins;

  GridFoldersTableView.DataController.RecordCount := Length(FolderOrder);
  GridFoldersTableView.DataController.BeginUpdate;
  try
    for var i := Low(FolderOrder) to High(FolderOrder) do
    begin
      GridFoldersTableView.DataController.Values[i, 0] := TranslationManagerSettings.Folders.FolderName[FolderOrder[i]];
      GridFoldersTableView.DataController.Values[i, 2] := TranslationManagerSettings.Folders.FolderReadOnly[FolderOrder[i]]; // Read-only
    end;
  finally
    GridFoldersTableView.DataController.EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

function TFormSettings.Execute(ASpellChecker: TdxSpellChecker; ARibbonStyle: TdxRibbonStyle): boolean;
begin
  FSpellChecker := ASpellChecker;
  FRibbonStyle := ARibbonStyle;

  FSpellCheckerAutoCorrectOptions := TdxSpellCheckerAutoCorrectOptions.Create(FSpellChecker);

  LoadSettings;

  Result := False;

  while (ModalResult = mrNone) do
  begin

    Result := (ShowModal = mrOK);

    if (Result) then
      ApplySettings;

  end;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.LoadSettings;
begin
  (*
  ** General section
  *)

  CheckBoxProjectAutoApplyStopList.Checked := TranslationManagerSettings.System.AutoApplyStopList;

  CheckBoxEditUseProposed.Checked := TranslationManagerSettings.Editor.UseProposedStatus;
  ComboBoxAutoApplyTranslations.ItemIndex := Ord(TranslationManagerSettings.Editor.AutoApplyTranslations);
  ComboBoxAutoApplyTranslationsSimilar.ItemIndex := Ord(TranslationManagerSettings.Editor.AutoApplyTranslationsSimilar);
  CheckBoxAutoApplyTranslationsExisting.Checked := TranslationManagerSettings.Editor.AutoApplyTranslationsExisting;
  CheckBoxEditBiDiMode.Checked := TranslationManagerSettings.Editor.EditBiDiMode;
  CheckBoxAutoShowMultiLineEditor.Checked := TranslationManagerSettings.Editor.AutoShowMultiLineEditor;
  ComboBoxNormalization.EditValue := Byte(TranslationManagerSettings.Editor.SanitizeRules);
  ComboBoxEqualization.EditValue := Byte(TranslationManagerSettings.Editor.EqualizerRules);

  CheckBoxResourceModulesIncludeVersionInfo.Checked := TranslationManagerSettings.System.IncludeVersionInfo;
  ComboBoxModuleNameScheme.EditValue := Ord(TranslationManagerSettings.System.ModuleNameScheme);

  ComboBoxSourceLanguage.EditValue := TranslationManagerSettings.System.DefaultSourceLocale;
  ComboBoxTargetLanguage.EditValue := TranslationManagerSettings.System.DefaultTargetLocale;

  (*
  ** Appearance
  *)
  SetSkin(DataModuleMain.CustomSkinName);
  ComboBoxColorScheme.EditValue := DataModuleMain.CustomColorScheme;
  FColorTheme := TranslationManagerSettings.System.ColorTheme;
  LayoutGroupUserInterfaceThemeAdvanced.Visible := (FColorTheme = ctCustom);
  LoadStyles;
  ActionEditStatusGlyphs.Checked := TranslationManagerSettings.Editor.DisplayStatusGlyphs;
  ActionEditStatusHint.Checked := TranslationManagerSettings.Editor.StatusGlyphHints;
  ComboBoxApplicationLanguage.EditValue := TranslationManagerSettings.System.ApplicationLanguage;

  (*
  ** Providers section
  *)
  LayoutGroupTranslatorTM.ButtonOptions.CheckBox.Checked := TranslationManagerSettings.Providers.TranslationMemory.Enabled;
  EditProviderTMFilename.Text := TranslationManagerSettings.Providers.TranslationMemory.Filename;
  CheckBoxTMLoadOnDemand.Checked := TranslationManagerSettings.Providers.TranslationMemory.LoadOnDemand;
  CheckBoxTMPromptToSave.Checked := TranslationManagerSettings.Providers.TranslationMemory.PromptToSave;
  CheckBoxTMBackgroundQuery.Checked := TranslationManagerSettings.Providers.TranslationMemory.BackgroundQuery;

  LayoutGroupTranslatorMS.ButtonOptions.CheckBox.Checked := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Enabled;
  EditTranslatorMSAPIKey.Text := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey;
  if (TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKeyValidated) then
    EditTranslatorMSAPIKey.Properties.Buttons[0].ImageIndex := 1;
  EditTranslatorMSAPIRegion.Text := TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Region;

  LayoutGroupTranslatorDeepL.ButtonOptions.CheckBox.Checked := TranslationManagerSettings.Providers.Deepl.Enabled;
  EditTranslatorDeepLAPIKey.Text := TranslationManagerSettings.Providers.Deepl.APIKey;
  ActionProviderDeepLLicenseFree.Checked := not TranslationManagerSettings.Providers.Deepl.ProVersion;
  ActionProviderDeepLLicensePro.Checked := TranslationManagerSettings.Providers.Deepl.ProVersion;

  LayoutGroupTranslatorOllama.ButtonOptions.CheckBox.Checked := TranslationManagerSettings.Providers.Ollama.Enabled;
  EditOllamaBaseURL.Text := TranslationManagerSettings.Providers.Ollama.BaseURL;
  ComboBoxOllamaModel.Text := TranslationManagerSettings.Providers.Ollama.ModelName;
  EditOllamaTimeout.Value := TranslationManagerSettings.Providers.Ollama.Timeout;

  EditGeminiAPIKey.Text := TranslationManagerSettings.Providers.Gemini.APIKey;
  ComboBoxGeminiModel.Text := TranslationManagerSettings.Providers.Gemini.ModelName;
  EditGeminiTimeout.Value := TranslationManagerSettings.Providers.Gemini.Timeout;
  EditGeminiTemperature.Value := TranslationManagerSettings.Providers.Gemini.Temperature;

  (*
  ** Files section
  *)
  LoadFolders;
  CheckBoxSaveBackup.Checked := TranslationManagerSettings.Backup.SaveBackups;
  CheckBoxFileProjectOmitDontTranslate.Checked := not TranslationManagerSettings.Project.SaveDontTranslate;
  CheckBoxFileProjectSaveNewState.Checked := TranslationManagerSettings.Project.SaveNewState;
  CheckBoxFileProjectSort.Checked := TranslationManagerSettings.Project.SaveSorted;
  CheckBoxFileProjectSaveTransient.Checked := TranslationManagerSettings.Project.SaveTransient;

  (*
  ** Proofing section
  *)
  LoadProofing(FSpellChecker);

  (*
  ** Parser section
  *)
  ComboBoxStringListHandling.ItemIndex := Ord(TranslationManagerSettings.Parser.StringListHandling);
  LayoutCheckBoxItemSynthesize.Checked := TranslationManagerSettings.Parser.Synthesize.Enabled;
  LoadSynthesizeRules;

  (*
  ** Advanced section
  *)
  CheckBoxSingleInstance.Checked := TranslationManagerSettings.System.SingleInstance;
  CheckBoxPortable.Checked := TranslationManagerSettings.System.Portable;
end;

procedure TFormSettings.ApplySettings;

  function VarToLCID(const Value: Variant): LCID;
  begin
    if (VarIsOrdinal(Value)) then
      Result := Value
    else
      Result := 0;
  end;

resourcestring
  sWarningPortableSettingsCaption = 'Portable Configuration';
  sWarningPortableSettingsMessage = 'A portable settings file already exist.'#13#13+
    'Would you like to use the settings in the existing portable settings file instead of the current settings?'#13#13+
    'If you answer No a new portable settings file will be created with your current settings.'#13+
    'Note that the settings include custom data such as the Stop List.';
begin
  (*
  ** General section
  *)
  TranslationManagerSettings.System.Skin := GetSkin;

  TranslationManagerSettings.System.AutoApplyStopList := CheckBoxProjectAutoApplyStopList.Checked;

  TranslationManagerSettings.Editor.UseProposedStatus := CheckBoxEditUseProposed.Checked;
  TranslationManagerSettings.Editor.AutoApplyTranslations := TTranslationAutoApply(ComboBoxAutoApplyTranslations.ItemIndex);
  TranslationManagerSettings.Editor.AutoApplyTranslationsSimilar := TTranslationAutoApply(ComboBoxAutoApplyTranslationsSimilar.ItemIndex);
  TranslationManagerSettings.Editor.AutoApplyTranslationsExisting := CheckBoxAutoApplyTranslationsExisting.Checked;
  if (TranslationManagerSettings.Editor.UseProposedStatus) then
    TLocalizerTranslations.DefaultStatus := tStatusProposed
  else
    TLocalizerTranslations.DefaultStatus := tStatusTranslated;
  TranslationManagerSettings.Editor.EditBiDiMode := CheckBoxEditBiDiMode.Checked;
  TranslationManagerSettings.Editor.AutoShowMultiLineEditor := CheckBoxAutoShowMultiLineEditor.Checked;
  TranslationManagerSettings.Editor.SanitizeRules := TSanitizeRules(Byte(ComboBoxNormalization.EditValue));
  TranslationManagerSettings.Editor.EqualizerRules := TMakeAlikeRules(Byte(ComboBoxEqualization.EditValue));

  TranslationManagerSettings.System.IncludeVersionInfo := CheckBoxResourceModulesIncludeVersionInfo.Checked;
  TranslationManagerSettings.System.ModuleNameScheme := TModuleNameScheme(ComboBoxModuleNameScheme.EditValue);

  TranslationManagerSettings.System.DefaultSourceLocale := VarToStr(ComboBoxSourceLanguage.EditValue);
  TranslationManagerSettings.System.DefaultTargetLocale := VarToStr(ComboBoxTargetLanguage.EditValue);

  (*
  ** Appearance
  *)
  ApplyStyles;
  TranslationManagerSettings.Editor.DisplayStatusGlyphs := ActionEditStatusGlyphs.Checked;
  TranslationManagerSettings.Editor.StatusGlyphHints := ActionEditStatusHint.Checked;
  TranslationManagerSettings.System.ApplicationLanguage := VarToLCID(ComboBoxApplicationLanguage.EditValue);

  (*
  ** Translators section
  *)
  TranslationManagerSettings.Providers.TranslationMemory.Enabled := LayoutGroupTranslatorTM.ButtonOptions.CheckBox.Checked;
  TranslationManagerSettings.Providers.TranslationMemory.Filename := EditProviderTMFilename.Text;
  TranslationManagerSettings.Providers.TranslationMemory.LoadOnDemand := CheckBoxTMLoadOnDemand.Checked;
  TranslationManagerSettings.Providers.TranslationMemory.PromptToSave := CheckBoxTMPromptToSave.Checked;
  TranslationManagerSettings.Providers.TranslationMemory.BackgroundQuery := CheckBoxTMBackgroundQuery.Checked;

  TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Enabled := LayoutGroupTranslatorMS.ButtonOptions.CheckBox.Checked;
  TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKey := EditTranslatorMSAPIKey.Text;
  TranslationManagerSettings.Providers.MicrosoftTranslatorV3.APIKeyValidated := (EditTranslatorMSAPIKey.Properties.Buttons[0].ImageIndex = 1);
  TranslationManagerSettings.Providers.MicrosoftTranslatorV3.Region := EditTranslatorMSAPIRegion.Text;

  TranslationManagerSettings.Providers.Deepl.Enabled := LayoutGroupTranslatorDeepL.ButtonOptions.CheckBox.Checked;
  TranslationManagerSettings.Providers.Deepl.APIKey := EditTranslatorDeepLAPIKey.Text;
  TranslationManagerSettings.Providers.Deepl.ProVersion := ActionProviderDeepLLicensePro.Checked;

  TranslationManagerSettings.Providers.Ollama.Enabled := LayoutGroupTranslatorOllama.ButtonOptions.CheckBox.Checked;
  TranslationManagerSettings.Providers.Ollama.BaseURL := EditOllamaBaseURL.Text;
  TranslationManagerSettings.Providers.Ollama.ModelName := ComboBoxOllamaModel.Text;
  TranslationManagerSettings.Providers.Ollama.Timeout := EditOllamaTimeout.Value;

  TranslationManagerSettings.Providers.Gemini.APIKey := EditGeminiAPIKey.Text;
  TranslationManagerSettings.Providers.Gemini.ModelName := ComboBoxGeminiModel.Text;
  TranslationManagerSettings.Providers.Gemini.Timeout := EditGeminiTimeout.Value;
  TranslationManagerSettings.Providers.Gemini.Temperature := EditGeminiTemperature.Value;

  (*
  ** Files section
  *)
  ApplyFolders;
  TranslationManagerSettings.Backup.SaveBackups := CheckBoxSaveBackup.Checked;
  TranslationManagerSettings.Project.SaveDontTranslate := not CheckBoxFileProjectOmitDontTranslate.Checked;
  TranslationManagerSettings.Project.SaveNewState := CheckBoxFileProjectSaveNewState.Checked;
  TranslationManagerSettings.Project.SaveSorted := CheckBoxFileProjectSort.Checked;
  TranslationManagerSettings.Project.SaveTransient := CheckBoxFileProjectSaveTransient.Checked;

  (*
  ** Proofing section
  *)
  ApplyProofing(FSpellChecker);
  TranslationManagerProofingSettingsAdapter.SaveFrom(TranslationManagerSettings.Proofing, FSpellChecker);

  (*
  ** Parser section
  *)
  TranslationManagerSettings.Parser.StringListHandling := TStringListHandling(ComboBoxStringListHandling.ItemIndex);
  TranslationManagerSettings.Parser.Synthesize.Enabled := LayoutCheckBoxItemSynthesize.Checked;
  ApplySynthesizeRules;

  (*
  ** Advanced section
  *)
  TranslationManagerSettings.System.SingleInstance := CheckBoxSingleInstance.Checked;

  if (TranslationManagerSettings.System.Portable <> CheckBoxPortable.Checked) then
  begin
    try

      // Detect existing portable config file
      if (CheckBoxPortable.Checked) then
      begin
        var PortableConfigFilename := TPath.ChangeExtension(ParamStr(0), '.portable');

        if (TFile.Exists(PortableConfigFilename)) then
        begin
          var Res := TaskMessageDlg(sWarningPortableSettingsCaption, sWarningPortableSettingsMessage, mtWarning, [mbYes, mbNo, mbCancel], 0, mbCancel);

          case Res of
            mrYes:
              {Keep file};

            mrNo:
              TFile.Delete(PortableConfigFilename);

          else
            ModalResult := mrNone;
            exit;
          end;
        end;

      end;

      // Try to create or delete the portable token file
      if (TranslationManagerSettings.System.Portable) then
      begin
        if (TFile.Exists(TranslationManagerSettings.FolderInstall+'portable')) then
          TFile.Delete(TranslationManagerSettings.FolderInstall+'portable');
      end else
      begin
        TFile.WriteAllText(TranslationManagerSettings.FolderInstall+'portable', 'If this file is present then the application will run as a portable application');
      end;

      TranslationManagerSettings.System.Portable := CheckBoxPortable.Checked;
    except
      on E: Exception do
      begin
        ModalResult := mrNone;
        ShowMessageFmt('Unable to change the portable setting: %s', [E.Message]);
      end;
    end;
  end;

  DataModuleMain.ColorTheme := FColorTheme;
  DataModuleMain.CustomSkinName := GetSkin;
  DataModuleMain.CustomColorScheme := ComboBoxColorScheme.Text;
end;

// -----------------------------------------------------------------------------

function TFormSettings.GetGeminiAPIKey: string;
begin
  Result := EditGeminiAPIKey.Text;
end;

function TFormSettings.GetGeminiModelName: string;
begin
  Result := ComboBoxGeminiModel.Text;
end;

function TFormSettings.GetGeminiTimeout: integer;
begin
  Result := EditGeminiTimeout.Value;
end;

function TFormSettings.GetGeminiTemperature: single;
begin
  Result := EditGeminiTemperature.Value;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.LoadStyles;

  procedure LoadStyle(ListStyle: TListStyle);
  var
    Style: TTranslationManagerListStyleSettings;
    Index: integer;
  begin
    Style := TranslationManagerSettings.Editor.Style[ListStyle];
    Index := Ord(ListStyle);

    GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnSample.Index] := 'Lorem ipsum dolor';

    if (Style.ColorBackground <> clDefault) then
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBackground.Index] := ColorToRGB(Style.ColorBackground)
    else
    if (ListStyle = ListStyleDefault) then
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBackground.Index] := clWhite
    else
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBackground.Index] := Null;

    if (Style.ColorText <> clDefault) then
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnText.Index] := ColorToRGB(Style.ColorText)
    else
    if (ListStyle = ListStyleDefault) then
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnText.Index] := clBlack
    else
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnText.Index] := Null;

    if (Style.Bold <> -1) then
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index] := (Style.Bold = 1)
    else
      GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index] := Null;
  end;

var
  Style: TListStyle;
begin
  for Style := Low(TListStyle) to High(TListStyle) do
    LoadStyle(Style);
end;

procedure TFormSettings.ApplyStyles;

  procedure SaveStyle(ListStyle: TListStyle);
  var
    Style: TTranslationManagerListStyleSettings;
    Index: integer;
    Value: Variant;
  begin
    Style := TranslationManagerSettings.Editor.Style[ListStyle];
    Index := Ord(ListStyle);

    Value := GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBackground.Index];
    if (VarIsOrdinal(Value)) and (Value <> clDefault) and ((Index <> 0) or (Value <> clWhite)) then
      Style.ColorBackground := Value
    else
      Style.ColorBackground := clDefault;

    Value := GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnText.Index];
    if (VarIsOrdinal(Value)) and (Value <> clDefault) and ((Index <> 0) or (Value <> clBlack)) then
      Style.ColorText := Value
    else
      Style.ColorText := clDefault;

    if (not VarIsNull(GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index])) then
    begin
      if (GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index]) then
        Style.Bold := 1
      else
        Style.Bold := 0;
    end else
      Style.Bold := -1;
  end;

var
  Style: TListStyle;
begin
  for Style := Low(TListStyle) to High(TListStyle) do
    SaveStyle(Style);
end;

procedure TFormSettings.ButtonStyleResetClick(Sender: TObject);
begin
  TranslationManagerSettings.Editor.Style.ResetSettings;
  LoadStyles;
end;

procedure TFormSettings.ApplySynthesizeRules;
begin
  TranslationManagerSettings.Parser.Synthesize.Rules.Clear;
  for var i := 0 to GridSynthesizeTableView.DataController.RecordCount-1 do
    TranslationManagerSettings.Parser.Synthesize.AddRule(
      GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnMask.Index],
      GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnName.Index],
      GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnValue.Index]);
end;

procedure TFormSettings.LoadSynthesizeRules;
begin
  GridSynthesizeTableView.DataController.RecordCount := TranslationManagerSettings.Parser.Synthesize.Rules.Count;
  for var i := 0 to TranslationManagerSettings.Parser.Synthesize.Rules.Count-1 do
  begin
    GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnMask.Index] :=
      TranslationManagerSettings.Parser.Synthesize.Rules[i].TypeMask;
    GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnName.Index] :=
      TranslationManagerSettings.Parser.Synthesize.Rules[i].PropertyName;
    GridSynthesizeTableView.DataController.Values[i, GridSynthesizeTableViewColumnValue.Index] :=
      TranslationManagerSettings.Parser.Synthesize.Rules[i].PropertyValue;
  end;
end;

// -----------------------------------------------------------------------------

function TFormSettings.GetOllamaBaseURL: string;
begin
  Result := EditOllamaBaseURL.Text;
end;

function TFormSettings.GetOllamaModelName: string;
begin
  Result := ComboBoxOllamaModel.Text;
end;

function TFormSettings.GetOllamaTimeout: integer;
begin
  Result := EditOllamaTimeout.Value;
end;

// -----------------------------------------------------------------------------

function TFormSettings.GetRestartRequired: boolean;
begin
  Result := FRestartRequired;
end;

// -----------------------------------------------------------------------------

function TFormSettings.GetSkin: string;
begin
  if (ImageComboBoxSkin.ItemIndex <> -1) then
    Result := FSkinList[ImageComboBoxSkin.ItemIndex].Name
  else
    Result := '';
end;

procedure TFormSettings.SetSkin(const Value: string);

  function DoSetSkin(const Value: string): integer;
  begin
    for var i := 0 to FSkinList.Count-1 do
      if (AnsiSameText(Value, FSkinList[i].Name)) then
        Exit(i);

    Result := -1;
  end;

begin
  ImageComboBoxSkin.ItemIndex := DoSetSkin(Value);
end;

// -----------------------------------------------------------------------------

function TFormSettings.TranslateStyleBold(Index: integer): TFontStyles;
begin
  if (not VarIsNull(GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index])) then
  begin
    if (GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBold.Index]) then
      Result := [fsBold]
    else
      Result := [];
  end else
  if (not VarIsNull(GridColorsTableView.DataController.Values[0, GridColorsTableViewColumnBold.Index])) and
    (GridColorsTableView.DataController.Values[0, GridColorsTableViewColumnBold.Index]) then
    Result := [fsBold]
  else
    Result := [];
end;

function TFormSettings.TranslateStyleColor(ColorValue: Variant; TextColor: boolean): TColor;
begin
  if (not VarIsOrdinal(ColorValue)) or (ColorValue = clDefault) then
  begin
    if (TextColor) then
      ColorValue := GridColorsTableView.DataController.Values[0, GridColorsTableViewColumnText.Index]
    else
      ColorValue := GridColorsTableView.DataController.Values[0, GridColorsTableViewColumnBackground.Index];
  end;

  if (not VarIsOrdinal(ColorValue)) or (ColorValue = clDefault) then
  begin
    if (TextColor) then
      Result := clBlack
    else
      Result := clWhite;
  end else
    Result := ColorToRGB(ColorValue);
end;

function TFormSettings.TranslateStyleColor(Index: integer; TextColor: boolean): TColor;
begin
  if (TextColor) then
    Result := TranslateStyleColor(GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnText.Index], TextColor)
  else
    Result := TranslateStyleColor(GridColorsTableView.DataController.Values[Index, GridColorsTableViewColumnBackground.Index], TextColor);
end;

procedure TFormSettings.GridColorsTableViewColumnSampleCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  r: TRect;
begin
  // Draw sample using current colors
  r := AViewInfo.Bounds;
  Inc(r.Left, 1);
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := TranslateStyleColor(AViewInfo.GridRecord.Index, False);
  ACanvas.FillRect(r);
  Inc(r.Left, 4);
  ACanvas.Font.Color := TranslateStyleColor(AViewInfo.GridRecord.Index, True);
  ACanvas.Font.Style := TranslateStyleBold(AViewInfo.GridRecord.Index);
  ACanvas.DrawTexT(AViewInfo.Text, r, cxAlignLeft or cxAlignVCenter or cxSingleLine);
  ADone := True;
end;

procedure TFormSettings.GridColorsTableViewColumnBackgroundCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  r, r2: TRect;
begin
  if (AViewInfo.RecordViewInfo.Index = 0) then
    Exit;

  if (not VarIsOrdinal(AViewInfo.Value)) or (AViewInfo.Value = clDefault) then
  begin
    r := AViewInfo.Bounds;
    r.Inflate(-2, -2);
    ACanvas.Pen.Color := clBtnShadow;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Rectangle(r);

    r2 := r;
    r2.Inflate(-2, -2);
    r2.Right := r2.Left + r2.Height;
    ACanvas.Brush.Color := TranslateStyleColor(0, False);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Pen.Color := clBtnShadow;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Rectangle(r2);

    r.Left := r2.Right+2;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font.Color := clWindowText;
    ACanvas.DrawTexT('default', r, cxAlignVCenter or cxAlignLeft or cxSingleLine);
    ADone := True;
  end;
end;

procedure TFormSettings.GridColorsTableViewColumnTextCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  r, r2: TRect;
begin
  if (AViewInfo.RecordViewInfo.Index = 0) then
    Exit;

  if (not VarIsOrdinal(AViewInfo.Value)) or (AViewInfo.Value = clDefault) then
  begin
    r := AViewInfo.Bounds;
    r.Inflate(-2, -2);
    ACanvas.Pen.Color := clBtnShadow;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Rectangle(r);

    r2 := r;
    r2.Inflate(-2, -2);
    r2.Right := r2.Left + r2.Height;
    ACanvas.Brush.Color := TranslateStyleColor(0, True);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Pen.Color := clBtnShadow;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Rectangle(r2);

    r.Left := r2.Right+2;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font.Color := clWindowText;
    ACanvas.DrawTexT('default', r, cxAlignVCenter or cxAlignLeft or cxSingleLine);
    ADone := True;
  end;
end;

procedure TFormSettings.GridColorsTableViewDataControllerAfterPost(ADataController: TcxCustomDataController);
begin
  // Redraw everything if default changes
  if (ADataController.FocusedRecordIndex = 0) then
    GridColorsTableView.Invalidate(True);
end;

procedure TFormSettings.GridColorsTableViewInitEdit(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
var
  Button: TcxEditButton;
begin
  if (not (AEdit is TdxColorEdit)) then
    Exit;
  Button := TdxColorEdit(AEdit).Properties.Buttons.Add;
  Button.Kind := bkEllipsis;
  TdxColorEdit(AEdit).Properties.OnButtonClick := OnCustomColorClickHandler;
end;

type
  TdxCustomColorEditCracker = class(TdxCustomColorEdit);
  TdxCustomColorGalleryCracker = class(TdxCustomColorGallery);

procedure TFormSettings.GridColorsTableViewColumnColorPropertiesInitPopup(Sender: TObject);
var
  Gallery: TdxCustomColorGalleryCracker;
  Button: TcxButton;
begin
  if (Sender is TdxCustomColorEdit) then
  begin
    Gallery := TdxCustomColorGalleryCracker(TdxCustomColorEditCracker(Sender).FColorGallery);
    Gallery.DestroyComponents;

    Button := TcxButton.Create(Gallery);
    Button.Parent := Gallery;
    Button.Align := alTop;
    Button.Caption := '(default)';
    Button.SpeedButtonOptions.Flat := True;
    Button.SpeedButtonOptions.Transparent := True;
    Button.SpeedButtonOptions.CanBeFocused := False;
    Button.TabStop := False;
    Button.Height := Abs(Button.Font.Height)+8;
    Button.OnClick := OnColorsEditColorDefaultHandler;

    Gallery.ContentOffset.Top := Button.Top + Button.Height+2;
  end;
end;

procedure TFormSettings.OnColorsEditColorDefaultHandler(Sender: TObject);
begin
  GridColorsTableView.Controller.EditingController.HideEdit(False);
  if (GridColorsTableView.Controller.FocusedRecordIndex = 0) then
  begin
    if (GridColorsTableView.Controller.FocusedItem = GridColorsTableViewColumnText) then
      GridColorsTableView.Controller.FocusedItem.EditValue := clBlack
    else
      GridColorsTableView.Controller.FocusedItem.EditValue := clWhite;
  end else
    GridColorsTableView.Controller.FocusedItem.EditValue := Null;
end;

procedure TFormSettings.OnCustomColorClickHandler(Sender: TObject; AButtonIndex: Integer);
begin
  if (AButtonIndex = 0) then
    Exit;

  ColorDialog.Color := dxColorToAlphaColor(TranslateStyleColor(GridColorsTableView.Controller.FocusedRecordIndex, GridColorsTableView.Controller.FocusedItem = GridColorsTableViewColumnText));

  if (ColorDialog.Execute) then
  begin
    GridColorsTableView.Controller.EditingController.HideEdit(False);
    GridColorsTableView.Controller.FocusedItem.EditValue := dxAlphaColorToColor(ColorDialog.Color);
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.GridFoldersTableViewCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if (ssCtrl in AShift) then
    ActionFoldersExplorer.Execute
  else
    ActionFoldersModify.Execute;
end;

procedure TFormSettings.GridFoldersTableViewColumnPathGetCellHint(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  ACellViewInfo: TcxGridTableDataCellViewInfo; const AMousePos: TPoint; var AHintText: TCaption; var AIsHintMultiLine: Boolean;
  var AHintTextRect: TRect);
begin
  AHintText := EnvironmentVars.ExpandString(VarToStr(ARecord.Values[Sender.Index]));
end;

procedure TFormSettings.GridFoldersTableViewColumnPathGetDisplayText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
var
  r: TRect;
  Width: integer;
begin
  r := ARecord.ViewInfo.GetBoundsForItem(Sender);
  Width := R.Right - r.Left - GetSystemMetrics(SM_CXVSCROLL);

  AText := cxGetStringAdjustedToWidth(GridFolders.Canvas.Handle, GridFolders.Font.Handle, AText, Width, mstPathEllipsis);
end;

procedure TFormSettings.GridFoldersTableViewColumnPathPropertiesEditValueChanged(Sender: TObject);
begin
  if (GridFoldersTableView.DataController.FocusedRecordIndex = -1) then
    exit;
  if (TTranslationManagerFolder(GridFoldersTableView.DataController.FocusedRecordIndex) in [tmFolderSpellCheck]) then
    RequireRestart;
end;

procedure TFormSettings.GridFoldersTableViewEditing(Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
begin
  AAllow := not GridFoldersTableView.DataController.Values[GridFoldersTableView.DataController.FocusedRecordIndex, 2];
end;

procedure TFormSettings.GridFoldersTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if (AItem.Index = 1) and (not VarIsNull(ARecord.Values[2])) and (ARecord.Values[2]) then
    AStyle := StyleDisabled;
end;

procedure TFormSettings.GridSynthesizeTableViewColumnValidateDrawValue(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  const AValue: Variant; AData: TcxEditValidateInfo);
begin
  if (VarToStr(AValue) = '') then
  begin
    AData.ErrorType := eetError;
    AData.ErrorText := sValueRequired;
  end;
end;

procedure TFormSettings.GridSynthesizeTableViewColumnValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin
  if (VarToStr(DisplayValue) = '') then
    Error := True;
end;

procedure TFormSettings.GridSynthesizeTableViewDataControllerBeforePost(
  ADataController: TcxCustomDataController);
begin
  // All columns must have a value
  for var i := 0 to ADataController.ItemCount-1 do
    if (VarToStr(ADataController.Values[ADataController.FocusedRecordIndex, i]) = '') then
      Abort;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ImageComboBoxSkinPropertiesChange(Sender: TObject);
begin
  PopulateColorSchemes(ComboBoxColorScheme.Properties.Items);

  if (ImageComboBoxSkin.ItemIndex <> -1) and (ComboBoxColorScheme.Properties.Items.Count > 0) then
    ComboBoxColorScheme.ItemIndex := 0
  else
    ComboBoxColorScheme.ItemIndex := -1;

  LayoutItemColorSample.Visible := (ImageComboBoxSkin.ItemIndex <> -1) and (ComboBoxColorScheme.ItemIndex <> -1) and
    (Length(FSkinList[ImageComboBoxSkin.ItemIndex].ColorSchemes[ComboBoxColorScheme.Properties.Items[ComboBoxColorScheme.ItemIndex].Tag].Colors) > 1);

  PaintBoxColorSample.Invalidate;
end;

procedure TFormSettings.ComboBoxColorSchemePropertiesChange(Sender: TObject);
begin
  LayoutItemColorSample.Visible := (ImageComboBoxSkin.ItemIndex <> -1) and (ComboBoxColorScheme.ItemIndex <> -1) and
    (Length(FSkinList[ImageComboBoxSkin.ItemIndex].ColorSchemes[ComboBoxColorScheme.Properties.Items[ComboBoxColorScheme.ItemIndex].Tag].Colors) > 1);

  PaintBoxColorSample.Invalidate;
end;

procedure TFormSettings.PaintBoxColorSamplePaint(Sender: TObject);
begin
  var r := TPaintBox(Sender).ClientRect;

  if (ImageComboBoxSkin.ItemIndex = -1) or (ComboBoxColorScheme.ItemIndex = -1) then
  begin
    TPaintBox(Sender).Canvas.FillRect(r);
    exit;
  end;

  var ColorSchemeIndex := ComboBoxColorScheme.Properties.Items[ComboBoxColorScheme.ItemIndex].Tag;
  var Colors := FSkinList[ImageComboBoxSkin.ItemIndex].ColorSchemes[ColorSchemeIndex].Colors;

  // Draw border in two contrast colors (black/white)
  TPaintBox(Sender).Canvas.Pen.Color := Colors[0];
  TPaintBox(Sender).Canvas.Rectangle(r);
  r.Inflate(-1, -1);

  TPaintBox(Sender).Canvas.Pen.Color := Colors[1];
  TPaintBox(Sender).Canvas.Rectangle(r);
  r.Inflate(-1, -1);

  var Width := r.Width;
  for var i := 0 to High(Colors) do
  begin
    r.Right := (Width * (i + 1)) div Length(Colors);
    TPaintBox(Sender).Canvas.Brush.Color := Colors[i];
    TPaintBox(Sender).Canvas.FillRect(r);
    r.Left := r.Right;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionCategoryExecute(Sender: TObject);
begin
  LayoutGroupCategories.ItemIndex := TAction(Sender).Tag;
end;

procedure TFormSettings.ActionCategoryUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := (TAction(Sender).Tag = LayoutGroupCategories.ItemIndex);
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionColorThemeCustomExecute(Sender: TObject);
begin
  FColorTheme := ctCustom;
  LayoutGroupUserInterfaceThemeAdvanced.Visible := True;
end;

procedure TFormSettings.ActionColorThemeCustomUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := (FColorTheme = ctCustom);
end;

procedure TFormSettings.ActionColorThemeDarkExecute(Sender: TObject);
begin
  FColorTheme := ctDark;
  LayoutGroupUserInterfaceThemeAdvanced.Visible := False;
end;

procedure TFormSettings.ActionColorThemeDarkUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := (FColorTheme = ctDark);
end;

procedure TFormSettings.ActionColorThemeLightExecute(Sender: TObject);
begin
  FColorTheme := ctLight;
  LayoutGroupUserInterfaceThemeAdvanced.Visible := False;
end;

procedure TFormSettings.ActionColorThemeLightUpdate(Sender: TObject);
begin
  TAction(Sender).Checked := (FColorTheme = ctLight);
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionDummyExecute(Sender: TObject);
begin
  //
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionEditStatusHintUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ActionEditStatusGlyphs.Checked;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionFolderResetAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := Low(FolderOrder) to High(FolderOrder) do
    GridFoldersTableView.DataController.Values[i, 1] := TranslationManagerSettings.Folders.FolderDefault[FolderOrder[i]];
end;

procedure TFormSettings.ActionFolderResetExecute(Sender: TObject);
begin
  GridFoldersTableView.Controller.FocusedRecord.Values[1] := TranslationManagerSettings.Folders.FolderDefault[FolderOrder[GridFoldersTableView.Controller.FocusedRecord.Index]];
end;

procedure TFormSettings.ActionFolderResetUpdate(Sender: TObject);
begin
  // BUGBUGBUG: Short circuit boolean evaluation doesn't work when second value is a variant...
  // Above isn't relevant anymore, but keeping it for future reference

  TAction(Sender).Enabled := (GridFoldersTableView.Controller.FocusedRecord <> nil);
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionFoldersExplorerExecute(Sender: TObject);
var
  Folder: string;
resourcestring
  sCreateFileLocationPath = 'The specified folder does not exist.'+#13#13+'Would you like to create the folder now?';
begin
  Folder := EnvironmentVars.ExpandString(VarToStr(GridFoldersTableView.Controller.FocusedRecord.Values[1]));

  if (Folder = '') then
    Exit;

  if (not TDirectory.Exists(Folder)) then
  begin
    if (MessageDlg(sCreateFileLocationPath, mtConfirmation, mbYesNo, -1) <> mrYes) then
      Exit;

    try

      TDirectory.CreateDirectory(Folder);

    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        Exit;
      end;
    end;
  end;

  Shell.DisplayFile(Folder, Self)
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionFoldersModifyExecute(Sender: TObject);
var
  Path: string;
  Title: string;
  FileOpenDialog: TFileOpenDialog;
begin
  Title := VarToStr(GridFoldersTableView.Controller.FocusedRecord.Values[0]);
  Path := EnvironmentVars.ExpandString(VarToStr(GridFoldersTableView.Controller.FocusedRecord.Values[1]));

(*
  if (CheckWin32Version(6, 0)) then
  begin
*)
    // Select folder using IFileDialog on Vista+
    FileOpenDialog := TFileOpenDialog.Create(nil);
    try
      FileOpenDialog.Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
      FileOpenDialog.DefaultFolder := ExtractFilePath(ExcludeTrailingPathDelimiter(Path));
      FileOpenDialog.FileName := ExtractFileName(ExcludeTrailingPathDelimiter(Path));
      if (not FileOpenDialog.Execute(Handle)) then
        exit;
      Path := FileOpenDialog.FileName;
    finally
      FileOpenDialog.Free;
    end;
(*
  end else
  begin
    // Select folder using SHBrowseForFolder on XP
    if (not SelectDirectory(Title, '', Path, [sdNewUI, sdNewFolder, sdShowEdit, sdValidateDir], Self)) then
      exit;
  end;
*)

  GridFoldersTableView.Controller.FocusedRecord.Values[1] := EnvironmentVars.TokenizeString(Path);
end;

procedure TFormSettings.ActionFoldersModifyUpdate(Sender: TObject);
var
  b: boolean;
  v: Variant;
begin
  // BUGBUGBUG: Short circuit boolean evaluation doesn't work when second value is a variant...
  b := (GridFoldersTableView.Controller.FocusedRecord <> nil);
  if (b) then
  begin
    v := GridFoldersTableView.Controller.FocusedRecord.Values[2];
    if (not VarIsNull(v)) then
      b := (not v);
  end;
  TAction(Sender).Enabled := b;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ButtonCategoryEnter(Sender: TObject);
begin
  TcxButton(Sender).Action.Execute;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.ActionProofingAddExecute(Sender: TObject);
var
  Item: TListItem;
begin
  FSpellCheckerAutoCorrectOptions.Replacements.Add(EditProofingAutoCorrectReplacementFrom.Text, EditProofingAutoCorrectReplacementTo.Text);

  ListViewProofingAutoCorrectReplacements.Items.BeginUpdate;
  try
    Item := ListViewProofingAutoCorrectReplacements.Items.Add;
    Item.Caption := EditProofingAutoCorrectReplacementFrom.Text;
    Item.SubItems.Add(EditProofingAutoCorrectReplacementTo.Text);
    Item.Selected := True;
  finally
    ListViewProofingAutoCorrectReplacements.Items.EndUpdate;
  end;
end;

procedure TFormSettings.ActionProofingAddUpdate(Sender: TObject);
var
  Replacement: TdxSpellCheckerReplacement;
begin
  Replacement := FSpellCheckerAutoCorrectOptions.Replacements.FindReplacement(EditProofingAutoCorrectReplacementFrom.Text);
  TAction(Sender).Enabled := (EditProofingAutoCorrectReplacementFrom.Text <> '') and (Replacement = nil);
end;

procedure TFormSettings.ButtonProofingAutoCorrectExceptionsClick(Sender: TObject);
var
  Dialog: TdxCustomSpellCheckerAutoCorrectForm;
begin
  Dialog := dxSpellCheckerAutoCorrectExceptionsDialogClass.CreateEx(FSpellCheckerAutoCorrectOptions);
  try
    SetControlLookAndFeel(Dialog, nil);

    if (Dialog.ShowModal <> mrOK) then
      exit;

  finally
    Dialog.Free;
  end;
end;

procedure TFormSettings.ActionProofingDeleteExecute(Sender: TObject);
var
  Item: TListItem;
  Replacement: TdxSpellCheckerReplacement;
begin
  Replacement := FSpellCheckerAutoCorrectOptions.Replacements.FindReplacement(EditProofingAutoCorrectReplacementFrom.Text);
  ASSERT(Replacement <> nil);
  FSpellCheckerAutoCorrectOptions.Replacements.Remove(Replacement);

  ListViewProofingAutoCorrectReplacements.Items.BeginUpdate;
  try
    for Item in ListViewProofingAutoCorrectReplacements.Items do
      if (AnsiSameText(EditProofingAutoCorrectReplacementFrom.Text, Item.Caption)) then
      begin
        Item.Free;
        break;
      end;
  finally
    ListViewProofingAutoCorrectReplacements.Items.EndUpdate;
  end;
end;

procedure TFormSettings.ActionProofingDeleteUpdate(Sender: TObject);
var
  Replacement: TdxSpellCheckerReplacement;
begin
  Replacement := FSpellCheckerAutoCorrectOptions.Replacements.FindReplacement(EditProofingAutoCorrectReplacementFrom.Text);
  TAction(Sender).Enabled := (EditProofingAutoCorrectReplacementFrom.Text <> '') and (Replacement <> nil);
end;

procedure TFormSettings.ActionProofingReplaceExecute(Sender: TObject);
var
  Item: TListItem;
  Replacement: TdxSpellCheckerReplacement;
begin
  Replacement := FSpellCheckerAutoCorrectOptions.Replacements.FindReplacement(EditProofingAutoCorrectReplacementFrom.Text);
  ASSERT(Replacement <> nil);
  Replacement.ChangeReplacement(EditProofingAutoCorrectReplacementTo.Text);

  ListViewProofingAutoCorrectReplacements.Items.BeginUpdate;
  try
    for Item in ListViewProofingAutoCorrectReplacements.Items do
      if (AnsiSameText(EditProofingAutoCorrectReplacementFrom.Text, Item.Caption)) then
      begin
        Item.Caption := Replacement.Text;
        Item.SubItems[0] := Replacement.Replacement;
        break;
      end;
  finally
    ListViewProofingAutoCorrectReplacements.Items.EndUpdate;
  end;
end;

procedure TFormSettings.ActionProofingReplaceUpdate(Sender: TObject);
var
  Replacement: TdxSpellCheckerReplacement;
begin
  Replacement := FSpellCheckerAutoCorrectOptions.Replacements.FindReplacement(EditProofingAutoCorrectReplacementFrom.Text);
  TAction(Sender).Enabled := (EditProofingAutoCorrectReplacementFrom.Text <> '') and (Replacement <> nil) and (not AnsiSameText(Replacement.Replacement, EditProofingAutoCorrectReplacementTo.Text));
end;

procedure TFormSettings.ActionProviderTMFilenameExecute(Sender: TObject);
var
  Filename, Path: string;
begin
  Filename := EnvironmentVars.ExpandString(EditProviderTMFilename.Text);
  Filename := PathUtil.PathCombinePath(TranslationManagerSettings.Folders.FolderAppData, Filename);

  if (Filename <> '') then
  begin
    Path := TPath.GetDirectoryName(Filename);
    Filename := TPath.GetFileName(Filename);
  end else
    Path := TranslationManagerSettings.Folders.FolderAppData;

  if (not PromptForFileName(Filename, '', '', '', Path)) then
    Exit;

  Filename := EnvironmentVars.TokenizeString(Filename);
  EditProviderTMFilename.Text := Filename;
end;

procedure TFormSettings.LayoutCheckBoxItemSynthesizeClick(Sender: TObject);
begin
  LayoutGroupSynthesize.Enabled := LayoutCheckBoxItemSynthesize.Checked;
end;

procedure TFormSettings.LayoutGroupTranslatorTMCheckBoxStateChanged(Sender: TObject);
begin
  // Enabling the TM breaks the TM lookup for some reason, so we need a restart to get it working again.
  // TODO : todo-marker to flag that this is a known problem
  if (LayoutGroupTranslatorTM.ButtonOptions.CheckBox.Checked) then
    RequireRestart;
end;

procedure TFormSettings.ListViewProofingAutoCorrectReplacementsClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := ListViewProofingAutoCorrectReplacements.Selected;
  if (Item = nil) then
    exit;

  EditProofingAutoCorrectReplacementFrom.Text := Item.Caption;
  if (Item.SubItems.Count > 0) then
    EditProofingAutoCorrectReplacementTo.Text := Item.SubItems[0];
end;

procedure TFormSettings.ButtonProofingEditCustomDictionaryClick(Sender: TObject);
begin
  dxShowCustomDictionaryDialog(FSpellChecker.FindFirstEnabledUserDictionary);
end;

procedure TFormSettings.ButtonRegisterFiletypesClick(Sender: TObject);
resourcestring
  sFileTypeRegistrationSuccess = 'The translation manager file types are now registered.';
  sFileTypeRegistrationError = 'The translation manager file types could not be registered:'+#13+'%s'+#13#13+'Please run %s with administrative privileges and try again';
begin
  SaveCursor(crHourGlass);
  try
    TranslationManagerShell.RegisterShellIntegration;

    // Register COM server.
    // ComServer.UpdateRegistry(True);

    MessageDlg(sFileTypeRegistrationSuccess, mtInformation, [mbOk], 0);
  except
    on E: Exception do
      MessageDlg(Format(sFileTypeRegistrationError, [E.Message, TPath.GetFileNameWithoutExtension(Application.ExeName)]), mtError, [mbOK], 0);
  end;
end;

procedure TFormSettings.CheckBoxPortableClick(Sender: TObject);
begin
  RequireRestart;
end;

procedure TFormSettings.CheckBoxProofingAutoCorrectPropertiesChange(Sender: TObject);
begin
  LayoutGroupProofingAutoCorrect.Enabled := TcxCheckBox(Sender).Checked;
end;

procedure TFormSettings.CheckBoxSingleInstancePropertiesChange(Sender: TObject);
begin
  RequireRestart;
end;

procedure TFormSettings.ComboBoxApplicationLanguagePropertiesEditValueChanged(Sender: TObject);
begin
  RequireRestart;
end;

procedure TFormSettings.ComboBoxAutoApplyTranslationsPropertiesChange(Sender: TObject);
begin
  LayoutGroupAutoApplyTranslations.Enabled := (TTranslationAutoApply(ComboBoxAutoApplyTranslations.ItemIndex) <> aaNever);
end;

procedure TFormSettings.EditProofingAutoCorrectReplacementFromPropertiesChange(Sender: TObject);
var
  i: integer;
  Selected: integer;
begin
  Selected := -1;
  for i := 0 to ListViewProofingAutoCorrectReplacements.Items.Count-1 do
    if (AnsiSameText(ListViewProofingAutoCorrectReplacements.Items[i].Caption, EditProofingAutoCorrectReplacementFrom.Text)) then
    begin
      Selected := i;
      break;
    end;

  ListViewProofingAutoCorrectReplacements.ItemIndex := Selected;

  if (ListViewProofingAutoCorrectReplacements.Selected <> nil) then
    ButtonProofingAutoCorrectAdd.Action := ActionProofingReplace
  else
    ButtonProofingAutoCorrectAdd.Action := ActionProofingAdd;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.EditTranslatorDeepLAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  TranslationProvider: ITranslationProviderDeepL;
  ErrorMessage: string;
begin
  EditTranslatorDeepLAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 0;

  TranslationProvider := TTranslationProviderDeepL.Create;
  try

    if (TranslationProvider.ValidateAPIKey(EditTranslatorDeepLAPIKey.Text, ActionProviderDeepLLicensePro.Checked, ErrorMessage)) then
    begin
      EditTranslatorDeepLAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 1;
      MessageDlg(sTranslatorAPIKeyValid, mtInformation, [mbOK], 0);
    end else
      MessageDlg(Format(sTranslatorAPIKeyInvalid, [ErrorMessage]), mtWarning, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;

end;

procedure TFormSettings.EditTranslatorDeepLAPIKeyPropertiesChange(Sender: TObject);
begin
  // API key no longer validated
  EditTranslatorDeepLAPIKey.Properties.Buttons[0].ImageIndex := 0;
end;

// -----------------------------------------------------------------------------
//
// Ollama provider handlers
//
// -----------------------------------------------------------------------------

procedure TFormSettings.EditOllamaBaseURLPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  TranslationProvider: ITranslationProviderOllama;
  ErrorMessage: string;
begin
  EditOllamaBaseURL.Properties.Buttons[AButtonIndex].ImageIndex := 0;

  SaveCursor(crAppStart);

  TranslationProvider := TTranslationProviderOllama.Create(Self);
  try
    if TranslationProvider.ValidateConnection(ErrorMessage) then
    begin
      EditOllamaBaseURL.Properties.Buttons[AButtonIndex].ImageIndex := 1;
      MessageDlg('Successfully connected to Ollama server.', mtInformation, [mbOK], 0);
    end else
      MessageDlg(Format('Connection failed: %s', [ErrorMessage]), mtWarning, [mbOK], 0);
  finally
    TranslationProvider := nil;
  end;
end;

// -----------------------------------------------------------------------------
//
// Gemini provider handlers
//
// -----------------------------------------------------------------------------

procedure TFormSettings.EditGeminiAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  TranslationProvider: ITranslationProviderGemini;
  ErrorMessage: string;
begin
  EditGeminiAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 0;

  SaveCursor(crAppStart);

  TranslationProvider := TTranslationProviderGemini.Create(Self);
  try
    if TranslationProvider.ValidateAPIKey(EditGeminiAPIKey.Text, ErrorMessage) then
    begin
      EditGeminiAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 1;
      MessageDlg('Successfully validated Gemini API Key.', mtInformation, [mbOK], 0);
    end else
      MessageDlg(Format('Validation failed: %s', [ErrorMessage]), mtWarning, [mbOK], 0);
  finally
    TranslationProvider := nil;
  end;
end;

procedure TFormSettings.EditGeminiAPIKeyPropertiesChange(Sender: TObject);
begin
  // API Key no longer validated
  EditGeminiAPIKey.Properties.Buttons[0].ImageIndex := 0;
end;

procedure TFormSettings.ActionGeminiDetectModelsExecute(Sender: TObject);
begin
  if GetGeminiAPIKey.Trim.IsEmpty then
  begin
    MessageDlg('Please enter the Gemini API Key first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  var TranslationProvider: ITranslationProviderGemini := TTranslationProviderGemini.Create(Self);
  try
    SaveCursor(crHourGlass);

    var CurrentModel := ComboBoxGeminiModel.Text;
    var ErrorMessage: string;

    if (TranslationProvider.GetModels(ComboBoxGeminiModel.Properties.Items, ErrorMessage)) then
    begin
      // Try to restore previous selection
      if (CurrentModel <> '') and (ComboBoxGeminiModel.Properties.Items.IndexOf(CurrentModel) >= 0) then
        ComboBoxGeminiModel.Text := CurrentModel
      else
        ComboBoxGeminiModel.ItemIndex := 0;
    end else
      MessageDlg(Format('Failed to detect models: %s', [ErrorMessage]), mtError, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;
end;

procedure TFormSettings.ActionGeminiHasKeyUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := not GetGeminiAPIKey.Trim.IsEmpty;
end;

procedure TFormSettings.ActionGeminiTestExecute(Sender: TObject);
begin
  if GetGeminiAPIKey.Trim.IsEmpty then
  begin
    MessageDlg('Please enter the Gemini API Key first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if GetGeminiModelName.Trim.IsEmpty then
  begin
    MessageDlg('Please select or enter a model name first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  SaveCursor(crHourGlass);

  var TranslationProvider: ITranslationProviderGemini := TTranslationProviderGemini.Create(Self);
  try
    var AllTestsPassed := True;
    var ErrorMessage: string;

    // Test 1: API Key validation
    if not TranslationProvider.ValidateAPIKey(GetGeminiAPIKey, ErrorMessage) then
    begin
      MessageDlg(Format('API Key validation failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end else

    // Test 2: Model validation
    if not TranslationProvider.ValidateModel(ErrorMessage) then
    begin
      MessageDlg(Format('Model validation failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end else

    // Test 3: Translation test
    if not TranslationProvider.TestTranslation(ErrorMessage) then
    begin
      MessageDlg(Format('Translation test failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end;

    if AllTestsPassed then
      MessageDlg('All tests passed successfully!' + #13#10 +
                 '- API Key: OK' + #13#10 +
                 '- Model available: OK' + #13#10 +
                 '- Translation: OK', mtInformation, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;
end;

procedure TFormSettings.EditOllamaBaseURLPropertiesChange(Sender: TObject);
begin
  // URL no longer validated
  EditOllamaBaseURL.Properties.Buttons[0].ImageIndex := 0;
end;

procedure TFormSettings.ActionOllamaDetectModelsExecute(Sender: TObject);
begin
  if GetOllamaBaseURL.Trim.IsEmpty then
  begin
    MessageDlg('Please enter the Ollama Base URL first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  var TranslationProvider: ITranslationProviderOllama := TTranslationProviderOllama.Create(Self);
  try
    SaveCursor(crHourGlass);

    var CurrentModel := ComboBoxOllamaModel.Text;
    var ErrorMessage: string;

    if (TranslationProvider.GetModels(ComboBoxOllamaModel.Properties.Items, ErrorMessage)) then
    begin
      // Try to restore previous selection
      if (CurrentModel <> '') and (ComboBoxOllamaModel.Properties.Items.IndexOf(CurrentModel) >= 0) then
        ComboBoxOllamaModel.Text := CurrentModel
      else
        ComboBoxOllamaModel.ItemIndex := 0;
    end else
      MessageDlg('Invalid JSON response from Ollama server.', mtError, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;
end;

procedure TFormSettings.ActionOllamaTestExecute(Sender: TObject);
begin
  if GetOllamaBaseURL.Trim.IsEmpty then
  begin
    MessageDlg('Please enter the Ollama Base URL first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if GetOllamaModelName.Trim.IsEmpty then
  begin
    MessageDlg('Please select or enter a model name first.', mtWarning, [mbOK], 0);
    Exit;
  end;

  SaveCursor(crHourGlass);

  var TranslationProvider: ITranslationProviderOllama := TTranslationProviderOllama.Create(Self);
  try
    var AllTestsPassed := True;
    var ErrorMessage: string;

    // Test 1: Connection
    if not TranslationProvider.ValidateConnection(ErrorMessage) then
    begin
      MessageDlg(Format('Connection test failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end else

    // Test 2: Model validation
    if not TranslationProvider.ValidateModel(ErrorMessage) then
    begin
      MessageDlg(Format('Model validation failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end else

    // Test 3: Translation test
    if not TranslationProvider.TestTranslation(ErrorMessage) then
    begin
      MessageDlg(Format('Translation test failed: %s', [ErrorMessage]), mtError, [mbOK], 0);
      AllTestsPassed := False;
    end;

    if AllTestsPassed then
      MessageDlg('All tests passed successfully!' + #13#10 +
                 '- Connection: OK' + #13#10 +
                 '- Model available: OK' + #13#10 +
                 '- Translation: OK', mtInformation, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_TAB) and (ssCtrl in Shift) then
  begin
    Key := 0;
    if (ssShift in Shift) then
      LayoutGroupCategories.ItemIndex := (LayoutGroupCategories.ItemIndex + LayoutGroupCategories.VisibleCount - 1) mod LayoutGroupCategories.VisibleCount
    else
      LayoutGroupCategories.ItemIndex := (LayoutGroupCategories.ItemIndex + 1) mod LayoutGroupCategories.VisibleCount;
  end else
(*
  if (Key = VK_F1) and (Shift = [ssAlt]) then
  begin
    Key := 0;
    LayoutControlGroupDevelopment.Visible := True;
  end else
*)
    inherited;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.PopulateColorSchemes(Items: TcxImageComboBoxItems);

  procedure ApplyColor(Bitmap: TBitmap; Color: TColor);
  begin
    // ARGB -> ABGR
    var Temp := TColorRec(Color).R;
    TColorRec(Color).R := TColorRec(Color).B;
    TColorRec(Color).B := Temp;

    // Keep alpha but replace color
    for var Row := 0 to Bitmap.Height-1 do
    begin
      var Pixel: PDWORD := Bitmap.ScanLine[Row];
      for var x := 0 to Bitmap.Width-1 do
      begin
        Pixel^ := (Pixel^ and $FF000000) or (DWORD(Color) and $00FFFFFF);
        Inc(Pixel);
      end;
    end;
  end;

  function Clamp(const Value: Integer): Integer; inline;
  begin
    Result := Value;
    if Result > 255 then
      Result := 255
    else
    if Result < 0 then
      Result := 0;
  end;

  procedure Blend(Foreground: TColorRec; var Background: TColorRec);
  const
    OneOver255: Single = 1 / 255;
  begin
    if Foreground.A = 0 then
      Exit;

    if Foreground.A = $FF then
    begin
      Background := Foreground;
      Exit;
    end;

    var ScaleFG := Foreground.A * OneOver255;
    var ScaleBG := 1.0 - ScaleFG;
    Background.A := Clamp(Round(ScaleBG * Background.A + ScaleFG * Foreground.A));
    Background.R := Clamp(Round(ScaleBG * Background.R + ScaleFG * Foreground.R));
    Background.G := Clamp(Round(ScaleBG * Background.G + ScaleFG * Foreground.G));
    Background.B := Clamp(Round(ScaleBG * Background.B + ScaleFG * Foreground.B));
  end;

  procedure BlendBitmap(Target, Source: TBitmap);
  begin
    Assert(Target.Height = Source.Height);
    Assert(Target.Width = Source.Width);

    // Blend one bitmap onto another.
    // True alpha composition blend, not merge. Target alpha is maintained.
    for var Row := 0 to Target.Height-1 do
    begin
      var TargetPixel: PColorRec := Target.ScanLine[Row];
      var SourcePixel: PColorRec := Source.ScanLine[Row];
      for var x := 0 to Target.Width-1 do
      begin
        Blend(SourcePixel^, TargetPixel^);
        Inc(TargetPixel);
        Inc(SourcePixel);
      end;
    end;
  end;

begin
  Items.BeginUpdate;
  try
    ImageListColorSchemesSmall.Clear;
    ImageListColorSchemesLarge.Clear;
    Items.Clear;

    if (ImageComboBoxSkin.ItemIndex = -1) then
      exit;

    // Create a list of color schemes and sort it by light/dark and then by hue
    var ColorSchemes := TList<PSkinColorScheme>.Create;
    try
      for var i := 0 to High(FSkinList[ImageComboBoxSkin.ItemIndex].ColorSchemes) do
      begin
        var ColorScheme: PSkinColorScheme := @FSkinList[ImageComboBoxSkin.ItemIndex].ColorSchemes[i];
        ColorSchemes.Add(ColorScheme);
      end;

      ColorSchemes.Sort(TComparer<PSkinColorScheme>.Construct(
        function(const A, B: PSkinColorScheme): integer
        begin
          Result := Ord(A.Dark) - Ord(B.Dark);
          if (Result = 0) then
            Result := Ord(A.Hue) - Ord(B.Hue);
          if (Result = 0) then
            Result := Ord(A.Lightness) - Ord(B.Lightness);
        end));

      var Preview := TBitmap.Create;
      var Overlay := TBitmap.Create;
      try
        Preview.SetSize(ImageListColorSchemePreview.Width, ImageListColorSchemePreview.Height);
        Preview.PixelFormat := pf32bit;
        Overlay.SetSize(ImageListColorSchemePreview.Width, ImageListColorSchemePreview.Height);
        Overlay.PixelFormat := pf32bit;

        for var ColorScheme in ColorSchemes do
        begin
          var Item := Items.Add;
          Item.Value := ColorScheme.Name;
          Item.Description := ColorScheme.Name;
          Item.Tag := ColorScheme.Index;
          if (AnsiSameText(ColorScheme.Name, sdxDefaultColorPaletteName)) then
            Item.Index := 0;

          // Construct color scheme preview image
          ImageListColorSchemePreview.GetImage(0, Preview);
          ApplyColor(Preview, ColorScheme.PreviewColors[pcFrame]);

          ImageListColorSchemePreview.GetImage(1, Overlay);
          ApplyColor(Overlay, ColorScheme.PreviewColors[pcWindow]);
          BlendBitmap(Preview, Overlay);

          ImageListColorSchemePreview.GetImage(2, Overlay);
          ApplyColor(Overlay, ColorScheme.PreviewColors[pcText]);
          BlendBitmap(Preview, Overlay);

          ImageListColorSchemePreview.GetImage(3, Overlay);
          ApplyColor(Overlay, ColorScheme.PreviewColors[pcSelect]);
          BlendBitmap(Preview, Overlay);

          Item.ImageIndex := ImageListColorSchemesSmall.Add(Preview, nil);
          ImageListColorSchemesLarge.Add(Preview, nil);
        end;

      finally
        Overlay.Free;
        Preview.Free;
      end;
    finally
      ColorSchemes.Free;
    end;

  finally
    Items.EndUpdate;
  end;
end;

procedure TFormSettings.PopulateSkins;

  function RGB2Hue(Color: TColorRec): integer;
  begin
    var RGBMin := Min(Color.R, Min(Color.G, Color.B));
    var RGBMax:= Max(Color.R, Max(Color.G, Color.B));

    if (RGBMin = RGBMax) then
      Exit(0);

    var Hue: Single;

    if (RGBMax = Color.R) then
      Hue := (Color.G - Color.B) / (RGBMax - RGBMin)
    else
    if (RGBMax = Color.G) then
      Hue := 2.0 + (Color.B - Color.R) / (RGBMax - RGBMin)
    else
      Hue := 4.0 + (Color.R - Color.G) / (RGBMax - RGBMin);

    Hue := Hue * 60;
    if (Hue < 0) then
      Hue := Hue + 360;

    Result := Round(Hue);
  end;

  function RGB2Lightness(Color: TColorRec): integer;
  begin
    var RGBMin := Min(Color.R, Min(Color.G, Color.B));
    var RGBMax:= Max(Color.R, Max(Color.G, Color.B));

    Result := (RGBMin + RGBMax) div 2;
  end;

  function LoadSkinDetails(Skin: TdxSkin; DevExSkinDetails: TdxSkinDetails; var ASkinDetails: TSkinDetails): boolean; overload;

    procedure AddColor(Palette: TdxSkinColorPalette; Colors: TList<TColor>; const Name: string);
    var
      ColorProperty: TdxSkinColor;
    begin
      if (Palette.Find(Name, ColorProperty)) then
        Colors.Add(ColorProperty.Value);
    end;

    function ResolvePaletteColor(Palette: TdxSkinColorPalette; const Name: string; Default: TColor): TColor;
    var
      ColorProperty: TdxSkinColor;
    begin
      if (Palette.Find(Name, ColorProperty)) then
        Result := ColorProperty.Value
      else
        Result := Default;
    end;

  var
    PreviewColors: array[TPreviewColors] of record
      Reference: string;
      Color: TColor;
    end;

  begin
    ASkinDetails.Index := -1;
    ASkinDetails.Name := DevExSkinDetails.Name;
    ASkinDetails.DisplayName := DevExSkinDetails.DisplayName;
    ASkinDetails.Group := DevExSkinDetails.GroupName;
    ASkinDetails.GlyphSmall := DevExSkinDetails.Icons[sis16].GetAsBitmap;
    ASkinDetails.GlyphLarge := DevExSkinDetails.Icons[sis48].GetAsBitmap;

    // Get skin color names for preview
    begin
      var SkinGroup := Skin.GetGroupByName('Ribbon');

      var SkinElement := SkinGroup.GetElementByName('FormCaption');
      PreviewColors[pcFrame].Reference := SkinElement.ColorReference;
      PreviewColors[pcFrame].Color := SkinElement.Color;

      SkinElement := SkinGroup.GetElementByName('FormContent');
      PreviewColors[pcWindow].Reference := SkinElement.ColorReference;
      PreviewColors[pcWindow].Color := SkinElement.Color;
      PreviewColors[pcText].Reference := SkinElement.TextColorReference;
      PreviewColors[pcText].Color := SkinElement.TextColor;

      var Color := Skin.GetColorByName('SelectionColor');
      PreviewColors[pcSelect].Reference := Color.ValueReference;
      PreviewColors[pcSelect].Color := Color.Value;
    end;

    // Get selected palette colors
    SetLength(ASkinDetails.ColorSchemes, Skin.ColorPalettes.Count);
    for var i := 0 to Skin.ColorPalettes.Count-1 do
    begin
      var Palette := Skin.ColorPalettes[i];

      ASkinDetails.ColorSchemes[i].Name := Palette.Name;
      ASkinDetails.ColorSchemes[i].Index := i;

      // Resolve skin colors for preview
      for var PreviewColor := Low(TPreviewColors) to High(TPreviewColors) do
        ASkinDetails.ColorSchemes[i].PreviewColors[PreviewColor] := ResolvePaletteColor(Palette, PreviewColors[PreviewColor].Reference, PreviewColors[PreviewColor].Color);

      // Calculate hue and light/dark so we can order the list by it later
      ASkinDetails.ColorSchemes[i].Hue := (RGB2Hue(TColorRec(ASkinDetails.ColorSchemes[i].PreviewColors[pcFrame])) + 16) div 32;
      ASkinDetails.ColorSchemes[i].Lightness := RGB2Lightness(TColorRec(ASkinDetails.ColorSchemes[i].PreviewColors[pcFrame]));
      ASkinDetails.ColorSchemes[i].Dark := RGB2Lightness(TColorRec(ASkinDetails.ColorSchemes[i].PreviewColors[pcWindow])) < RGB2Lightness(TColorRec(ASkinDetails.ColorSchemes[i].PreviewColors[pcText]));

      // Create a list of unique colors samples
      var Colors := TList<TColor>.Create;
      try
        AddColor(Palette, Colors, 'White');
        AddColor(Palette, Colors, 'Black');
        AddColor(Palette, Colors, 'Paint High');
        AddColor(Palette, Colors, 'Paint');
        AddColor(Palette, Colors, 'Paint Shadow');
        AddColor(Palette, Colors, 'Brush');
        AddColor(Palette, Colors, 'Accent Brush');
        AddColor(Palette, Colors, 'Accent Brush Light');
        AddColor(Palette, Colors, 'Accent Paint');
        AddColor(Palette, Colors, 'Accent Paint Light');
        AddColor(Palette, Colors, 'Key Brush');
        AddColor(Palette, Colors, 'Key Brush Light');
        AddColor(Palette, Colors, 'Key Paint');

(*
        for var j := 0 to Skin.ColorPalettes[i].Count-1 do
        begin
          var Color := Skin.ColorPalettes[i].Items[j].Value;
          var Index: integer;
          if (not Colors.BinarySearch(Color, Index)) then
            Colors.Insert(Index, Color);
        end;
        // Sort colors by Hue (this is extremely slow but since we know that there
        // are only a few handfulls of colors it's safe to do).
        Colors.Sort(TComparer<TColor>.Construct(
            function (const Item1, Item2: TColor): Integer
            begin
              if (Item1 = Item2) then
                Exit(0);
              var Hue1 := RGB2Hue(TColorRec(Item1));
              var Hue2 := RGB2Hue(TColorRec(Item2));
              Result := (Hue1 - Hue2);
            end));
*)
        SetLength(ASkinDetails.ColorSchemes[i].Colors, Colors.Count);
        for var j := 0 to Colors.Count-1 do
          ASkinDetails.ColorSchemes[i].Colors[j] := Colors[j];
      finally
        Colors.Free;
      end;
    end;

    Result := True;
  end;

  function LoadSkinDetails(Skin: TdxSkin; var ASkinDetails: TSkinDetails): boolean; overload;
  begin
    var DevExSkinDetails: TdxSkinDetails;
    if (not TdxSkinRibbonPainter(Skin).Painter.GetPainterDetails(DevExSkinDetails)) then
      Exit(False);

    Result := LoadSkinDetails(Skin, DevExSkinDetails, ASkinDetails);
  end;

begin
  FSkinList.Clear;
  try

    for var i := 0 to cxLookAndFeelPaintersManager.Count-1 do
    begin
      var SkinInfo: TdxSkinInfo;
      if (cxLookAndFeelPaintersManager.Items[i].GetPainterData(SkinInfo)) then
      begin
        var SkinDetails: TSkinDetails;
        if (LoadSkinDetails(SkinInfo.Skin, SkinInfo.Skin.Details, SkinDetails)) then
          FSkinList.Add(SkinDetails);
      end;
    end;

    FSkinList.Sort(TComparer<TSkinDetails>.Construct(function(const Left, Right: TSkinDetails): Integer
      begin
        Result := CompareText(Left.Group, Right.Group);
        if (Result = 0) then
          Result := CompareText(Left.DisplayName, Right.DisplayName);
      end));

    ImageComboBoxSkin.Properties.Items.Clear;
    ImageListSkin.Clear;
    ImageListSkinLarge.Clear;
    for var SkinDetails in FSkinList do
    begin
      var Item := ImageComboBoxSkin.Properties.Items.Add;
      Item.Value := SkinDetails.Name;
      Item.Description := SkinDetails.DisplayName;
      // Add small glyph (displayed in combo edit)
      ImageListSkin.Add(SkinDetails.GlyphSmall, nil);
      // Add large glyph (displayed in combo drop down)
      Item.ImageIndex := ImageListSkinLarge.Add(SkinDetails.GlyphLarge, nil);
    end;

  finally
    for var i := 0 to FSkinList.Count-1 do
    begin
      var SkinDetails := FSkinList[i];
      FreeAndNil(SkinDetails.GlyphSmall);
      FreeAndNil(SkinDetails.GlyphLarge);
    end;
  end;
end;

procedure TFormSettings.RequireRestart;
begin
  if (not Visible) then
    exit;

  FRestartRequired := True;
  LayoutItemRestart.Visible := True;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.TextEditTranslatorMSAPIKeyPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var
  TranslationProvider: ITranslationProviderMicrosoftV3;
  ErrorMessage: string;
begin
  EditTranslatorMSAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 0;

  TranslationProvider := TTranslationProviderMicrosoftV3.Create(nil);
  try

    if (TranslationProvider.ValidateAPIKey(EditTranslatorMSAPIKey.Text, EditTranslatorMSAPIRegion.Text, ErrorMessage)) then
    begin
      EditTranslatorMSAPIKey.Properties.Buttons[AButtonIndex].ImageIndex := 1;
      MessageDlg(sTranslatorAPIKeyValid, mtInformation, [mbOK], 0);
    end else
      MessageDlg(Format(sTranslatorAPIKeyInvalid, [ErrorMessage]), mtWarning, [mbOK], 0);

  finally
    TranslationProvider := nil;
  end;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.TextEditTranslatorMSAPIKeyPropertiesChange(Sender: TObject);
begin
  // API key no longer validated
  EditTranslatorMSAPIKey.Properties.Buttons[0].ImageIndex := 0;
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.LoadFolders;
var
  i: integer;
begin
  GridFoldersTableView.DataController.BeginUpdate;
  try
    for i := Low(FolderOrder) to High(FolderOrder) do
      GridFoldersTableView.DataController.Values[i, 1] := TranslationManagerSettings.Folders.Folder[FolderOrder[i]];
  finally
    GridFoldersTableView.DataController.EndUpdate;
  end;
end;

procedure TFormSettings.ApplyFolders;
var
  i: integer;
begin
  for i := Low(FolderOrder) to High(FolderOrder) do
    if (not TranslationManagerSettings.Folders.FolderReadOnly[FolderOrder[i]]) then
      TranslationManagerSettings.Folders.Folder[FolderOrder[i]] := EnvironmentVars.TokenizeString(VarToStr(GridFoldersTableView.DataController.Values[i, 1]));
end;

// -----------------------------------------------------------------------------

procedure TFormSettings.LoadProofing(SpellChecker: TdxSpellChecker);

  function GetDictionaryLanguage(ADictionary: TdxCustomSpellCheckerDictionary): LCID;
  begin
    Result := ADictionary.Language;
    if (Result = 0) then
      // We do not use dxLanguages.GetDefaultLanguageLCID as that returns the
      // system default instead of the user default.
      Result := LanguageInfo.DefaultLocale.LocaleID;
  end;

  procedure PopulateLanguages;
  var
    I, J: Integer;
    List: TStringList;
    Item: TcxCheckComboBoxItem;
    ADictionary: TdxCustomSpellCheckerDictionary;
  begin
    List := TStringList.Create;
    try
      SpellChecker.PopulateLanguages(List);

      ComboBoxProofingLanguages.Value := 0;
      ComboBoxProofingLanguages.Properties.Items.BeginUpdate;
      try
        ComboBoxProofingLanguages.Properties.Items.Clear;

        Item := ComboBoxProofingLanguages.Properties.Items.Add;
        Item.Description := 'Auto (use project language)';
        Item.Tag := -1;

        for I := 0 to List.Count - 1 do
        begin
          Item := ComboBoxProofingLanguages.Properties.Items.Add;
          Item.Description := List[I];
          Item.Tag := Cardinal(List.Objects[I]);

          for J := 0 to SpellChecker.DictionaryCount - 1 do
          begin
            ADictionary := SpellChecker.Dictionaries[J];
            if (ADictionary is TdxUserSpellCheckerDictionary) or (not ADictionary.Enabled) then
              Continue;
            if (GetDictionaryLanguage(ADictionary) = LCID(Item.Tag)) then
            begin
              ComboBoxProofingLanguages.States[I] := cbsChecked;
              Break;
            end;
          end;
        end;
      finally
        ComboBoxProofingLanguages.Properties.Items.EndUpdate;
      end;
    finally
      List.Free;
    end;
  end;

  procedure PopulateReplaces;
  var
    I: Integer;
    Item: TListItem;
    Replacement: TdxSpellCheckerReplacement;
  begin
    FSpellCheckerAutoCorrectOptions.Replacements.Clear;

    ListViewProofingAutoCorrectReplacements.Items.BeginUpdate;
    try
      ListViewProofingAutoCorrectReplacements.Items.Clear;
      for I := 0 to SpellChecker.AutoCorrectOptions.Replacements.Count - 1 do
      begin
        Replacement := SpellChecker.AutoCorrectOptions.Replacements[i];
        FSpellCheckerAutoCorrectOptions.Replacements.Add(Replacement.Text, Replacement.Replacement);

        Item := ListViewProofingAutoCorrectReplacements.Items.Add;
        Item.Caption := Replacement.Text;
        Item.SubItems.Add(Replacement.Replacement);
      end;
    finally
      ListViewProofingAutoCorrectReplacements.Items.EndUpdate;
    end;
  end;

  procedure PopulateExceptions;
  var
    Stream: TStream;
  begin
    Stream := TMemoryStream.Create;
    try
      SpellChecker.AutoCorrectOptions.FirstLetterExceptions.SaveToStream(Stream);
      Stream.Position := 0;
      FSpellCheckerAutoCorrectOptions.FirstLetterExceptions.LoadFromStream(Stream);
      FSpellCheckerAutoCorrectOptions.FirstLetterExceptions.AutoInclude := SpellChecker.AutoCorrectOptions.FirstLetterExceptions.AutoInclude;
      Stream.Size := 0;
      SpellChecker.AutoCorrectOptions.InitialCapsExceptions.SaveToStream(Stream);
      Stream.Position := 0;
      FSpellCheckerAutoCorrectOptions.InitialCapsExceptions.LoadFromStream(Stream);
      FSpellCheckerAutoCorrectOptions.InitialCapsExceptions.AutoInclude := SpellChecker.AutoCorrectOptions.InitialCapsExceptions.AutoInclude;
    finally
      Stream.Free;
    end;
  end;

begin
  CheckBoxProofingSpellCheck.Checked := SpellChecker.CheckAsYouTypeOptions.Active;
  // Note: Assign does not copy member objects
  FSpellCheckerAutoCorrectOptions.Assign(SpellChecker.AutoCorrectOptions);

  CheckBoxProofingIgnoreUppercase.Checked := SpellChecker.SpellingOptions.IgnoreUpperCaseWords;
  CheckBoxProofingIgnoreMixedCase.Checked := SpellChecker.SpellingOptions.IgnoreMixedCaseWords;
  CheckBoxProofingIgnoreRepeatWords.Checked := SpellChecker.SpellingOptions.IgnoreRepeatedWords;
  CheckBoxProofingIgnoreNumbers.Checked := SpellChecker.SpellingOptions.IgnoreWordsWithNumbers;

  CheckBoxProofingAutoCorrect.Checked := FSpellCheckerAutoCorrectOptions.Active;
  CheckBoxProofingCorrectSentenceCaps.Checked := FSpellCheckerAutoCorrectOptions.CorrectSentenceCaps;
  CheckBoxProofingCorrectInitialCaps.Checked := FSpellCheckerAutoCorrectOptions.CorrectInitialCaps;
  CheckBoxProofingCorrectCapsLock.Checked := FSpellCheckerAutoCorrectOptions.CorrectCapsLock;
  CheckBoxProofingDisableCapsLock.Checked := FSpellCheckerAutoCorrectOptions.DisableCapsLock;

  CheckBoxProofingCorrectAutoReplace.Checked := FSpellCheckerAutoCorrectOptions.ReplaceTextAsYouType;
  CheckBoxProofingCorrectAutomaticallyUseSuggestions.Checked := FSpellCheckerAutoCorrectOptions.AutomaticallyUseSuggestions;

//  PopulateLanguages;
  PopulateReplaces;
  PopulateExceptions;
  ButtonProofingEditCustomDictionary.Enabled := (SpellChecker.FindFirstEnabledUserDictionary <> nil);
end;

procedure TFormSettings.ApplyProofing(SpellChecker: TdxSpellChecker);

  function GetDictionaryLanguage(ADictionary: TdxCustomSpellCheckerDictionary): LCID;
  begin
    Result := ADictionary.Language;
    if (Result = 0) then
      Result := LanguageInfo.DefaultLocale.LocaleID;
  end;

  procedure SaveLanguages;
  var
    i, j: Integer;
    Dictionary: TdxCustomSpellCheckerDictionary;
    LocaleID: integer;
  begin
    for i := 0 to ComboBoxProofingLanguages.Properties.Items.Count-1 do
    begin
      for j := 0 to SpellChecker.DictionaryCount-1 do
      begin
        Dictionary := SpellChecker.Dictionaries[j];
        if (Dictionary is TdxUserSpellCheckerDictionary) then
          continue;

        LocaleID := ComboBoxProofingLanguages.Properties.Items[i].Tag;
        if (LocaleID = -1) then
          continue;

        if (GetDictionaryLanguage(Dictionary) = LCID(LocaleID)) then
        begin
          Dictionary.Enabled := (ComboBoxProofingLanguages.States[i] = cbsChecked);
          Break;
        end;
      end;
    end;
  end;

  procedure SaveReplacements;
  begin
    // Note: TdxSpellCheckerAutoCorrectReplacementList is a bastard (poorly designed) object list. Calling Clear will
    // destroy the objects it contains but calling Delete() will not. We misuse this to transfer objects from one list
    // to another.
    SpellChecker.AutoCorrectOptions.Replacements.Clear;
    // Transfer ownership of replacement items
    SpellChecker.AutoCorrectOptions.Replacements.Assign(FSpellCheckerAutoCorrectOptions.Replacements);
    // Remove items without deleting them
    while (FSpellCheckerAutoCorrectOptions.Replacements.Count > 0) do
      FSpellCheckerAutoCorrectOptions.Replacements.Delete(0);
  end;

  procedure SaveExceptions;
  var
    Stream: TStream;
  begin
    Stream := TMemoryStream.Create;
    try
      FSpellCheckerAutoCorrectOptions.FirstLetterExceptions.SaveToStream(Stream);
      Stream.Position := 0;
      SpellChecker.AutoCorrectOptions.FirstLetterExceptions.LoadFromStream(Stream);
      SpellChecker.AutoCorrectOptions.FirstLetterExceptions.AutoInclude := FSpellCheckerAutoCorrectOptions.FirstLetterExceptions.AutoInclude;
      Stream.Size := 0;
      FSpellCheckerAutoCorrectOptions.InitialCapsExceptions.SaveToStream(Stream);
      Stream.Position := 0;
      SpellChecker.AutoCorrectOptions.InitialCapsExceptions.LoadFromStream(Stream);
      SpellChecker.AutoCorrectOptions.InitialCapsExceptions.AutoInclude := FSpellCheckerAutoCorrectOptions.InitialCapsExceptions.AutoInclude;
    finally
      Stream.Free;
    end;
  end;

begin
  SpellChecker.CheckAsYouTypeOptions.Active := CheckBoxProofingSpellCheck.Checked;

  SpellChecker.SpellingOptions.IgnoreUpperCaseWords := CheckBoxProofingIgnoreUppercase.Checked;
  SpellChecker.SpellingOptions.IgnoreMixedCaseWords := CheckBoxProofingIgnoreMixedCase.Checked;
  SpellChecker.SpellingOptions.IgnoreRepeatedWords := CheckBoxProofingIgnoreRepeatWords.Checked;
  SpellChecker.SpellingOptions.IgnoreWordsWithNumbers := CheckBoxProofingIgnoreNumbers.Checked;

  FSpellCheckerAutoCorrectOptions.Active := CheckBoxProofingAutoCorrect.Checked;
  FSpellCheckerAutoCorrectOptions.CorrectSentenceCaps := CheckBoxProofingCorrectSentenceCaps.Checked;
  FSpellCheckerAutoCorrectOptions.CorrectInitialCaps := CheckBoxProofingCorrectInitialCaps.Checked;
  FSpellCheckerAutoCorrectOptions.CorrectCapsLock := CheckBoxProofingCorrectCapsLock.Checked;
  FSpellCheckerAutoCorrectOptions.DisableCapsLock := CheckBoxProofingDisableCapsLock.Checked;

  FSpellCheckerAutoCorrectOptions.ReplaceTextAsYouType := CheckBoxProofingCorrectAutoReplace.Checked;
  FSpellCheckerAutoCorrectOptions.AutomaticallyUseSuggestions := CheckBoxProofingCorrectAutomaticallyUseSuggestions.Checked;

//  SaveLanguages;

  // Note: Assign does not copy member objects
  SpellChecker.AutoCorrectOptions.Assign(FSpellCheckerAutoCorrectOptions);

  SaveReplacements;
  SaveExceptions;

  SpellChecker.LoadDictionaries(True);
end;

// -----------------------------------------------------------------------------

{ TcxButton }

type
  TButtonViewInfo = class(TcxButtonViewInfo)
  public
    procedure Calculate(const ABounds: TRect); override;
  end;

procedure TButtonViewInfo.Calculate(const ABounds: TRect);
begin
  inherited;
  if (TcxButton(Button).Kind = cxbkOfficeDropDown) then
    FDropDownArrowRect := TRect.Empty;
end;

procedure TcxButton.Click;
begin
  inherited;

  if (Kind = cxbkOfficeDropDown) and (Action <> nil) then
    Action.Execute;
end;

function TcxButton.CreateViewInfo: TcxButtonViewInfo;
begin
  Result := TButtonViewInfo.Create(Self);
end;

// -----------------------------------------------------------------------------

initialization
  DialogManager.RegisterDialogClass(IDialogSettings, TFormSettings);
end.
