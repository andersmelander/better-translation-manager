inherited FormSettings: TFormSettings
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = 'Settings'
  ClientHeight = 633
  ClientWidth = 602
  KeyPreview = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  ExplicitWidth = 618
  ExplicitHeight = 672
  TextHeight = 15
  inherited LayoutControlButtons: TdxLayoutControl
    Top = 546
    Width = 602
    Height = 87
    ExplicitTop = 546
    ExplicitWidth = 602
    ExplicitHeight = 87
    inherited ButtonOK: TcxButton
      Left = 432
      ExplicitLeft = 432
    end
    inherited ButtonCancel: TcxButton
      Left = 514
      ExplicitLeft = 514
    end
    inherited LayoutItemButtonOK: TdxLayoutItem
      Index = 1
    end
    inherited LayoutItemButtonCancel: TdxLayoutItem
      Index = 2
    end
    object LayoutItemRestart: TdxLayoutLabeledItem
      Parent = LayoutGroupButtons
      AlignHorz = ahClient
      Visible = False
      CaptionOptions.Glyph.SourceDPI = 96
      CaptionOptions.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C7376672076657273696F6E3D22312E31222069643D224C
        617965725F312220786D6C6E733D22687474703A2F2F7777772E77332E6F7267
        2F323030302F7376672220786D6C6E733A786C696E6B3D22687474703A2F2F77
        77772E77332E6F72672F313939392F786C696E6B2220783D223070782220793D
        22307078222076696577426F783D2230203020333220333222207374796C653D
        22656E61626C652D6261636B67726F756E643A6E657720302030203332203332
        3B2220786D6C3A73706163653D227072657365727665223E262331333B262331
        303B3C7374796C6520747970653D22746578742F637373223E2E59656C6C6F77
        7B66696C6C3A234646423131353B7D3C2F7374796C653E0D0A3C706174682063
        6C6173733D2259656C6C6F772220643D224D32392E372C32362E324C31372C34
        2E38632D302E362D312D312E352D312D322E312C304C332C32362E32632D302E
        362C312D302E322C312E382C312C312E386832342E374332392E382C32382C33
        302E332C32372E322C32392E372C32362E327A20202623393B204D31362C3236
        632D312E312C302D322D302E392D322D3273302E392D322C322D3273322C302E
        392C322C325331372E312C32362C31362C32367A204D31382C3230682D34762D
        3763302D302E362C302E342D312C312D31683263302E362C302C312C302E342C
        312C315632307A222F3E0D0A3C2F7376673E0D0A}
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 
        'Some of the changes you made will not take effect until the appl' +
        'ication has been restarted.'
      CaptionOptions.WordWrap = True
      Index = 0
    end
  end
  inherited LayoutControlHeader: TdxLayoutControl
    Width = 602
    ExplicitWidth = 602
  end
  inherited LayoutControl: TdxLayoutControl
    Width = 602
    Height = 501
    AutoSize = True
    ExplicitWidth = 602
    ExplicitHeight = 501
    object EditTranslatorDeepLAPIKey: TcxButtonEdit [0]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          ImageIndex = 0
          Hint = 'Verify API key'
          Kind = bkGlyph
        end>
      Properties.Images = ImageList
      Properties.OnButtonClick = EditTranslatorDeepLAPIKeyPropertiesButtonClick
      Properties.OnChange = EditTranslatorDeepLAPIKeyPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 34
      Visible = False
      Width = 371
    end
    object EditOllamaBaseURL: TcxButtonEdit [1]
      Left = 181
      Top = 209
      Properties.Buttons = <
        item
          ImageIndex = 0
          Hint = 'Test connection'
          Kind = bkGlyph
        end>
      Properties.Images = ImageList
      Properties.OnButtonClick = EditOllamaBaseURLPropertiesButtonClick
      Properties.OnChange = EditOllamaBaseURLPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 35
      Width = 400
    end
    object ComboBoxOllamaModel: TcxComboBox [2]
      Left = 181
      Top = 237
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 36
      Width = 400
    end
    object EditOllamaTimeout: TcxSpinEdit [3]
      Left = 181
      Top = 265
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = ',##0 ms'
      Properties.EditFormat = '0'
      Properties.MaxValue = 300000.000000000000000000
      Properties.MinValue = 5000.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 37
      Value = 5000
      Width = 100
    end
    object ButtonOllamaDetectModels: TcxButton [4]
      Left = 334
      Top = 306
      Width = 120
      Height = 25
      Caption = 'Detect Models'
      TabOrder = 38
      OnClick = ButtonOllamaDetectModelsClick
    end
    object ButtonOllamaTest: TcxButton [5]
      Left = 461
      Top = 306
      Width = 120
      Height = 25
      Caption = 'Test'
      TabOrder = 39
      OnClick = ButtonOllamaTestClick
    end
    object CheckBoxEditUseProposed: TcxCheckBox [6]
      Left = 10000
      Top = 10000
      Caption = 'Use Proposed status for new translations'
      ParentBackground = False
      ParentColor = False
      Style.Color = 4206115
      Style.TransparentBorder = False
      TabOrder = 5
      Transparent = True
      Visible = False
    end
    object CheckBoxAtstart: TcxCheckBox [7]
      Left = 10000
      Top = 10000
      Caption = 'Display guide dialog when the application starts'
      ParentBackground = False
      ParentColor = False
      Style.Color = 4206115
      Style.TransparentBorder = False
      TabOrder = 13
      Transparent = True
      Visible = False
    end
    object ButtonDialogsSuppressReset: TcxButton [8]
      Left = 10000
      Top = 10000
      Width = 197
      Height = 23
      Caption = 'Reset suppressed dialogs'
      TabOrder = 14
      Visible = False
    end
    object CheckBoxResourceModulesIncludeVersionInfo: TcxCheckBox [9]
      Left = 10000
      Top = 10000
      Hint = 
        'Include the version info of the source application into the gene' +
        'rated resource modules'
      Caption = 'Include version info'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Transparent = True
      Visible = False
    end
    object ComboBoxSourceLanguage: TcxExtLookupComboBox [10]
      Left = 10000
      Top = 10000
      RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemLanguage
      Properties.ClearKey = 46
      Properties.DropDownAutoSize = True
      Properties.DropDownSizeable = True
      Style.HotTrack = False
      TabOrder = 1
      Visible = False
      Width = 195
    end
    object ComboBoxTargetLanguage: TcxExtLookupComboBox [11]
      Left = 10000
      Top = 10000
      RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemLanguage
      Properties.ClearKey = 46
      Properties.DropDownAutoSize = True
      Properties.DropDownSizeable = True
      Style.HotTrack = False
      TabOrder = 2
      Visible = False
      Width = 195
    end
    object CheckBoxEditBiDiMode: TcxCheckBox [12]
      Left = 10000
      Top = 10000
      Caption = 'BiDi mode follows edited language'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 11
      Transparent = True
      Visible = False
    end
    object CheckBoxProjectAutoApplyStopList: TcxCheckBox [13]
      Left = 10000
      Top = 10000
      Caption = 'Apply Stop List when project is updated'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Transparent = True
      Visible = False
    end
    object ComboBoxModuleNameScheme: TcxImageComboBox [14]
      Left = 10000
      Top = 10000
      EditValue = 0
      Properties.Items = <
        item
          Description = 'ISO 639-2 language/region code (ENU, DAN, DEU, etc.)'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'ISO 639-1 language code (EN, DA, DE, etc.)'
          Value = 1
        end
        item
          Description = 'RFC 4646 language/region code (en-US, da-DK, de-DE, etc.)'
          Value = 2
        end>
      Style.HotTrack = False
      TabOrder = 4
      Visible = False
      Width = 394
    end
    object ComboBoxEqualization: TcxCheckComboBox [15]
      Left = 10000
      Top = 10000
      Hint = 
        'Specifies the rules that should be applied to automatic translat' +
        'ions in order to make the properties of the translations match t' +
        'hose of the source values'
      Properties.Delimiter = ','
      Properties.EmptySelectionText = 'None'
      Properties.Items = <
        item
          Description = 'Character case: Upper, lower, title, sentence, etc.'
          ShortDescription = 'Case'
        end
        item
          Description = 'Accelerator characters: &'
          ShortDescription = 'Hotkey'
        end
        item
          Description = 'Line endings: colon, semicolon, ellipsis'
          ShortDescription = 'Ending'
        end
        item
          Description = 'Surround pairs: ( ), [ ], { }, < >, " ", '#39' '#39
          ShortDescription = 'Surround'
        end>
      Style.HotTrack = False
      TabOrder = 10
      Visible = False
      Width = 394
    end
    object ComboBoxNormalization: TcxCheckComboBox [16]
      Left = 10000
      Top = 10000
      Hint = 
        'Specifies the rules that are applied when comparing texts for si' +
        'milarity'
      RepositoryItem = DataModuleMain.EditRepositoryCheckComboBoxNormalization
      Properties.Items = <>
      Style.HotTrack = False
      TabOrder = 9
      Visible = False
      Width = 394
    end
    object ComboBoxAutoApplyTranslations: TcxComboBox [17]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Never'
        'Always'
        'Prompt')
      Properties.OnChange = ComboBoxAutoApplyTranslationsPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 6
      Visible = False
      Width = 195
    end
    object ComboBoxAutoApplyTranslationsSimilar: TcxComboBox [18]
      Left = 10000
      Top = 10000
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Never'
        'Always'
        'Prompt')
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Visible = False
      Width = 181
    end
    object CheckBoxAutoApplyTranslationsExisting: TcxCheckBox [19]
      Left = 10000
      Top = 10000
      Caption = 'Also apply to already translated values'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 7
      Transparent = True
      Visible = False
    end
    object CheckBoxAutoShowMultiLineEditor: TcxCheckBox [20]
      Left = 10000
      Top = 10000
      Caption = 'Display multi-line editor when editing multi-line texts'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 12
      Transparent = True
      Visible = False
    end
    object ImageComboBoxSkin: TcxImageComboBox [21]
      Left = 10000
      Top = 10000
      Properties.DefaultDescription = '(none)'
      Properties.Images = ImageListSkin
      Properties.Items = <>
      Properties.LargeImages = ImageListSkinLarge
      Properties.OnChange = ImageComboBoxSkinPropertiesChange
      Style.HotTrack = False
      TabOrder = 19
      Visible = False
      Width = 164
    end
    object GridColors: TcxGrid [22]
      Left = 10000
      Top = 10000
      Width = 531
      Height = 159
      BorderStyle = cxcbsNone
      TabOrder = 21
      Visible = False
      object GridColorsTableView: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnInitEdit = GridColorsTableViewInitEdit
        DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoImmediatePost]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnAfterPost = GridColorsTableViewDataControllerAfterPost
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnSorting = False
        OptionsData.Deleting = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GridLines = glNone
        OptionsView.GroupByBox = False
        Styles.UseOddEvenStyles = bFalse
        object GridColorsTableViewColumnName: TcxGridColumn
          Caption = 'Style'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.ShowAccelChar = False
          Options.Focusing = False
        end
        object GridColorsTableViewColumnSample: TcxGridColumn
          Caption = 'Sample'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.ShowAccelChar = False
          OnCustomDrawCell = GridColorsTableViewColumnSampleCustomDrawCell
          BestFitMaxWidth = 60
          Options.Focusing = False
          Width = 100
        end
        object GridColorsTableViewColumnText: TcxGridColumn
          Caption = 'Text'
          DataBinding.ValueType = 'Integer'
          PropertiesClassName = 'TdxColorEditProperties'
          Properties.ImmediateDropDownWhenActivated = True
          Properties.ImmediatePost = True
          Properties.OnInitPopup = GridColorsTableViewColumnColorPropertiesInitPopup
          OnCustomDrawCell = GridColorsTableViewColumnTextCustomDrawCell
          Options.AutoWidthSizable = False
        end
        object GridColorsTableViewColumnBackground: TcxGridColumn
          Caption = 'Background'
          DataBinding.ValueType = 'Integer'
          PropertiesClassName = 'TdxColorEditProperties'
          Properties.ImmediateDropDownWhenActivated = True
          Properties.ImmediatePost = True
          Properties.OnInitPopup = GridColorsTableViewColumnColorPropertiesInitPopup
          OnCustomDrawCell = GridColorsTableViewColumnBackgroundCustomDrawCell
          Options.AutoWidthSizable = False
        end
        object GridColorsTableViewColumnBold: TcxGridColumn
          Caption = 'Bold'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.AllowGrayed = True
          Properties.ImmediatePost = True
          Properties.NullStyle = nssInactive
          Options.AutoWidthSizable = False
          Width = 32
        end
      end
      object GridColorsLevel: TcxGridLevel
        GridView = GridColorsTableView
      end
    end
    object CheckBoxDisplayStatusGlyphs: TcxCheckBox [23]
      Left = 10000
      Top = 10000
      Action = ActionEditStatusGlyphs
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 23
      Transparent = True
      Visible = False
    end
    object ButtonStyleReset: TcxButton [24]
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Hint = 'Reset all styles to their default value'
      Anchors = [akTop, akRight]
      Caption = '&Reset'
      TabOrder = 22
      Visible = False
      OnClick = ButtonStyleResetClick
    end
    object CheckBoxStatusGlyphHint: TcxCheckBox [25]
      Left = 10000
      Top = 10000
      Action = ActionEditStatusHint
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 24
      Transparent = True
      Visible = False
    end
    object ComboBoxApplicationLanguage: TcxExtLookupComboBox [26]
      Left = 10000
      Top = 10000
      RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemFilteredApplicationLanguage
      Properties.ClearKey = 46
      Properties.DropDownAutoSize = True
      Properties.DropDownSizeable = True
      Properties.OnEditValueChanged = ComboBoxApplicationLanguagePropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 15
      Visible = False
      Width = 470
    end
    object CheckBoxTMLoadOnDemand: TcxCheckBox [27]
      Left = 10000
      Top = 10000
      Hint = 
        'Silently load Translation Memory from disk the first time it is ' +
        'needed.'
      Caption = 'Load on demand'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 26
      Transparent = True
      Visible = False
    end
    object EditTranslatorMSAPIKey: TcxButtonEdit [28]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          ImageIndex = 0
          Hint = 'Verify API key'
          Kind = bkGlyph
        end>
      Properties.Images = ImageList
      Properties.IncrementalSearch = False
      Properties.OnButtonClick = TextEditTranslatorMSAPIKeyPropertiesButtonClick
      Properties.OnChange = TextEditTranslatorMSAPIKeyPropertiesChange
      Style.HotTrack = False
      TabOrder = 32
      Visible = False
      Width = 371
    end
    object CheckBoxTMBackgroundQuery: TcxCheckBox [29]
      Left = 10000
      Top = 10000
      Hint = 
        'Search the Translation Memory for matching translations while yo' +
        'u work and indicate if matches are found.'
      Caption = 'Query Translation Memory in the background'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 28
      Transparent = True
      Visible = False
    end
    object CheckBoxTMPromptToSave: TcxCheckBox [30]
      Left = 10000
      Top = 10000
      Hint = 'Ask before the Translation Memory is saved'
      Caption = 'Prompt to save'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 27
      Transparent = True
      Visible = False
    end
    object cxCheckBox1: TcxCheckBox [31]
      Left = 10000
      Top = 10000
      Caption = 'Automatically add new translations:'
      ParentBackground = False
      ParentColor = False
      Style.Color = 16053234
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 29
      Transparent = True
      Visible = False
    end
    object cxSpinEdit1: TcxSpinEdit [32]
      Left = 10000
      Top = 10000
      Hint = 'Maximum number of translations to return per term'
      Properties.Alignment.Horz = taRightJustify
      Properties.MaxValue = 20.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Properties.ValidationOptions = [evoShowErrorIcon]
      Style.HotTrack = False
      TabOrder = 30
      Value = 2
      Visible = False
      Width = 61
    end
    object cxSpinEdit2: TcxSpinEdit [33]
      Left = 10000
      Top = 10000
      Hint = 'Maximum number of translations to return per term'
      Properties.Alignment.Horz = taRightJustify
      Properties.MaxValue = 20.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Properties.ValidationOptions = [evoShowErrorIcon]
      Style.HotTrack = False
      TabOrder = 31
      Value = 3
      Visible = False
      Width = 61
    end
    object EditProviderTMFilename: TcxButtonEdit [34]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          Action = ActionProviderTMFilename
          Default = True
          Kind = bkEllipsis
        end>
      Style.HotTrack = False
      TabOrder = 25
      Visible = False
      Width = 371
    end
    object EditTranslatorMSAPIRegion: TcxComboBox [35]
      Left = 10000
      Top = 10000
      Properties.Items.Strings = (
        'australiaeast'
        'brazilsouth'
        'canadacentral'
        'centralindia'
        'centralus'
        'centraluseuap'
        'eastasia'
        'eastus'
        'eastus2'
        'francecentral'
        'global'
        'japaneast'
        'japanwest'
        'koreacentral'
        'northcentralus'
        'northeurope'
        'southafricanorth'
        'southcentralus'
        'southeastasia'
        'uksouth'
        'westcentralus'
        'westeurope'
        'westus'
        'westus2')
      Properties.Sorted = True
      Properties.OnChange = TextEditTranslatorMSAPIKeyPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 33
      Text = 'global'
      Visible = False
      Width = 371
    end
    object ComboBoxStringListHandling: TcxComboBox [36]
      Left = 10000
      Top = 10000
      Enabled = False
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Ignore'
        'Treat list text as a single property'
        'Treat each line as an individual property')
      Properties.ValidationOptions = [evoAllowLoseFocus]
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 40
      Text = 'Treat each line as an individual property'
      Visible = False
      Width = 442
    end
    object GridSynthesize: TcxGrid [37]
      Left = 10000
      Top = 10000
      Width = 533
      Height = 200
      Enabled = False
      TabOrder = 41
      Visible = False
      object GridSynthesizeTableView: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnBeforePost = GridSynthesizeTableViewDataControllerBeforePost
        OptionsBehavior.CellHints = True
        OptionsBehavior.FocusFirstCellOnNewRecord = True
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomizationShowCommands = False
        OptionsData.Appending = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object GridSynthesizeTableViewColumnMask: TcxGridColumn
          Caption = 'Type mask'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ValidateOnEnter = True
          Properties.ValidationOptions = [evoShowErrorIcon]
          Properties.OnValidate = GridSynthesizeTableViewColumnValidate
          OnValidateDrawValue = GridSynthesizeTableViewColumnValidateDrawValue
        end
        object GridSynthesizeTableViewColumnName: TcxGridColumn
          Caption = 'Property name'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ValidateOnEnter = True
          Properties.ValidationOptions = [evoShowErrorIcon]
          Properties.OnValidate = GridSynthesizeTableViewColumnValidate
          OnValidateDrawValue = GridSynthesizeTableViewColumnValidateDrawValue
        end
        object GridSynthesizeTableViewColumnValue: TcxGridColumn
          Caption = 'Property value'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.ValidateOnEnter = True
          Properties.ValidationOptions = [evoShowErrorIcon]
          Properties.OnValidate = GridSynthesizeTableViewColumnValidate
          OnValidateDrawValue = GridSynthesizeTableViewColumnValidateDrawValue
        end
      end
      object GridSynthesizeLevel: TcxGridLevel
        GridView = GridSynthesizeTableView
      end
    end
    object GridFolders: TcxGrid [38]
      Left = 10000
      Top = 10000
      Width = 531
      Height = 128
      TabOrder = 42
      Visible = False
      object GridFoldersTableView: TcxGridTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCellDblClick = GridFoldersTableViewCellDblClick
        OnEditing = GridFoldersTableViewEditing
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.CellHints = True
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnSorting = False
        OptionsData.Deleting = False
        OptionsData.Inserting = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Styles.UseOddEvenStyles = bFalse
        Styles.OnGetContentStyle = GridFoldersTableViewStylesGetContentStyle
        object GridFoldersTableViewColumnName: TcxGridColumn
          Caption = 'File type'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.ShowAccelChar = False
          Properties.ShowEndEllipsis = True
          MinWidth = 50
          Options.Editing = False
          Options.Focusing = False
          Width = 120
        end
        object GridFoldersTableViewColumnPath: TcxGridColumn
          Caption = 'Path'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ActionFoldersModify
              Default = True
              Kind = bkEllipsis
            end
            item
              Action = ActionFoldersExplorer
              Glyph.SourceDPI = 96
              Glyph.Data = {
                424D360400000000000036000000280000001000000010000000010020000000
                000000000000C40E0000C40E000000000000000000004298D2EF3D94D0FF3D94
                D0FF4197D1E70000000000000000000000000000000000000000000000000000
                000000000000000000000000000000000000000000003D94D0FFDCFDFFFFDAFB
                FFFF358FCDFF3A92CFFF3E95D0FF4398D2AF0000000000000000000000000000
                000000000000000000000000000000000000000000003B92CFFFD2F9FFFFB6F0
                FFFFDCFDFFFFDFFFFFFFE5FFFFFF3E95D0FF0000000000000000000000000000
                000000000000000000000000000000000000000000003D93CFFFC1F7FFFF51B5
                E5FF2F89CAFF2F8ACBFF328CCCFF3992CFFF3F97D3FF000000004097D3AC3D94
                D0FF3D94D0FF4197D1A80000000000000000000000004095D0FFA0E5FBFF48A7
                DDFFDDFAFFFFDAF9FFFFDBFAFFFFDDFCFFFF328AC8CE000000003692D2FFDCFD
                FFFFDAFBFFFF348DCDFF3991CEFF3D94D0FF4297D2B04397D1FF54A6D9FF82E3
                FDFF86EBFFFF83EAFFFF85ECFFFF51B3E4FF8D8C8CFF8D8C8CFF3190D2FFCEF7
                FFFFB5EEFEFFDBF9FFFFDDFBFFFFE2FFFFFF3D94D0FF4190C7D14397D1FF4094
                D0FF3C92D0FF3991D0FF3B92D1FF3991CFEC00000033000000333490D1FFB7F3
                FFFF77E0FDFF77E0FDFF76E0FEFFDAFEFFFF3B92CFFF00000027000000330000
                0033000000338D8C8CFF000000330000002E00000000000000003C93D1FFA9F9
                FFFF8FF0FFFF8FEFFFFF8DF0FFFFD2FFFFFF3E94D0FF00000000000000000000
                0000000000008D8C8CFF000000000000000000000000000000003A87BCB23E93
                CFFF3E91CEFF3E92CEFF3E92CFFF3E94D0FF3D8BC1BE00000000000000000000
                0000000000008D8C8CFF000000000000000000000000000000003D93CFE23C93
                D0FF3B92CFFF3D8EC7D600000033000000330000002300000000000000000000
                0000000000008D8C8CFF000000000000000000000000000000003492D3FFDCFD
                FFFFDAFBFFFF348DCDFF3991CEFF3D94D0FF4297D2AE00000000000000000000
                0000000000008D8C8CFF8D8C8CFF8D8C8CFF8D8C8CFF8D8C8CFF308FD2FFCEF7
                FFFFB5EEFEFFDBF9FFFFDDFBFFFFE2FFFFFF3D94D0FF00000000000000000000
                00000000000000000033000000330000003300000033000000333390D1FFB7F3
                FFFF77E0FDFF77E0FDFF76E0FEFFDAFEFFFF3B92CFFF00000000000000000000
                00000000000000000000000000000000000000000000000000003B93D1FFA9F9
                FFFF8FF0FFFF8FEFFFFF8DF0FFFFD2FFFFFF3E94D0FF00000000000000000000
                00000000000000000000000000000000000000000000000000003D8BC1C04094
                D0FF3F92CFFF3F92CEFF3E92CFFF3E94D0FF3D8BC1C000000000000000000000
                0000000000000000000000000000000000000000000000000000000000230000
                00330000003300000033000000330000003300000023}
              Kind = bkGlyph
            end>
          Properties.OnEditValueChanged = GridFoldersTableViewColumnPathPropertiesEditValueChanged
          OnGetCellHint = GridFoldersTableViewColumnPathGetCellHint
          OnGetDisplayText = GridFoldersTableViewColumnPathGetDisplayText
          MinWidth = 100
          Width = 297
        end
        object GridFoldersTableViewColumnReadOnly: TcxGridColumn
          DataBinding.ValueType = 'Boolean'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
        end
      end
      object GridFoldersLevel: TcxGridLevel
        GridView = GridFoldersTableView
      end
    end
    object ButtonFilesReset: TcxButton [39]
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Action = ActionFolderReset
      Anchors = [akTop, akRight]
      DropDownMenu = PopupMenuFolderReset
      Kind = cxbkDropDownButton
      TabOrder = 44
      Visible = False
    end
    object ButtonFilesModify: TcxButton [40]
      Left = 10000
      Top = 10000
      Width = 75
      Height = 23
      Action = ActionFoldersModify
      Anchors = [akTop, akRight]
      TabOrder = 43
      Visible = False
    end
    object CheckBoxAutoRecovery: TcxCheckBox [41]
      Left = 10000
      Top = 10000
      Caption = 'Save auto-recovery information'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 49
      Transparent = True
      Visible = False
    end
    object EditAutoRecoveryInterval: TcxSpinEdit [42]
      Left = 10000
      Top = 10000
      Properties.Alignment.Horz = taRightJustify
      Properties.MaxValue = 60.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Properties.ValidationOptions = [evoShowErrorIcon]
      Style.HotTrack = False
      TabOrder = 50
      Value = 1
      Visible = False
      Width = 53
    end
    object CheckBoxHistoryBackup: TcxCheckBox [43]
      Left = 10000
      Top = 10000
      Caption = 'Save extra backup files'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 52
      Transparent = True
      Visible = False
    end
    object EditHistoryBackupMaxFiles: TcxSpinEdit [44]
      Left = 10000
      Top = 10000
      Properties.Alignment.Horz = taRightJustify
      Properties.MaxValue = 100.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Properties.ValidationOptions = [evoShowErrorIcon]
      Style.HotTrack = False
      TabOrder = 53
      Value = 1
      Visible = False
      Width = 53
    end
    object EditHistoryBackupMaxSize: TcxSpinEdit [45]
      Left = 10000
      Top = 10000
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = '0,0 Mb'
      Properties.EditFormat = '0,0'
      Properties.MaxValue = 10000.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.UseLeftAlignmentOnEditing = False
      Properties.ValidationOptions = [evoShowErrorIcon]
      Style.HotTrack = False
      TabOrder = 54
      Value = 100
      Visible = False
      Width = 78
    end
    object CheckBoxSaveBackup: TcxCheckBox [46]
      Left = 10000
      Top = 10000
      Hint = 
        'Save a backup of existing files when they are replaced with newe' +
        'r files'
      Caption = 'Create backup of saved files'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 51
      Transparent = True
      Visible = False
    end
    object CheckBoxFileProjectOmitDontTranslate: TcxCheckBox [47]
      Left = 10000
      Top = 10000
      Hint = 
        'Do not save details for items (modules, properties, etc.) that a' +
        're marked "Don'#39't translate".'#13#10'This can save considerable space i' +
        'n the file. The item values can be recreated by updating the pro' +
        'ject.'
      Caption = 'Omit "Don'#39't translate" items when saving'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 45
      Transparent = True
      Visible = False
    end
    object CheckBoxFileProjectSort: TcxCheckBox [48]
      Left = 10000
      Top = 10000
      Hint = 
        'Sort items when they are saved.'#13#10'This makes it easier to compare' +
        ' two project files - For example for use in version control.'
      Caption = 'Save items sorted'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 48
      Transparent = True
      Visible = False
    end
    object CheckBoxFileProjectSaveNewState: TcxCheckBox [49]
      Left = 10000
      Top = 10000
      Hint = 
        'Save the "New" state of items (modules, properties, etc.) when s' +
        'aving.'#13#10'Omitting the "New" state can make it easier to compare t' +
        'wo project files - For example for use in version control.'
      Caption = 'Save "New" state'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 46
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingIgnoreNumbers: TcxCheckBox [50]
      Left = 10000
      Top = 10000
      Caption = 'Ignore words with numbers'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 59
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingIgnoreRepeatWords: TcxCheckBox [51]
      Left = 10000
      Top = 10000
      Caption = 'Ignore repeated words'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 58
      Transparent = True
      Visible = False
    end
    object ComboBoxProofingLanguages: TcxCheckComboBox [52]
      Left = 10000
      Top = 10000
      Properties.Items = <>
      Style.HotTrack = False
      TabOrder = 60
      Visible = False
      Width = 217
    end
    object ButtonProofingEditCustomDictionary: TcxButton [53]
      Left = 10000
      Top = 10000
      Width = 146
      Height = 23
      Anchors = [akTop, akRight]
      Caption = 'Edit user dictionary...'
      TabOrder = 61
      Visible = False
      OnClick = ButtonProofingEditCustomDictionaryClick
    end
    object CheckBoxProofingSpellCheck: TcxCheckBox [54]
      Left = 10000
      Top = 10000
      Caption = 'Check spelling as you type'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 55
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingIgnoreUppercase: TcxCheckBox [55]
      Left = 10000
      Top = 10000
      Caption = 'Ignore words in UPPERCASE'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 56
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingIgnoreMixedCase: TcxCheckBox [56]
      Left = 10000
      Top = 10000
      Caption = 'Ignore words in MIXed caSE'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 57
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingCorrectSentenceCaps: TcxCheckBox [57]
      Left = 10000
      Top = 10000
      Caption = 'Capitalize first letter of &sentences'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 63
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingCorrectCapsLock: TcxCheckBox [58]
      Left = 10000
      Top = 10000
      Caption = 'Correct accidental usage of cAPS &LOCK key'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 66
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingDisableCapsLock: TcxCheckBox [59]
      Left = 10000
      Top = 10000
      Caption = 'Disable Caps Lock'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 67
      Transparent = True
      Visible = False
    end
    object CheckBoxProofingCorrectAutoReplace: TcxCheckBox [60]
      Left = 10000
      Top = 10000
      Caption = 'Correct text as you type'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 68
      Transparent = True
      Visible = False
    end
    object ListViewProofingAutoCorrectReplacements: TcxListView [61]
      Left = 10000
      Top = 10000
      Width = 386
      Height = 85
      Anchors = [akLeft, akTop, akRight]
      ColumnClick = False
      Columns = <
        item
          MaxWidth = 100
          MinWidth = 100
          Width = 100
        end
        item
          AutoSize = True
        end>
      Enabled = False
      IconOptions.WrapText = False
      ReadOnly = True
      RowSelect = True
      ShowColumnHeaders = False
      SortType = stText
      Style.TransparentBorder = False
      TabOrder = 71
      ViewStyle = vsReport
      Visible = False
      OnClick = ListViewProofingAutoCorrectReplacementsClick
    end
    object ButtonProofingAutoCorrectAdd: TcxButton [62]
      Left = 10000
      Top = 10000
      Width = 88
      Height = 23
      Action = ActionProofingAdd
      Anchors = [akRight, akBottom]
      Enabled = False
      TabOrder = 72
      Visible = False
    end
    object ButtonProofingAutoCorrectDelete: TcxButton [63]
      Left = 10000
      Top = 10000
      Width = 88
      Height = 23
      Action = ActionProofingDelete
      Anchors = [akRight, akBottom]
      Enabled = False
      TabOrder = 73
      Visible = False
    end
    object CheckBoxProofingCorrectAutomaticallyUseSuggestions: TcxCheckBox [64]
      Left = 10000
      Top = 10000
      Caption = 'Automatically use suggestions from the spell checker'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 74
      Transparent = True
      Visible = False
    end
    object EditProofingAutoCorrectReplacementFrom: TcxTextEdit [65]
      Left = 10000
      Top = 10000
      Enabled = False
      Properties.OnChange = EditProofingAutoCorrectReplacementFromPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 69
      Visible = False
      Width = 162
    end
    object EditProofingAutoCorrectReplacementTo: TcxTextEdit [66]
      Left = 10000
      Top = 10000
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 70
      Visible = False
      Width = 228
    end
    object CheckBoxProofingAutoCorrect: TcxCheckBox [67]
      Left = 10000
      Top = 10000
      Caption = 'Enable AutoCorrect'
      Properties.OnChange = CheckBoxProofingAutoCorrectPropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 62
      Transparent = True
      Visible = False
    end
    object ButtonProofingAutoCorrectExceptions: TcxButton [68]
      Left = 10000
      Top = 10000
      Width = 146
      Height = 23
      Caption = 'Exceptions...'
      Enabled = False
      TabOrder = 65
      Visible = False
      OnClick = ButtonProofingAutoCorrectExceptionsClick
    end
    object CheckBoxProofingCorrectInitialCaps: TcxCheckBox [69]
      Left = 10000
      Top = 10000
      Caption = 'Correct TWo &INitial CApitals'
      Enabled = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 64
      Transparent = True
      Visible = False
    end
    object LabelAutoUpdateIntro: TcxLabel [70]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Margins.Left = 12
      Margins.Top = 6
      Margins.Right = 12
      Margins.Bottom = 4
      Caption = 
        'The application can automatically check for, download and instal' +
        'l updates as they become available. You will always be asked to ' +
        'accept an update before it is downloaded and installed.'
      ParentColor = False
      Style.Color = 4206115
      Properties.ShowAccelChar = False
      Properties.WordWrap = True
      TabOrder = 78
      Transparent = True
      Visible = False
      Width = 536
    end
    object CheckBoxSingleInstance: TcxCheckBox [71]
      Left = 10000
      Top = 10000
      Caption = 'Use single instance of the application'
      Properties.OnChange = CheckBoxSingleInstancePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 75
      Transparent = True
      Visible = False
    end
    object ButtonRegisterFiletypes: TcxButton [72]
      Left = 10000
      Top = 10000
      Width = 318
      Height = 23
      Caption = 'Restore Translation Manager file associations'
      TabOrder = 77
      Visible = False
      OnClick = ButtonRegisterFiletypesClick
    end
    object CheckBoxAutoUpdateEnabled: TcxCheckBox [73]
      AlignWithMargins = True
      Left = 10000
      Top = 10000
      Margins.Left = 12
      Margins.Top = 6
      Margins.Right = 12
      Margins.Bottom = 0
      Caption = 'Check for updates every time the application starts'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 79
      Transparent = True
      Visible = False
    end
    object ButtonAutoUpdateNow: TcxButton [74]
      Left = 10000
      Top = 10000
      Width = 197
      Height = 23
      Caption = 'Check for updates now'
      TabOrder = 81
      Visible = False
    end
    object ButtonAutoUpdateReset: TcxButton [75]
      Left = 10000
      Top = 10000
      Width = 197
      Height = 23
      Caption = 'Reset declined updates'
      TabOrder = 80
      Visible = False
    end
    object CheckBoxPortable: TcxCheckBox [76]
      Left = 10000
      Top = 10000
      Hint = 
        'If enabled, the application will save and load settings and data' +
        ' files in the installation folder'
      Caption = 'Use as Portable Application'
      Properties.OnChange = CheckBoxSingleInstancePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 76
      Transparent = True
      Visible = False
      OnClick = CheckBoxPortableClick
    end
    object ButtonThemeLight: TcxButton [77]
      Left = 10000
      Top = 10000
      Width = 274
      Height = 52
      Action = ActionColorThemeLight
      Description = 'Dark text on light background'
      Kind = cxbkOfficeDropDown
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C73766720786D6C6E733D22687474703A2F2F7777772E77
        332E6F72672F323030302F73766722206865696768743D223438222077696474
        683D223438223E0D0A093C7061746820643D224D32342033315132362E392033
        312032382E39352032382E39355133312032362E392033312032345133312032
        312E312032382E39352031392E30355132362E39203137203234203137513231
        2E312031372031392E30352031392E30355131372032312E3120313720323451
        31372032362E392031392E30352032382E39355132312E312033312032342033
        315A4D32342033345131392E38352033342031362E3932352033312E30373551
        31342032382E31352031342032345131342031392E38352031362E3932352031
        362E3932355131392E38352031342032342031345132382E3135203134203331
        2E3037352031362E3932355133342031392E3835203334203234513334203238
        2E31352033312E3037352033312E3037355132382E3135203334203234203334
        5A4D322032352E355632322E354831305632352E355A4D33382032352E355632
        322E354834365632352E355A4D32322E3520313056324832352E355631305A4D
        32322E352034365633384832352E355634365A4D31332E30352031352E313520
        382E312031302E322031302E3220382E312031352E31352031332E30355A4D33
        372E382033392E392033322E38352033342E39352033342E39352033322E3835
        2033392E392033372E385A4D33342E39352031352E31352033322E3835203133
        2E30352033372E3820382E312033392E392031302E325A4D31302E322033392E
        3920382E312033372E382031332E30352033322E38352031352E31352033342E
        39355A4D32342032345132342032342032342032345132342032342032342032
        3451323420323420323420323451323420323420323420323451323420323420
        3234203234513234203234203234203234513234203234203234203234513234
        2032342032342032345A222F3E0D0A3C2F7376673E0D0A}
      OptionsImage.Margin = 8
      OptionsImage.Spacing = 8
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 16
      Visible = False
    end
    object ButtonThemeDark: TcxButton [78]
      Left = 10000
      Top = 10000
      Width = 274
      Height = 52
      Action = ActionColorThemeDark
      Description = 'Light text on dark background'
      Kind = cxbkOfficeDropDown
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C73766720786D6C6E733D22687474703A2F2F7777772E77
        332E6F72672F323030302F73766722206865696768743D223438222077696474
        683D223438223E0D0A093C7061746820643D224D32342034325131362E352034
        322031312E32352033362E373551362033312E35203620323451362031362E35
        2031312E32352031312E32355131362E35203620323420365132342E34203620
        32342E383520362E3032355132352E3320362E303520323620362E315132342E
        3220372E372032332E322031302E30355132322E322031322E342032322E3220
        31355132322E322031392E352032352E33352032322E36355132382E35203235
        2E382033332032352E385133352E362032352E382033372E39352032342E3837
        355134302E332032332E39352034312E392032322E335134312E39352032322E
        392034312E3937352032332E3237355134322032332E36352034322032345134
        322033312E352033362E37352033362E37355133312E35203432203234203432
        5A4D32342033395132392E34352033392033332E352033352E3632355133372E
        35352033322E32352033382E35352032372E375133372E332032382E32352033
        352E3837352032382E3532355133342E34352032382E382033332032382E3851
        32372E32352032382E382032332E3232352032342E3737355131392E32203230
        2E37352031392E322031355131392E322031332E382031392E34352031322E34
        32355131392E372031312E30352032302E333520392E335131352E3435203130
        2E36352031322E3232352031342E37373551392031382E392039203234513920
        33302E32352031332E3337352033342E3632355131372E373520333920323420
        33395A4D32332E382032342E31355132332E382032342E31352032332E382032
        342E31355132332E382032342E31352032332E382032342E31355132332E3820
        32342E31352032332E382032342E31355132332E382032342E31352032332E38
        2032342E31355132332E382032342E31352032332E382032342E31355132332E
        382032342E31352032332E382032342E31355132332E382032342E3135203233
        2E382032342E31355132332E382032342E31352032332E382032342E31355132
        332E382032342E31352032332E382032342E31355132332E382032342E313520
        32332E382032342E31355132332E382032342E31352032332E382032342E3135
        5132332E382032342E31352032332E382032342E31355A222F3E0D0A3C2F7376
        673E0D0A}
      OptionsImage.Margin = 8
      OptionsImage.Spacing = 8
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 17
      Visible = False
    end
    object ButtonThemeCustom: TcxButton [79]
      Left = 10000
      Top = 10000
      Width = 274
      Height = 52
      Action = ActionColorThemeCustom
      Description = 'Select from all available color schemes'
      Kind = cxbkOfficeDropDown
      OptionsImage.Glyph.SourceDPI = 96
      OptionsImage.Glyph.Data = {
        3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554
        462D38223F3E0D0A3C73766720786D6C6E733D22687474703A2F2F7777772E77
        332E6F72672F323030302F73766722206865696768743D223430222077696474
        683D223430223E0D0A093C7061746820643D224D32302033362E363637513136
        2E3538332033362E3636372031332E3534322033352E3335345131302E352033
        342E30343220382E3232392033312E37373151352E3935382032392E3520342E
        3634362032362E34353851332E3333332032332E34313720332E333333203230
        51332E3333332031362E3520342E3636372031332E34353851362031302E3431
        3720382E33313220382E3136375131302E36323520352E3931372031332E3732
        3920342E3632355131362E38333320332E3333332032302E33373520332E3333
        335132332E36363720332E3333332032362E36323520342E3435385132392E35
        383320352E3538332033312E38313220372E3536335133342E30343220392E35
        34322033352E3335342031322E32355133362E3636372031342E393538203336
        2E3636372031382E3136375133362E3636372032322E37352033332E39333820
        32352E3335345133312E3230382032372E3935382032362E3935382032372E39
        35384832332E3833335132332E3230382032372E3935382032322E3739322032
        382E3431375132322E3337352032382E3837352032322E3337352032392E3431
        375132322E3337352033302E3132352032332033302E3933385132332E363235
        2033312E37352032332E3632352033322E3837355132332E3632352033342E32
        39322032322E3536322033352E3437395132312E352033362E36363720323020
        33362E3636375A4D31302E3435382032312E3239325131312E3337352032312E
        3239322031322E3034322032302E3632355131322E3730382031392E39353820
        31322E3730382031392E3034325131322E3730382031382E3132352031322E30
        34322031372E3437395131312E3337352031362E3833332031302E3435382031
        362E38333351392E3534322031362E38333320382E3839362031372E34373951
        382E32352031382E31323520382E32352031392E30343251382E32352031392E
        39353820382E3839362032302E36323551392E3534322032312E323932203130
        2E3435382032312E3239325A4D31352E3632352031342E3333335131362E3534
        322031342E3333332031372E3230382031332E3638385131372E383735203133
        2E3034322031372E3837352031322E3132355131372E3837352031312E323038
        2031372E3230382031302E3534325131362E35343220392E3837352031352E36
        323520392E3837355131342E37303820392E3837352031342E3036322031302E
        3534325131332E3431372031312E3230382031332E3431372031322E31323551
        31332E3431372031332E3034322031342E3036322031332E3638385131342E37
        30382031342E3333332031352E3632352031342E3333335A4D32342E33373520
        31342E3333335132352E3239322031342E3333332032352E3933382031332E36
        38385132362E3538332031332E3034322032362E3538332031322E3132355132
        362E3538332031312E3230382032352E3933382031302E3534325132352E3239
        3220392E3837352032342E33373520392E3837355132332E34353820392E3837
        352032322E3739322031302E3534325132322E3132352031312E323038203232
        2E3132352031322E3132355132322E3132352031332E3034322032322E373932
        2031332E3638385132332E3435382031342E3333332032342E3337352031342E
        3333335A4D32392E3636372032312E3239325133302E3538332032312E323932
        2033312E3232392032302E3632355133312E3837352031392E3935382033312E
        3837352031392E3034325133312E3837352031382E3132352033312E32323920
        31372E3437395133302E3538332031362E3833332032392E3636372031362E38
        33335132382E37352031362E3833332032382E3130342031372E343739513237
        2E3435382031382E3132352032372E3435382031392E3034325132372E343538
        2031392E3935382032382E3130342032302E3632355132382E37352032312E32
        39322032392E3636372032312E3239325A222F3E0D0A3C2F7376673E0D0A}
      OptionsImage.Margin = 8
      OptionsImage.Spacing = 8
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 18
      Visible = False
    end
    object ComboBoxColorScheme: TcxImageComboBox [80]
      Left = 10000
      Top = 10000
      ParentFont = False
      Properties.Images = ImageListColorSchemesSmall
      Properties.Items = <>
      Properties.LargeImages = ImageListColorSchemesLarge
      Properties.OnChange = ComboBoxColorSchemePropertiesChange
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 20
      Visible = False
      Width = 164
    end
    object PaintBoxColorSample: TPaintBox [81]
      Left = 10000
      Top = 10000
      Width = 235
      Height = 19
      Color = 4206115
      ParentColor = False
      Visible = False
      OnPaint = PaintBoxColorSamplePaint
    end
    object CheckBoxFileProjectSaveTransient: TcxCheckBox [82]
      Left = 10000
      Top = 10000
      Hint = 
        'Save informational project and module statistics (translation co' +
        'unts, etc.).'#13#10'Omitting these can make it easier to compare two p' +
        'roject files - For example for use in version control.'
      Caption = 'Save statistics and other transient values'
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 47
      Transparent = True
      Visible = False
    end
    inherited LayoutControlGroup_Root: TdxLayoutGroup
      AlignVert = avClient
      ItemIndex = 1
      LayoutDirection = ldHorizontal
    end
    object LayoutGroupCategoryButtons: TdxLayoutGroup
      Parent = LayoutControlGroup_Root
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object LayoutGroupCategoryGeneral: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'General'
      ItemIndex = 2
      ScrollOptions.Vertical = smIndependent
      Index = 0
    end
    object LayoutGroupCategoryAppearance: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'Appearance'
      ItemIndex = 2
      ScrollOptions.Vertical = smIndependent
      Index = 1
    end
    object LayoutGroupCategoryProviders: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'Providers'
      ItemIndex = 2
      ScrollOptions.Vertical = smIndependent
      Index = 2
    end
    object LayoutGroupCategoryParser: TdxLayoutGroup
      Parent = LayoutGroupCategories
      AlignVert = avTop
      CaptionOptions.Text = 'Parser'
      ScrollOptions.Vertical = smIndependent
      Index = 3
    end
    object LayoutGroupCategoryFiles: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'Files'
      ItemIndex = 1
      ScrollOptions.Vertical = smIndependent
      Index = 4
    end
    object LayoutGroupCategoryProofing: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'Proofing'
      ScrollOptions.Vertical = smIndependent
      Index = 5
    end
    object LayoutGroupCategoryAdvanced: TdxLayoutGroup
      Parent = LayoutGroupCategories
      CaptionOptions.Text = 'Advanced'
      ScrollOptions.Vertical = smIndependent
      Index = 6
    end
    object LayoutGroupCategories: TdxLayoutGroup
      Parent = LayoutControlGroup_Root
      AlignHorz = ahClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      LayoutLookAndFeel = DataModuleMain.LayoutSkinLookAndFeelNoPadding
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldTabbed
      ShowBorder = False
      UseIndent = False
      Index = 1
    end
    object LayoutGroupProject: TdxLayoutGroup
      Parent = LayoutGroupCategoryGeneral
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Project'
      Index = 0
    end
    object dxLayoutItem61: TdxLayoutItem
      Parent = LayoutGroupProject
      CaptionOptions.Visible = False
      Control = CheckBoxProjectAutoApplyStopList
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 413
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutGroupResourceModules: TdxLayoutGroup
      Parent = LayoutGroupCategoryGeneral
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Resource Modules'
      Index = 1
    end
    object dxLayoutItem27: TdxLayoutItem
      Parent = LayoutGroupResourceModules
      CaptionOptions.Visible = False
      Control = CheckBoxResourceModulesIncludeVersionInfo
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 413
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem62: TdxLayoutItem
      Parent = LayoutGroupResourceModules
      AlignHorz = ahClient
      CaptionOptions.Text = 'File naming scheme:'
      Control = ComboBoxModuleNameScheme
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutGroupEditing: TdxLayoutGroup
      Parent = LayoutGroupCategoryGeneral
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Editing'
      ItemIndex = 2
      Index = 2
    end
    object LayoutControlGeneralItem2: TdxLayoutItem
      Parent = LayoutGroupEditing
      CaptionOptions.Visible = False
      Control = CheckBoxEditUseProposed
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem68: TdxLayoutItem
      Parent = LayoutGroupEditing
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Apply new translations'#13#10'to whole project:'
      CaptionOptions.WordWrap = True
      Control = ComboBoxAutoApplyTranslations
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutGroupAutoApplyTranslations: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem55: TdxLayoutItem
      Parent = LayoutGroupAutoApplyTranslations
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = CheckBoxAutoApplyTranslationsExisting
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 401
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem69: TdxLayoutItem
      Parent = LayoutGroupAutoApplyTranslations
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Apply to similar values:'
      Control = ComboBoxAutoApplyTranslationsSimilar
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 181
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem66: TdxLayoutItem
      Parent = LayoutGroupEditing
      AlignHorz = ahClient
      CaptionOptions.Text = 'Normalization rules:'
      Control = ComboBoxNormalization
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem65: TdxLayoutItem
      Parent = LayoutGroupEditing
      AlignHorz = ahClient
      CaptionOptions.Text = 'Auto equalization:'
      Control = ComboBoxEqualization
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem54: TdxLayoutItem
      Parent = LayoutGroupEditing
      CaptionOptions.Visible = False
      Control = CheckBoxEditBiDiMode
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 413
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = LayoutGroupEditing
      CaptionOptions.Visible = False
      Control = CheckBoxAutoShowMultiLineEditor
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 205
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem43: TdxLayoutItem
      Parent = LayoutGroupProject
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Default source language:'
      Control = ComboBoxSourceLanguage
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem28: TdxLayoutItem
      Parent = LayoutGroupProject
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Default target language:'
      Control = ComboBoxTargetLanguage
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object LayoutGroupStartup: TdxLayoutGroup
      Parent = LayoutGroupCategoryGeneral
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Dialogs'
      Visible = False
      Index = 3
    end
    object LayoutControlGeneralItem12: TdxLayoutItem
      Parent = LayoutGroupStartup
      CaptionOptions.Visible = False
      Control = CheckBoxAtstart
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 413
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutControlGeneralItem11: TdxLayoutItem
      Parent = LayoutGroupStartup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ButtonDialogsSuppressReset
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 197
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem4: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup6
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupEditing
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object LayoutGroupUserInterfaceTheme: TdxLayoutGroup
      Parent = LayoutGroupCategoryAppearance
      CaptionOptions.Text = 'Theme'
      ItemIndex = 3
      Index = 1
    end
    object LayoutItemUILanguage: TdxLayoutItem
      Parent = LayoutGroupUserInterfaceLanguage
      CaptionOptions.Text = 'Language:'
      Control = ComboBoxApplicationLanguage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 164
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutItemUserInterfaceSkin: TdxLayoutItem
      Parent = LayoutGroupUserInterfaceThemeAdvanced
      CaptionOptions.Text = 'Skin:'
      Control = ImageComboBoxSkin
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 164
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup18: TdxLayoutGroup
      Parent = LayoutGroupCategoryAppearance
      CaptionOptions.Text = 'Lists'
      ButtonOptions.ShowExpandButton = True
      ItemIndex = 4
      Index = 2
    end
    object dxLayoutItem49: TdxLayoutItem
      Parent = dxLayoutGroup18
      CaptionOptions.Text = 'Colors:'
      CaptionOptions.Layout = clTop
      Control = GridColors
      ControlOptions.OriginalHeight = 159
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem51: TdxLayoutItem
      Parent = dxLayoutGroup18
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = ButtonStyleReset
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutSeparatorItem5: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup18
      CaptionOptions.Text = 'Separator'
      Index = 2
    end
    object dxLayoutItem50: TdxLayoutItem
      Parent = dxLayoutGroup18
      CaptionOptions.Visible = False
      Control = CheckBoxDisplayStatusGlyphs
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 115
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem53: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = CheckBoxStatusGlyphHint
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 137
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutGroupTranslatorTM: TdxLayoutGroup
      Parent = LayoutGroupCategoryProviders
      CaptionOptions.Text = 'Translation Memory'
      ButtonOptions.CheckBox.Visible = True
      ButtonOptions.ShowExpandButton = True
      Expanded = False
      ItemIndex = 2
      OnCheckBoxStateChanged = LayoutGroupTranslatorTMCheckBoxStateChanged
      Index = 0
    end
    object dxLayoutItem64: TdxLayoutItem
      Parent = LayoutGroupTranslatorTM
      CaptionOptions.Text = 'Filename:'
      Control = EditProviderTMFilename
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = LayoutGroupTranslatorTM
      CaptionOptions.Visible = False
      Control = CheckBoxTMLoadOnDemand
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem44: TdxLayoutItem
      Parent = LayoutGroupTranslatorTM
      CaptionOptions.Visible = False
      Control = CheckBoxTMPromptToSave
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 94
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem38: TdxLayoutItem
      Parent = LayoutGroupTranslatorTM
      CaptionOptions.Visible = False
      Control = CheckBoxTMBackgroundQuery
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutGroup22: TdxLayoutGroup
      Parent = LayoutGroupTranslatorTM
      CaptionOptions.Visible = False
      Visible = False
      ItemIndex = 1
      ShowBorder = False
      Index = 4
    end
    object dxLayoutItem57: TdxLayoutItem
      Parent = dxLayoutGroup22
      CaptionOptions.Visible = False
      Control = cxCheckBox1
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 94
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup20: TdxLayoutGroup
      Parent = dxLayoutGroup22
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem58: TdxLayoutItem
      Parent = dxLayoutGroup20
      AlignHorz = ahLeft
      CaptionOptions.Text = 'If they occur at least:'
      Control = cxSpinEdit1
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutLabeledItem1: TdxLayoutLabeledItem
      Parent = dxLayoutGroup20
      AlignVert = avClient
      CaptionOptions.Text = 'times'
      Index = 1
    end
    object dxLayoutGroup21: TdxLayoutGroup
      Parent = dxLayoutGroup22
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem59: TdxLayoutItem
      Parent = dxLayoutGroup21
      AlignHorz = ahLeft
      CaptionOptions.Text = 'And contains a maximum of:'
      Control = cxSpinEdit2
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 61
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutLabeledItem2: TdxLayoutLabeledItem
      Parent = dxLayoutGroup21
      AlignVert = avClient
      CaptionOptions.Text = 'words'
      Index = 1
    end
    object LayoutGroupTranslatorMS: TdxLayoutGroup
      Parent = LayoutGroupCategoryProviders
      CaptionOptions.Text = 'Microsoft Translation Service'
      ButtonOptions.CheckBox.Visible = True
      ButtonOptions.ShowExpandButton = True
      Expanded = False
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = LayoutGroupTranslatorMS
      CaptionOptions.Text = 'API key:'
      Control = EditTranslatorMSAPIKey
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem67: TdxLayoutItem
      Parent = LayoutGroupTranslatorMS
      CaptionOptions.Text = 'Region:'
      Control = EditTranslatorMSAPIRegion
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup27: TdxLayoutGroup
      Parent = LayoutGroupCategoryParser
      AlignVert = avTop
      CaptionOptions.Text = 'Delphi Form Parser'
      ItemIndex = 3
      Index = 0
    end
    object dxLayoutItem73: TdxLayoutItem
      Parent = dxLayoutGroup27
      CaptionOptions.Text = 'String list properties:'
      Control = ComboBoxStringListHandling
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 0
    end
    object dxLayoutEmptySpaceItem3: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup27
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 1
    end
    object LayoutCheckBoxItemSynthesize: TdxLayoutCheckBoxItem
      Parent = dxLayoutGroup27
      CaptionOptions.Hint = 
        'Synthesize properties that have been omitted from the form resou' +
        'rce because their current value equals their default value'
      CaptionOptions.Text = 'Synthesize missing properties'
      OnClick = LayoutCheckBoxItemSynthesizeClick
      Index = 2
    end
    object LayoutGroupSynthesize: TdxLayoutGroup
      Parent = dxLayoutGroup27
      CaptionOptions.Text = 'New Group'
      Enabled = False
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 3
    end
    object dxLayoutItem74: TdxLayoutItem
      Parent = LayoutGroupSynthesize
      AlignHorz = ahClient
      AlignVert = avTop
      Control = GridSynthesize
      ControlOptions.OriginalHeight = 200
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem5: TdxLayoutEmptySpaceItem
      Parent = LayoutGroupSynthesize
      AlignHorz = ahLeft
      AlignVert = avClient
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutGroup12: TdxLayoutGroup
      Parent = LayoutGroupCategoryFiles
      CaptionOptions.Text = 'File Locations'
      ItemIndex = 1
      Index = 0
    end
    object dxLayoutItem32: TdxLayoutItem
      Parent = dxLayoutGroup12
      Control = GridFolders
      ControlOptions.OriginalHeight = 128
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup13: TdxLayoutGroup
      Parent = dxLayoutGroup12
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutItem34: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = ButtonFilesModify
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem33: TdxLayoutItem
      Parent = dxLayoutGroup13
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = ButtonFilesReset
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup25: TdxLayoutGroup
      Parent = LayoutGroupCategoryFiles
      CaptionOptions.Text = 'Project Files'
      ItemIndex = 2
      Index = 1
    end
    object dxLayoutItem70: TdxLayoutItem
      Parent = dxLayoutGroup25
      CaptionOptions.Visible = False
      Control = CheckBoxFileProjectOmitDontTranslate
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 241
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem52: TdxLayoutItem
      Parent = dxLayoutGroup25
      CaptionOptions.Visible = False
      Control = CheckBoxFileProjectSaveNewState
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 112
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem71: TdxLayoutItem
      Parent = dxLayoutGroup25
      CaptionOptions.Visible = False
      Control = CheckBoxFileProjectSort
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 115
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object LayoutGroupRecovery: TdxLayoutGroup
      Parent = LayoutGroupCategoryFiles
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Project file recovery'
      Visible = False
      ItemIndex = 1
      Index = 2
    end
    object dxLayoutItem36: TdxLayoutItem
      Parent = LayoutGroupRecovery
      CaptionOptions.Visible = False
      Control = CheckBoxAutoRecovery
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 190
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem37: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Interval (minutes):'
      Control = EditAutoRecoveryInterval
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 53
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutGroupBackup: TdxLayoutGroup
      Parent = LayoutGroupCategoryFiles
      CaptionOptions.Text = 'Backup files'
      ItemIndex = 2
      Index = 3
    end
    object dxLayoutItem45: TdxLayoutItem
      Parent = LayoutGroupBackup
      CaptionOptions.Visible = False
      Control = CheckBoxSaveBackup
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 158
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem40: TdxLayoutItem
      Parent = LayoutGroupBackup
      Visible = False
      CaptionOptions.Visible = False
      Control = CheckBoxHistoryBackup
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 133
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup16: TdxLayoutGroup
      Parent = LayoutGroupBackup
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Visible = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem41: TdxLayoutItem
      Parent = dxLayoutGroup16
      CaptionOptions.Text = 'Number of files to save:'
      Control = EditHistoryBackupMaxFiles
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 53
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup16
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 2
    end
    object dxLayoutItem42: TdxLayoutItem
      Parent = dxLayoutGroup16
      CaptionOptions.Text = 'Max total file size:'
      Control = EditHistoryBackupMaxSize
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 78
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutEmptySpaceItem6: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup7
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupRecovery
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutEmptySpaceItem7: TdxLayoutEmptySpaceItem
      Parent = dxLayoutGroup16
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutEmptySpaceItem8: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup8
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup18
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = LayoutGroupCategoryProofing
      CaptionOptions.Text = 'Spell Check'
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Visible = False
      Control = CheckBoxProofingSpellCheck
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Visible = False
      Control = CheckBoxProofingIgnoreUppercase
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Visible = False
      Control = CheckBoxProofingIgnoreMixedCase
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Visible = False
      Control = CheckBoxProofingIgnoreRepeatWords
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Visible = False
      Control = CheckBoxProofingIgnoreNumbers
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Separator'
      Index = 5
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutGroup4
      Visible = False
      CaptionOptions.Text = 'Dictionaries:'
      Control = ComboBoxProofingLanguages
      ControlOptions.AlignHorz = ahRight
      ControlOptions.AutoControlAreaAlignment = False
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 217
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'User dictionary:'
      Control = ButtonProofingEditCustomDictionary
      ControlOptions.AlignHorz = ahRight
      ControlOptions.AutoControlAreaAlignment = False
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 146
      ControlOptions.ShowBorder = False
      Index = 7
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = LayoutGroupCategoryProofing
      CaptionOptions.Text = 'AutoCorrect'
      ButtonOptions.ShowExpandButton = True
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutGroup6
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = CheckBoxProofingAutoCorrect
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 126
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutGroupProofingAutoCorrect: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Enabled = False
      Hidden = True
      ItemIndex = 5
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupProofingAutoCorrect
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = CheckBoxProofingCorrectSentenceCaps
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      CaptionOptions.Visible = False
      Control = CheckBoxProofingCorrectInitialCaps
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.Visible = False
      Control = ButtonProofingAutoCorrectExceptions
      ControlOptions.AlignHorz = ahRight
      ControlOptions.AutoControlAreaAlignment = False
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 146
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = LayoutGroupProofingAutoCorrect
      CaptionOptions.Visible = False
      Control = CheckBoxProofingCorrectCapsLock
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = LayoutGroupProofingAutoCorrect
      CaptionOptions.Visible = False
      Control = CheckBoxProofingDisableCapsLock
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = LayoutGroupProofingAutoCorrect
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = LayoutGroupProofingAutoCorrect
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = CheckBoxProofingCorrectAutoReplace
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 148
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutGroup5: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup5
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object EditProofingAutoCorrectReplace: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Replace:'
      Control = EditProofingAutoCorrectReplacementFrom
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 114
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'With:'
      Control = EditProofingAutoCorrectReplacementTo
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 168
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup5
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      AlignVert = avTop
      Control = ListViewProofingAutoCorrectReplacements
      ControlOptions.OriginalHeight = 85
      ControlOptions.OriginalWidth = 308
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup3
      Index = 1
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = ButtonProofingAutoCorrectAdd
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = ButtonProofingAutoCorrectDelete
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = dxLayoutGroup5
      CaptionOptions.Visible = False
      Control = CheckBoxProofingCorrectAutomaticallyUseSuggestions
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutEmptySpaceItem9: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup9
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      Index = 0
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup6
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutEmptySpaceItem10: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup10
      SizeOptions.Height = 10
      SizeOptions.Width = 16
      Index = 0
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupProofingAutoCorrect
      LayoutDirection = ldHorizontal
      Index = 5
    end
    object LayoutControlAdvancedGroup7: TdxLayoutGroup
      Parent = LayoutGroupCategoryAdvanced
      CaptionOptions.Text = 'Launch'
      Index = 0
    end
    object LayoutControlAdvancedGroup9: TdxLayoutGroup
      Parent = LayoutControlAdvancedGroup7
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Offsets.Left = 12
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object LayoutControlAdvancedItem1: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup9
      CaptionOptions.Visible = False
      Control = CheckBoxSingleInstance
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem63: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup9
      CaptionOptions.Visible = False
      Control = CheckBoxPortable
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 151
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutControlAdvancedGroup2: TdxLayoutGroup
      Parent = LayoutGroupCategoryAdvanced
      CaptionOptions.Text = 'Shell Integration'
      Index = 1
    end
    object LayoutControlAdvancedGroup4: TdxLayoutGroup
      Parent = LayoutControlAdvancedGroup2
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Offsets.Left = 12
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object LayoutControlAdvancedItem3: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup4
      CaptionOptions.Visible = False
      Control = ButtonRegisterFiletypes
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 318
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutControlAdvancedGroup5: TdxLayoutGroup
      Parent = LayoutGroupCategoryAdvanced
      CaptionOptions.Text = 'Auto Update'
      Visible = False
      Index = 2
    end
    object LayoutControlAdvancedGroup6: TdxLayoutGroup
      Parent = LayoutControlAdvancedGroup5
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Offsets.Left = 12
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 0
    end
    object LayoutControlAdvancedItem7: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup6
      CaptionOptions.Visible = False
      Control = LabelAutoUpdateIntro
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 34
      ControlOptions.OriginalWidth = 428
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutControlAdvancedItem8: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup6
      CaptionOptions.Visible = False
      Control = CheckBoxAutoUpdateEnabled
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = LayoutControlAdvancedGroup6
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 2
    end
    object LayoutControlAdvancedItem10: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup6
      CaptionOptions.Visible = False
      Control = ButtonAutoUpdateReset
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 197
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object LayoutControlAdvancedItem9: TdxLayoutItem
      Parent = LayoutControlAdvancedGroup6
      CaptionOptions.Visible = False
      Control = ButtonAutoUpdateNow
      ControlOptions.AlignHorz = ahLeft
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 197
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = LayoutGroupUserInterfaceTheme
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = ButtonThemeLight
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 274
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = LayoutGroupUserInterfaceTheme
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = ButtonThemeDark
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 274
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = LayoutGroupUserInterfaceTheme
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = ButtonThemeCustom
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 274
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object LayoutGroupUserInterfaceLanguage: TdxLayoutGroup
      Parent = LayoutGroupCategoryAppearance
      CaptionOptions.Text = 'User Interface Language'
      Index = 0
    end
    object LayoutGroupUserInterfaceThemeAdvanced: TdxLayoutGroup
      Parent = dxLayoutAutoCreatedGroup11
      AlignHorz = ahClient
      CaptionOptions.Text = 'Advanced'
      Visible = False
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutEmptySpaceItem11: TdxLayoutEmptySpaceItem
      Parent = dxLayoutAutoCreatedGroup11
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      CaptionOptions.Text = 'Empty Space Item'
      Index = 0
    end
    object dxLayoutAutoCreatedGroup11: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupUserInterfaceTheme
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object dxLayoutItem24: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      CaptionOptions.Text = 'Color scheme:'
      Control = ComboBoxColorScheme
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 164
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutItemColorSample: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup12
      AlignHorz = ahClient
      CaptionOptions.Visible = False
      Control = PaintBoxColorSample
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 19
      ControlOptions.OriginalWidth = 229
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup12: TdxLayoutAutoCreatedGroup
      Parent = LayoutGroupUserInterfaceThemeAdvanced
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object LayoutGroupTranslatorDeepL: TdxLayoutGroup
      Parent = LayoutGroupCategoryProviders
      CaptionOptions.Text = 'DeepL'
      ButtonOptions.CheckBox.Visible = True
      ButtonOptions.ShowExpandButton = True
      Expanded = False
      Index = 2
    end
    object LayoutRadioButtonItemDeepLLicenseFree: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup2
      Action = ActionProviderDeepLLicenseFree
      CaptionOptions.Text = 'Free'
      Index = 0
    end
    object LayoutRadioButtonItemDeepLLicensePro: TdxLayoutRadioButtonItem
      Parent = dxLayoutGroup2
      Action = ActionProviderDeepLLicensePro
      CaptionOptions.Text = 'Pro'
      Index = 1
    end
    object LayoutItemTranslatorDeepLAPIKey: TdxLayoutItem
      Parent = LayoutGroupTranslatorDeepL
      CaptionOptions.Text = 'API key:'
      Control = EditTranslatorDeepLAPIKey
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 314
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutLabeledItem3: TdxLayoutLabeledItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'API version:'
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = LayoutGroupTranslatorDeepL
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'New Group'
      Hidden = True
      ShowBorder = False
      Index = 1
    end
    object LayoutGroupTranslatorOllama: TdxLayoutGroup
      Parent = LayoutGroupCategoryProviders
      CaptionOptions.Text = 'Ollama (Local LLM)'
      ButtonOptions.CheckBox.Visible = True
      ButtonOptions.ShowExpandButton = True
      ItemIndex = 4
      Index = 3
    end
    object LayoutItemOllamaBaseURL: TdxLayoutItem
      Parent = LayoutGroupTranslatorOllama
      CaptionOptions.Text = 'Base URL:'
      Control = EditOllamaBaseURL
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 371
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutItemOllamaModel: TdxLayoutItem
      Parent = LayoutGroupTranslatorOllama
      CaptionOptions.Text = 'Model:'
      Control = ComboBoxOllamaModel
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutItemOllamaTimeout: TdxLayoutItem
      Parent = LayoutGroupTranslatorOllama
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Timeout:'
      Control = EditOllamaTimeout
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object LayoutItemOllamaDetectModels: TdxLayoutItem
      Parent = LayoutGroupOllamaButtons
      AlignHorz = ahRight
      CaptionOptions.Visible = False
      Control = ButtonOllamaDetectModels
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 120
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutItemOllamaTest: TdxLayoutItem
      Parent = LayoutGroupOllamaButtons
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = ButtonOllamaTest
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 120
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutGroup25
      CaptionOptions.Visible = False
      Control = CheckBoxFileProjectSaveTransient
      ControlOptions.OriginalHeight = 20
      ControlOptions.OriginalWidth = 112
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutSeparatorItem3: TdxLayoutSeparatorItem
      Parent = LayoutGroupTranslatorOllama
      CaptionOptions.Text = 'Separator'
      Index = 3
    end
    object LayoutGroupOllamaButtons: TdxLayoutGroup
      Parent = LayoutGroupTranslatorOllama
      AlignVert = avTop
      CaptionOptions.Text = 'Hidden Group'
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 4
    end
  end
  inherited ActionList: TActionList
    Left = 36
    Top = 144
    object ActionFoldersModify: TAction
      Category = 'Folders'
      Caption = '&Modify'
      Hint = 'Select folder'
      OnExecute = ActionFoldersModifyExecute
      OnUpdate = ActionFoldersModifyUpdate
    end
    object ActionFolderReset: TAction
      Category = 'Folders'
      Caption = 'Reset'
      Hint = 'Reset to the default value'
      OnExecute = ActionFolderResetExecute
      OnUpdate = ActionFolderResetUpdate
    end
    object ActionFoldersExplorer: TAction
      Category = 'Folders'
      Caption = 'ActionFoldersExplorer'
      Hint = 'Open the specified folder in Windows Explorer'
      OnExecute = ActionFoldersExplorerExecute
    end
    object ActionFolderResetAll: TAction
      Category = 'Folders'
      Caption = 'Reset all'
      Hint = 'Reset all file locations back to their defaults'
      OnExecute = ActionFolderResetAllExecute
    end
    object ActionProofingAdd: TAction
      Category = 'Proofing'
      Caption = 'Add'
      OnExecute = ActionProofingAddExecute
      OnUpdate = ActionProofingAddUpdate
    end
    object ActionProofingReplace: TAction
      Category = 'Proofing'
      Caption = 'Replace'
      OnExecute = ActionProofingReplaceExecute
      OnUpdate = ActionProofingReplaceUpdate
    end
    object ActionProofingDelete: TAction
      Category = 'Proofing'
      Caption = 'Delete'
      OnExecute = ActionProofingDeleteExecute
      OnUpdate = ActionProofingDeleteUpdate
    end
    object ActionEditStatusGlyphs: TAction
      Category = 'Edit'
      AutoCheck = True
      Caption = 'Display status indicators'
      OnExecute = ActionDummyExecute
    end
    object ActionEditStatusHint: TAction
      Category = 'Edit'
      AutoCheck = True
      Caption = 'Status indicator hints'
      Hint = 'Provide mouse over hints on status glyphs'
      OnExecute = ActionDummyExecute
      OnUpdate = ActionEditStatusHintUpdate
    end
    object ActionProviderTMFilename: TAction
      Category = 'Providers'
      Hint = 'Browse for file'
      OnExecute = ActionProviderTMFilenameExecute
    end
    object ActionColorThemeLight: TAction
      Category = 'Appearance'
      AutoCheck = True
      Caption = 'Light mode'
      OnExecute = ActionColorThemeLightExecute
      OnUpdate = ActionColorThemeLightUpdate
    end
    object ActionColorThemeDark: TAction
      Category = 'Appearance'
      AutoCheck = True
      Caption = 'Dark mode'
      OnExecute = ActionColorThemeDarkExecute
      OnUpdate = ActionColorThemeDarkUpdate
    end
    object ActionColorThemeCustom: TAction
      Category = 'Appearance'
      Caption = 'Custom'
      OnExecute = ActionColorThemeCustomExecute
      OnUpdate = ActionColorThemeCustomUpdate
    end
    object ActionProviderDeepLLicenseFree: TAction
      Category = 'Providers'
      AutoCheck = True
      Caption = 'Free version'
      OnExecute = ActionDummyExecute
    end
    object ActionProviderDeepLLicensePro: TAction
      Category = 'Providers'
      AutoCheck = True
      Caption = 'Pro version'
      OnExecute = ActionDummyExecute
    end
    object ActionOllamaDetectModels: TAction
      Category = 'Providers'
      Caption = 'Detect Models'
      OnExecute = ButtonOllamaDetectModelsClick
    end
    object ActionOllamaTest: TAction
      Category = 'Providers'
      Caption = 'Test Connection'
      OnExecute = ButtonOllamaTestClick
    end
  end
  object PopupMenuFolderReset: TPopupMenu
    Left = 44
    Top = 280
    object Reset1: TMenuItem
      Action = ActionFolderReset
      Hint = 'Reset selected file location to the default value'
    end
    object Resetall1: TMenuItem
      Action = ActionFolderResetAll
      Hint = 'Reset all file locations to their default values'
    end
  end
  object StyleRepository: TcxStyleRepository
    Left = 44
    Top = 324
    PixelsPerInch = 96
    object StyleBackground: TcxStyle
      AssignedValues = [svColor]
      Color = clWhite
    end
    object StyleDisabled: TcxStyle
      AssignedValues = [svTextColor]
      TextColor = clGrayText
    end
  end
  object ImageList: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 6029352
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000000F744558745469746C6500436865636B426F783B9B171E
          3B0000024749444154785E8D93CF4B545114C73FE7CD9BE764560445454591F6
          63D47E6960BF1C5D48D8A2454114812DDAD4AAFFA15DCB5A44D4AAA0B05611B4
          283221A3C4323550432A24C4C97E204E924D33EFDD9373EFA30171D1810BE75C
          CEF7C3F79E7BAF0002240097FF7F1820F281C4B5CEFE67092F9141416384CD55
          1D535C8D2A26CE4D54ECB9D8D1D4E6039EE065CE9DD845DCC9C250C043898C01
          71466FDC1FCA009E0F486414C035006A9DE83F96A0E40B050AF32B190404C900
          E3346201AE501C27B6AE20AA88C0F7E91C371F8EA05E92D6BA2A1AEA371345A6
          0C2815C6360B188331C6E68A323935C3F507C3B4B5A449ADACE26E671FE9EAB5
          846108205E0C009CB8BB7F9CCBB7FA78DAFB81B14F592B3E767437F9600977EE
          BDA6355D491054101F1B1FB07654959E81CFBCFD38C381A66A0686B33CEA9DE4
          F4F1BD647F43EFCB51B6AE8C3872B8968A8A547906CE81DA8D1555015FA77F91
          23A039B39DF6C0E7FDD41C23A313E88F2F749C6F2648A51084794DF908A131A8
          08B55B5673F2D07A9E3C1E64686296BEF11CD96F39C6DE8C70E154039595CB09
          2330501E2240142A1A29A1F1D893DEC0994281DB5DEF6868D9C9ABAE41CEB6D7
          B06ECD2A42671B83730CE0AED14E1E3B1823C2BEFA4D148A45AE743E67FF8E65
          1C6CACC1888FD5286074C135960018544B4BF048CC8BB6D158B7918424F04A53
          8F4051E227EE6031000B50F044E2572816E4074B01271011448801609C03F581
          E26CEE67CFA5ABDD195501EB82381435A0314401412DE04F7EEE05100AE00129
          20B9C87716160F050A40FE2F0C443CDF350F545E0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000015744558745469746C6500436865636B3B4D61726B3B5469636B0B00
          C7240000026B49444154785E95924D48156B18C77F338D7A94B436816090828B
          8B94919BBE886304C5599CEA9A14145177211246AB3641F6B16861044610B408
          23C842FB2410B4ACB06BDDD55510823072532267A19E93E76BE6FDCAF3323910
          44F4303CFF7786797EFFE77978BD9B2FF6BE715DA7955F8589040CC63818345A
          99B13389D13D5EA9B87DDB05FE341EFC7B310EB89E5286824A912ABC8FDCA2F4
          F3BB9575952D48A9019C6580466B89D63FAAED4F51B11558585CA27A75259EE7
          A2748092060B2891941168AD4213EB132930323AC1FF935FA85B5FC3F12371A4
          F6114202E009A12C512AB5E2684AC931F67C7F708CB565BBB8717690AEAB5B48
          67965853E12382B003DF170855442AC9CC4C8AFEC7236C6DD9C4EE783323AF26
          A8ADDEC7A9F66EAEF49DA03D99205659812F0A148A3E165022E5FD1CD97C9EFE
          872FE9E9FA8F47AF6ED1737D809D1B4FD2D176817BC397A9AD536C68A822574C
          53EE6411225C621048842C10C880B644923BCFBA39DF7997C9E9C3FC55BF994C
          EE33E3538374FC93643E9BB2E355951510221C41488D6F013E750D352C6632DC
          7E728ED3477BC175B874AD93FD895616B2B380C618F0450E1128003C19683B93
          54826F6A9EA6E675BC1B9FE2E9EB5E1AEB9B70631962D5057C195877005FE6A3
          7B2084A628F30825D00616E51CDB7734F27CA88FBEE14F1C3BF437393F83C158
          773025C368075228029127500227BC44F3B9AF1C4CB652597E80B9F4478A4202
          7A05501405A20EA4B11DC4BC1AB02E1A6D0CE9FC1C0BB95930066F5585FD8E01
          6DECCE501680F18A3931363CF4210E267C88344CB6D605B4E5E1601081790B48
          6FA0673A017880CBEFC309D50002F0BF03C5148A5699E7E19C0000000049454E
          44AE426082}
      end>
  end
  object ColorDialog: TdxColorDialog
    Options.ColorPicker.AllowEditAlpha = False
    Options.ColorPicker.RGBHexNotation = cphnDelphi
    Options.ColorPicker.DefaultVisible = True
    Left = 102
    Top = 141
  end
  object ImageListColorSchemePreview: TcxImageList
    SourceDPI = 96
    Height = 28
    Width = 28
    FormatVersion = 1
    DesignInfo = 24379456
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D494844520000001C0000001C0804000000D80417
          1F000000494944415478DA63FCCFC0D0C0E0C0401A38C0D0C002D666CF402A00
          6A24471B500713039960A8696424110C453F8E6A1CD538AA919A1A19FF935320
          1F6438002AC91B48B60E580500009A890B68BE10446C0000000049454E44AE42
          6082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D494844520000001C0000001C0804000000D80417
          1F000000254944415478DA636018058308308288FFFF49D404D4C544AE8DA31A
          47358E6A1C061AE90F00B63E0226E0A69CCB0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D494844520000001C0000001C0804000000D80417
          1F000001954944415478DAED94BB2F045114C6BF73678D47C4238BB06B42226B
          97D9ACC8088557B5FE018D46BC7AFF030589422334127F815621A2D2D1E924AB
          F10A854D14625FEE71666CB3CCAE2D25DC5BDC9B93EF37F39DEFDE19E07FFCA2
          41FE65C63DBA642DC02C2351FE98A88DE254BA7A10864E86B7D5813A30F7B18A
          7AAE0E1459AD9AC532E6652E600E313FB7CAB7EF7E0CA1A1B8B7684A0C57033E
          06300D4B108D9CBCBE0DE3BA957F06199DCD1817B9E6279C238B1A4495F3DDAC
          F2313AC2519167E98C8F91918AC59379F3AB2CF00D34314196AC193EE52B5A44
          B3CC61A357F6A5C17F35CA7DB4045BB677BCA31E24A4080C52B8A6CBB58A5689
          C62453379867D58301BCC03DFF6E1A4553E51E9B308AB0578F601D5B484AB7AE
          FD046C2E0F32B42DE66ABD888218441CDD45458C9DD23C4AC3099023F7E4F38E
          DFCA29BA0F6E17EB0A4172740837E5C090804159F338E423BCBAA054D6D0220E
          1C65F30DF97F567A069BE4269AC60A4EA8E0D94FF0AEC00A6FD8C01EBDFA82EF
          6165A34EC459BAA074B1EF468EA3C393A5DE520DB9BFF4B3FA00895564C26DF1
          040B0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D494844520000001C0000001C0804000000D80417
          1F000000294944415478DA63601805A360148C8251800530C218FF1B88D40055
          C70217A927D22A0C8D8E833D70000EA1034A766921F10000000049454E44AE42
          6082}
      end>
  end
  object ImageListColorSchemesLarge: TcxImageList
    SourceDPI = 96
    Height = 28
    Width = 28
    FormatVersion = 1
    DesignInfo = 27525184
  end
  object ImageListColorSchemesSmall: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 30670913
  end
  object ImageListSkin: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 33816640
  end
  object ImageListSkinLarge: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 36962368
  end
end
