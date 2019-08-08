object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Better Translation Manager'
  ClientHeight = 643
  ClientWidth = 964
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RibbonMain: TdxRibbon
    Left = 0
    Top = 0
    Width = 964
    Height = 125
    ApplicationButton.Visible = False
    BarManager = BarManager
    Style = rs2016
    ColorSchemeAccent = rcsaOrange
    ColorSchemeName = 'Office2016Colorful'
    QuickAccessToolbar.Visible = False
    SupportNonClientDrawing = True
    Contexts = <
      item
        Caption = 'Translation'
        Color = 6957271
        Visible = True
      end>
    TabAreaSearchToolbar.Visible = False
    TabAreaToolbar.Visible = False
    TabOrder = 0
    TabStop = False
    object RibbonTabMain: TdxRibbonTab
      Active = True
      Caption = 'Main'
      Groups = <
        item
          ToolbarName = 'BarManagerBarFile'
        end
        item
          ToolbarName = 'BarManagerBarProject'
        end
        item
          ToolbarName = 'BarManagerBarLanguage'
        end>
      KeyTip = 'F'
      Index = 0
    end
    object RibbonTabEdit: TdxRibbonTab
      Caption = 'Edit'
      Groups = <
        item
          ToolbarName = 'BarManagerBarClipboard'
        end
        item
          ToolbarName = 'BarManagerBarFind'
        end
        item
          ToolbarName = 'BarManagerBarProofing'
        end>
      Index = 1
    end
    object RibbonTabTranslation: TdxRibbonTab
      Caption = 'Translation'
      Groups = <
        item
          ToolbarName = 'BarManagerBarLanguage'
        end
        item
          ToolbarName = 'BarManagetBarTranslationStatus'
        end
        item
          ToolbarName = 'BarManagetBarTranslationState'
        end
        item
          ToolbarName = 'BarManagerBarLookup'
        end>
      KeyTip = 'T'
      Index = 2
    end
    object RibbonTabTools: TdxRibbonTab
      Caption = 'Tools'
      Groups = <
        item
          ToolbarName = 'BarManagerBarImport'
        end>
      Index = 3
    end
  end
  object StatusBar: TdxRibbonStatusBar
    Left = 0
    Top = 620
    Width = 964
    Height = 23
    Panels = <>
    Ribbon = RibbonMain
    SimplePanelStyle.Active = True
    SimplePanelStyle.AutoHint = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object TreeListItems: TcxVirtualTreeList
    Left = 241
    Top = 125
    Width = 723
    Height = 495
    Align = alClient
    Bands = <
      item
      end>
    Images = ImageListTree
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.CellHints = True
    OptionsBehavior.RecordScrollMode = rsmByRecord
    OptionsCustomizing.BandCustomizing = False
    OptionsCustomizing.BandMoving = False
    OptionsCustomizing.ColumnFiltering = bTrue
    OptionsData.AnsiSort = True
    OptionsData.CaseInsensitive = True
    OptionsData.Deleting = False
    OptionsData.CheckHasChildren = False
    OptionsSelection.MultiSelect = True
    OptionsView.CellEndEllipsis = True
    OptionsView.FixedSeparatorWidth = 1
    OptionsView.ShowColumnFilterButtons = sfbAlways
    OptionsView.ShowRoot = False
    OptionsView.TreeLineStyle = tllsNone
    PopupMenu = PopupMenuTree
    TabOrder = 2
    OnEditing = TreeListItemsEditing
    OnEditValueChanged = TreeListItemsEditValueChanged
    OnEnter = TreeListModulesEnter
    OnExit = TreeListModulesExit
    OnGetNodeImageIndex = TreeListItemsGetNodeImageIndex
    object TreeListColumnItemName: TcxTreeListColumn
      Caption.AlignVert = vaTop
      Caption.Text = 'Element'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Options.Filtering = False
      Width = 198
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnType: TcxTreeListColumn
      Visible = False
      Caption.AlignVert = vaTop
      Caption.Text = 'Type'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 100
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnValueName: TcxTreeListColumn
      Caption.AlignVert = vaTop
      Caption.Text = 'Name'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 125
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnID: TcxTreeListColumn
      PropertiesClassName = 'TcxLabelProperties'
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      Visible = False
      Caption.AlignVert = vaTop
      Caption.Text = 'ID'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Options.Filtering = False
      Width = 100
      Position.ColIndex = 7
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnStatus: TcxTreeListColumn
      PropertiesClassName = 'TcxImageComboBoxProperties'
      Properties.Items = <
        item
          Description = 'Translate'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'Don'#39't translate'
          Value = 1
        end
        item
          Description = 'Hold'
          Value = 2
        end>
      Properties.OnEditValueChanged = TreeListColumnStatusPropertiesEditValueChanged
      Caption.AlignVert = vaTop
      Caption.Text = 'Status'
      DataBinding.ValueType = 'Integer'
      Width = 70
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnState: TcxTreeListColumn
      PropertiesClassName = 'TcxImageComboBoxProperties'
      Properties.Items = <
        item
          Description = 'Obsolete'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'Pending'
          Value = 1
        end
        item
          Description = 'Proposed'
          Value = 2
        end
        item
          Description = 'Translated'
          Value = 3
        end>
      Properties.OnEditValueChanged = TreeListColumnStatePropertiesEditValueChanged
      Caption.AlignVert = vaTop
      Caption.Text = 'State'
      DataBinding.ValueType = 'String'
      Width = 70
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnSource: TcxTreeListColumn
      PropertiesClassName = 'TcxMemoProperties'
      Caption.AlignVert = vaTop
      Caption.Text = 'Source value'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Options.Filtering = False
      Width = 120
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnTarget: TcxTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Default = True
          Hint = 'Open in text editor'
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = TreeListColumnTargetPropertiesButtonClick
      Caption.AlignVert = vaTop
      Caption.Text = 'Target value'
      DataBinding.ValueType = 'String'
      Options.Filtering = False
      Width = 120
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object SplitterTreeLists: TcxSplitter
    Left = 237
    Top = 125
    Width = 4
    Height = 495
    HotZoneClassName = 'TcxSimpleStyle'
    ResizeUpdate = True
  end
  object TreeListModules: TcxTreeList
    Left = 0
    Top = 125
    Width = 237
    Height = 495
    Align = alLeft
    Bands = <
      item
        FixedKind = tlbfLeft
        Options.Moving = False
        Options.OnlyOwnColumns = True
      end>
    Images = ImageListTree
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.CellHints = True
    OptionsBehavior.RecordScrollMode = rsmByRecord
    OptionsCustomizing.BandCustomizing = False
    OptionsCustomizing.BandMoving = False
    OptionsCustomizing.ColumnFiltering = bTrue
    OptionsData.AnsiSort = True
    OptionsData.CaseInsensitive = True
    OptionsData.Deleting = False
    OptionsSelection.CellSelect = False
    OptionsSelection.MultiSelect = True
    OptionsView.CellEndEllipsis = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.DynamicIndent = True
    OptionsView.FixedSeparatorWidth = 1
    OptionsView.ShowColumnFilterButtons = sfbAlways
    OptionsView.ShowRoot = False
    OptionsView.TreeLineStyle = tllsNone
    PopupMenu = PopupMenuTree
    TabOrder = 4
    OnEnter = TreeListModulesEnter
    OnExit = TreeListModulesExit
    OnFocusedNodeChanged = TreeListModulesFocusedNodeChanged
    Data = {
      00000500060100000F00000044617461436F6E74726F6C6C6572310200000012
      000000546378537472696E6756616C75655479706513000000546378496E7465
      67657256616C75655479706504000000445855464D5400000400000078007800
      7800780001445855464D54000004000000780078007800780001445855464D54
      000101445855464D540001010100000000000000020801000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFF010000001208020000000000000000000000
      FFFFFFFFFFFFFFFFFFFFFFFF0200000008080000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFF0300000008080000000000000000FFFFFFFFFFFFFFFFFFFFFFFF
      0A0801000000}
    object TreeListColumnModuleName: TcxTreeListColumn
      Caption.AlignVert = vaTop
      Caption.Text = 'Module'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Options.Filtering = False
      Width = 160
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object TreeListColumnModuleStatus: TcxTreeListColumn
      PropertiesClassName = 'TcxImageComboBoxProperties'
      Properties.Items = <
        item
          Description = 'Translate'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'Don'#39't translate'
          Value = 1
        end
        item
          Description = 'Hold'
          Value = 2
        end>
      Properties.OnEditValueChanged = TreeListColumnModuleStatusPropertiesEditValueChanged
      Caption.Text = 'Status'
      DataBinding.ValueType = 'Integer'
      Width = 70
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = ImageListSmall
    ImageOptions.LargeImages = ImageListLarge
    ImageOptions.UseLargeImagesForLargeIcons = True
    ImageOptions.UseLeftBottomPixelAsTransparent = False
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 592
    Top = 8
    PixelsPerInch = 96
    object BarManagerBarFile: TdxBar
      Caption = 'File'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 408
      FloatTop = 320
      FloatClientWidth = 85
      FloatClientHeight = 135
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          BeginGroup = True
          ViewLevels = [ivlLargeControlOnly, ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarProject: TdxBar
      Caption = 'Project'
      CaptionButtons = <>
      DockedLeft = 163
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarImport: TdxBar
      Caption = 'Import'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarLanguage: TdxBar
      Caption = 'Language'
      CaptionButtons = <
        item
          Hint = 'Select available target languages'
          OnClick = BarManagerBarLanguageCaptionButtons0Click
        end>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarEditItemSourceLanguage'
        end
        item
          Visible = True
          ItemName = 'BarEditItemTargetLanguage'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagetBarTranslationStatus: TdxBar
      Caption = 'Status'
      CaptionButtons = <>
      DockedLeft = 156
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagetBarTranslationState: TdxBar
      Caption = 'State'
      CaptionButtons = <>
      DockedLeft = 271
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end>
      OneOnRow = False
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarProofing: TdxBar
      Caption = 'Proofing'
      CaptionButtons = <
        item
          Hint = 'Settings'
          OnClick = BarManagerBarProofingCaptionButtons0Click
        end>
      DockedLeft = 235
      DockedTop = 0
      FloatLeft = 824
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonSpellCheck'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarClipboard: TdxBar
      Caption = 'Clipboard'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 824
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarFind: TdxBar
      Caption = 'Find'
      CaptionButtons = <>
      DockedLeft = 110
      DockedTop = 0
      FloatLeft = 824
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarLookup: TdxBar
      Caption = 'Lookup'
      CaptionButtons = <
        item
          Enabled = False
          Hint = 'Settings'
        end>
      DockedLeft = 411
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = ActionProjectOpen
      Category = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = ActionProjectNew
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = ActionProjectSave
      Category = 0
      LargeImageIndex = 2
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = ActionProjectUpdate
      Category = 0
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = ActionBuild
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = ActionImportXLIFF
      Category = 0
    end
    object BarEditItemSourceLanguage: TcxBarEditItem
      Caption = '&Source'
      Category = 0
      Hint = 'Source'
      Visible = ivAlways
      PropertiesClassName = 'TcxExtLookupComboBoxProperties'
      Properties.DropDownAutoSize = True
      Properties.View = DataModuleMain.GridTableViewLanguages
      Properties.KeyFieldNames = 'LocaleID'
      Properties.ListFieldItem = DataModuleMain.GridTableViewLanguagesColumnLanguage
      Properties.OnEditValueChanged = BarEditItemSourceLanguagePropertiesEditValueChanged
    end
    object BarEditItemTargetLanguage: TcxBarEditItem
      Caption = 'T&arget'
      Category = 0
      Hint = 'Target'
      Visible = ivAlways
      PropertiesClassName = 'TcxExtLookupComboBoxProperties'
      Properties.DropDownAutoSize = True
      Properties.DropDownSizeable = True
      Properties.View = DataModuleMain.GridTableViewTargetLanguages
      Properties.KeyFieldNames = 'LocaleID'
      Properties.ListFieldItem = DataModuleMain.GridTableViewTargetLanguagesLanguageName
      Properties.OnEditValueChanged = BarEditItemTargetLanguagePropertiesEditValueChanged
      Properties.OnInitPopup = BarEditItemTargetLanguagePropertiesInitPopup
    end
    object dxBarButton3: TdxBarButton
      Action = ActionProjectPurge
      Category = 0
    end
    object BarButton4: TdxBarButton
      Action = ActionStatusTranslate
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
      Down = True
    end
    object dxBarButton4: TdxBarButton
      Action = ActionStatusDontTranslate
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object dxBarButton5: TdxBarButton
      Action = ActionStatusHold
      Category = 0
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object dxBarButton6: TdxBarButton
      Action = ActionTranslationStatePropose
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = ActionTranslationStateAccept
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = ActionTranslationStateReject
      Category = 0
    end
    object BarButtonSpellCheck: TdxBarLargeButton
      Action = ActionProofingCheck
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = ActionProofingLiveCheck
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxBarButton10: TdxBarButton
      Action = ActionProofingCheckSelected
      Category = 0
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Action = ActionEditPaste
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = ActionEditCopy
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = ActionEditCut
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = ActionFindSearch
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = ActionFindReplace
      Category = 0
    end
    object dxBarLargeButton6: TdxBarLargeButton
      Caption = 'Auto translate'
      Category = 0
      Enabled = False
      Hint = 'Auto translate'
      Visible = ivAlways
      LargeGlyph.SourceDPI = 96
      LargeGlyph.Data = {
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000000E744558745469746C6500436F756E7472793B9D0B04DD
        000009AD49444154785EC5976D8C5CD57DC67FE7DC7BE7CEEBCE78BC5EEF9BD7
        BB0683B1EB601A1C371817D4268AAAF45BA4004A9BF0A292F6431BA944084494
        B41F5A8AD2120922944869A4B4AA2A2A5E1A14DA10686ABA35B80263B08DB11D
        2FB6D7EB5DEFEBECBCDEB92FE79C9E5EDD0FABAE2A3EF6AF7DF4DC3D5733CFF3
        7FFEF3BFA311C618FE3F4B64CC3BF7E401509ABD893677260A62657E19297331
        4AC4EF4789793254E699AFBE997C171080C9980DFFB399376363D3EE86F3BAD2
        E667D22D7EB656A860A4607E798D28EC53AE6D65F74D137C7C69EEA9BFB9FD7A
        F0C8BBEA471BC4E506033A83CA587F9219F1C51B790238F047B7F83B6E99BAF1
        50B9588720A0EC06C4387CD4C8E3967C8AF112C5E01227967CF342EFCEE74E4F
        3C50925EF9204E6E4A2BD5D249704605EDE351F3DAF1E6E5A3671B177EBE0A44
        4002A89BEF7BC1A01330064838F7FCEF9119602F30FDB951B7F83BFB27F395A0
        895A59C635924AD9A71D4ADEBBD623E71BEA03501910BC71ADC6FB87BFC7AE4F
        1F666AB4C6D5959099F93697E75AACAD75E9763AD783D5CB3F6C5E3AFAF2EA87
        2F5D06FA407CC763A77492689A573EE0DC3F7D358BCF70D6E29137E693B5D74F
        5F5E5F571AE9418CA6DD89A8E40437D47C8200D6DAD06E19EE1C6E3175ECCFD8
        EAB5A8150D5BAA2E77FCDA20771D1CE3F64F4FB277FFD4F0B6A97DDFD976EB3D
        2FEFB8FB5BF7003520FFD65F7DCA1108308AAC90087875869F18C32F5FB3268E
        5D695D6B95EB383E28A9E9F6FAD44B0E5BF2B9D4C4FB8BF0D2E53A011E0BFFFC
        347947D30A14CBEDD89A71D951F7A8950B4CED1A63747272AA3A79F0073B3FF7
        178FE62AA34340FEBFFEFA5607BDD1800180E51E7FA221F9976BB17B7CB6B7DC
        2FD588A4E1172B9ABF5B2EF39F6191D33D41F3B30F32FCC4AB8C3FF61223F7FD
        3903A53C9EE3102786B9F5C85E0B46AD09216160A0C2B6D1315119DFFBA72387
        1E7E14A803FEF997FE400A21C812C8D67081EE7297872243E9B5F9B0323DA7CD
        74B34AEF2BCFB1FD3BAFB3F7E963DCF6EC7176DEFB04233B26D8363C4C79A04A
        D126E3380229C11582855642DE930C57BC942786CAEC9C18A73ABCE70FC70FFF
        F1034015F000012001BE78030650D6C4D9D5C079665DFB627A05F1F16D0F53DD
        7B98BDBB46B9F9861D6CDD7933F5C16D948A25BC9C8FE7B938528010080B3008
        03CD9E62A4E632B1D525529A4EE291AB0C8BE2B6DD0FD7777FFE2050021C614B
        C2868D067D75FCFE8FC3DA3E7F198F0B1F1E63B5D9254A40C81CC3B52223559F
        6AC1A5E80AA400630CAE14547C69EF79DCB43DC7E4568F4819A2D8B0D64A305A
        E0F803F8D51D6395B103F76F4801099041B8C5ADEE965D77DF53BFEB1B08E9D0
        B97A9A33FFFA639AAB8B5CB6F3996D44744245C183B1AACBFE111FAD0CBF3EEE
        73E360CE1A93B443CD470B21334B21BE0B9E2BD046A7700A759BC4C8DDD58943
        FB813C2025C0AB1711803B7CE0DEDDE5C1D1CFDF7AFBA718F9C237312A62EECD
        9F70FCDF7FCEF5C5251AED888566CCAF16FB9CBC1AF0D6C73D94D24CCFF478FB
        52C0A9B93E9796ADC940D10B35BD4853F605263128C0B845DCE2D096F2D02D5F
        201B43960002F00A83371DAC568A695C437BEEA47CE04B205D4E3EFF2433E7CF
        D2586FD10B62FA91268C35B13229A25011279A3806959D25169D409393A0B406
        6DD0B1417865DC7C79FFFF3620015F16EA876BB522312E5EB9CEF891AF511AB9
        19AD132EBCF234A98130218834419C7648122B82C410C59A585B24865869540C
        EDBE461A83B2504A632CE3967072C59D400170DC347E3203FEC06D03953C5164
        C87B05CA83631C79E82F79E7F517F18A5522E3D08D0C90759F28A2C4210C1561
        A209238D3562919AA01F6A8A058D529086A0C0481F47E606011F90EEC61148AF
        B063627B817AD96320EF50CE1770CD1626266F4C77BA5A29E379394060944E0D
        047DC591C99CE5846E4FD10EA01518D6BB9AF58EA16DCF46070C41CFD0978644
        BA345C59005C406C34204D1275CFCF76F395720EDF15E43CC96FEC2EF3C1428C
        510621FB08D1471B88B521490CBFBDCBE795533DFA91B248BBB65084B1C6249A
        C1BCB61BA451898512B8AE42C7619FAC5CC064D049AF31B3D6EC6F755C496211
        2963BB48105AA6F30693421950690286208CE9F69334FA3032A463482C424D5E
        18C2D8A4ABAA14200D26E9A2A34E0350809159F71A88C3D6B553AD75DB4D5FD3
        B5B091B2DC8A11C6D0B2D71D2BD4B1DCEE59D14061852D546ACEBEC68AA79D13
        DAEB48295C4713669BA1B54108017193246CCE037D4049630BB0200A96CFBDD7
        EDF6D31D0E328185D5088149D7AFD34D6865E29D9E15EF697BAEE85B049145A8
        ACB84AC5E35023D104969531184020205C25EAAC9D07BAA90180CC40D8BEFAF6
        E97EAFD1E874FAE9AAF5ACC04223C231A0137080D101977DDB3D0EEDCC7164CA
        A51D247C665C706058B267503232007969700524A1A2D935180376AC08DD245E
        BFDCE9ADCFBE057400E502009A3481F30BEDABEFBEEC17071EDC32B81D21216A
        6AAE979CF48BA59413E9A77A6E45D1E8699A81E2E098E4D84C4C3E07BE303818
        B6FA8AC040101BBA91464A89740434E708562F9E6CCD9F7907E86506C0D81242
        244073FD57AFFDB43878CBEFBA7E71C8F78B0CD98E55AC0985E6C2B584E55682
        3106AD2C2CB7EB0EEBDD04DDD4241A74A2A915049E48D22DD95276684702115E
        275A3EBDDE5BBBF22AB004F401E302645040B73B7FF2C3F59937FED62F561EAF
        8E8EA195C399D92EB5B26313900456CC088381D440A39D3E8AD126154769D2F8
        8344D24B4853ABC816BDD6053A8B1FFDA2317BE235A0012469E31600085B8004
        CAC0D4C81DDF787CF086DFFCB2280D81C8610C760C5ECAB32B1106C0186EDA26
        393BAFC91261A82A2CC36AD7A47397AA8D6C9EA13173F4E8FCA957BE0D9C03D6
        C90C48B2CAB64167B3B9B674E2C7CFAE5E3CFAD3687D16D56FA76B7465294C1F
        36235587BC803836740245A215791FB667E2CDBEC0F51C64B4885E7B3F155FBE
        F81FDF05668016993880C838C59E7B9FE7FCF3F70AC0036AC0D4D0ADF73D3430
        7EFB97DCDA645DB85B304E815A5192F7A01F1B5C34B191382265DA21903411DD
        39A2E553CDFF89DDFE7D1FB808AC01D1EEBBBEAE2F1CFD0100920D658CE6E037
        4F1A20CEE67471E9837F7C66F1837FF856E7D21BD3F1CA89AEE95CA4DF5DA0D5
        6901315A9894FB619BA87505B1F61EF1ECBF759B177E766C7566FA292BFE6416
        FB2A10D9F7D72803C0E604BEFCF7609485E1FC8B0F0AC005F2591ADB4BC3FB6E
        AB6CDFF75B6EA1B6C7CB97471CAF50958EEBEB380855D86E26FDD6F5A8BB723E
        685C7DAB75FDEC7160316BA40724BB8F7CDD90E95D98FEE126039B206C01D948
        F08132309071293B938006C24CA80B34330E8024BB6F36FD38DD64E0938D3880
        9BB1F37FFC304D3228C064C86AB381FF062CC1A4BBF2054CA60000000049454E
        44AE426082}
    end
    object dxBarButton15: TdxBarButton
      Caption = 'Dictionary'
      Category = 0
      Enabled = False
      Hint = 'Dictionary'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Glyph.SourceDPI = 96
      Glyph.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001D744558745469746C650044617461626173653B44423B536F757263
        653B53746F72ACB1EA720000029849444154785E6591CB6E5B551486BF73B54F
        E2D83881242D0E992006A1158A50C78C90102378843E04521F821740883760C4
        089870197480A0266949012548CD055F523BCEB1CFDEC7FBCA91155509D9D2BF
        B4F6607D5AFA56ECBD27A8DE379F7FD2B9B3B6FC300E8307C0561470CF7B1779
        07CE393B57F64069DB97A5F9FDE9D1CBAF3EFBE2F161356B630020DADE683C5E
        DFF9A8535FDD265D6A506FAD81156004CECC22797E725F89FC7E311A7E580B7E
        FD14780F10AF00DEB8CE1BEF7E4018BF0601E00C04293ECC08A30AD88E486A23
        965A2BFCF3E497B78198AB0210686DF0F204965382A8859507E8FC296A7A48D9
        D35CFCFD82B896D2DE5EC7280B10DE005865F1DE501500F016BCC6BB2A56E34C
        952858F4466980E006E0F27CD21D1D1DEC36DE6C92AE4454F6F06E015D00CAA9
        C0E505CE49F2F1B40BD8EB80306BB576C32463D23FC39E0C91839F5093BF984F
        7B889EA518CCC896EB34D63649927817486F385042D2DEDA265AD9210C5B38B9
        86CA9F2D1CC833C1E88F43C2C8B37AB78DD97F79DB812A15DE4CC1CD21747835
        C2C933F4EC183551949311719A62551DA36F3BB0F968DA3DAF1C34DFDAA0D64C
        883078A7C0AA8540994B3C822052CC2E451750D70169D66CEC46499DCBC129F6
        6C8C38FD8E72FC1C39E9333BB5E4FF0AB29584D67A46142F1C64C0C52B07F342
        B2DAE910B71F10C6AF63DEC9D09327C88B3F295E48FADD23C2D0B37AA789FB6D
        7CFB8C66AE703A07570206AF8698E2189D1F538E75051A93D412ACAA61B503E0
        3AC088520FF6BEFF796373A746EBEE3D966B8BFBE3AA78AD91A541CCA1783EA1
        28F5C9FF1D886FF7FB1F1FF77E78B814FFF87E12F84E3D0CB69C7578E7AB3884
        B63DA1DC69A1DCB3BD73F92590DFD8E0EBBDE13EF0084881E40A1E5C05C00016
        9803F2EACF7FF1BE83483B8CD56F0000000049454E44AE426082}
    end
    object dxBarButton16: TdxBarButton
      Caption = 'Next untranslated'
      Category = 0
      Hint = 'Next untranslated'
      Visible = ivAlways
      ShortCut = 16462
    end
  end
  object SkinController: TdxSkinController
    NativeStyle = False
    ScrollbarMode = sbmClassic
    SkinName = 'UserSkin'
    Left = 536
    Top = 8
  end
  object OpenDialogXLIFF: TOpenDialog
    Filter = 'XLIFF files (*.xlf;*.xliff)|*.xlf;*.xliff|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 344
    Top = 364
  end
  object ImageListSmall: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 19923288
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000002B744558745469746C65004F70656E3B466F6C6465723B426172733B
          526962626F6E3B5374616E646172643B4C6F6164F1C3C4630000022249444154
          785EA593BD6B545110C57F6FF3242AA9B412144B3FB1500CA20663FC032C6C44
          B0B010041194147616366295805A88A058898D8D106C444D6C44123426120959
          36B8316FD9F8F2B15F6FDFBD7746B9EFAD82019B1CB81C6698397366E006AACA
          461000859CC959F327FC079DC1E1C4C381D785807EB21815A827E642DF8DB1E7
          E30F4E8BA2A0CA1F12A5F7FA281D8488F61FBAFC940C8A6DD5987A76F3DE9D4B
          FB468F5C7D53653D0470B94B426704DC2AA4DF517184380E9EBBB6DD99E1F2A9
          03DB4072BB0AA2608C1B1BB8F5E10C6032012BA00E5C422016D4D2250D0E5F1C
          24E8DE0104A00208AA8ED1BB57FA80AEBF02A9CB046C82DA26625BE00CD4CBA8
          CF1B54F21A1556AB75809E20080A800BDEDD3EA67D8343C8CA272AD3E3C40B15
          54404510C92EA7A28888E7A5F92AEAD38A38AD862675B4E28864A1C872D460FF
          F961BC786E1B71A85A108B3A8B8A0149894BDF78FB6868DEAFB05A2E11CFCCD2
          B3AB174D221AB32F51DF90DD47457C8C737E1D114769B2CCCA9A19094DDBB154
          9A632D5A66E7F1BDB42BD3D85ADC29CC9A54C04F17C40B0951B1C29772FD4598
          B62D4B73737477F7B0796B487D6602DB58F6D63B2E347391E71CB59536F1CFC6
          D7FBEFA362D86AA4B018B1E7C44992C529926AD14F50BF7BA749BD082A5EA8BA
          9010D7CD0860C24633FD88AB1D9D1C79C5647E5D72560001505401554421B55A
          FEFCA3F9184803600BB00928B01EC13FB10206489E9CDDED0036FC9D7F01FAB6
          A14B22EE620A0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000003D744558745469746C65004E65773B506167653B426172733B526962
          626F6E3B5374616E646172643B4974656D3B426C616E6B3B44656661756C743B
          456D7074793B130452ED0000016349444154785E6D51314E04310C1CEF1E0289
          B7D0D3C035347C006A2A3AC413A8A9111D15E20B743420D1DE6310E2F612DBC8
          B11372DC269BC4BBF1CC8EC70B5505118D8F2FABB7611C970A850D3BEC2EC2B6
          D9A79CA68FDBABE33355DD2CE06300D1F2FAF2C8E21D10407EC6FEF0BC3A0130
          1AB01210B3946093045A49D4379BFE10F6F706E45C72879E002CCE2E1DDAF1F1
          1ACBE859B8C27A05A9D61DA0DE030A02BBA3AA80FE1178AA4803951C356564D0
          CEC4CCBB04393114A180C84F4F6B31A99794D2AE026CC2448181B7DB286122DB
          1245E61905927301899802448CE8405352569E333145FB44B5815BDD2EA3DDE7
          AC331E30438BC46656AB5B10C362CB9933910B525D41DF3E9BBD1A19C0336D44
          628163156182CF4AA643FB01F30C8164F7E0F060E11D28C904F5DF7B77C44B10
          F13A7B82BC9EBEDF6FEE5E4F15CD441069B09707146AA6F5D7A775BE27989EEE
          2FCE01EC0118AA2FFDD9C51AE01F03FE022E9833255C6BD8490000000049454E
          44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000000B744558745469746C6500536176653BF9E8F9090000020349444154
          785E7D52316B145110FEDEE6EE9A03EF2E57284A6C6DAC42C0262185829D0A36
          16820AFE010BADC47F60AB2022585A588875B01041822158D858081204956872
          DC5DD6DD3733CF99D93DD713CCC0F7BEF776E7FB66E6ED0654912982633EFCFC
          9F67A2603B2CAC9DBFB2810CEB4B274EE1E4D271B0303832A24450A94C113112
          2846ECED8F301A7DB59CD76F379E9F6D9901425A5F3DB38C4F9FC7B87BE70690
          60E1E49C80BC886049B87EF33656964F6373EBFD1A8096190466017352B0ABA6
          BF22C4D5C9C5972E5CD632010F1F3F0553C4CECE17088B8F9ED99292B898884C
          EFE2548B270711D942867E7F114717BB9E0308582A83962D2C6EE0EE2925EFA6
          245671899205ED561B9D4EA77EC7CA6D887063904CCCE29735C923BEEF4F91C4
          A771DC7FF008C7865DEF88896B23FA6310BC03226FEFEAB55B9A203E63823143
          5490445C3883D05F23F8FCC228F26F180C06B3CB730059BD57866F20229EDF18
          D42358BC78F60487C5EAB98B5A6408E63903B1F6BD358B9FE302F06D729610BC
          B2AE20B63CF9D780602072579FB9F98B6082E6DF8D044932FF156CA648EC89F7
          5E7E844802299851B3C26667F30BCAF31D043B3091DFC3917E0F5C895C1C4D3C
          03E095C79303A4CA20984111CBFCDDE6D6F6CA70D0C39B571F2A7164AF129589
          14C65E59B0FB631765596C03C8030033E929BA8A0C4D8443F6A2982AF67E037E
          F6AC9379188DF20000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000027744558745469746C6500526566726573683B52657065
          61743B426172733B526962626F6E3B52656C6F6164CD4DF6E9000000B1494441
          54785EC593B10D02310C454162001688D8E0FA1BC2A2A3A14F895241CF128C40
          7B5DE86E1F96301FE947F249761A4EA2784DBEF3EC28C946557F623D81DC5F8D
          040AA8E04D2AD7126B42C1165C80064C608C047B2094DC40060792C16C24C913
          9C5920A683CD0723290B0137A941107A92CCBCB66CB1399230F3E8875FC1F5F9
          D8F59AD8F12A83EC8C1F1ED30A0A83190C8EC04AC4BB8504A62671AEF16424E1
          431A9B24E048C97A4FF9FFBFF103FFEC875AFFDCA9F30000000049454E44AE42
          6082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000011744558745469746C65004578706F72743B5361766546D49E310000
          02A849444154785E75935D48145D1CC69F597752C3B24C5E83EAA58B280C5E2A
          56892EB22E22C88BA4ABBC780D0BCA2ECCD0A88B500991288A85C2A8E8830A82
          E0C525FB80B20431B008D74273D12CECA2CD6D5BF755576767E77CFC3B737649
          43FA313F660F67FFCF3C676040440B74A9BC50A05598FBCF2F9FDA5E67068ACB
          B38A0064298DB206133B941EFC012125AE1F7F09858709324E55B5EC5BBB29FF
          9DEF80778F1BDAE36746FB59BD0F43E9D1C9739ACA5C659EB2B0A265E974D80A
          507FB88D8E5EF689AD47CC4B797F19F9EE8C1E3E78C2DF05183B133FA2902450
          BE6B1B5E472E226A0F00A42FF8EBCF2162BDC712F36F74F77E40A0F3E160F433
          AF7603BCD50D7E56EAFB072F9E76E2E6D516907050D3B601574EDE01490E490C
          F15408E19920B864C8C95A86443C1777DB3B925E008694029C7108CE202561D6
          72C0B944D4EA5343FD1092E94121B9FE9D901388C46D4C4FA5900E10028C7325
          0317128280352BB6A0A6F90CD21838565B0A41025230F4F68EE34D772C141F13
          877580105237E09CEB06D39640EDDE7B906A3D339340C30D9F3A7B2146232378
          FE388CB1A1E4AD6F6F65D36C9462BF1A389C4328FFADAAD34F2229414458BF6E
          353808C1C14F78F6E83B56792A30FAE4FE690013ED1F778B7403B73EE328DE5C
          A2872408B393FF23168BA1A070251033D015209414D5C3B6090A6B63A5573436
          77410770B7418A213AFE15FFDD6EC53CF4B12CEB109A5AAF810903C3C3437009
          3DE070D101EE5939635A97D8940D0DB9170130111A194376F662388E03858788
          E602DC41E69ADED4C7A04C403AC2004B39F09AB99042426120C3FC77A0FFD4D8
          31022E094220735712A970068F9D849442A7CE0FE089C978CF40B0AF6C91E9C5
          60F00BB83054558694CD95496838834824C058EA95BB52FEF621E528CDCC7A6E
          6F21A4644A9B8874959FB191A9A729553D740000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001D744558745469746C650041727469636C653B4C6F61643B4F70656E
          3B4973737565C206CFD50000024F49444154785E7D93414854511486BF19DE84
          944544CBC05A15448586619BD2DA07096D0229A8B08D9BA0856D8A16EE5A242D
          8A40284C68232ECA9D6042B590CA214A28279519B5C61C199B7166DEBDF79CE8
          300C2EC20BE7FDDCC73DDFFF5F0E375255001E0DCFD0D7D39AE0FF6BEB7F1D78
          FC5EFB7B3B008830C19A1F0C4D4F005DAACABF1253B0BD288AE27D98BC73F3F4
          F9FE5E150324128964DD21198274DDBE7E8AEDD6BD87539D5B1345E927672692
          093A2528AF7C00A01207140045C5F096A2B92985B73324816000443B8FDE7881
          F79EB1A74B008C8CCD34A29B621F7A2FB7E35C0380018213084574731EEF7603
          D0D3DD6A0012D6083404173C400AA861002FA001F5559CDF09C0D0CB0F983BD4
          D5AE42DF950EBC25209ABA7B121188421CEA800ACE0900572FB56D7155D04463
          E7BC019ACFDEFF180321F2B182C4846A91F63DDF987D36880641551051101B21
          2262DA5D5DE5E2AD63591B73D0D5C8C5814AE1271BD9798EEF5DE270F7003659
          11541D8843438C95AFA1BE6A5558CCF06E6478310AB54031B740FEFB1CFB0EB6
          A1B522E5B9D7A8784B62D733770F21A0121009E4D20BAC17FDB825F8BD90A194
          5FA7A5E310D59534FE4FA171D09A542078038981847CE6179F73A5D128AE79D6
          327334A59AD8117936173F112A1B20A19142EB29104B4069BD4AA150F93AF836
          FF23AA9463746585FD278E5059FE426D2D6B0E2AE65C07A9415031503E5762AD
          E4C6011795CB6E1ABFD13EFB669AD9499B3BA8290A20008A2A600F0C62AFB9F4
          F2E6101047D746B367811490DCFE195B29E080EAF30B07C2B9965DFC05AC49C4
          7E0DF9E81B0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000019744558745469746C65005461626C653B466F726D6174
          3B436C6561723B1A97D51A000002CA49444154785E75935D685C4518869F397B
          CEC698A695986E76A14AB3EEA6D96852891A134A4345633590DC48945E0822A5
          8A1755420D815294629188A5469B86D28ABD68F5A25650A4172524B5244D1316
          4D5057A3C1354BB2DBFC904D9BC4A47B7E3EE95CB804EA030FCC5CBC2FF3CD30
          0AF00106FF8F228F68C1151101300F7C32D0AF0C5F2302A215B49E20E83D61BF
          03E221028E6B5F3B7AA8E539C0D6059EA71ADB9AAB110480893F17D8112D0514
          2024FE9867FF9E7250683EEAB9D208F8FE2BB073AE0ECFAFD82042F2E66D4A42
          9B41D04C656EE3382E82C2320D6CDBD9309699B31D7E49CC919A5D469480C0C8
          E814E8A5864B97C708068A896E0FF0CCAE0ABA3614E41CAA6201B63EB4054471
          6324497DFD76942804616838C9CBAD4FF0D3CF29EE1FBFCAC3FD97F9F6D986F7
          94528701D7B83B02FAE2D038AE8080A7E3100916E333C01FEFC398FD8BF2575F
          21B2A7B1E3AB86DAA380A99ADB2FC9D375513D6B1E5D48C5B62D84D42D76E592
          58F37F531ADB81D86B185601BFC7135CFFF262977AE3DDF3D275A40DDBF110E0
          E27771DA5A9FC4327D7CFDFD1095993182B90502B108E4D611C08A543179EC53
          266FA6316D7DC3E0010AF044304D03CBE7F288B546E9D2342595619C6C1644B0
          AA7692E8FC90B995652667E74EA87D6FF65C33ADC2DD0808426524482C1A623C
          95C5DC5A46933F4D786A14A5C05F53CBC4FBDD4C2F2DF26366E6E4B14CBA5301
          45803FFFB66C6E7EFBDC919AA71E7F3D1C2EC3F6A02A35C2CE0761E283532417
          E7184AA77A7BB28B1DC03F88C80681C2BDEDDFC8891F66E4F8C0B4F6C258460E
          1EFC5CBE8856CB6B459B4E03C580B1CF2AB8E727F27E1B1DEE1EEC8B73C77629
          2982E3DD57E94B3B9C5CB5CE9E5B5DE9005607EB9FF7961D877B9DC0008A4375
          EF7CF6E84BBD52D1D22DE54D1F4BB0EED019E001C0785119EC45D18442E9501E
          4A1E7B8BECAFBD065000DC07F8000F58BFEB0B189E4B3EF32FA0B35AC6D4781A
          190000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001B744558745469746C65004164643B506C75733B426172733B526962
          626F6E3B9506332F0000036349444154785E35927D6C535518C69F73EE6DEB64
          63A3AEFB60A3A36E33B8C56581E0D8707E21CC1A43A2A22304FE3001512A86C4
          E900132451FF503367420043B244364C483031465C248B4441C0980C45B4D065
          CDBA4ECAE82AAC5DBBDE8FF3E1BD27F1397973DE9C3CBFF7233964226FC2D543
          A53E0280443E3FD752525AB14323FA06685A3381E492F329C6ADF39954E2F8C9
          C3DBA6018858DE940A9C2C5870C1D51BB6FAF61DBB327860F81A1BFE25297FB8
          3127C7EFE4E5D5745E9EBB9991239766E481937FE4DE1818DB0DC0EB322EABBA
          B63FD5EB7D6CCBBE6F1B83FE9E67BA82E084C0E4123697CAE0D109BC94805B0C
          E7AFCC606A66EEECF75FBCBB753AFAEB2201A0BD3E7861B02914D8DBF34408A9
          AC0D2181D3672E23319D81AB950D016CEBED824E809A722FC62E4CE17A343130
          D4DF73507FB9FFAB551E9F6FCF93EB82B879BB088D52504A14FCC9CE4E95F79D
          B80CD396284A8179C7D3DD1144F29FEC5BE1D73E1BA6BEB2C09BEDCD955A7CCE
          44D1744C1687C9045C05EBFC686F0DAADCB08413D2098E89B4E1BC5779965687
          5ED585D03ACBFDA548E7197EFA711C776EDFC5FF12200A7075F4E85975D7D4FA
          F1F4A635A82C5F02A2956CD46D2EEB1D160B455BC19FEE5E0F4A885A45828071
          81137D1B61DB0C1E5D43E4C8CF5858E4D0A1810BBA5CB76DEEBDB768C1E604AE
          EA6B1F40D9121F0A265385BC0E5457530109404A8010E27805EEE60598CDA15B
          8699C8E7CD4784EEC3F2BA00767C340A4AA9327E79300CE1505BDEFF0E9AA681
          5082150DD5604CA26858282E1693D428E42F6666B3909068EF68C5E6171FC7E6
          17BA611A260C93A9029C713CF7FC3A3C1BEE404B5B2398E0989FCBA190FD774C
          CFA46243B11B4B77ADADF67BB236478E10500AA5D2121D5C48354D3A674108A1
          56114C201E4BB1D9F86FA70880FB1EDD3E34B0A229B4E7E1350FC2E22E2011BF
          16C3FCBD050557562DC3CA964608B8B4C4E49F4924A27F1F193F1DD9AF03B0FE
          1AFDE03D113EDC6431B1A96575089212B4AD6D555F581280D902398343308EC9
          EB49DC9A981A75E043000CA46D09005A49457059DB4BC78E77EDFCDAEAFDF892
          DC3B1295EF7C13977D4E444E45E52BCE5BE7AE338555E10FDF0650EE32B30E4B
          D24C0212A8F210EAAED3D01969BB3FD0BCDDE32BEB06D56AD5D09CCDDA66EE62
          EED6EF43A9AB2331008603ABCEFF019D3AAD15CCD8D2E00000000049454E44AE
          426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000021744558745469746C65004170706C793B4F4B3B436865636B3B4261
          72733B526962626F6E3B6463C8680000037D49444154785E4D8E7F4C94051CC6
          3FEF7B77E02073EA92742577579B684891E62AB6C4526B6013696BC9DC5A0B33
          D0322DA716D3CA94A21A8E96E976AEB654688E409B46B859CC249500E3F81588
          234EE0F875DC1DF7A3BB7BDFF7DBC16AEBD9F3D9BEFF3CCFF7C13555CB58A801
          40014CC5E5696BF638D24FBEF7EDF2D683550F7B0E5666B4969C5A5EBBEBCB65
          2F0209803A116E6438F82377A66A60385007A0E4EFB2A5BC51B1B4AEF4EC5AB9
          D476583A87AA642C7055BA47CE4A43F72752713157F67D93DE54B0DFBE04308D
          867E9E290050725F4BBDB7F8E8B29EAA86B7C4E5BF203DDEE3D23E71585AC6F6
          48E7E4C7D2E777C870A05E7E68DE277B4F668C6EDE6BCF00D4017F350A607EF5
          48DAB99CECBC9CF4343BC3E1264CAA60C282AAA8288A028A30313E852DE509EE
          0C4D72EEF26967CD17FD4F0EDE0A064DF9BBEDEB6CD6C51F3C9DF5382EFF1540
          104014216E500C2ED6DDA4F67C3BEDB79BC9C95EC3E8F8784AD28288BBADC1D3
          6C4E98652A7C2C7D2543816674430304C4885B0755E1CC99EBCC51D750F14E35
          DBCB32E91DF98DCCA5ABE8FCB36733E0500D3132EF9EAB108C7AE9ED1BA6B4AC
          969F2E39896A11CE5F68212529975D5B4A395A59C40B79CF6049D0489AAD81AA
          3C0A9854436741140FE148809AEA16CA8AAEA34C65F1E9E7F524EBEBD99A7F80
          53751FB2707118EB836642311F31C63174497C286BEE6C55D3F48971DF2088C1
          A60D6BF9BAB6849D0547D8FD520D2F3F5F822FD8C7AFCEEF58B16A11FEC82831
          3DC6A87F8868C488745C9D0C9AF5A8D2E51EF15BE72FD248B127E2F5FE8DE3FB
          FDEC28280755E1FDCFB691BF310B6FC48566C4C030F08D458984B40E4057837E
          ADAAA7CB87A0E2090EB2E491594C1A4DD45C2EC779AB0E53B287C4399384A353
          718288A8F4767B09F8F4F380069094BBDD7AB3E474869CB8B1428E5DCB90AAB6
          0DB2E59055B2B621C72EAF93134D99723C8EE3F79572A83A5336EEB439EF9A67
          990FA82A1071F7855EF9E35AC0D3EB0C010A9EF000799B56F1EEDBAFC7BF87D0
          0D411185BEEE30AD8DFE88AB2B501CF0C4FC5706DE34CC0D7F15E9AB53BF6A17
          784ED78C4AB72BF6803DDD82B6B013D5A420064CB875FABB628CB8A21DEEDBA1
          A2D6FAB11B8066480C7EE92F045000737CD6BCA736DFB77F7D616A63EE769BCC
          B0C326CF6E4D6D5B5D70FF47C9732CF700164099CE4D3373FCA76CAB43052CFF
          62065440001D884E130F19FC4FFF00FE20CB5D5DF1FFF30000000049454E44AE
          426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000023744558745469746C650043616E63656C3B53746F703B457869743B
          426172733B526962626F6E3B4C9696B20000038849444154785E1D906B4C5367
          18C7FF3DBD40CB1A2E32B55C9D598B4CA675D8D13836652E9B0359B67D589665
          3259E644A52571644474CB4CB6ECC23770C4449DD38D2885005E4683AB69C616
          8DA12384264EC8AAAC0C9149A1175ACEE9E939CFDE9EE7E477F2CBFFB924E720
          E6E943CC3B8895D12B00A0FEE3D08167A75A5BBAEEB71D9D081E6B4DA549FBDD
          A3CEEFDD1F3658016818AA98A71FD1915E202DE980A19D741E3EF6E0F8A7FC7F
          673B6979E002C5BC43B4C2581EB8480BE7BA68E6441BEF3B72F03300990C8E1D
          5016554E7B55D6C1ED9543C6C2B5BB739FDF025988838424E4240F10A0D2EAA0
          D26540AD37203CFE17C2C187A3EDBFDE7CF3DAD4748403A06EA8A8E830AC5FB3
          3B7BAB1901B717AE23DFE1CEC5EBEC90A0E0EB71A3CFD981C0B017C6F252180B
          D6BD74BCFA856E003A0CBDFD966DF250532AD4FF038DB734D18557DF21CFB08F
          2E37B5D370ED5E72D7D52BEEF9654CE9F91C1FD392EB0C4D3A0E4BE7F6ECD909
          CFDEFAD381AF4ED0A3D35FD399E272BA3F3D478F971234FD2044BDCE930AF798
          CF2FAED0DF5373CACCFCA92F2970B29DDCAFD7F56B48945E918201C41738945A
          2D581C7461ADA3192AB50AD64F9A010272730CC8D4AA313BE44289D58CF85D3F
          2411504BB28D93845489145E041F9CC1863C09A11BD7E1EFEA86240339463DB2
          B3F59025C0DFD98DD0C83594E6886C360831F408523265D208BC0021B20A35A7
          82B8BC0429C2239A10D812417988007088B14C8A8421EA75A094044A8A48F200
          17E78587629220B370E69F2884EA3750F07E23245946868E43A64EA3B8695F23
          F8EA7A046763EC780AC9640AF155FEB1269AE0BD91AC8CFDF910108E26F15A5B
          33788D1E860CF6CDE7CF225D45FB3F02A0C7CE36076E5CBD84825C3562A20E4B
          097E0CAD051B5FFCA97C9BE4ABAEA05B2FDBE9E6BE0F880F8568FCDB0E1AA9AA
          646C579C654AEF564D15FDB96333FDBCC94A8E751B6A0140DF5168B9E42A7B86
          266AB6D2ED1A1BF559CAC853B58DFCB576F2D7D9D3AE64B777D96862D716EA2F
          2BA76F4CE62B008C1A00C2F9C57F9D8DA2C99212C5E72C85323699F320A77FD2
          72040021DF9885F56BF2204457706F9EC74C4CF2F744169A012430DBF21E00A8
          2B754F98BEC82EEEED7AF2291A306FA451EBD3346633938FF13BF341969D62BD
          CF738AAF6ED6EA4B006882CE77A14ABFD255D2799903606830E4EF28E274070C
          1C67D74255041044C25C9CE43B4149F8B16735F41B8038DB9300E07F6924ECFB
          01D589CC0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000003F744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E5365745369676E73333B436F6E646974696F6E616C466F72
          6D617474696E673BC5369B60000002EB49444154785E5D536F48536F143EEF76
          27685991058549C36CA985454490CD597D8A82FC4384F8A1A2B0D035B5BEE497
          FA90066626044260189893A00F15094EC2922611A39A12A63FB7F99BD3253A37
          67B9393777DFB7F3BE779A74EECECE3D7F9EE73CEFBD5C70F95F084723E86AE3
          FDFCE2EA26FDD3DAE682AFB75A0C511E795E557FAC04FB123A71F8CCE09833C3
          CD47060067025C663A945ED3A47FDBF0AC9859BE36B0414F1B73CC75F188F93D
          56DF5EC46E341EEF3E5F99B70B01AA315F27E03C08F0E5BA23B9B75A4EF83ADF
          D5B021EF13F6D155C72CA3D758F7F025D63352C1FA9DB7D9E0542B7BDE6B62D5
          0FF4B3A5D70F683989A9311FC8DEBC6DC9A7CB759F0BF30B0EA667A44220E402
          CA647120C6008D89480881B48D5930ED5984BE81819EB6BBB6526CC6C8D53B47
          AFECC9CC68371872617E6902C11484AD81C5BF5242D2B4642D58ADA3E0189BBC
          6A7E68EF90240D29D36569613E3C053295D78657592832204E446E81B0077459
          BBC1EDF69663DA250190C31B360344681498185206293A41350817A4D81391E2
          95B2990251B13CFED624949C4649586C17A66C52404281C884AFF2534D0864C6
          B6F01D523C2ECF8796425B89860F5001123F854C5145D6D50881700417AED05F
          3C55C596E9907F6E09C1042895D119B2D3C43D15A4A246454DA8F0FB22105D8E
          0FF315526831FA7ADC1138B57DE70E04F235CA51D8BFC7614CBC4A3510187706
          617121FA125B2B2AEB2BB7D9EB0DFC3731BE006A2209CC9A028C3246BE5D51AF
          8109D76FF0FC1FE8EBED709AB11457057D91D04FE7E2C541DBB4DF3112048224
          04545C8120E1A6226A017662DF6E9B0DB87F046BB11C29ADDECF54D8973F757B
          86866D3EFDB7CFD3EFFB2D1E98F546418E4990A44981F88A0433DE08F45B26C1
          FE69E6C388CD57F0DD3AE3E038CA95D9A71E0B75892F2DF5645966E5D98A7DD6
          22634EB0C494C3CE19B383672A74D6C20BDA2AEC6F4ACC912F9E662832660329
          36E502614C487ED33ACA8992122E29C4A215478F7147108375F6070B79B97E38
          56EEF50000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000011744558745469746C650050617573653B53746F703B3B
          8A7A3C0000012249444154785EAD91C14AC4301086A7D68AE89328EC9BE81EF5
          A6AFA04751F02D647D0341104FB23E8908227A12B6AE2D6B366B9B99D4FE2565
          1743C8C51F063EBE0993494BFF996434DEBFB97E1C7EB4958FC6C35B3814180E
          3D9C71DE4B7AF5B0D7E4FAA9992E9E1B309CF370E82DBDCB1AA067664BD9464A
          2F933B02C3F53ECD127ACDEF97DE657DF509681AAB481A2170BF6AC07B1B101B
          A1DA7E93888063DE1F604C7F1383C33E3C40A812859BC0111F1850B322B602F6
          7CC53A32A01632A2A8D06F1DFBFE1D1CDB604E95D160CFB33038F21159135B03
          8EF8D06FC4411170D4FB03D8DAE9E717CD94E978D5174549E5CCF940B283939D
          B3A3F3C1E4F862501E9EEE5EC2A1C070E8E14CE75D923FDB6CB6B5ED846EEB07
          E0FC96E3B9F3168D5F3C1F3F11AF0B16D00000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000014744558745469746C650052756C65733B5761726E696E
          673B0BD1AE46000002EB49444154785E4D935F689B5518879F73929A6649930E
          57B7A64163BA1B61F32E5DA70C04A573A23015E79D0C51A2171365420B6DC310
          D7A288A28ECE4E6138D9D83A6FD64E443BB032717688FF8515265D8DB36B3086
          CE6C59BEEF7CE73507F6C19EC3EFF0DE3C2FEF81F7281121442905A06F490407
          086081C0E55647037C91BFDDC90A687BBF3BB5ED7026F5C6B16CFAEC5436BD7C
          BC27BDFC712675F6C0FAE45BA3EBD63C08C49552FA44368DC34D10CAB10F33E9
          9752118A11212F2204A2B022B8230237C42E5D311C1EA95E7B07A88B88D5CE75
          F24426F5CADA882A6954BEE7F15D6CF9E0083BCEFFC6CE1F17B8FFD011EE7CE2
          6922E8BB366806873BE3834042B5D04074DF1DC907D24A152D24EE797990FEF7
          0EB1EEA1EDCCCC7DCDA9AFE6A8ACEFA1EFED03DCBB77088B8A776976EF4EC6B6
          036D006BDEEDEE983C994DCBB93DCF4B48A9342A07270ECAF8F8B84C4E4ECAFC
          FCBC38665F785626D6C6E5D554EC28D0A981F604EA3E6B2133F00821F57A9DA6
          D7A45AADD26834B8B4740947EEE147F1C592843E2011056271A5EE0E44E82AF4
          13D26C7AD46A352A950AC944C2D5F014746FD98A09A01DB2403C0A44ACA09408
          8EA9A99318E3B3BABACAE2E222BEEF532EFFC5C68DBD3804C1582150E05C0D04
          351B5C76FECAF9EFE8EB2B303B7B866BF5BA93F13CAF95A67B128EF2B96F3162
          F937B015C0D34073C5D85F2CC2D2E733E4723946464730418031ADF8C635A150
          28E0B830338DB1B012C8EF4043BBEB0F2FF8ACD5B17AF1D3137CFFE67E7AF379
          C6C6C6D8BC79138E8181018AC52273AFBFC6CFC78E520B64B51CD8D3C07F0AD0
          40D78BA9F6FD9BDAF4330ADA7A9FDC456EC76364FAB7E2F8B335F685E9697E6A
          C94D11B32072FC94912160395CE528D0F35CF2B67DF9A8DE99103A7D2B04D662
          AC60C4D542CDCAD54561E6742025A02C22BE06F8644387012E7F54F786BF699A
          E15F4DF06545ECDF1ECA73F947585EB072E607CB484B1E727229A6FDF0331172
          73B5E3400AE8B8593B1A401DB80A5C17111B3AFF0338A781C131C708F6000000
          0049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000017744558745469746C65005370656C6C436865636B3B5370656C6C3B
          53FC4602000002E349444154785E65927F48936B14C71F9DBFCA19DDA925534B
          9D3A6D9BDBEB720ABAAE9BEE75BB2A9A9699962204A636B2A566D245B952C1D4
          98FD7060964ED3A20CEE3547F68722256AA2E62F340B94B21FE294A4A4A86B9E
          DE07DED1C60E1C5E5EF83C9FF33D0F0F9290258A28D5799028CE92FE3CE5F648
          653944269C03715CB16A978FD09190A9E5118A52D84F960242C81E0090652309
          0587CBD4A911641950024F0C7204C9FE62450978ED8D700B8FD3E0832E543B50
          6D6723C0A01F4FE54F819420914DC8CF00212B0681B4B0D2831DF68730F63416
          3885C5AA112E1B818882451484415FAEC28F02614F488248F0E72970670BDCF9
          078AB080892578059C02A7A1FF1908833EDCF8600C7A07C97D79D242E0490B20
          589273C8DD5BE81A28CE2643A3F30137967805495CD32B7BDA73752340AA0D7F
          E1548ED868F175A6DB819EC6A0EF609B2F5FC64AAF7CD2D534F00E7ADE6C4076
          EDD0EF5D70656B07D1FCFF80E67E6CA1D9EF5B68E6DB4F34F57513E1E89CA834
          4F6AF240F3F07BE89C5B873C6D3F08536AFFB612D0D39CE834F6E6C3DEFB6259
          072F189FB68F2DC3DDE935286A1886B0942B068A71B3143048758BEA58DD1024
          971BBB88240D875E8599A079D87573E02DB48C99A0BC630A84A9D7469C99BB3D
          B0DC52E092553308C685CFD03EFA018E54F77D8AC9A93F292F686BAC33BE02C3
          B809AAFE7D0592CC9B1F77711379F88EF8297A642970921CD5EB4ED40F42EB84
          097A97BE80A669146ABAE7E1CEE42A5CEA5904695EDB265B785C4927B30B4DBC
          6125B0C3718934DDF5DCDA6750D3BB04FFBD5E07C38B15A87EBC08A91546F08B
          2ED36206B3F767D7105779D54A80E887B2839FA4D5675DEE87AAEE05A87CB400
          F9FAE7C0915D1CA7004FCCDC9B594577264D2888D4590BC49906B364E73EE5C5
          C68CEA3E287BF01244690D1BAC00528AD7EC985E45AD132BE8D6E8320A8CBF62
          2D20329A1171F8B659C20A21FF698AC9EF04365150618ECE91D7A1008BB610D8
          1403AF43C766D2529BFA05BA6881B1E52780230000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000012744558745469746C65005370656C6C3B636865636B3B752FF3FB00
          00026549444154785ECD93EB4B536118C0F721F05FE85B51C302459B15EA8745
          25AE084BC5629169DEC2215B6B11695A6462494A562211813742A5DC0C375C5E
          16EE4C410D9CBB9C4D669663E4B633DC663B3BDBD9D9D94EEF6306FBDE87FAF0
          3BBCCFEDF73EE7C0E1711CF757FC0702C1693904C588B914A408750A638806C4
          0384368526DEF1823B20E8E81FD63932850DDCA6CBBB087163DBC0B7BCF30AA6
          A0EC21DDF264C805E24D17D17953DEBD2510D6B3A2D27B2194EB83E13484BA5A
          F66AFB7255FBCE9B7E8D03041592E7DECE9E31FBB6FFE7C29113555C88A40CB5
          F21744DDAD2E2F1D63A6282A3A0D1B80202F4C4527730B15CCBB0F3AB3B8BACD
          877253A5D71F39CF16C9896B75ED7E45F3EB2D34841D3D5995FCB2625FDE7B95
          340004B79513FAE563C29A588DACCB939E2366917DF6A2B8D1592B7D6A7DF672
          18CFCCAF60562DEB4BFC9CAB4993F5EBD29E601F0082917A79C7F72B954DEEDE
          B7E378767E7954A5C6564ACB9B3DAD1D7D36321C994C1794306AAD615554220B
          564A1E7B693AF6194002C5AE2033574C6AB4980EBE76B5A47503B85026F5F0B3
          8A68D12589EFEEFD6E473CCE6A8CA6B5FE73C512FFFE436712A70A6FEC20412F
          0894C96412986318460FB02CAB8FC7E3FA68348A452211EC4F9E24492C140A19
          689A86BA2E9148B4F3A0F9C7CCACC9A9FD649ECEC8E6800D8DC6BC3EA1B6CCEC
          C576A5CA8A8F29AD10CF646471C691517C6DFCA3152EE081597980CFA90EF239
          9B6ADC821A2D4A74064CA3EF71E3F0280E75889707876C8B0383B6DFF5C35C20
          1030C0063DA9AB8135180C1AA008EB033E9F6F9E2088F970388C41AFDBED5E00
          288AEAFDF73FD32FD93DEE00CB2643620000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000021744558745469746C650050617374653B426172733B526962626F6E
          3B5374616E646172643B259B079D000001EF49444154785E75523B681451143D
          6F77418D86A056DB0AC26A61A512035A8C168A59B0102C5C2C836817145448E3
          070C2954B00AC4C23695209A66D32A29B7B6B050D2C8261A7666DFE7DEEBDC97
          9D0167DD03877BE631E7BC3B87312282024FDF7CD6D18541A2C7C20266C26090
          6D3A3BBC7C78F32E142FBFA428502BC4B7F54EF712DE0A33270B9D8B98BDD0C2
          F9B916CECD9E427FA79F246655EEDC6F775141A3106A6C5D5FC4A7B51E9E3CDB
          867316DE79386B71FCE01E4ECE77B0D3FB904C0E20C1D16333B83DF713DBDF7F
          00C6A05ECBD9A8E1C8D40198BD3EB2D46262000546A30EB4CE9C40B33983DD5F
          BB00044669540A606A58FE9A1D5A8E071000AE2CB1F7EEA69CBEB188D0DF8277
          0E2B1B6721C239B5C89C3183A316D267C6ABA5F654B941F0040916E22D82B5DA
          099E3FB882FFC113E3E18B8F2AEB6500B900D0101C2CC8E72482E277EA2190A8
          45460440C46A336580B701EC33B0B3FB648682D55C1A254E551CE8DF80603DD8
          65FA0991C46A8D09718A1453A20E24E31B884F630FE41C288C0A4434A82E8354
          108F6DE0202103FB7C9203094723AB510C507EC2E40E36BAABEFAFEA4DE93080
          9AED7D33974645D1C578C0FCEBAD6B8536C64C2F3CE23F1C572F8AAC0471A583
          0A586FB8F7783DBEC8C2A31EB8BA519814305C5BB9353DFAD50D14E393000CFE
          023DB570481AE91B650000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001F744558745469746C65004375743B426172733B526962626F6E3B53
          74616E646172643B9EE424DE0000032549444154785E85927D4C535718C62FB4
          F845196EF10F3448540644AD12C568158206D94417701D322C6D808252AC42B1
          463E8528D888AD016A6BB063912F8923925AA44D05B2588D18503794206A022D
          E8D46C685B688720218FF734AD1AFFD8DEE4C939E7FEDEF39C73DFF750747817
          CABBBBF34E5DE3D173062DAF8A0B3D54B9FA0E75A2DA44159CEDA48E567450E2
          92364A286DA1084F48AD49DE93A2E82273978154A6970D0D8F4354F49B945EFB
          100080FA5224979BAE940C5BFE0627B6E03459BB1CA3E3327D8F9ED20D3D338F
          439857AFA6C17C023D06EE9398DC749572F4C51B44FF50FA787968EC22CF0D5C
          CE02F185C893D59DB323CFADD82FAAD5AD08DDB6D87D8257F8961F593F65A8DB
          5EFF338954B16A6E3DE7E05617F384B8444B06265FAC91376B1F60ECA51D8919
          AADE90F571419C18E1525EF6C59E37562754759D088F3A5C4972433664501F43
          54D8EABA66087B87FFFE6CCDD3BE47AF68131BE205F2D1B4237516EBC414EEF6
          5BB079E7B127DF04ACFB8AE4AE64F33F1A78AA4BC4D8117F2C263BBF71EEF63D
          332A553730E19886E5B5034942C55C303B693BC901400586FDFCC94090D34006
          4FB158BB92CAAF97290C70FCFB1EC32F9DA8D218111691A6A799BFA7434BBF4D
          A4BE0C06AD45097C5956D119DDECA47306CF9E4FE2CE1F7F215B5A8BBD82CAD9
          A0D55C099D438ACBFCBC035E918212DFCC5FFAAB44F54F270FD50F41DD350AFD
          FD571834DB91537409EAABF7A0348CE0806600A9AA070E9EDCA4647F2FF4F398
          3079D57D35655A0B6E8D38611A7140613023FFD7FB58BB4584D08DE9286E7C08
          B9610C1D8F9D681F7420B77E1071457A156D308F182C8C97F5BCBDF9E23D3859
          4DF8EEB81606F33438E236D06C0D516C8111AD833308E7D5625B56331AFADF61
          6B6EBB95667EC4801529D15BABFF9C42B2C2849CA60154F4391096D264A7D912
          F2CF1B0F5CB51D373AB1ABD8007E4D2FC43A3BCD9B6D84B96E10CC3D5F17997F
          03B9372770F8F70944480C58B2BDBC919813BE7CF7B9BA4D1223922F5BB1AFF9
          2DD8A28ECF39C5F0F93A78198B53DAC28A3E67F58D92DB1644145EF1F60B0A24
          8C88B978D57FF04F2D242F2CC02D7F77ABFE977F003C798BE83E395B10000000
          0049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000025744558745469746C6500436F70793B426172733B5269
          62626F6E3B5374616E646172643B436C6F6E656D0EDF5B000000644944415478
          5EEDD2310E8030088651EFE41599B9014773E5100EC59088F91B2D51D251922F
          4CBC2E5DCCAC8B886C503BF78A378FC0681C60E6CD912AE06B47E43ACA52D500
          BA00C85F159140A26F804F202500CB81BC49C00F447500BFFD5CE05D77E00041
          2F543873A5691C0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000026744558745469746C650046696E643B426172733B5269
          62626F6E3B5374616E646172643B536561726368BB659C080000005B49444154
          785EB592C10900310804AFC16B630B4955E9CEE0C129C124FB303EC6C72A2388
          8F88186FEBF24372232F8843CE2E3F094004A81168B882F594B89D834940868F
          7D1384ED1C140BFC801FF50283BEB2734FA025415E3000FE3DA38A41B3014A00
          00000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000013744558745469746C65005265706C6163653B456469743B69AAF970
          000002F149444154785E75915D6C937514C67FFFFFDB8FE55D69D7956EEB04D9
          66A62E534CBCD1B8044214A251D165892C92DDA937A80496A1018D5E2C1A45B8
          003F50512442442E9CCA0226651780103BB20FD8071B3A098432F75537BBEE6D
          DF36EFB14B7AC1C57692274F724E9E5F4ECEE1FD1383BC9717A00057DB57BF37
          BE7DE4F2E13D47FB7ADE393690D9FD5D6FCFAEC3B16FDE3CD0D5047800BDE83B
          0E5D6A075CECF9FE0A806E6EFB6275DBD7DD9D1FFD744DCE0C4E49773C2557A7
          3372E956527EEE9F94F61F07E48D83174E6FD8D25AFBDADEDFF66E3F1413C054
          80DEBAFBC84391AAFAB3F5F79785EB6AC324B342D611727969402B459186E1D1
          09864627161EAC2D33874727F9724783DF15A9595BBC225C736CED03E5E1F255
          4146EEA418B83AC6CD1B534C4FFD4765652955D51554DF574EE5EA107EBF698A
          D78DD51B07D0FA89A6B75A827EDFC381B09FBFC6E7E98AF6712E1AEBF8F34ACF
          D6A1E88135D7FA622DE7BB62BFF65E1E63FC5F8B9468C667D3585606C07029A3
          F8A57B569510CF3707FBC718EE1FFA65ECE2B7DB66E383338033F577F799C79A
          F7AD0F044C1C1473E91CB6ED904EDB005A6D6EEB4C28A582083840E2F650CBC5
          1F769D7C6EE729BB73FFF39E275F3DFA81C70CB68A0882B0E8885A74A29F3596
          02F8819540391002BC80062878F15DF30A205250087003E83F1A1ED976A1BE5A
          4ED4449E2D841091BB05A09B3E471A0F22CF7C8CAC7F974F004303DAC965373A
          8681CEC926C060E9D2730998BCC1E6F93BAC931CAD8FBE42AD06DCD905FB054B
          38AD1CE745C0BD1C206B41661E236B13CA58303FC1AC3E5E57F5F4CC5C929393
          89FD02F76E2FF1D5017A098002304BE9C04B8795E0D3EBA7F28022918D019FC9
          CBC11567B54099529B96D942A7123031427332CE16D1BC5EF9382B752669AD8B
          8D4FEF7B6AE4E69A3971A25E910D806729809D816C1AC35EC095CB80F61072D9
          76B6FE9F5CAE15984939CEB922A17D99438A52E08B703C0F213DCB87B7CF731D
          C007780B21132801DC4BBCD1007C8579002802F4FFAFBC55FD76C606D2000000
          0049454E44AE426082}
      end>
  end
  object ImageListLarge: TcxImageList
    SourceDPI = 96
    Height = 32
    Width = 32
    FormatVersion = 1
    DesignInfo = 19923352
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000002B744558745469746C65004F70656E3B466F6C6465723B426172733B
          526962626F6E3B5374616E646172643B4C6F6164F1C3C4630000054249444154
          785EE597DF8B5D5715C73FFBCC9D4CDBA4650C6DD334516223452CD81A8B208A
          587D50109F2A2DD42789885450FF8116F441F4455A141F2CEA836FFAD23C444B
          25A4A5A57D504A29D8265183CEA493CCDCCECCFD79EEB9E7ECB5BE827B73CEE5
          1221948A0F5DB0D86B9F75EFFE7ED777AD7DE0F424F1FFB41EF03E2710420008
          DC9889F7C824B50A04A0C8BE6CA103C6B3EBBD6E41F1C2539FFBC2FAA1D51F15
          213C48362D0593B279EC33DF7DF1F780BDFECB2FE6B49002A0657D902020A42E
          7DEA3BE7AF4F60FDE0EA6F4F7EE97B470EDE797211BA8DE36CC485677FF2F453
          8F7FFCC5EFFFE28D9D07BE75CEDF8DEAEDBA4C40AE23878EDE07CD859457565C
          295EEDF5B8FBD4E7EFF8D4F0CC4F81D3C08D10084BE096DDF3BE9B0139204F8E
          72BCB8361C3E71827B1F7AF8D13FFF8C47176B51A7F9624BBA3A80687A6D6BAF
          7AE2911FFFE51CD02C13409E81644BC0DE7A50CDE10F1EE5F0E91F4071DBF55A
          F55F9F8DB72E9FE2773FFF0DF061202EB72078F4F4DC6D1918DC01CF246BA887
          600E18F294975BFEADA5D81773915B6EBE0BCCEF5CBC69218405029E41F341CB
          04945794C0526CC80C3CAF6A5A022D293324C3572AEA2A02AC6412CA9E099812
          B8C7EB82A2AE223C1D8A3528CE515323ABD37F2D91F14C4216913B856E66BC3F
          03B80970A0C9ABF500DC048AC82264095106CA7B99779567F0663AE2ED7F6C32
          D89D800B1072474A2BAE14EB22A8E4CCE3F75C13C2C534463DFBC833FFFC463B
          0356576836451EA1AB2AED2D1172F3F4CC1A46FD5D76B66B8E7DFA313E72F2C1
          4E55D18D3FDEC692B7FBE9DEB583CFFFF09B9F058ADC0227CE4A6C5AA27AC6B8
          BFC53B57AE32AF1AC8D54810DC900B97583FF1093EFAF0D759E941F3F69FD07C
          84A4A45248D57B3B478667F5280EB0F9E6DFA86A3F07A8552056639AD110ABA6
          6C5DDAE0635F7B92B55B6F2799B2D3DE1297A3D916CDD53720D6480958AEC539
          CAE4AD1BD05E60E7D26546657CAE2360A29E8CA98623A6BB3BACDE7637070EDE
          4A73E58F283659DADC53940E0270C7597C7F2801C9F16E9612E16880F0067636
          AE5567FF3A3E0F780F08D618F3F188D960C8E05A9F3B1EF8249AF5F17909A8AB
          4A8900EA6E89502296C01270CEE111CFABDC2114F4AF5CA52A9B97CEBE359A66
          05C01A518D87947B23C67B53EE3D7E029B6CA6EA9501255C960E4648DE0207AC
          AD58128A31C96FD65E6179030A6CFF7D834965CF03DEBD071AA31A0E18EFED53
          AC1EE0964337515D7E19B9137A6B84A28703215F31296670476E2813C30C57EE
          B5722ED678AC913514BD35B63776B9D49F3F07583B03B13166C301A3FE8023F7
          DD8F953BD8640F2124501021AC127A0740052A8A549D2717069600DD1A880D8A
          CD7F62E59B2002E3FD8AF1B0BAF8F4ABBBFF02D4295047CAFD01E5A4E4F0F163
          34C34D2CD6597A4086790972DCE97A1C423B071E230143DEB62CB90B700281FE
          C68849A5F3E4EA7FFDD5634981BA71CAC1008FF081BBD669FA17F07ADE1D2243
          2690B787E36DDC8228934142D9C96D0B2B05BBDB13F6CAF80AE080E4A2071475
          658CDFD965FDE8ED508F68867D641170DC32901C39045956458B37A1DD07D1CA
          EE0894DC63417FBB9A9FB9347E212B807B6A81628C54E309F7DCFF219AC1165E
          579D94D9C995AA93372B026028D584210A0997C84962E30C76E78C67F6EAEBDB
          D504D0335F3E2A941468E635AFADAE71EACD972FF2D64B179080E0B8070200BE
          F09A6F030864F901D42903D0C6C25D5473DB7F656BF62450035EAC14E421A4FC
          F61F361F02D68062F91B6179FF2E72CA92CF8119D0FCEA2BC71DD41288400954
          DCB8056EDC58FEAE387DF60A5247C05B96FF7B134BD6CB4CF4BEFD38FD379B7D
          158A0D532ADA0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C0000003D744558745469746C65004E65773B506167653B426172
          733B526962626F6E3B5374616E646172643B4974656D3B426C616E6B3B446566
          61756C743B456D7074793B130452ED0000007349444154785EEDCE310A80400C
          44D13D5FCE953647D8A3A5123C8416716D830A5996B19981DF0EAF45C4AFBD02
          08204055A3D83692517B680E50D98D30B3B3F72EE90B0770F7840003C632020F
          C8083420238E1B01076484AA0A02F0D5BE1A50C64D0108208000020820808045
          5500F808B800327A1D263F84669D0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000000B744558745469746C6500536176653BF9E8F9090000054549444154
          785EC557BF8B5C5514FEEE7D33B3EE6E36B1D02882853F1A41D046540C1241B4
          B5B3482C36601A41831048A148F01FD022B516366A21181051D0C2422DACC222
          61A322E81A22C4EC8FECECBC7B7E48BEC39DF774D80109EAEE5CCEBB770EE73B
          E73BDFB96F37B93BFECF9F34BB47BAA958F3977796AB0F860CA0A1E59A097EB3
          E0155801080003E0831E40F3F29BEFBC315A583893726E524AC8D9F1F3C575EC
          6C6F33DF83CB4B78F8A10760E630535A3583DD586AD01BCB14A60E55C1DADA1A
          960E2EC31D70A59F8A94F73FF9F0DC090065268166343A7DE491079B9C123C03
          C3A6C1D98FCE6379296369F900F2CA019C5C7D2EF87300B41E00A0EDCE0C7861
          F5149E7DFA28133235987BF3D9E75F3E0FE064B000F413C86636823BBEFF7103
          9680C5E1B032171F37A83936AEEE76C0B48E13C78E47E752B87F7CFE03FA5EB8
          7009A24AC6EE387C1BCCADB6195D02B1928B43CC482B6B1A3488CA12AD9A41D4
          508A72DF4F20E5014C17909070F7BDF7A12D06538565836BF88B29FA629F49C0
          5C604C4019C82A403890CA228622DA07E773CA0D9AD420370DCC9C3E2CC4127D
          61606CB72AFE590628149510514A0E3705D10912622BD23160D6B190F3008366
          C444CCC2A702BA1B1719F1FD13486ED102332103AC8EBF011209284A11021BC0
          24C0041A0C4723348301D40D93220474846ECC13AD9B55BCD90454850CA81852
          4E5013A0A39994B645A2BA6E0268536AB0B872887B53431B0C80076422CE1DB3
          0CD4839863D5108D27B6C2BD5B95DA5622306BF10879E6EC59DC7EEB52F83942
          2766A45C482199658C7D5B605A0820AAC89618E0F05D77E2F2AF1BD8D9B98695
          8382574FBD0603A924D5608F09C4E7F8CE09B872E810CC8DBE6CAF1A8BAA7833
          09882844249848405B5A3CFED493481C4320E4CE0F0113590136AF5D45BBBB0B
          EFB342C11134C4EDCED6CE6320FA5F04AAC2FDD6B620F7D2F5C427027B02ADAA
          E28F2BBFD3A10A13912DAC6A84E318F131670A28C222A15EB7B8AFAC03EFD266
          1087A784EB9B9BEC710AB0AA09520FAFAE46ABB5553DCCBFB6403534D00A9013
          C0C084428A2D12174F48F378E73ADC957BC0C31F98566EFD6B5C0566BAFF1458
          2928A54044812682EDEE6C414B81A78EDAA8D2216D8148A1C098265131BDA472
          CE5858589CEE952FA5392D10DE01857D8502098632D9C3BBE75E8F96047C7D3F
          B09AC0440566325507C7564F63301CC5182B606270DF7F0A083E29424BB1C121
          25F420BD2ADDC1A5D6ED031EB1E7D4F0EA65C52187F92DE0A1A942DBB8E9728E
          40E63AADFA8BAF7F22A89A626B6B0F6D89AB59D598A888D2BE78FC31C04126CD
          AC261963A8B36398FA53D096021381A6CA8A4C031C7DF49E182FEB546E7D061C
          DD9B2F318100E4B9431A5E53FBBE0B20F1A2E14D9852CD5AA7E2FAF4AB75EEB7
          775A4C4461A26480D51783A8F0E27969F54865607A2BAA0359C9C03C110A8417
          91C641ED1BA2D2679EB81FAC41630AE2C3EA7A62AC3D07935123207D285AC47E
          760CA90183460B6A30F6D7ADCA9F60F5B12FBE2E21EE5358115888B713ADEDFF
          1711AA065404E869E0BDEF7EC3D6B840D4312E420DA8D5A02008E7DC416BD329
          316A25D5C41573FF222245CAACAB58A28F79B488810DA1E2183546F0C6007547
          2638E299ADE9C693FA5183A504D497D7DF4498C3F0545DCDD494A04E914542D1
          4BA78DEA120C209D5627C108CE67207C9C3D9FF6AA8EA4001062760C305E3B1E
          6FBF7D69FDE22BC9916BA06193F1ED373F6032919810E9FE09916A4599608C9D
          134835D695CBBFA0C7B9B5EDF5B7004C88D99DD30E01DCC2D5BF1FE6AFF40FBE
          F7A81C7B00C6005A00DED74001A0F12532FE9D1F8FCAA1F3FE3BFE2F3E5E377F
          02C73EB2E2D2D4F54C0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000027744558745469746C6500526566726573683B52657065
          61743B426172733B526962626F6E3B52656C6F6164CD4DF6E90000014C494441
          54785EED96314AC44018852D766DB6132C245B5818C809B44B4E305749699B20
          8847706F3007B0F100DBA54E95C2C22B6CFFFB1606098FC9CEFC132108293E16
          927DBC8F4926FF5C89C8A2A802ABC02A605E3E0B50030B7A7072F4C0BA7B855E
          205C9C81160C40020CEEBF59AA00973F820F201A5CA6D40A70F9993BF0052481
          634822546EDCEFFD48A2030DA8C08DA372D7BA8995C852040C10927805F9854C
          0E0E1E89365AE0D9BE6F46E54212DB889DB2F3480C53BB83CB6F47E58C516CD7
          DCF338EAA00095CF9568286B7D1945B94E02998A72BD2FA32D6709CAAB31149E
          2BA1CF4F2D5F4F812ABCECFAC77849C052A00994AB5FE490404DA10EE47F2061
          CE5B3D46A0F04CBE03D845945F835F092ADF6866410B8425223EC56FE081244C
          CA2CC8780C2B86D13749248FE3121C816871127B30FB4052CE38903C2D7A24FB
          3787D245590556811FFFE4F2FAE6AD10150000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000011744558745469746C65004578706F72743B5361766546D49E310000
          068849444154785EB5976F8C156715C67F3373EF2E2CB48B15411BAA50AD49C5
          BF8126D47F69C06AFAC90F36DAC8176D52AA5DC5D8A62AE54389FD404514A325
          6A484948DA7EB0A218684BD3042B901636459B6E77C16CA184520A0B2CECDE7B
          97B977DE738EF1E4CDE4DEBD48B58D277973E67DB333CF739FF33C33D9C4CCF8
          5F2B491262F1BDCD37128B47060E27403AF09B1BB70DBF78E1FBCF3F717A1230
          C056AEBBBE0BC80C52DE6D99F1B3BB77F0F0AA1DC44AC1565EFFF1B97FFFEAEA
          EB960115207D7CDDB1E4776B77F2EFB5E1BEDFF2F0BDBFC6302AE52F7A87A506
          AA5A8A03646AC6DA3B7FB570CB8E0D7FADFC287B68FB86E31B81705575B100F6
          FAC49F0D1453C347D0462029FB954B81B4FBEFFDACF7EE4D1F9DDC30F024F5E6
          719EDDBB87A7F7EDD87362B871D7E0CE73A78002D0D1F127EC818D6B5C810EF6
          D31ECC15082571551DB85C54450CB5C0641865F91797F0E10F7D64F9B6BF6C19
          EC9F57FDEE738FBEF50CD0BCE19A6F0A605181C4C1573FB4F5C14AB5BA062333
          6078709089F3E32CF8E0752C5BF619CCCCE5563582084B3F75037B5F5BCFD9FA
          081818947DE3EAC73835B507804A3A8BC9C982279FDAC9C8C8E8E697768DFF74
          EC783E0914ED0AA459A5B2E6F34B1767499A90A5292F3CB39B59B35ACC9C3983
          DB577E0DCCB0882022F425057F3834CC2F7EF0188A122980EF5A1452B812C72E
          0E51CF6B7CE9D68FB1E0DA7903D5DE835F38F9CFFAB70FED1A3F5269933355D1
          4C0D4EBC314651088E65869A7AA724608828920A2246B09C13B53D600A80D334
          63E2D279CED64ED20C4DCC94372E8E307FD1357C63FEF24FEEDA7D60FF9C0FF4
          DCDBAE002A828952AB4DD1DB5BC5706042083878B9F02E2284601492D30A39CD
          628AA00553CD096AF9455AD244D51C5CCC30555A6993A9A973D426A6981C6FA6
          1D2654158209A60296E14018220135A324A1FE30487125C6EAA35CCA7307514D
          E849FB794FDF6C4E5E388294EA25F4F7CDE5D54363EC7BFEE8C89963F95D475F
          A8BF324D014582F84D1A2C4A0921080E6A6D0B508585F36FE281F5EB311CC47B
          02ACFACE0A5AA170E92B592F3D5CC5CEED87197DF5FCD6D1FDB507EBE7C245A0
          D9A98008129C049A09A8F99210508D847C2FB4F2264D0BDC79DB23C8AD0151F1
          51351A0DD66DBB95D93DEF25E8087DD5D99C7B4BF8DBB347383E72EE9ED17DF5
          3F019E0040DA4D98040984E803375E62DE43285C85A2555014852B658A93BAD4
          0CBE174B0902FD3366F8791E1ACCC8AEE6D08B639C796D0E9F5B38C073BFBFFF
          29A006B4005DF2F539D665C220FE6BC004148826AC4F34A2BF01538C942405D5
          94244BC90C4C32D2CC8971F6EC79766D3FCAB5336E61C5276EE3E9DD7B012E01
          05A08F0E7ED9366F18A4630412823BDB4720C6DCF7CF63ECF41948737E7CDF4F
          CA789591F466312DB87277DCFE1527F0F8D6216E597C0F8D5A1F2F0FBDCEA5BC
          051000DB727085052D508C6E1316E2249AAD82A59FBD19E27B00551430F13DEA
          6980BC5E63AA51070C0DCAFBE6CF67D1DC9B58B2E80E0E1F39C5E9B137997375
          3F60C462F3CF5F2256A702A108B40A57817ABD51BA1D55C42071326D51346572
          FC7C790D70E6CC053EBD6025070E1E266F16246478AAD41C03E0E53F4E5C9600
          1A42945F2841C0814CC177EA828329CD3CC70DE97BBCEF3F38E464CC80242993
          632A5D1FB66E05422014859388375282C6B92BB1ABD16C34B0389AC40900446F
          00C4FB832866D6050E302D86E27193A84008459C7F54A1349E22129C8CA5E01C
          E9342609719F945FD0F68A84A69B305084C21F6E86C76FCBA6FB89E3C588AE27
          8128B30118A5620A44D1F8D6AAB540078104881D03BA63188A80049F2B3E0A85
          20564690085A46303228C95982A1DE558434CD507DFB11003860E1AFDD80A92B
          828395A8A0D3E78CA1D394A0ED6B999096A6BE5CA51D269480B4CAEF81FB21CE
          BD13C4CA39A26D877EAE94631011341AD6541DE38A29D0102842AB4C818450CA
          5E26C0B7118C3652C4F372BAE011ADB837FEAB14203105A22E591C4182A25809
          36BDB78DC33ACF454254E93F8FA0FB635404EF31056C3DF026171A2D97513154
          41D441110555F32516AFE388AA3367E10AF87982BE0D01C3F145421132110183
          2042A577263D5A75603573F04C41CC481D3C5E7B5288E40C4C51159CB63FCF02
          20805D8E8002459E37360D0FBDF243830C8C4AA5C23F0E1D6762328FE3519FAB
          881262F791A93B1E1543D5CFF16AD4A9D76BEED6566BEA97402B629555FE5F10
          C9F4F8EAF44659EFF0CC00019A400E14805DEE4D1822BB66575CDE7DC580A257
          F20080F2FFAD2E27FE0B3AC8D37AF98699190000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001D744558745469746C650041727469636C653B4C6F61643B4F70656E
          3B4973737565C206CFD5000005F849444154785EC5574B6C95C517FFCD77DBDB
          96525ADE29948487C685096025716308B210E22BFA8F60E22B1157480C1BB7E0
          C2C4C74E17B810E54FE2420D318A8144890A110221E11513791AA03429F4C57D
          7DDFBDDF63668E9E6F2633B4D7525818A73DDF37736672CEEFFCCE3973EF1544
          84FF72B4C00E21C4E43D81E6713F67E8CEF75481B64C6134B06FD1ECA8793EC5
          5A59D116C47400BCF38F3E3BF2B308C43A5E18E064FFE11E56EF753ED4DC8A92
          F2B71D6F6F781240765700CDD4A3008175EF6C598BE9074DA9FDE0D35FD9402B
          00D99C629F929649D4050C80B4D98C53E54C36F973F10BC78E10AC11E82816A0
          8D83C274B5D4E272EEA5A83559DA3568023EF26B220F8EBC8AC89C313610DC4B
          1704473E5EBBBE6766EBFB20AC89338DE354430EC1DAFEE6C0EF20976FE16BC2
          5169227FF9B9959E1DAD7167319FD9F504F56F3BFCCF007A3A5BBF5CB161FBC2
          F6B94B51AF3770E28728B7AE61C6ABCFAF9A905F5F9C562CA6542AC78256E4EC
          B3FCED5C3B13930190A68533173C08593B0B8A62905AE418E0C7DE6FCF8287AF
          7CFB24ABB39BAFBCB09AD1E43A4DB9BF0E00098014806C6E4B5B03F9597E680D
          AD2447C0E28CBFFEBF477CA077698838930E6851D770E0DDC7AE7577B6F2DE99
          9BA578C7E60F4FFD32B92D5B5CBE4881B484961917D084FCEED9779A17DE3939
          06ECD2807DED6FA064D7858E2EACDAB413F3E6CE423236D82FF6EDFA3F806500
          64531768C9D14B402B689581943235400421802D9BFAD9C1B4A39148973A9D46
          48CEFF84A4BB88F69E2580D20B4C3DF8ABDF03E08899019542672914AFAD4726
          67F7D7A7DCDA2271ED68F5868117FB7996EB945250F506549B04A509D2380FBC
          6041108B07A018720662C96B409B28ACCF375F5A33F5E5E7FB027566C032475A
          218DCA50AD45A8F6126AA50600B4DB22CCEC5B31003000CE3F65123249A0B918
          6D3BB1E97A9C59273EE7821D25558C9FFE1CD1C0D11C2DB158E74FB503E1B846
          381682AE8C635E5F37F6BFB5FC1681F86824257DBF79F7F5375C0DE8B401D988
          90D64368A55DB3314C41C2AEE180448327513DB7178B1EDD8839EB37DDC9EAC4
          5BD2A548BB7574FB56E7A1F7B63E0E20B029D0908D3A9230425CA9627EE106AE
          EEDF86B472D3440532C5C07332EFEEA52BF1D0335B51282824D7BE03C5658B81
          4082AC2F7B9EC8769A060AED18BC781D71AAB925C93190356A48C3088D7205AB
          8AC7F0C0BAED68EB9AEB2261F1534E91828E06900C9D02646A8A5110C8B58161
          D1A4C5386710A2B580913F0750ADCB1F3D0045B9F37AB982FAED2A66F72E41B1
          7306922B5F8164EA6965638E4EE46B33D3B01BC611515E476081618059E6412A
          C0C8E0687CF08FDA61DECC01A84C21AD9573FAD3284257EF72E870083A8E8C6F
          4DB6BD7C5E35F9FCC247691CC38005B3C46FAD0C43410163436388EBD9D18317
          AA9165005019210EAB884A21549C6076DF52A8CA75E82CB3CC6B77BF4F282A82
          A115D6B1D59152209F77D719A250C4C8B55B086375888DFA7B20536854AA084B
          55B475746246D72CC4574FF2A56423366D29DC6784326A13B92B4C686D41B298
          3DAF2304040CDF18C7E5D184F3AF5C0DC84C21E6FC571BE85BF130547D042A2C
          B93B9E601D30138AB5363A1BA1DD679DA15A3B00BCB667046AA518B54A7CE993
          13E303136FC25422AA5490C429E62C598CAC320825534B1F5C2E4D8E612254CA
          3BE63FA5210457BA2B442316B880C0E88D2AC2980EC346BFE7D9C5868134D3A8
          572A105A60F6C21E64A317A1D304E429CF2307B99CFAE8BD13C3802D52B202CB
          8A2804181F0E71BB2E8FDBFC13836300411A2B44A532BA7BE7036915596514A4
          647E4E2BEB88450382C1107C8E2738D51004DF1156CFA26580D1E138D97FB976
          C432C0D8720024A5441C4658BE7A19B2F210741A7B2AADC0464A9E5E57F56C8F
          4C4C3C4360DBD46E42661AE5F104B5863A716E380E7963F7C65E021906B224C5
          99D6B6A0FFFCB14BB870F4A2895070BE3973FEA23181BB09204C2798419E195E
          BA39E5F51327AA747CA8B1D37E3DD34121709F2C45FB31D9E6BFC5FAD1B4BEFF
          3DB29427001A1CF0174FF799889A7E13DCFB10B8BF61AAD408B1F85F465EA9F0
          EF0F9AACF80BA05D20D02252B9300000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000019744558745469746C65005461626C653B466F726D6174
          3B436C6561723B1A97D51A0000079549444154785EA5970B6C14C71DC67F735E
          DB38726C134193F2083606038D018B36A90821895B8828843E5355D0AA55A206
          B54A2A554D4BD24A69EB80AA84568D95B401430221C1B40D6D9A12688481808D
          31E010283636061BFBC0BC6C5EF1E36EEF6E6F67BAB73BAB954F8714299F3C37
          B7DAF3FDBEFF37FF59CD093CA5CD9F590250045200CA51A60F86FC9166407C7A
          D8ADA5E112B001996EC200B2BEB3FAC3DD2294F5109F410FDC150ACA562084A6
          2B9076B2E1172B2A17EADBE90608A5E04F2FABE056BA706990F19F2FE0566A3A
          7E91158BCBB8956A6A9B1ED42C9B34197E842868BF122193CE9CEA67508440E9
          8F0A3562A9FB6E44895B32BD385082DC9C103A75419A8410810109DE07050825
          829C5048A908564EF97FC1A554A0FCDC950B56489494EEFFDAB69DD1C0F1654B
          3D030E587F09A8145C68829654521B508C9407B6A544795F844C0D69934C26BD
          D916585622A3013B696B0312C2BD37693F7D357DE3F831D3DE7AC1BFD69106B7
          9582F7779F70AB955262272DC6B6EFA35C5D736F4E88E403E4027121846C7EEC
          6B4A69B38687514C1C5F44C4C8498BD25BA7F696F3CC983971A4B740B49FE865
          C98299D8B6C44A24183E7B86BC6B0663EEFF362878F060233B1FAD7C6EC98E7D
          BF07ECFBFEF9811C3E58A78EBFB4C64BC075AE082A93CAAF0CDC482128DA2F3B
          B022ED54D592841523D2D549EE477514949612F9DF51508AC292494C9F3FFF99
          9DB64C2EF9A0BE0A48E4CF7B44EE5B5CA93C033A0EA48E5800D2EB76A1706375
          EFA767A0FB2369DBC4E3A6537927A30EEFA2B0B484F885F3A0943BE2BDE7195D
          3C8929F31E7876BB25D5D7F71C5805242AFFBBCFF696C05D3BCDD7D113BC45DA
          8A800F412F48B77ACB810F7676907BC8819738F0F3E7502E3C6854F35C983B26
          4DA474DEDCE7B65996F86EFDE155405C00058B9FAF1B5878EF245ABBAEA63597
          224D813FDDED7622C6B8781F4FE6763A55DE4DFCD245006D2018FEF56D6565F4
          F55EE6F8BFDE5DF383431FBFA07B004A268F41E6E70570CD1640EBB130E5738A
          03034ABA0D9774E005FD6759D8DB41E1B88998E1B0074C378067C028284014E4
          635CBE48F1AC8A955B000300E5ADB1929A28D1748554C28179654BA9F4832989
          158F717B7F370BCE35307AC20407DEED47A33D8C4C20ABA09051D3CAE859BF11
          D312E4FDAE9AC2DA9A9541134AE547AB5D004AE0ED5789ADA407B76D12319342
          A7F2AFF6ECA768DC78A2DDDD1A98D94056A1866FD884990C91F3EB35986BFF48
          F68DCBFE36F49B5069B4421118C196A0F4568B45DDD82BBB3EE48E3BEF227AF6
          2C9A4C00F62F1C7891070F6FDC4CD476E0BF7989C41B2F133EB097363356EDEF
          020E1FE9A6EF7A64C4331EBFD980634D9D242D13695B7C63D19788944F256FCB
          9F3DF0C8175D3918297899037FF36D076E909D82BF5E4D4FC31E4E4463AF54F7
          5FF59AB0E2F638CF7FBF8278428248872BFEF1DE11163D5C4E4BF715868CD17C
          61DA9D0C9849FA1F799CE93BD6A7C10152B117903B7D0AE1B76B315536D94EEC
          C937AAE972E0C723B1575FBB7EBD0A88FA4BA0E3F3831728DDB949CB22168D70
          A2EB120359A3B967EA58FA87E20018E5E59CB09E60E6F6756879DDEEC2A7D2B3
          E51D4C72527037F6CEFA3D1C33CD5737DCB8E9C201CB0077EDF5D001B8BB0217
          3E343444FF70940251C48CD2B15C1E882394F093C2B86716C7E23F66F6F6D700
          2FF6DC69A584B76EC314A3309CD82DA7F233F5753447CDB56F0D0EAE02224002
          5086C79308813E3C78062C2B492C364C5BCF158A2B2A985C3C868B9FC482E396
          DFA30844F96C9AE32B98DB584B6ED964C2DBDEC30CE5613C9B82BF4C47C36E9A
          86231BDF89445643007F3C3FDF3560C513F1FDBF5DF39F871500122595BBCFA3
          D2E68B95F3292D1D43EFCD1821083A5E2F943F67CF99C3F5680FD6D68DC48CDB
          C85AF922C98DD5B437D4D15838EEFABFFB5AFE000CF9F053DF5AAA56EFDA8B00
          72805C3D670142CFF9CF6C683EFDE57B8BE94BC50E28FC1313282108E99E31B2
          4348CBE240432715A7EB99F5D8A3C8375F71E10722D14DDB63660A7E4D579F6C
          5FBA540154EDDE830124011B8801420F0350494B72EE6A142D0D573A79815290
          EDC0AD88E9C0CF902D2525CB97D1B17327F1FDBB6834CD9A1D31733530089880
          DDBE78B1C2B6014848E982D21FC0FEFB684B6BDB5F4CC5D3138BC77A7002B9D1
          39F068244AE3FED3E408C5371F9ACCAE8F7A3918CE4118E3D69D8A9D7C41C3E3
          80DDB66891DB6FBE924A79E7C1F4932A1002B28182FB7FF4D7AA29B367FFF4EE
          92CF0141F7E5E484B0E3110ED677304A08967D65AA0B6F6AEEE06AB8BD66E0F4
          A62A6040C3650A4E9A7EB97B2F21324BE9A5196EDAFC54555BF3D1755D672E12
          4F5ACEB091211B736080FD75AD1896CDF72AA7B2B3A987034D6DF4779FF4E183
          99E1816C5466030F3FB54D015277ECD0C77FFF7955DB91A335673B2E0110BD39
          C0BEBA160CDB66F98232DE6FEC72E027B9166E5B3FD8B9D98F3D06C8BFAD5CAB
          C82C6CA530C8A0842599FBE4567568C372A9AB186C7DF7575596F5A2EA6CEFFD
          89928AD17982F965065B77B5D0D36F71A3B7A326D2539B827FE2573EA568867A
          FD4F3F0340A5BD6A65EE81FB9EA845DADE19E1D85B3F14BA2772803C3D0C40A4
          2D570C88EAD4E4E4A2E9AA78B01319744E2665369041428F2C3D8732FE020E86
          E253EAFF4E60C805383D93BB0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001B744558745469746C65004164643B506C75733B426172733B526962
          626F6E3B9506332F000008F449444154785E8D570B7055C5F9FFED9E739FB909
          E40121E4C13320963A80888DA47F4450B41D915AA0481D6B6BA7B5159D3E9CFE
          517CD4D13AB66594DA426BB55AB1A530814A5B194B41D1227104E4116C54484C
          02216F929BFB3CE79E7376BB67F79CE44A8769BF99DFFDF6EEDDB3BFEFFB7DDF
          6E4EC8435B1B410801A104D4F5181D43780200EEBC87076E9D437069C3E30DC7
          38631C5C407AAE3CE30C8E333AEF30079BEE5E04DD5D70CFEA05504CAE237963
          65E541CD1F928B906F5C000FAF9AE77A896EC3E1DCFB490C140019D4D3AF344A
          0EDD9F24F2237F9C4F0C2A40D63FBFEF8A6861D10AA20596504A2294D02B00C0
          B6ED53E0C8E672C69BC9A1C1DD9BEEBBB90900AB086B0C003F9FB5392E322F32
          E80E93A33C620E0E820A45EE427BF0A5B7BF142A2878626C41B8765A55312AC7
          C510D435948E09CB2517868D39A665E35C5FB2AEB5B368C323DB0E9FC924861F
          DB78F7F53B013895119D75666DC5E4ABE0F1522EEBE4FFA07C454892D3754FEF
          9AF2C81FDF3B585359BE63F9C2DADAD54B2FC3ECDAF188C44220111DE7333901
          1324AC212CE63E3BA31C6BAE9F85158B66D64E9D5CF587F52F1D3AB876FDE6E9
          00F4AA884EABA33AE123E5E0172BA03E26467499F5F77FF5FAE2C231C53BEAE7
          5417CF9A3A0E71D34647C28046FC1E21C271F95CDA71C038306C0A2F06D17000
          5FFCFC7434B7F65FF54F90C6BB7EB2FDF6DF6D58F30600ABA62080F694C5D9A8
          020C9CAB8D2A3DF275CFFCEDBAB12565AFDD7CEDCCE29AAA12740C1B4898B68C
          5C042CC15CCF213C94E7A35D3F6C38681DCCA2AAB218B72CBEACB8BC72D2EE3B
          1EDBB60440C06FDE91001C47915729727AE78F5F9E1E1B5BB24D6410A4A1207A
          53A6DC5C40914BEF13FAC17881F8417145D09530C10241AC587C59A0AC7CE22B
          CBD76D9C01409F1C0B505F796A598ECCCC6FB8B1E3AB5FFCBF79934A1D5DC390
          9193646E90CC7149946F69EDC3A6CDFBF0C307B6E3FE07B7E3D92DFF406B5B9F
          DCC776B85C6F7BC15D48E760100D8BAE9A565231F58AE7010405E86F7FB0542A
          41932243511799FD379F7A75D5B892C2BA4A21DD60C6F636637098DAD0F7DB76
          3462E1F4623CF8952BB161CD955834B30C0DBBDE0330AA0473A45252B1BE540E
          1515C5282F1B73F59A07B6AE02A0FBA5D0B38635927D20147BF49AB935E88C1B
          EA5832B58C7001E19977309329034B16D4624A751902411DE98C813F37B6A9CC
          051863AA648E07316EBB9045FDBC4938DB39B001C02E015B80D39D4FAC90D9AF
          FAFF9717971517D406A311983906CB7BD8F260BBB0D59C6BB158087A50934405
          D130745DF308D9C85A4B2926BFE72C061209A37CDC98695FF8EEB3D702D00488
          0E6534C702CB26579608B94C494601700210AAB2A7E0A0848C5E611C5ED713B9
          2610A01E1983707014B1AF84FCDE3D640AD54AD1DC3CE606006F08D87E2D28E3
          FA021A0CA23F6E898C34689C836A045D670770F06033BABB872EBEF82521DC75
          946260308DC79FDC09DF264C28467DFD67306E4289EA1F9B216D31140AB54083
          F33D0530A2000399C902010C244C24321A4A8A748483147BF61CC5B23995987A
          CD2468BA065DA30808CF38918DC641609B0E7E7DFF4D48650C2910A540477702
          BFDFFB3EEEB873A92C692A6B833B0C05B10038D56AF34B405C70C68A723691B5
          1363F40EE6100E6948A74D2C9C3B05D595A508057559062200019B01E04CDD23
          134BC0F22EA4DA2913B065F77124330E12691B8CA9D3643AF291429F97421971
          9B2769E4E426B6B7D8301CD570D110344DF38E21BC9A3209C605F28E29938008
          3E0000B2F9DCBDFDDF52394B7E1F3986F0CCB659226BE44A1D682A4B4EC12950
          5010C6997383A8A92A050154F600D2860D65EAFA2D8804DC215451084E7CDC8D
          68414836A24FCE094336CB0497938467BAFFF2E058B9D366DAACA3D1286CB913
          0301455DFD6C6CF9EB096C6A382CEBAF09E89A86171EBAC54F02B1888E5B7FB4
          1D94C22F910C7CE9757391356DF9F6C3993A5556C680651AAD0064017D0558CE
          CC1E4DC5537585E12818E1B0E5F60EA2454558B97A3174AAEAEEDA8B2FECC170
          228B582CACB2E69035FEFA376E829163E05C653D94B290CBD9925C7CCA6C5343
          49E4B2C963009C4F05904DF4EFEFECE8BB77D6C471702C064EA894326D3AC8E4
          32D04080D11854B339AEACA38DD73D682065A82E63720D6430FE5A4DA738D7D1
          874CBCEF801F00F54AE01C7FF5D1B77B7A2E7C32D4979033B2C16CE6351B8725
          BC7FABB9A6530A47122BD90589FA9D3158729DFFAC24972C83FDC3E8EE1E683F
          F9DA930746AEE2ABEF78817BF5B0D2F1EEA7DA3F6A03A8CACA71617B70A03CE3
          8846C368E9BC80B1B1104A0A433879A60791481896ED28E2FCF56E120E97CAB5
          7FD48E647FC746008617007436F2A606EBE4EE871B026BB77CABABAD67FEF8EA
          09F23E00A1A0840302C45B39FFEACBF18B8623F8E9D643702D1C09A26EE16C64
          0C47F60207469A8E73F5DCF9F61EF476F59DFC60CF130D004CBF09A9FBC0BBE7
          53DCAB8939D871ECDE96532D4389E1041854296C019677CEB5C2186E5C5E8F95
          B72DC1CAB54B70D32DF5704251E4A4ECFE5F40E9A592897812679A5AE27D67DE
          B90F404665AF8CCCBBED37D8FCF3DBE15A5D554C07109EB1F4FE65A5D597FF69
          E6FC5981A29222990A910A788D887C53133CEFAD86E5BD66272F24F0E1D166AB
          BFEDC4D75ADEFAE5EB00D202F6BC35CFF163DBBF0DCA18C0A1E0AB707AFFC67D
          FDEDA7BEDA74A869B8E76C6FFE8B8602870097F06F42FF1AF65502077A3A7A71
          E29DA6446FEBB13B05F95E3FFB773B539C7901EB7EE43E3C79B22D079EF9FBC4
          392B6FB0CDEC7362A33993674D86AB06710908C77F9AAF1047623089F6E6760C
          F5F636F59F3EF09DEE537F69F6C82D5F1C9F97BA033916683C97E2F941749DD8
          F9AFA65DDFBBA1EBE3E3EB8EBF75F4EC91FD87F1C987ED880FC4918AA7C1D55B
          B01827111747ACADB90D47F61FC5F1370F9F3BFFD1FBF789679709F2534A7645
          7E48707CEAFF02D7939112A820AEA98E11008E7F5C5ADEF8D92B0076D67CEEAE
          05F19E4937EAA1583D40C2540FCD90E5B1CDD300376C23792833D8BEF7DCE197
          0E03C8E61D37C727271E992F3C99FDE5CDB8947DB0EB9EFCFF0D3581401E3439
          AF8C79B0F2E07880E0E097D81F04FF9B913C4FA5F7A18CE78149EFCFFF17FB37
          66AFE935F6829A2E0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000021744558745469746C65004170706C793B4F4B3B436865636B3B4261
          72733B526962626F6E3B6463C8680000098749444154785E8D570B7054D519FE
          CEDDBB9BCD6349480C7910214882488804C25B5E2518F041A5D5215550192D30
          BCA28E531D713A6851C6B1EA0C68950A5A2B2275C096F2465AE340B0BC820931
          40020979BFC826FBCA66F73ECEE9B967EF4D769C71DAFFCE37FF393B9BFBFDFF
          F7FFE73F1BB2E5E3FB21D98880CD80046BCF01489201BE2600B111AC7FF008C1
          CF1BDE3FB284E99482E90C3A87C641752ABCAE510ED3F3FDDB1BBF87CCC0F0EC
          F29520C643220020F6109F0169714F58A4E4278836C6814D0F9F30BC40AB7F2F
          63E00F63A0CCF0D45C53ECFC72B7E09169E42B0695F0E235661019F183C41207
          D9B6A7E8DE78977D991C438A2409B184907BB987A6EAD58C61203CA07FEBED0B
          1F7CFDB767AE00A059AE1514006BF6EE315F6D1A231C919D0C33326A0621C819
          9099F0B495A5EDADBD45BF8A75C96FB8E25DB9A3D2C6202D39030ED981C4F814
          18E6EDEF2D50B4103ADCEDB39A3B6FBDFAEE3F8A6E04BCCAEB5B569D3900401F
          95F8246DF47C4605970188A5A90035369A491CE1CC723D6B2CA49777CCCEBE23
          3D6E6F7AEA88199372272325291903AA07612D00151A3AFC4D4235598A059125
          64676660FCE809E8F5F5E656D5557CF1E6BE79CFDDBAEA796AF7D62B0DD949AB
          3400ECA67B1783A9BA59021D0688F98C1EB65664BD79E79C5F240D777E559857
          387C4C56167CA14EB4795BCDEA987D42221969340C4A19FCAC87EFEBE1B02560
          56C16C34B6B64C03BBF07DE91F0B57EEF85DC5BF01A83929AB51DBB393314A87
          14A0D0203182ECA48D82FCA5EDB3162627C71D9E3F6D8EC319CF33F55E15C406
          3B61C259120A0C351A85A1685077C31FEA414A4A06164E2F1A5E76BEECE0FA6D
          05CB3EDC5C2982E0ECFC311550354D9460CCF01784EC6B5F9F9CE31A1EF3E5FC
          69331DD4EE86271830B32591004874374522B10415C930030C7575DDB878E93C
          1E7D6406164C9F6F3F1E3AB5A7E4B9F10BBEDA7EBD767CEA7AADF4DD422A0208
          0407409906ABE192D3623E2D9C383145957B785BFB20116236272049569FB021
          723320EB34793D611C3D5A8B8CC44528C85E8CBF1FFA14CB1F9330F5DE29C9FD
          81EF770158C44177BC58218E2A79F2F779D8B3B5469097BE3DA564D4E8115FCC
          9B33017DC15608498814A580F05607588D14E96C063434F4A2EC9B3E3CB6E80D
          E48D9B02095EBCB4A318C50FDC85FCDC3C949FBD8ADADAB6673EDB5AB30F80C2
          4165C6E860F676A76DCBA4BC1CB8032D42154244001C881C52CA4186C80931BC
          8800577FBC8DCA0B4E6C28D983D1776622CEA9E0B50F4BB172F922C4247AD0ED
          6FC0A4BCF168EBE87E15C0D71C9A50C0225FFEC2B84513F2338F2F583016DE60
          A718BBD663B0F22D303425ADDCC52B2A2A3A50579D8875251F223B2B034E8782
          57B69760EEBC4C0CBBA31FFD8A579C92E4F82C9C2D6F407545EB23073FBA7912
          802A5B93CEE69016DF91928EF6BE7638EC549C0A227120527BCAF792352BC810
          7979791BBA1A33B0E1F10F90959106BB1CC6CBEF95A0707A3212520308843DA0
          0CE23EE8F6B6237D443A6E24741603304E84260356A9C9F4D804825E7F801332
          24C5C7F04024681AC3951FDC98322D15B24D1A9A011C953FDC46676326D6977C
          809199A9888BB1E1FDBD9B917127436636833FDC2732D7548A605813AAC7B952
          20C9642A001B07061560C0DD924383AE68D028438F974296249CFDB60B0E9A8B
          43CD4DB8FFE1118875CAA2048DB7FCB85AE944E98AF79099910A1B9170F1C723
          B8D57916CB7F5300777F1B544D87A2E8DC3350508083385443D15C3300622940
          18C3308D0C40339A8F49A0D071E17437D212E6E08987DEC08DC6CB38786033E6
          172741A70CE5653EACFEF527B833331386296A37761D780DCB4BA6A0C5DD24AE
          5C0AF3F603336704A02304C6E0B2782D0508A380AA0D80722F1106354CE0F3A8
          D8B86C1D46A6A72039693E626376E08B63CF43D1827862C976DC33F61ED1974E
          07C1B68F5FC4CCD963D0A7B440D535733282830ECD09468DBF1565B16A29C134
          5D67BE50488D1C30CA9010EFC4234B67E283FD1B40582F9C4E3BF22714E29965
          BBF1C07DAF60EAC4D9B0C936714CCF5CDA075FB81EA923091435049D52014A75
          3026BC088401E01C06971F51F73C33A02BAC2E1460002542AE012500D5D18BFB
          E66463CBCE1590A5001C7619E3C78EC7FC69CB6077D845869AEEC65F0FBF85D9
          7373D117EC86C684DC11586B911405A180C1A186683D00CAC12C05286F964BBE
          3E5D9C320A26E00FF6C296E0C3DD79097873D72A0C8B6590650971713142E218
          AEC09747B76162FE48045997208B266783DE04213038C203FA65003A0793AD00
          825EF55F5D6DC14D29A362C0A80A888621F004DC189E9A8AB410C53B9FAFC18B
          4FED465F4087615D3D55A8AA3F85E287F278F6ED436319885A47C8B913B3A5AB
          AD1F7E8F5A2602889E841CF14BD7E55E2E98EBBA2B2E915A3FD306EF80545726
          6EDDF023D1968F358FBE87B0A2E10F1F2F436E5E0CB418237B8B58500A811933
          F72C32B6FBBD12AACAFD8D87FE543703809743911E5C9BCBCC7AA8813EE5AD5B
          D7544844162FA48C1A10EBDBBE768C1D9784AEFE0A7C75722B2ED57C0D6AEB86
          1CDF0F4DD323B2EB3A984E394CF961958342820D4DD71478BA43EF0008997701
          64668509A8657F6BDAFFE09A9C351D4D646A6A9604C62C251828083A3C4DC89F
          340615178FE1C4B9CF515434113E437A625E4E11A5C51AE2D8411881848E6605
          3D9D0355A7F737EF07101E6C42C6DDF19A0DCCAC49B8BD3EB0A9A126DCD7EFA5
          919751F33C9B8DD4D2DB80A9D34763E5E30B11827B5025F613C5740630018280
          97A1A17AC0D37CCD5B0A2028B2378D2C7E36079B9EBF5FE4B834FFCF3200E7CC
          5F662D4ECF8EDB973359B6BB9225B31798353B84271187E84F59D4860976C0D7
          ABA3BE52535B6F069EBE78B4FD38807E0E6DC9EA1C7662D74D4888324B857387
          5A4FB537F4AFB87E5EF576B7E8603055B0BA1A667DAD7F340C44D79C463EEF6E
          D570FDBCE66BAD0DACE2E427ADEC0F57AF638C12444D420ACB4C79062E1C693B
          515FE929BE79395C59F31F05FE3E5112F35C4380320C0560B63277E2BB57CFA9
          A8BBA45CA9AB703F70F144FB3100010E75888F5901584BE048F55A161DC4B573
          B76B4E7EDA50DC7C2DB8B1FA74B8B9EABB305AAE6BF0BA75881E31874C90AF7D
          BD142DB52AAABE53507D5A6969AA09967EF397FAC57517DDD5427693FC30E720
          1832D99AC804148C7B439EA5F91F1100BA755CCEFDB3750F8003050BD3A7BBDB
          9D4B1C4EDB1C02E6B4D9A571A26E2AAB63602125A49FF576874F5695755E3012
          883A6EBA450ECBA29BF0E7ECE42737AD60257358D92D98FBC1516E428D826E02
          9C83FDCCFB41F0FF1989F292E94D086316A20B2CFCFFB0FF02A614B488B3A126
          BC0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000023744558745469746C650043616E63656C3B53746F703B457869743B
          426172733B526962626F6E3B4C9696B2000009AA49444154785E8D96097054D7
          9946CF7DBD6869ADAD1648AC025B8AC35694C106EC84C910E2B552C626768D17
          927126953126D86106B298941D3B4E4219882B95C2E5D8659C541687C5186C27
          98D8C090106C30036637C8C6420809099044AB97F7FADD25AF6EF54B75854A25
          57F5EBEB5BAA7AE7FB37BD165D2B9E020460E5CA63C00840DB0BA3BFFBB8E01F
          1F3A9E586E0C06A30D020255F633068CD14198E25DD3B6FAA744D186E6871610
          3A305C79A2C996102A4AE34AABD0F2E40F0D60C3EF395E2483556D306830868F
          57BD0440545B57DAC229C50B1180C785100710FB962D995253563E2FE2389F17
          980A4730C56883D2EA089ABC2BFD1D17B3D9CD739E7BE130A063CD13B435D27D
          D4A035C69AB181560A6BC028EBE8CAAC1BC68759460E7D67E99D8978FCE9584D
          756BA2ED2ACAC78EC089C5890F6B000C5EEFC5A9DAF3C87774CDAA3AD1BEFCF8
          D225ED97F3F92767AD797E23A0622326E942D7618D36802D3F4A692C474985D1
          BAA4C286D8B03601383B163DD432B2AEEE378991CD33EA6E9846D9F006E4E020
          EAF265D4904FA6F323301AA722018E43D55523A9BB6E326EEFA5D6F23FEDFDF5
          A1C58B1E3D70AEFBCB0F6E7AED747CD4140918AF63BFB11590B2D802A5213400
          C49AAEB159BFF7E8E27F4F5627D6A566CFAC4FB4B550E83E47F683330060DB66
          15B4467A0356FDBEF3D650A4A696E6DBFE8DC4C933D74D7BE7CF7BB6DCFB1F0F
          DCF1CAEFB6037E59CB74BCF6778D94AA68404A821B08417CE4440BDFFDF0C239
          C9DA9A379ABE38371E118ADCD143608A6C0CA258CA709AB193AD8350A034FE85
          3E0AE7CF53317A0CA3EFB9BD5EADFFFDE64D5F9A3FEFAE8DAF5A135A29A38B06
          C489258F32FE9B0F523676AA2DFBE6FF5CD0DA3A7CF8EED1F36F6D3099016450
          EED2F10C81188A6A570BAC81623B95C2DE038DD62711A966DA7FB5A57F5F67E7
          E716BFFDF64940EEB9F73E7DC32BBF255AB89C06290907AEA5BA766DEAC6E90D
          7AE042001FF8BBD5B4E0A2DA08E1816A9BBD3514A8D1D2DEBDA01231AFC08839
          B392535ECFBD08CC057400B72938856C9EB2ABA6DBEC777DEDAB775734266755
          D49653B8D887F16510BE0D7730CDBEF56FF187956B39F8C6FF21F36EF837A4EB
          72F0CD3FF1FAAA5FB267C31F71D343185FA17D89917ED08E6E2A130E95C31B66
          BC72CB6D7703514060B74029C2EC134EF489E4B409E43B3B402A8C1000F83997
          FD01544D9A49E382A50CFE7E3DFB376FE7DADB3E0BC6F0FE9BBB709BAE66C4D3
          4BC8ECDCCABB9B7670FDED3752561643DB762872A73E64C48CC9F4779C5B0EBC
          0A48C08810BEE1E65BE7B64D6CDB3A6AF654BCDE1E848563F5E05B7BF0DAA691
          BAEB7E9A5235F852717CF50AE2E74E5903B9003EFCBFBEC1F0C65A9C489413CF
          FD0C3ED8CDB573A75938520722291F398A8F769FE0E0F153772C7EFFDD6D801F
          05009C84706E8E2562648E7C40A4B61E1171084B933E7F91D9CFFE377911A3BE
          B60A84C159F65D8EAEFC315269863DB888A6A624A9861A6B68F6D247D93C770B
          F805B432D8E194926C7B3B895435754EE426603B209D22C38918737D141FB7E3
          1332C70E2107FA318502DAF71976750BA75F584373633560D01A1A1AEB98B8EC
          31C62E5C4273006FA8AFB66B99288B7078D533345D3D06E54BB45F406632B83D
          3D76AEE2514D0C311D8800FCAD0228FD29BC1CD22F8067C89CFC9068A28A6843
          8AB6191338B6F3001FACF81153BFF318195701D010649C0C02C000D5017CFF53
          DF277DF400533E772D7E4F376A68085570ED7A8220EA7B08655A8B0644388D42
          6A5D433E87F61438B6F7F84369FCCC106E572757B58EE1E4FB7BD8F7E4F7B9E6
          5BCB01A7F41D82569AF77EFC14E9FD7B98785D1BD96347304A85AB6A0D0442D4
          CBA095AA0EB9610584F25500CBDA61C1080402843562F73ADB711AE3BAF4F70F
          71E14286C692CC35964376286FFB9E3DD381830583213460CDF8D92C526ACB2C
          6D014AC9B497F71A1C5DFCC7220442601504672FE429B44DA7E6FE8731029431
          166EF106C061F423DFE6D4CA1FF0F1F1BD8C1B596D096883C15805819BF19052
          0E855C073080710BEA9497F7D15A61DF904AA203D552D2D3EFE15F731DD50F2C
          64585392645D0263347595116A2B6318FB7C4D32594DEBFF2EC74C9C41674F06
          2D354A29B4AFB0AA35D94C81BC941F87850B2BA0B385C2FE4C363A2B562940FA
          48276C8320EFC3E4FF5946D644B17008E0B1600D7F64E193826DE8CFF800D427
          6B98F9F813ECBAF3566BDE846F4E6D6CC3D3699F21AF700050941AE875F3EFD4
          A5A38B6BE2805416AE1D70105426AA70B7BF4ECB82AF9175253515514EAC5E41
          FF5F76D9FE1E133061E963A4733E5515713E59BB96EA9A4A942C20B4C1983060
          60C0A5CF7377961A30805A7EEAC8AEB59F9E763A1D33E3AB2B44F125031A8761
          C3CAE97C6D0300E3EF9CCFB155CF7369CF2E4635558380AEDD3B396E0C931E5A
          48FBCB1BE8D8B88E31236BF12EF4DACC2DD97118E8CF3230A43A56F77EB21390
          80717E71CDB47090FDEE7C7E45DFA0414A85B2FD0F5449DCBEF334A712F4BCB1
          8977EEBD9BF4FBBB696AA820DBDD4DEE5C37231A135CDEBB9BADF3EFA27BCB46
          468F08E07D7D685F15E748E37B92AE8B8AB36E6E15E002B2F832D2E136F9DFEB
          38BE61CDF8C95FAFECD7D31BAA852D3F8E00A9C805B0D4B01491541299CB920F
          C0DA1800B2E77A48A5523407215D975C4F8F5D6761849D01AD0D3DFD3E035973
          68F5C5331B008F70089552EC9833DDCCD9B15F01DEFFA707160B5DFB878828D4
          D7C4238888C0FE488FA1B3DD200CE28A6FE5866C770F082C102300835D55A519
          C848BA07C5E0DE5CFA112017660F209E1B3B91D66601C017DE3B1A05CA97348E
          BDB9B5BCF295E15585586D854324E2E0005A08AB06AC6A4A8F097F833156A52F
          83AC15E70622FE312FF7959786CE6F05B2805C59DF62960D7410B5BBEAC9F061
          B60ACF5E38F3F6A2E4E8FB0B7EC58BAE57A8ADAB8078DCC1118E3541291C1366
          5C1461E7C79392FE0C9CCF88F4875E66E1CBD9BE6D61F69B278D33273BC3AFE5
          5A53F02518C22381FC9AFEB36FCDAB4ADD34D3AFF9F9E5BC999A2CF7A98C1B9C
          88433C0810441C0703282DC1807D9654643DB8948D30503087F714D20BB7B983
          C78B701F40157C947100103F69BC9AF1F52E1A8363605EFBB9B0B911A00CA85C
          5C33E29EE648FC5B15113326115354C634424059545BB02705DA0872BE20E339
          E42567BB7461E5F3D9DE0D40B674EAD78F6B366068EF8BB13C7B16B1AA613C2D
          355944883530FF93DEF0E600D1A2918AFB2A1BAF1F1589DD5249E4330EA23C26
          68C340C1E853DAE0668CFA4B00DEB6CEBDB40FC8978015C0BA318D619DF9E852
          5960A00BF14CFDB87068AC2208BF72F3ED7467A99108102B8948D120802E865F
          12AA18FC3031CA70E5C11AE05F3BA2449DA28601604A421715ABFFE4FC153983
          B3D2BAD003AD0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000048744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E53657453796D626F6C73436972636C6564333B436F6E6469
          74696F6E616C466F726D617474696E673B94FCCE9B000009CB49444154785EA5
          95797454E519C67FF7CE6485C06421211012081020252C09022A95D06095208B
          62D9E4A0B4581037AA506DD5635BE8A12D2E88222D9B5431820261332A1202C8
          2E4B30094B12320949866492C96492D9EFF235B9A0C7FFFA47DE39CFF9CEFDBE
          F7B9CF73DF7BE73C52B5F32011660B0951BF940079E9BF321E88EC6E5E101626
          679A43E41484A8D13451E36953F3DE5B7E651FA036B9CFEA41BD0D55F393440F
          10608AC936F8A7DECF9E161A224F359BA4D12659CAD07451A2AAE2B2D7AF164C
          FCC3898380A6D8BF1242C0D57D6BA1DEF52D80F4E8F383139E7D7BC4D77FCF9B
          22BEB9F44F515AFB8568749D11576D7B4551E9DB62DDFE9962E5A6D1DFCF5B99
          36043035B41FA7C67900D571D4E07FF2EA98BE17364E3A7063D75CD152FCBEF0
          DEDA2314FB61E1ADD92D1C97D6896B7973C4D9F7B30F6E5A3E3A099083B70F72
          7143360679CA6F537B2F5D3BB23CAF7085A8717E2DAE356D11571AFE25CED7BF
          264AEC6F8B8A96EDA2DE5528F69F7B5DACDC98659FFB72DA0840B6B6EC33F807
          56DD9B7E69D3647BDDB1D744A06E8FF0DFDC207CD7FE29BCA57F13DEB235C277
          639DF0D7EC14B7BE7D459C5F9FDDB8F1F991FD01F9FC7B0F2001E6457F1DBE3F
          77D2CCDCE14353A9775FC4240BCC5208B224234912480247733BA989E3A8B339
          39509857B26F63E57DF537DD9EC999BDC2573F957E2625EBC191317D12D1DCF5
          8046F937A7B959F43D03B3C73078F258840053B73E386C762ACE1E2998F4A7D3
          8F0141F9D117D2727AC7F7CD1D96D60F6BCB09742D80AA690475054D573BA050
          F0F54536FEA78877B6AE2739298694BE0332B267F75B049856CE1A342F2AA6EF
          C8E85E16D4B66A84AA7440A5FAE46566ECBD4DF5A92B2047A2AB0A6A6B35D171
          DD89EED52777CF2B594F00B23934DCB4F89E8C31D4B75D36044160123A42D740
          96D8F5F959A2431E60FD2B9FB16CCD58CA6F9F6374FA58AEDE289F076C099799
          1B939C86EAB681103F21AC670F7C0E1BE1160B9822105AB3B1AFB6D5119B3C80
          86AAEAF9C0A7665DE8A3A32C12ED81566A6A9AD8BFEF3C633287903D69188547
          CAE81DF510CFCC7E8DBF6FFE1D8FCDC8C11CA212116A98CB044C422333325242
          680AE8028100A1133778008D170B891B3A14A1064055D005C65944781892AE8F
          004C665D233E289CF8021EF6EFBDC0DA174FB2E7C866DE79771713463CC9D38F
          BFCE275FAE2621C94F726A0CDEA093C81007BA26C2D2EF8D8D128A162BA91E74
          5D010C018410A48C1DCEF96DAB18FFDC12F4403BBAAA023A4217C852E7B56E01
          2459553547B3CB6610673EF220DBF6BEC90B0B56F1F282CF796AC69F71B9AB38
          79E50B32EF49A23DD084A229D85D3694801EB87AC6E10904D416BFA70D7415E3
          FD6BC64A6898CAC43F2E212C42A0795B8C09759830CE03EE76823ECD05206B41
          AE3536B6E1533CC4F7D74848F1B165F7EBDC3B723C164B24FFF8681933A74FA0
          D55F873FE82510F4D0D8D84AC0A796019AD7AB16B7755CEBC6C7A7182B1DA83C
          7E91C36FBCC58D4387D0837E8C73CD3048ABBD1DB757290584EC695777965F77
          22906971DB481B118943B948FE91F5FC507E1853642B613D5C7803ED78831E40
          A6F28613B74B3D00A8CD4E7F7E7D85CDB8B17EE7E98DB5EE7225F7BDB98BBA62
          2B5268F7BB93D1D03585FA4A3B8DCEC0E78022177D5ABDDB76CB75C57AA30D09
          13CDEE3AC6DEDF87A357B6F0E70DB3B8276B20ADBE6682AA8224246AAADAA8AE
          74969EDA5FF701A0AC29B8B5E3764DD3755BB90DEE3CA1817E59C339FDD73924
          DF370ED91C79775FC15661A7BACA7EE4A57DD61D802A0381862ACFA21FCEBB5A
          6E96B9919068F1D6327DE6385E7D6929A13D7CE8BA30C4ADE55E8ACFB6066AAF
          B72DF33895B663952FEB5687DF7DC1EA5A5876DEDA6C2DA9FD69D4FDC70D61F2
          9B2F3168E23DA8BE1663DF5A6AA3F45CADE358856B39E0FB74F640613E5AF1A2
          F6ABC1EF950A785853F5CF1AEA820307A487A1F6BE866492400747A34ACD8D00
          F6BA405983D5F34C7161E37940D5850AA0BD55642B9E3F2A3021DB15D870BBCA
          91D33F3D1E4B9C9FD0763B019F426B931B6B991D5B83FB686155FB73BBCB9C95
          80A6693A14962F03900073B7E890980766A7FCE9C1A7524FE72E19240C2C1D24
          7EBD28F5878973FAAF8EEC11D20B0801A44E5E27DCA5EB7FE203517FCBE9F3CC
          C66929273E7A34C5F9F16303C44733539C1F4E4D3EF1974989CB801E77FBA4B6
          4B6BD83EA3BF71237EAC9CB40F6543C080D1280302D08060273AFA757E56F5AF
          160020907872AF5502420DDC15BACB577FE46F9F9122F859499E6F7601D0EDA1
          3977F27CE9D3D342CDE6A966A933CFE50C55D34A54212EFB824AC1C4CD5B8D3C
          7717E409808A2FBF63D4071FD295927F14FFF837B3FA5C7876697E4C4C747E72
          56FAE2D45F8DCB4A7DF8FED08139E3B29233D317C7C558F69EFDFDE2FC4D33A6
          F5ED9E3B5F46D3D1548DAE96DC297E60C1FC61BF4888BF1C37A8DFB43EA30763
          763711BC5E8CF7DC7704CB8A0969B793D4B11F3F38F99191F10917374ECD4DEE
          3E6D81ACAA4AD70D4C4E4D0D8F8F88C88B1F92D20B572B67DECAA3FA7809BAD7
          07AA86EEF35271A498536B3F43381C240C4D894FB3446F0042C66FFD48EAB281
          15E3C7CFEB66891AD94DF273BDE00223B66FC33C69063565763455A5F2B28D6E
          8F2F2463C7762A8A4A88322B58627AE67E317DA691E75D3610263137AA574F82
          F5754427C5E038759AC439B3089F328BD293B7E8F9C462E2A63C4C73D171E206
          F646753AB0F48A2202693E60EEB201A1EA99A141B71116C9C3E3F114E463FFEA
          30F133A631F0DD75C44E9E84FDE02182455F913CA22FAAC74BA8DF85ACDEC9F3
          2E1BD0836AAC686B41282A7A9B8BE4340BB7376FC65F6723AC5F121E6B0D4D1F
          FF9701A392509AECA81D3DC2D58AAA2A469ED3C53207FCC19640BB3726540681
          4E4D690D098B9712D227117FCD2DC293FB11BB602155FBF348EC6D022108F882
          74F05C74BD903D017FB1C7ABA1A90A7515AD747BFC496226E7D0B8EF20552B56
          E0282C2276EA14421E7A1C5B7D103DA8D2EED171FBFD469E77D94053BB37FF76
          B31F1485D6962043A64FC6FF4D01CAE17C86E70CC6B3EBBFE8A7BF237DCE545C
          2D01A4B0106C1DABDDED35F2BCCB06D65E2DDED168775D6F68F693322C96138F
          CEC779680F4983A309D4D6929800F5DB365194FB1B52321271B8A1D6EE3AF2CA
          D54B469ED3C532577BDCEE0B8EA685683105FD153D2E7D6C3CB2398460830DCD
          ED012148ECD5BDC3503F1A1B3DDCA8703A8F37371A79BE756856D75F01A0BD57
          75BDF8607DED84626B4BE1D953566A4B2AF13A5A118A4AC0AFD070CBC19963D7
          387DE1E6D13DB72AEFDFD9585B0E68BAAAD2D5929AD7BD41DCF25512600222DE
          481EB220CE1C362F4C96324C481655E8AD7E5D2FB12BFE9D6BEA2A77005E40B3
          AF5E2EF66E2D6449D50F5D33B069D028000482259557FE6F9EFF7B40C6CFC7DE
          6503FF03568070FAFE27A8C80000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000011744558745469746C650050617573653B53746F703B3B
          8A7A3C0000017349444154785EED97B14A03411086679358D8DAE4850441B0B4
          B4158BA0B63E848D951622D818B01404B1F615F4092C44B44B727BB7F38FBB91
          010B77D3CC62081EFCC5775FF33373DCDD0E4484FEF21AC42C6701E79C590111
          59F6092CCE7F0177FEB073E69CDB8D308C791391DB83ADBBC3240B4EAC0AF444
          68B4B779A13CBC7EDC1F45384E50706C56001062F2F4F23A9E8BC4E97E829CB3
          2CE098418C8644301789D3FD0425675580C042811A824079A1332D10C2F70400
          28979C7D016650901941A05C74F6050228201560E592ABB382301FB32817DC4A
          4E80411D37C48072C1555BC18C26ED3BADF5D613FFEADA30A9B70286A789FF50
          2EB85A13E0EC7B405DE587903D315839EFAABD88D81384950BAEDA0A3A624079
          A133FF18315A0258B9E42AAD2074D43193F72E71C9991790661A2EC7574FDBBD
          BEDB00CB67E870AFBF5C3967590037A7CF47114E62FA311C338D419239675A20
          A689697F0868819C335D410CA764BCBAD53917E8796EF54F465FD5BBF840931F
          16EA0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000014744558745469746C650052756C65733B5761726E696E
          673B0BD1AE460000097049444154785E95577B8C1D551DFE66EEDCF7B3F7EEFB
          D1EE6EBB6D29A5A0DDDD22552850A422EDD296A7B12AC61205816834426C8289
          913FD44420684222A081D454A50F855A2CA00B2D8FB6A1F641ED76BBBBEC7677
          CBEE7677EFDDFB98F739FEE6CC4C5C0A69F4DC7CF9CDDC49E6FB7EDFF9CDEF9C
          2371CE71A9214912FCCB8BE2C5D7FCD3E327319753F91FC8250FF2C5B84800F3
          486DEFDA07BF2487AF666F6B4E44C6B990BE6168C6270E10943B5391DC35D1E0
          9AB884AB4312960720B501BC9A73C0E67C52677C50E33839CBD87B0754ABE755
          D59C0260122C02FBCDBC2877DEED2B7A6846FDA403CBBBBBC5D3054F3DEF1307
          BF918934AE8A86EE4A4A589FABA95915CB66114BA7104E24A184C342B0A96ACD
          6AB1D85CCC17AE9D9D9ABA3F3D3E71647538F0CABBBAB563AF6A8D00D0EF9F51
          ADC35B3633308E832FBFF2C92970F316E4B2272CF28BDAE4976B02D2371B9B1B
          D7661A1A2105C398191DC5B953BDA8944AD074138C33041505914804B1441C55
          D539646BAA3BA6A7663A222323D72D5202BF7FAAA8FF1540B9F385978C435FD9
          C4D89C4991BD08E664FEA44F8EF8AF6A93F72DCC247FDEBE62F9DA4CF3024C7C
          780EC363E3087DEE3A2C79EC71ACF9CB7EDC76BC0F1B8FF5E1BA3DAFA2FD278F
          2374FDCD385736F151FF201261054B17B6ADB92C95FCD9F712A1EF00C810C25D
          DB77CAECA21A985B6C4142E297B5C9AD8BABB28F342E6ECF3899CE9434D4AFDF
          84964DB723B1A0159C339CED3B0BCBB6D1D6D606C6186C02B32C14060730B867
          17465FDE8364A58868268391C9A9C2C9E999279E2E9BCF00C81374027786EF80
          3FE7D1C7AA13DDAD99D4430D443E7B611AA5581ACBB7FD1457FDE011A4DB1642
          92654200273FF800C78E1DC3850B53E8E9E9C189E327C4B3644B0B967DF7612C
          FBE1A3A82C5884FCE424EA32C9F4C244FCDB5BA2C1CD009273A77EAE80D0BA44
          B8B54991EFAD6F6B6910739CADC68A1F6DC3FC9BD7B9C40459962093639AA6C1
          300C98968181B30378E7BDB7BDEFD57D5EBFE6462C7BF061186D4B50CECFA22E
          9DAC6D92B16585222F0610F5B965CFFE0021BE2616BCA7757ED317A8C2C9761D
          4BEF7B00355D57839821137A4FF7E2C05B07303931015DD7A1A92A98CDA01A1A
          0932307A7E0C3B77EDC2C18307411A50F5999568FFDABD28C4920890D8B66CA6
          AB4B91EF06902604251A7E4309AD8C280D3945FE9253EDE3FD0368587F1B1A6F
          A2CCFD8E4399BF7FF428060606286B8B0875E88E03A6099DDC30758DA28E53A7
          4EE1B5FDAFC11FF5D7AE41FD2DB762BAAC22410E56CBB8A94596E6038810645F
          40E4FA58686D534DF5155228043D9E46CBC63BC0395C00608C0922CDF0ACD735
          E182619AE25EA36B8B84E9BA2B8C0304F7D77CCB7A98350DE2650D89F8E2AB14
          792D80D8C704542972573C9B437E640455AB5623D1D2EABE82038C338ADC25D4
          0C9F4444D3D0DD7BCD89060CF1BF26C8242E090713CDCDC87574A2A4E922ED2A
          091D00E28480EC577F52C292683A8DC2D434B29F5D09D1361981DBE036771D10
          64AA20545595B2D684102A488F9C9EAB8E2813F01DE05CC4792BAE445937110A
          2A48000B3D018AEF403822A3319C48A05C2C21BDE43270E664CD5C72CE84004D
          D588D4CD5C33DDACD58A0A83C87D270C8B84989A20660E5C2548B5B7A3625808
          53CE51A0D6AF01C5FF048390D34E6FD74965840A9109EF1920918D36058A1A65
          6B119926A6C2B5DBB66DE826DD537615D575C7B62C2100026E22B1DA7A98B68D
          802443919074380974E78E806715C1CD363F338343870EE18DD75F47B95C169F
          9BA169827CF7AE9D0E9110B063C70EE180619978F18517603945492007BDDA01
          985F478027ECBF3DC817C035C68B4645831250503A370C4D5371E8C821D1EDB6
          6FDF8E6269D62325DBBD62333D113AC1D474982EB988CC6316C414CBD4239480
          04C3718CF33200DB17C00966C166E3159AFF48248CE9531F20994A211E890BD2
          515A019F7DFE776EF1910B96E10AD0FC2FC1B9B79D6BD3F914451132E10017CE
          716EA370A617612508CDB251E4B800C02030D9DBB5E8176C3E54CAE7114FC431
          F9FE11D1F936746F40221E17C5363A3CEC662D1C506188EC9D8C0D024522B76D
          B72730318D5C2C507E314E1D3F8EA81280665AC8733E0CA042B065CF0A75C4B2
          8FD16602A9AA1C26DF7D1B85817E844221DC71D75D4866D24EF50B529DA2A9BB
          84A6E908A2E8909A4E249003F575F5226BCE6C3105C5A1215C387218712AF522
          899EE0380EA04CB07C01E5039AD5D3777EFC438B320F8C8F394BAAA8F070388C
          AF6FD982CC3C478437CF8EE59688029669D1BD259ED9B685A54B2FA3E81633A3
          38FCB7BD90CF8FC2A4FB21DD1839C1F83F0094E64E813A6CB1C1418B1D9CA146
          94ABA9C618ADE7236FEC775E28763B5BBFB515AB5675224CD794A5432C082DCB
          26B8E41691D7D5D6A1B3B3C3B19FC031F6660FCE9380543884BCAA638CE11D72
          A0DF73C096390DAF20A67B54F3A57F0D8F9C362409F14A11BDCF3D8B09B2CE22
          27A2D128366FBE1DDDEBBB91CBCE2352B29B60B851B8555B5787EEEE6EB453D3
          E136A35A3A8AB3DB5F44AC30039584F66A7ADF51C6FF04B845387743C208A533
          163B79D264BBFA47C70BB14C0681FED338F1E413187DE335D8962D483ABA5662
          0B4DC98D37DC88C6FA06C8E0686A6AC2BA75EB70DFD6AD58FDF9D5C2FAD137FF
          897F3FF36BC8BDA71108C83857D18A6739F69C73E7BF48B0E76EC9247F4F4068
          B927167CF89A6CE69EE679C988B399988DA550474B2AAD6A6261115D9E015C44
          BF55BB9D6F76E8430CEDDB8B8FC876CADC252FABFA11DDFAE33EC69F0030E0CD
          BFCD69F8E7025F844248115AEF8C280F74A4E29BE66752296733315556C5929A
          EDEC44F68A2B915AD48EA8A876269A4CE1CC19FAD48E39D52E0A2E4D735EB12D
          22D78BC72D7BF73E9B3FED91170816F7887D01787A5E140FE635B131F54434AF
          0B2B772F0D481B2FCF66DA130109CEAFA8EA28EB0654D3826EDB22EBA02C23A4
          28888614C482415133794DC769CDEC3FCBF9EE376DFE0700C31EB9F9A822F1C7
          4DF6F16D39271CFEEA6627989ECAC17DBAF5DC6EDDFAF1FEC9E93F1F9E981E9D
          AC688004641351B4546570795D0ECBEAAAB0209746361611EF982857F07EBE34
          F6966AECFCBBCDB611F96FBDCCF30473DFAD5FE49F7A347B2A137597220E7C7F
          5697FC8D8AB78BADAE95A5455706A41B6A2569455AC2FC18A45C44E231C6018D
          F3CA2CC774813A9CD3644ED2773EC9D1076092304BD008CCC9DC27160E78022E
          7538F5372C616F0B95F20425BCFF827087E5919408450F65823EE7B0FAFF9F8E
          491C2311FE8957F3A646F130F774CC3D12CB834FCA052E31FE03110904762004
          AD290000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000017744558745469746C65005370656C6C436865636B3B5370656C6C3B
          53FC46020000089C49444154785ECD976954544716C70BCC28884B20718B202D
          3BDDD03474B38A0828880AB2EF62D446D088823BB8206626C6C4A3C6050405A1
          15501951E28AA8B8A01844657141059400A2A0ED86D02EE09DAAC72BF33A643E
          38F361A6CEF99D5BE7F5EDF7FFD7AD5B058D00E07FCAFF87014B2729B2729E8D
          F050C1F4C1A892B9C4753662E75F60FE4622FDCC0A7F87E4B2CFFBB151856F13
          8C3E6B100316636732E2D62E52BD715E8B41E434AB918AD9B9454F35B79F0662
          D7D9E03039F6B9A92470313524B00F8EE25B07FF2EB00D051349E06DF2CC581C
          801272AB59AA50424E358ACFA922301ABD600C8C99CEAC54EC3433D6CE7D5EA5
          C425B2CBD8D25B4284AC5D2367091D2200CF354563A7279A5A077569EBDB0E35
          B30B99652209E8D2379F123B545B3892C79F60412A6268E98BE2B32BD1722CB8
          7C6F25C3DA821A56BC57C5FA3006840ED31079201C137E4AE418B1C1DA35EA8E
          B1D82F89245A39CF88148F8F025389CF44A17DF83123B16F959A86A696C02EEC
          8A8185D7499CA341B745DFC21BE90BBDD052D90DB4E6500D4AC4B0C2AAAC60FF
          C80D79CE2BF6575D8CDA544856AD460C30493A06365A78F50ABEB5EF542B9799
          E92662BF32F2720B87F028632B3F30B10EB88DFB040C445EA938FF2B33BBB047
          3CBE7B3231A96FEE89F4CCA7308C369B84EADE7E44B518CEAAD59C4316E82C95
          FD96B3B9A80E2E36B7C3C2F432B9646A0C8F1AE863661F1284F70FEF6510485C
          A2406013D2A535CC485B601B34D748E44D9286E999B97BE212838E9173B09943
          D82DB60283305FB0422ABAA6EEA856C188D3556B48D7E74D4DCCBBF5E4F85D39
          DCEDE886D2A71FA0A0AA1502D7161EA106FAF26D82B20C2D3C2BC9EA740CC758
          E21203CFC435C258EC1D231C13011A8386E9F3F86EAB469B4D8661A3C413744D
          C7CF37B50EEE36B0F05C3752DFD16338CF76022B484BDE77888EA166CC8EE28D
          9B4FD57657C8DF4299FC3D14B728605F5913782D3DF4D861FAF6306AA09F9ED0
          EB1E4F30712BDB20FD79661E35BAFC097B46E83984EB0A3C4057305131CA647C
          15165B423EC70C18A1E7F80F6D23D73A6DE3F13052DFB9843CA725B7740BD18E
          4BBF522A2B6D845BAFBBA0B0B113CE362B607BE17D7099BBF7C2689B40039CA7
          4E0D10C76AACB82AFB12751635B6CC5F6206D21CCE77066334490E9BABEE2E5D
          235A9C5976BFF8C14BB82A7F07F9F59DD880027E3E740B1CA5E939EA83870F61
          72E929A0236CFD7914B5AD14DDEBFCF86FE8EEC5DD4EDA6C4C1F68F82C4A714B
          C8AE7876B1A91DCE3429E0C0FD7638F1A003D61FBA090E33D2528959565C75DC
          DC7D48C940E0DFCFA2D01F8B7B5D18773B3E22DC3C9FA8E1C0111FE01D97EC99
          78A0AAA3BC5501471F7640EE9D575050DB0E3F1DBE4DC465449C56106F0B728A
          CE5536E09F749A7B74FA126877D7BCE946943B2C5C71CFD814EFC47D958AAB6D
          6F21EFDE6B90DD7C097935AF605B512D38CC4C3F459A9BAE9C6854BFFC801C67
          672B1B2042F4E84C8A9545F82CCF959297B3CF546F6351867625710DB7E88D93
          E365D7DF9561F13DD52F21BDE20564DD7C0199A5CDE03C27BB466B94D528D21B
          74315558BCEAC5073426926380BB1A97A8B4E8F8AC6BDD2BB2AE81DBBC8C656C
          83F5654AD7DEC5AD92867D60BCFDBCEDA52F2F3DEAC4C272482D97C3CE6B7290
          95B781475C9E9C671B6E49F2A8780516AE78F11E553C7F8FEC67EDE11860BBDA
          3932551A9F59DE5DF2580125F8CCAE929583E38CE4D5E414D02D618DF6B79C34
          5724DD78AEF55C433BA461D14D97DA60C3F956D859D606FE2B8F7D30755FE243
          4E0EBD1F6E60D14FC8DF23DB99B25E0634DC17E6D71DBD835F76A115D6153F81
          627C7E576696813868E35AB689D4491ECFD2C32828E944EDF11A396CB9DC0A6B
          8B5A187E296985E8AD9740E4BF613DC9674DAB5CC782946BCF7AB0F936AB7705
          4453573807269D7A937AF909FC70A605BE3FDD02A71EBE81F8F452107AAF272F
          1D3170C868DE84D8FD65FBAF3D86E42B4F21F16433C33A9CBB3AEF0E48C27690
          4B6928B7E9CA9FBD4384AB4FFF401291F9973D30D0D2272924F487331FB6E1D5
          249D7CC4081CAB6F87F85D97C1C463CD36A7C85D07B79EBC07BBCA9FC28A638D
          0C2B8F37C14F458DE0149DFD62387FA20577DFCBB018E537425B0F9269BB7B19
          50654BF6A53868D36AE92F25F073710BAC38DE080958A4001FAF84F44BB0F9F8
          5DC8AE7C0ECB7F6D8065BF36621AE0C7D3CDE0B7FA0418BBC74793EFB38B5121
          4257DADE62D8D8DA4329C62A8C6B40D9443FCC57E2D06D69D1C965F07D61132C
          2B6880A505BFC33F6FBF823D15CF60C9E10686C59895471B617EC60D10066C29
          624BDF8F5E6244887299CB93B748149AA16CC05E9ACB35A18E1966199C726C7E
          46052E71232CCA6F8085871FC0C243F510978FE3414C7E3D241E7900F852793D
          5CE069478E312D3D11B9C4A18441F1096170BAB201C9B77B09DC73DEBFBF96AE
          AE247CD7D5B8BDD5B8020F617E5E1DC41CACC3B11E62F03CE14803F82516E2D2
          AF5E85F3B568D733228F316CBC486951A00B2C66813B950D584DDB8391911271
          4D0CD0D4B513584FCF6C5E72E01E23FCDDFE3A987BA016161CC431A312CCFCB6
          5CC779DF60D469D75311CA79C2A31ECE31B113F103FE6440149689F7258B9688
          7B32068D1005BB3844E6BC5A8485E7E4DE873939F761717E3D29FDBB1142FFF1
          2487361E4708D3F92916139A3BD159029E9BF8EE5036601EBC1B990765905251
          A8095256CD9136D200C7E803EF16ECAF85185C059FA422309CB8660B693C7A55
          1301CAD9BFA2A987334D1DC8C82745D980206017E2FBEF644BD589619C5313FD
          305FEB8C8D9B376E41FEC7D9BBABC13C30A5596DF037FADCFF8C59212CC0A583
          C0CC4F3374301878252B1B30F14FEBC12F0D19FB125249E49E0C35CC509E6BE2
          F7C2D0DD30DA79C977E4CCD3BB5EE09F8A04FE3B1013E9DC8F8D183EC12F0519
          7B2733E27A9EDB950D18F9A4B2EC6030F4A6A428996045BFE6FE956405B0208E
          7FC2D4178BE27233A253B673600D7CC650E1FE56E4FE8E44FFE1E01AF83C2394
          FF72FC0BDF07F6E4857816860000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000012744558745469746C65005370656C6C3B636865636B3B752FF3FB00
          0007DB49444154785EED94695094571686AF8949A55235DB9F4931E3361A1451
          D911C1061A4459C31A4411954D9B75914D015917356012457132018228518344
          258186160CD2DD2CA211946DB0BBD9BA4140591A68403EF4CE393D7655574DCD
          BFA9C91FA97AEABB9C7BFA9EF72CF7124AE96FCA3B01EF04106B97E3C4EA2D6C
          977825F0B7421DB6731C617FA622567DFF3D44DDD7C2319AA8F11FBEEAFE2CFB
          28A20CA802032D2F2F7FB7B4B4747F71715109C33088A9C5DBC0B07F01EC050B
          0B0B350A8542C9FCFC7C25FC5F00F6E0E1E1E18F590EC708CBFE18999E9EFE13
          DAC0A7606E6EEE9E0AF0BFF2EAD5ABB4478F1E7D40D4B383CD4F30A87F64DE9C
          C3FE0C6AE396487FAE69EA005BB44A35EE07C75D9207449D9F753998B5ECEE7B
          8AF18B38379BFDD535E9E8D84B21EC9F2B2B2B7B1F8298A1B081C191E62FCE97
          4903A2F2669D0E64BC39C0C95584C7E78D4F4DCB4B950230335576A0CC4D2491
          B6D879A5511460EB994293B28A46C07E43553E10D9807BBBDC13E95EFFECF97D
          81A7E7D1177FE317963B2597CFF0C7C7C7F520EBBB95BCE64EB7C3A7186BF065
          3BC75368B3F2EBEA93ACC02A80D00FA14F31885200FC28F5F2F55A111E1E12FF
          F769FB7DE9D4C53B6501830E0C0C6880CFFB3333337C0C08A269154FF8F4C58B
          17027E635B1BFA9A3B4453DEBD07ED93939349ED1DCF1E3A79A7BFB6708A05A1
          E9B335754DED13131382C1A1E1A6A79DCF5AA10525185339282CC76324353575
          2508A84CC82C19B7841F5D2BAFFBA7B34FD66BB6530CEDEC163F989D9D754701
          72B99C8FD9B21CA228F76EE3D3A1A1A1E4E19191463BAF9437A67BC294A240C0
          CF0999C5633057D4CE2376B17F60A809E6A1402693E9F6F5F5AD853959031558
          65601940C84EBB48B2D336924C4D4DE94E4D4F0B5C0F6532667611B4ED49772B
          27E682DCDA398EE617FC2886CC7340C04AF0E3EF81D6B0C1FE13B7A1A3AEFE41
          FBF1F4C2D19DF651D4E350D2CCF8F80B2156C5D9276D0905659C291C04416515
          1515BF53CD91AEB91FD163F9125DB3C384801341230408BCC7FFB59DED1A4F9D
          F7272A46464684B917CA8676B99DA08783B32721F35A369BFD111CC6B7811661
          7688956B027C8F53379F93738FDB3B5BC7C6C6AE0C0EC91AAD5C4E50632B0E2D
          2EADE8191D1DF5C7F9D9667A886CDBE143B6EE38007893AD26DE846CB7E610DC
          8412E7E7E4FD3084992564FC63647070B0B10232B406013B6C38AF3133B1586C
          887DC48026BB43E9414ED6A47FD89909DBCF13180B6895A3679CA2ABFB594B77
          8FA8C51CDA68C03E428B4A6EF73C7FFEDC1763686FDF47B48DBD946C468CBC08
          31B008206D6D6D7F841EDD3F1C9A2B576586D36A096210636B0EADA8AA7F0A07
          85C2840BCC1D63A8BE851FBD79ABA6432A95D67474F5B438EE3FB9686C1D4463
          92BE92A178CBCF625E1BB139F464FAC54168C97598B18F542DD864E04136E97B
          104D7D3742D00059D98A2403CD30B16FF01023289D21FB2835B58DA0F0A85093
          5D21342EE96B1996171060BFA194F4E66D5E078FC7338341E40646E64EE85B06
          50CF83F19370637E3918746ACA785728B5720A5D9048FA9B5EBE7C992F1289B6
          747777AFC5418498AB3FD571FEB700C8FE78F1F755BD26BBC320B02FD3D7D7DF
          843300D93586C59D1B37B109A3568E410AE8A510265868B2279CEAB27CE98D72
          6E27046BAC6F68796CE918B9B4D9782F8D3E7156D6DFDF7FFE5A597597110837
          647360A6E2E41595754FE01608257D03CDAD8F9E3CC4D711DBA2EC3F08288F4E
          BA38AA67EE4F3D7CE227A1645C4343C38FA1E4C9970A7F1419DB84502D232FDA
          D1D9D382028CAC839507EF768D5ED8E31EBBA0C3F2A3DADBF753634B9FC5DE67
          E266F009C19B9090963FA40B671A4035117DCB2374ABD9216A61EB370B1528C2
          6BAD140037A0DCDC3E7851CB702FCD39572C0641B9B809429C1EB775B56A6FF7
          A69A7AEEF4D2B7377AB105B66E11730616BECC26F0673B7014568E47E792332F
          F48B25FDCD30CC3FD4D6D6FE01AEAB3F0EECE5D2DB5DEEDEB153DB76782F6F34
          F0A43AA6FB1877EFA8097501F8BEDFC40706FAC4876F0308F04061304C1A50AA
          0610C2474028EE15821F17DA21C06A40AB04C055D82F02BC4B4B4B7FFFF6E095
          F07B16D8CE82E8BBD04E21FC2FC42F0C7235C4C9C6D84A01F8CAC1CB54055F25
          B0AE441B02CF70153873115C83720F08EE0962B8F02654236887433FC73D5857
          82C82A04D72A7F3C03C4D420B846BB52281C1004E56AF8F5CBB3A23BFAFACC1D
          7D3DE6616EAE181CF8C8839C1C71B98E2E53AEA3C3B49CF9428C958060FCA6D3
          A7C537B66E61AE6B6F611A610D59F2114156B6F8AAD666E6CA262DA621334B0C
          732440EE6764888B376E6490FAF40CA53FD843086C56D747474BAF6B6AD2BAA8
          28695D64A4F4DA860DB43622525A1B1121BDBAFE6F94171E2EE585854B4BD6AD
          A3D5A161326E48A8ECBB356B293724448614AD5A432B838265C8B77F59457FE2
          04C92A381CD9371A7FA5778E1C9521973ED1A0B7028FCA6E051E915DFCB306BD
          0D36B82D3C027DE17DBF591BD4668AA1A70200D54A4A2083CB1BB5985FD2D325
          707D04485D6A9AA470832653B8FE53A636255502F75F88F0925324DFAC5BCF20
          35492725D86B849B9824C95FB38EB9B87A2D53959028812B2B442A13122479AB
          5633BDBDBD77B1025F4239B0975C587B22507A5C5723B886E09E08AE61E0AA11
          BCAA2A3BAE41780DA26EC761C39712C13588DA8BA8ECB0FE9AE0B4021FBCFDBE
          87A86CFF23FB87C87FB1A33F59A1064170FD7FB3534A7F53DE097827E05FD027
          A85E2DA4E2670000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000021744558745469746C650050617374653B426172733B526962626F6E
          3B5374616E646172643B259B079D0000064449444154785E85976D885C6715C7
          7FE7DE3B33BB33BBD96EB2D98D6E52562A7EA968DB101B59535F4A5F44285811
          151B69B596C6375A44C837DB6F7EAD504441ADB5AE2DE24B1015B41429D85243
          A2821F5AD0C686E6656D926E32C9EECEDCE7397F93DD87B95CDCDD39309C7B9F
          E7E19EFFF99FFF39F78E4902C0CCA80C6363B32F3FFAC4DCF43BAE7F32CF8ADB
          DF3A7FFECFE7CEFEE7D02F7EFCD809406C6AD59E543F565037AB7E00E4402379
          806272C7AEA7EEB96BEF81EB774FF2DAEB8B773CF36C7F01B807080080032B40
          4C81BD0E82AD011CFFD9C18F8CB61ADF31635F67EE2E9E7A31E7CA6A814C283A
          125C775D8737CE5E246B1490151FF8E2B77E741609C919C99D073E9A539E7C9E
          3CE3F89595FEE1DBBFF1AB1712106D05C0001B6D160BBBF77F6EA6BD7D0FDD95
          16E77EFD020F7EE1E3CCECDC467488EEBC7D69854B977B84E0DC7FDF1D8C8D36
          E887C8A9D3E778FA2747B8D2B889DDFBEFA3152FDCB278FC773F05F6003E9C01
          C8CCB4163C5EFE2779D8CE9D37459EFCDE73ECDC3DC7ECEC14EDCE28EDF60879
          9EB3BCBCCAEB27CF7271E9126F9C38CD5B674E72E0C68CDEF97FB3AC65266FD8
          0BEE33409612D4D0122846E4115FF92F992E70EBCDB38C8DBCC98BAF1CE7E8BF
          8C2B65C6CA6A4188804A1A59C96811989D32E66F1D636AB2608C53E4A5C8BC44
          EE35510F2B01EE0E0A28044C7D9AE1356EBC618C8991494EBDB9C4CA6A9F3246
          A2048222379AAD51461B4EA7D9BDEA97E98C148C8DE698AD3FA702F01866368C
          01813BF2003819A2E54BCC4D47C6F392A50B5DDC851CCC846546061485513432
          1A79C14833A33091C909C199D931DB1C7FE7BBE3AE89C558145F51B71B74ECD8
          0FB43180149C1810C25C80939BB36BEE66B64DAFD25B2E114232CC1C0C4C0990
          19990118B198A2BD7B1F133BCEB7C71A53857B2FF47A16DA6DEFEFDDFB50B806
          A20EA02A011E03489000E08E9781DFFF639A334B2308A181B204020964800400
          0AC03C07BF367F3AAD1043F9973FFE66E1EEF1F15107C58D45A8C8358F1C7347
          38D1B5B6767AA9C5E1431F669855E0EADA7FFCBB7F9A37AC198256E171FB3F00
          1E85428962097224211C45E11EF0945D1984502D9A44DDE4882C796835735CC2
          206FB532DBA40B2228400C7500417870E402AA60AAC4036420100ED4F73DDDC8
          1D97E5319606B001038E7C5D03264702C9D1DA7A1C0414C2A016B0F2C9241CAF
          18023C08C0B61E44B10F31E072D28CC7A3882120799D01BC9621B58C537B0072
          12264F00D890013C3A7840310543E0426BEB5509C05102F2CC91BFE32E5CC245
          EA2488EE3CF8997D156BA43DC83665C083A358220F24FE913BB89047A2940257
          EABBF7EEF7A605AB389118384F059370694B06CC63445EA2C11CA8BA20461F64
          E70C9A9E9FFF769D0139B847E4223AB8C4A183FB2BD500DA82014B6D08B19F00
          008A20A128D6F501D41880CF7EE2FDE94A55C669173754090697B62C011E031E
          4A88011072C71DA4F5EC5DCEC004423CFDCB63443972924F6C487CFDFE0FD518
          88615809828397691E3828511B1DA58783AA2E70E3F39FBC054958AA8A5481AB
          DA1124E11EB616618C0EB18418911C530A1885475F070628090BC40F9FFB2B42
          C885BB522090C4235FBA0D5159D49039E021E2A13FE8021F7402283A3E48BDA2
          F5814FEF83942118C853C6D4B421817BD2C02625D07A09FA981578EC41AABDDC
          D6BC4721C011A464BEBFF032526205E1EE9034F0CD873F46550950F42D19F032
          C4C5F3A7CECC8C77B6514848914C8220ACD9AEDA5024BB26B403D56B19434A57
          80AA830888DA9C0107FA2716971FF5E75F7A2293766A201C70199DF76CC37DAE
          DE05F5D18BEA6F4764E9DE954AB9B90604948F3CFBEA11E00F40511D6CDAF6ED
          D3ADED3BFF3673E7A7E68F5693502988D53481A503896D32100947DC7A0E4460
          15E857C13118B3A9A977B5C627A6DBC2ABAE160803D5A950A67A5D3DA94610E5
          6426F2BCB1210315909ABDCF2626F6647953FD9401E3A30D808AF23A2B40FD13
          4D325C8EBB10C45ECF550320A9025237CC50A7F3D5D8F3CBCB65BFF7F2C38717
          3E883408AE74ED9EC0E0780D8C00903BA1EC1F15BA5C14E6F0ED0460A819DDEE
          43A1DDCEBBAFBEF2D2BD666507B28632654206D4C66BDD6386616E809752A35B
          E4F9DBDD6E28C194000CB76B9FD0573FA57BE3E3C585108A8BFDD6156BC79114
          68F8DFFAE5E6AA9ABD8E1A0D8BDDAE95579FE700FF035802C08A010C91F50000
          000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001F744558745469746C65004375743B426172733B526962626F6E3B53
          74616E646172643B9EE424DE000007E549444154785ECD5569505467167D4689
          5BC0C424B319C71A97188D32A06283CB18D4E0862B820AB8208A2C2D826C0A88
          4D03DDD2D0021284661751B0C1B02F238282A86C362A12356A2B101985882B13
          DB68CE7CDFAB7E5D5D3443D58C3F666ED5A9C7BB55E79D733FEE779A01F03FC5
          FF8781A4EC06269180565064197320A2944520FB2C610225254C4078310B7F8A
          4345CC7E0A7111B38F4521B34F54C8F811F8861568E01D4A1092CF901AD4076C
          690C2466B1E2835273AFE068C6450125044A88201566058B59416D513F4E34AC
          808008534156349FF1A20821106AC43FD823C815780A4E83FECDF6B40DC84ED6
          B3068E665E2E69B8D68198D4EA604A7ACFE3E5C407BB079D0A2E3BD78A9576A2
          52FAAE6320FE441D139F59C7488E964D3CFEFD95DEBAE63644C8CE0ADFC7847A
          D221FCC02C6169552B767925F47EB3D27B4ABF274026678E1EBFCC3A8E4A3E17
          50DDA0C4C5A6FB083B521A421DFF175353113DD7FD2742A8787AF63958580B0E
          D05EBF3B1047C48F1CAB659B365BBC471C4E3EAFEC7AF20A35F577111491174A
          27A1C4FF40FC43E77DC7434B2A6FA0F3510F2CED43957F9E686A4087E9D7C077
          C72E32D169B55C7FD081F0DC85A9F27ABCF9F51DCE5DFA11BE21F230CEFDC0E2
          ACC05027BF6361549C96D7C134CC5DE26EC1F1E72DF763740C44A7D632646AB6
          E91592471F4382A485F20B4D4AD64445CD4DB8076488E864546800F1614E3E69
          A2E2CA16D0AABCD002F335FEB9A43F9C9B7EEE526F1D0344BC9A912454B24DCF
          60D6C0A09D7BA2C68BE3CA9FDFEF7C0AD5AF6F5156D502272F999833D1477C08
          1571F44A11179F65C5D1DDF30A1B764A9F4F9BBDFE2B6E7AB3255E0C6FB1878E
          01225EC588E22AD826B9AF2CA863BE7FDADECCD3F5E8EC7E01D59BB7283AD38C
          CD2E31E1F498A9B096F8C8ED9E49878AD4E22F7B5588961563CE120F1FEDE9A9
          F82C73775D0362222E8C29679BEE41392C2861DC04C391FC808C56456B071E3E
          7ECE9AF8BEB401EBB74B247462F5641F3978248517555C07AD9E972ADCBCF310
          E6AB025A47E87F365A7B77669AF319E3F97C5D03C2E832E6A0B4986DEE26E2FC
          0372861F28674FC1DA2164812032FF5DDBA367E878F41CAF8989530597B0CC26
          504A08BFDBB23B3EA2502DDEF5EC35BA9EFE0227CFB877D3781BBFA526B5B284
          88BB31867377E91A0892D298CD679B6E44D82DE014E34AA05EB0A1B6CE51E939
          254D6827261E743EC1CB57FF444A66396C1CA58D9C78E7935E16792575305DEC
          9E4178067D6F8EE19C5DCC34DE0E5D03FEE27C92E5B96CD3D53F9B8867332EE4
          C9259AC9DF368C73F448E8BE71A71377DB1FE3C6ED36145528C8EDB8055A0F1E
          F5A2FDF14B28DB7BB0DCE660CF17E3795FD21B41B9DA06A699EE64A6CE76D435
          E01D729AF114B0474E84B318E7FD04FBB2B40346CF628DAF9B502A47CBED07C8
          2EB88C0B8D4AFC0640F9D30B283B5FE02E7906879F8491D936BA65FAFD85D714
          93EDCC5733B6EA1A18B8340133DA7C95CFD52329E5B840A25AD1D286F4531771
          F6E26DDC6A7F8A7AC55D9898EF6E2684DF130CD564FE0035A0012E56B98021F8
          C3DAAD227941F935FC46460F9616A0EE6A1B79E6E307650F1CDD63316DB62D0D
          913F12E87106B431B0015D513DF524FAF4A3560E92D8BCB26656FCEAED6E1C49
          AB829D731C8EA45622B7F012DC7CE3E1EA130743D32D0984F3A93AB0F4387059
          309001567C47F4D9892E890D0297E42BF52E49CDAAEDDF5D52D809F21A320B1A
          A152BD41FDCDC768BAD5A541CBAD7FC07ED761C4A69420A7B4117EA26C58BA1D
          6DD81C5ED66477A8E2B58DB0A8616D60AE70A153B42611FF9D810FEC0F154FDA
          115F279755DE47FDBD67E87AF516CD6D2F5074ED67945FEF466CFADFB16CA318
          4B6DC4B0582FC2E275A158B82698FEEF316B011F9EC24CA4D5B423B5A603676E
          74E3C79EB784D785D0AC2BB0D89B953BD34638955B4E8D01ED3CB78FAA0E8E3B
          730F55ADDDD82A398FAFED32B1415C8D826B4F9052D58E399B63E89219124C26
          F89A603A01FDE8048A6F1DA31589E7DA9154F5132C03CA317543222C03CB2123
          EFDEB25AF0B6C58771E1D4D7006D0CB51257369CF9A1079B24D598EE989138F6
          1BE75986DBD393578B6B71BCBE0BC68EE9D709EF4FEABD18A6C6876A8C5CEA7D
          529154FD108B7CCBF0D78DD2C4716676B38C3645262FF62B4774D97D186E8A6B
          E2AE687F06862F3950AAAAE9780323E71C8C99EF64427A9F8F99E7606AE49A87
          D8C65F30D93645C52D589F2D1F4CF90B7667A8C22A9EC2684B12C69A6E62F963
          675B9BCE704885A0FC0926AD89A6FC8FB98CE86B6004CF25A331AAFA11AC62AF
          83E79193327E91B399E99E9CB475E4DD36E50EBE581EA920C44FB80F18CE71A2
          5C0DDFD83EA6D136E12656865583E7244B193FDFDECCD449966629AAC1EAC8AB
          18B328543190816193D7878B5C9315702DF81936C94AAC3A7C1DD6C9F7609BD5
          8DF97B0BF189995F243D42EE4A71B9CEF1FFB23C4864233E8B0D494A58452BB0
          22E43CD6455D81B5EC1EE6F1E518CDF38AD0E6F75D42BDCF676F9B3E7E9D287F
          6140315624DC8357D973B89E50629E77214699FA158EF8D26A8656C673A5E17F
          6A6C377DDC0A41BE093F07CB22AEC23AA9034B0E35C3D8598E8F793E852327AD
          E5F83A4BA899E2A3296B8D0C4CDC2406663E8A5173FC55063CDF66FD197CE9F0
          89AB66D245EB2F50B4F9FA93571B19CC74938CE2792B4699ED277C9F667D6357
          E9F0092B75F8FD05D160ADF41B4DF0997AE94651737DC439EE7BF0078EE221DA
          31AAFBE3A2E1BE075FD780C6880E748BE3BE17FF5FAC57759B4588C1B9000000
          0049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000025744558745469746C6500436F70793B426172733B5269
          62626F6E3B5374616E646172643B436C6F6E656D0EDF5B000000A74944415478
          5EEDD7310A04210C8651CFE7B96C45B1F7642195B087982DB24EFBA30CEE4876
          0712F85A79061B9D88FCB467004208B258EBF99E1BF41D60654E448CF15D6BF5
          70961E809901A10CE883087D002246805B8FAD942244340320E2381108B87DD3
          9492B4D6A600447480DF0A6066445C6DEEB515D00710D7E8DD0044A80346087D
          0022884805302DE7BC1DB08A3380010C6000038C52DF801BF5DF0003ECEC11BF
          E30FBB3E9B500CE46CA50000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F40000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000026744558745469746C650046696E643B426172733B5269
          62626F6E3B5374616E646172643B536561726368BB659C080000007049444154
          785EEDD3C109C0300C43D12ED8353448A7CA76EAB1501562704C8AD1E1DF4478
          3EE420B9B5D0C880F31A7CF5B5915D1960B26B02D007B5E82E0B400280B500AD
          27C00079340198FE84D0F5C9D017F06C5300BDBCB2280005002C051820F0C500
          030C30800500FE16B035036EAEDCF97183C2D6350000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
          F400000013744558745469746C65005265706C6163653B456469743B69AAF970
          0000085249444154785E9D570D6C95D5197ECEF7737FDADED296B6B0524A47D1
          8A4506825010112A5264C1C58DA9414864996E6C4C16F027A2C2CCC212B398CD
          28E82671C33926718E2C71B00981315AFEE447A4DA851F5B2848697B6F7B7BEF
          FD7ECFCFFA7D9E6FF672B7BBC537797372F3BDE73CCF79DEF73DE75C822F6FF9
          E68A2FBF48FE58394ACF2522B23C874C4E2C340CB397F75E80E002420870E18F
          587B4F7D00A03CFCEC96E27113A7DEADE9E16F0A901B85E01542906ACED86546
          791FE7EE392395DEF9C9B13D7BF7BCF5621200972EB2C80F2397A5C04B7F3B87
          FB16D405FC50A329C4035EB9E1D5B2AF36CC7856D7438F8C2E2F8C568F8EA1AC
          2482485847414447DA74610E796F22838EAE04BAAEF45B4626FD465BEBEE4DFB
          77FC320E8049606DD58B7F5DFFEABA453F054001F02C0518E3C3813D579F7BB3
          F5DBE1C2D82B632B0B4B6FBBA51AA1880697715006B8422061503F548B8430A6
          3A849AEA3218293B72F24CD70F84F28D15636F9AB1E6CDE797FD0900566EDAB9
          5E28FA93005E00C0725240258180ED86DF1DDE30A2A4F899F933C72156148141
          390C83820B99643F4D0097A3ED70F40F3A6010187F43356A6B2A627B5BF43796
          6FF8C3143E6477CCBCF9C7874E5D04001D800D80652B40196A7445F1C0D7FFB6
          75637945E9FABB1A6BC1150509092CC1A40BDF290792691786C9FCA40A0E74DB
          0E7455C59D7326A2E51079AC6EEC484C98508503C73E05005542922C024FDF37
          C9075FF7EAFB4B63C5B1F5F367D4C01280695030011FD5B629CE9CB9888E8EAB
          88F7A6901C345054184549690C636A2A505337061CAA4FD4A60219476056633D
          C2211D1D711BAEEB2BAF4895A15DD722CA9247378E8A14956C6E9A590B8B2B48
          DB0CCCEF0CE0FCB9AB38B0FF34920303FB1C23B5C74CC54FB5B7BCDD76D3EDF7
          DFD2171B39F56247D1C2B6D317E64D6F6C40D9E80AB88CF96A7C663170E2FA0A
          522609F8964B40ABFBDA1DEB268EAF28D1C221C433148C73704170E283B3387E
          B43D918E5F7962DFB6A7BCA272652189C37FFCD90100AD00B6CE7970E3D28386
          B969CAB489A55575E360510640A60C02AEC3731508763F79EEBD2342E182EF4D
          18578EABFD369206854B392E765CC3A963FFBCF8E9895D4BDA0E6CEF0C0AE8BA
          43C66F8796B79FDFD5FCFD2DB30AA3A115218D60D0E2121CFE48299578B90A68
          B72E5876EFA8F258A4DF64E8EAB37DE9296538FFC905DE7BE9A35543E01DFF05
          9CC8C20ADFFDE8E6C79BEE9AB5A27EE2385C4C9870A93CD80008B95E6E0AE402
          A6AD2C2E8945D19F667E4B71003D5D3D480FF6FFA5F59D178E0270E44ED1DA99
          120202736A8B03F068D3235B9E99D7D4B8BAAEBE06E77B0D0C1A549EC9024276
          B82420FE930262304D6F7EF7BD13186E8400833DD7DE016049D9F1F5B53BC4A6
          97766198290B566D7D2A1489AD6939720E2D47CE420C8311F28737124220EB47
          0CCF8522C984A5AB522621831D006696F4B9F2470044E5FCA0C8020F8CCB8DA4
          E5288F62A98E0C70241965D824578ED996BBB093059E7B6B0AA9229598825C7F
          0E345557867F357FC66570512A00647AE3E6D6B39D6336777627F392C8065296
          6F538F8278266A3923A59C893ED745A765889D57DBF1C689D7790F00A19CBC73
          2A4ECC9D026964E3B486D9D4B44B3965006350742DBAA8BCB449CA4C0E354E42
          EB4CCF1B647E45E059EF0021702B81989A4A89D2E4208745511E8E607AD108B2
          A9743CF64E7A888C044014CAB9DF6ED294225559EC18068C8C79C1A5CC52751D
          11221607D252CAE0B933E4794CB11DC0B681BEABB8FCDE63BCA8EB9468C80CE2
          379C017A9834148D218F7B710AA5DC5F3028261D68360D0B8954FA1FA6ED7EE8
          710B296AB3AC0BE24A0294F2BCA960AE2F20388567FCF86BFCC2F16D7C9D6508
          707BC85DD4C1578031CC3ED2E6E7EDF5D9536AC1D8CD4EC6424F2AF341CA728E
          324AA1E9A1312FDF503DD98BB9EBC3B3C49BE3791E23D415701D01C144D0654A
          D574543BB6402A2DE058E263FF03FB62276A5D6174B1633AB01C0727FB060EF7
          1AE661E632105545B9A22E0EEAC0610C2ECD4F20008F142234E387646ED373E4
          27B12ABC9719048C383E19388F5FFB6DE8B22FE48F08F12DCBB4E0B8FCD2CF2F
          75773DC0C4E0DA1B6B994214552764A17CC9B84BDA3BC9BB136A443E02CC01C0
          014D4565AC12BB140DE04CC031F051FC633CD07510095F8185A7CFF9E04FD4D7
          56285CCCD0341D7A69F13100FA8E2BD74CD376DAA94B11D5B4690F8D1C5129E5
          FCBF52C01C81448FC824AE883F27AF891E6A030545983C6A320E8C5F82DB3C5C
          2DD87D63716C1173A82A844021C8D283B3A72E05F764E4605E80A2A833A39185
          BF47729B5F638C893C4548A8037F9ED18781F6ED5809804F5A86A6E26A6C0FC7
          50A917E03500D3FF4DA0909066D771D1D31707F780E183A2BCAC041E11555511
          116806F01600B2FC5237C9F707C4234014803B803CFDDCB6EDD8376D15F68722
          B847084CFCCAEDA8F509D44623E110E7F30DCB864379F247577A26F533660020
          DF35ACBAFB2BCB0F4108B54055E7556A6AB487321B00CF5F8480A202B2568974
          8553445DDB2708C1A02A00D4276BAA66714A4B32A68594CBFE3E049E0290F17C
          6B77DF39D3714F31C61052D592EF1417CD92DD90CF0877014E01BDC0078E1454
          A264D283582380799901809938DB7D041DFEA553A19066461932A68D7ED77D5F
          5E3E3468CFA4E3EE29D3D4E93A0146FADD80BD00F2A680390011404121AA6E79
          18DD9CF999849100EC1452563F567B381A002412C90549082F809DB4ECDDD7DD
          7EF464BC7F77BDAE3D0D0144419AF0BF8DA713929DBCC005478AB9E864368E5B
          71FC22FE31CE03A064D83B4093A0CEF007836C3B5DC610A94CF02CE3420461C1
          6303C19A213966BD07E43C2A9D6B92A325038320F14A59894F607562202015A4
          44C8EF7CE81BB22CE76D91F316801CF950077823FE05A9F885EF479F861D0000
          000049454E44AE426082}
      end>
  end
  object ActionList: TActionList
    Images = ImageListSmall
    Left = 384
    Top = 232
    object ActionProofingCheck: TAction
      Category = 'Proofing'
      Caption = 'Spell check'
      ImageIndex = 13
      ShortCut = 118
      OnExecute = ActionProofingCheckExecute
    end
    object ActionProjectOpen: TAction
      Category = 'File'
      Caption = 'Open project'
      ImageIndex = 0
      ShortCut = 16463
      OnExecute = ActionProjectOpenExecute
    end
    object ActionProofingCheckSelected: TAction
      Category = 'Proofing'
      Caption = 'Check selected'
      ImageIndex = 13
      ShortCut = 8310
      OnExecute = ActionProofingCheckSelectedExecute
      OnUpdate = ActionProofingCheckSelectedUpdate
    end
    object ActionProjectNew: TAction
      Category = 'File'
      Caption = 'New project'
      ImageIndex = 1
      ShortCut = 16462
      OnExecute = ActionProjectNewExecute
    end
    object ActionProjectSave: TAction
      Category = 'File'
      Caption = 'Save'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = ActionProjectSaveExecute
      OnUpdate = ActionProjectSaveUpdate
    end
    object ActionProjectUpdate: TAction
      Category = 'Project'
      Caption = 'Update'
      Hint = 'Update project from source'
      ImageIndex = 3
      ShortCut = 116
      OnExecute = ActionProjectUpdateExecute
      OnUpdate = ActionProjectUpdateUpdate
    end
    object ActionBuild: TAction
      Category = 'Project'
      Caption = 'Build'
      Hint = 'Build localized resource modules'
      ImageIndex = 4
      ShortCut = 120
      OnExecute = ActionBuildExecute
      OnUpdate = ActionBuildUpdate
    end
    object ActionImportXLIFF: TAction
      Category = 'Import'
      Caption = 'XLIFF'
      Hint = 'Import translation from XLIFF file'
      ImageIndex = 5
      OnExecute = ActionImportXLIFFExecute
    end
    object ActionProjectPurge: TAction
      Category = 'Project'
      Caption = 'Purge'
      Hint = 'Remove unused items'
      ImageIndex = 6
      OnExecute = ActionProjectPurgeExecute
      OnUpdate = ActionProjectPurgeUpdate
    end
    object ActionTranslationStatePropose: TAction
      Category = 'Translation'
      Caption = '&Propose translation'
      ImageIndex = 7
      OnExecute = ActionTranslationStateProposeExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionTranslationStateAccept: TAction
      Category = 'Translation'
      Caption = '&Accept translation'
      ImageIndex = 8
      OnExecute = ActionTranslationStateAcceptExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionTranslationStateReject: TAction
      Category = 'Translation'
      Caption = '&Reject translation'
      ImageIndex = 9
      OnExecute = ActionTranslationStateRejectExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionStatusTranslate: TAction
      Category = 'Translation'
      Caption = 'T&ranslate'
      ImageIndex = 10
      OnExecute = ActionStatusTranslateExecute
      OnUpdate = ActionStatusTranslateUpdate
    end
    object ActionStatusDontTranslate: TAction
      Category = 'Translation'
      Caption = '&Don'#39't translate'
      ImageIndex = 12
      OnExecute = ActionStatusDontTranslateExecute
      OnUpdate = ActionStatusDontTranslateUpdate
    end
    object ActionStatusHold: TAction
      Category = 'Translation'
      Caption = '&Hold'
      ImageIndex = 11
      OnExecute = ActionStatusHoldExecute
      OnUpdate = ActionStatusHoldUpdate
    end
    object ActionProofingLiveCheck: TAction
      Category = 'Proofing'
      AutoCheck = True
      Caption = 'Live check'
      ImageIndex = 14
      OnExecute = ActionProofingLiveCheckExecute
      OnUpdate = ActionProofingLiveCheckUpdate
    end
    object ActionEditPaste: TAction
      Category = 'Edit'
      Caption = 'Paste'
      Hint = 'Paste from clipboard'
      ImageIndex = 15
    end
    object ActionEditCopy: TAction
      Category = 'Edit'
      Caption = 'Copy'
      Hint = 'Copy to clipboard'
      ImageIndex = 17
    end
    object ActionEditCut: TAction
      Category = 'Edit'
      Caption = 'Cut'
      Hint = 'Cut to clipboard'
      ImageIndex = 16
    end
    object ActionFindSearch: TAction
      Category = 'Find'
      Caption = 'Find'
      Hint = 'Search for text'
      ImageIndex = 18
      ShortCut = 16454
      OnExecute = ActionFindSearchExecute
    end
    object ActionFindReplace: TAction
      Category = 'Find'
      Caption = 'Find and replace'
      Hint = 'Find and replace text'
      ImageIndex = 19
    end
  end
  object OpenDialogProject: TOpenDialog
    Filter = 'Translation projects (*.xml)|*.xml|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 364
  end
  object ImageListTree: TcxImageList
    SourceDPI = 96
    FormatVersion = 1
    DesignInfo = 18874432
    ImageInfo = <
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000003F744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E5365745374617273333B436F6E646974696F6E616C466F72
          6D617474696E673BBD1216EC0000032C49444154785E45926D485B571CC69F73
          131793D4248B26EB5A496A8BA26E6E3ACA46192BD889C3B1C98476AC30F61206
          5DCBFAA576C240987BB5DD8B1F4A999B038BF8C142EBC656B73A669DB8B56C85
          958C2AAD7496D48A1A6B6362D47B73EF3DE7BF136F322F3C3CFC9F737FCFE1DE
          73D8A5F6DD2002400C04211DB999D078F21A1B7EF709CA06042BA3FFD7AD9951
          6606F9C74AD986334758193A56DBF94257F43DCAC4C42605E477196A6B817D33
          DC5C60853BD8E0D1C75EF604C36DE70E9B51E6D87196D45B395AE41082E0801D
          C437E19C1F7DB6D4E9F5074E3EF97A2BFEE8FEE044E4E9FB3F9230D798458248
          582E28574016CC5C150C8072EED0A36F57EC6B09398C1B28AF7F29D4383F7F48
          71579D02C0A520D251923404B73845CADEDA18F2F447AAF70DBCF548EBD8A7CD
          29BEF0039993ED64CE7D47A31FBD98EA7FA3F278CFC1F286C89EAD3E00055236
          29C6060FD77C52E42F39E82BDD59E67D3804EFF630BC8107615BFD1330328062
          87B9E529A41613589E8D2139378344EC762CB9B434F06AFF54BB32757BF94CE2
          5EDA5D59DF805DB5611417DD83B27C05B49E86D033202D2DE7DF651EC7AEC7B7
          A1AA7E2F12F7D3EE7FA697FBACC307948E866D7555655B479E3F72C057A0CF02
          DCB07E14114848877428306C0FE1A79EA164F456FCB9CFAF2CFEFD55532957CC
          A571D1313217BD39BDD03CFCCDF9355D2996BC019E5121A44857C1750D06F361
          B8F7E2DAC4BF8BFB257C4DBFFB3DE73C5BCB3598F15FF8FBA373575753A90175
          651D649A12CC6C80C2D0C0B88096D6B0924C9FEDBC1CBFACDF19304972C57E27
          14E23A84A9C3FA1E1674BA0B21D415803128853E10D9C0D5340ADD0FC0060401
          10991A88AB1082A06407C80190EF3B9D6185A7C0DC01C4664C8C5F9840ECAE09
          B8FCC8E6AE22E74E20C764952F209ED928F0F8BCA1C9BFA6F0ED17BF6ADD5D23
          BD17C7A79BBEEE1AEDEDE91AD726AF4EC3E5716F07F28C14017612D92681E66A
          BF33313BCF2EFC1CFFF266CA38FDDBBCB690BB7963CF248D8FE571BFB3B72618
          692AF73A21B43502411001EA8DD352A710D91D74BD56170800704829EAC46750
          AF9F90EACCDF56C72B35C5C137EB4A5CEBD10FB11EED405F4B19FE0365D3BD53
          AA437B1A0000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000042744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E5365745175617274657273353B436F6E646974696F6E616C
          466F726D617474696E673B0760EE330000027D49444154785E4D93D952135110
          860F8BAC17EE98C4AC8421936466C22CC9CC649909D94608AB884870412F7C27
          1E032F44CAE209A8F2C69790A80FA0376D77D71093AAAF4E55D2DFDFE774CE11
          EDFE7B063F13C8A46C76760A66EF0CB92E5AC19F82D9BD968DEE594E6FED62CD
          14D579C189F07A0391373A42B4FAA72C67955A346F76CF357B139CF54368F44E
          C00FDE40A33B00BBF902D4CA06E4F4F6795AB663545F6F1F0B59EF0896574BEB
          B982D5BBB1EAFBE00524BE06AF479C7040A333807AE715E8D56D0AF9812189D0
          13E251343B23EBED6F658F65EC3C60A9DE3D66A98654DBC411545B471C22A9DE
          270C9896345F88D552F39D527E86C5A1C0C5E3D24B70113A96D33CE4E36043C8
          149CB73433B1AAF95FACFADE48648158278905A6E2130750F10EA08473CAE4DD
          4B0CB82324D5FFE960814B1D42C121E956F09F43D9431AFB60317BA0BB3B1470
          830133624569A07430EA322E59DE3E8BB44393A8ED825125B60107F91703E6C4
          72A1F68B522BA32E5CCC923112764047485C43E8AF4E4AD6100366455AAE5CAA
          384473D4652F945840710BD6DC6D28B97D283988DDE721C6B3FA573E423C6B7C
          CC2A7512189D241725678B0446B391CA26A8CC06A473364452C50F7C33E717EF
          2D2456ACEF79BDF55F22C126A14F0283BB24E80E402CA55DD0F9C3EB2F26979E
          CA5A7CC518E28FA140320BA020C572008A15C072B106B14C6978FF7152222F9A
          D6C8E794A9074BA9742CA37D4E4A65C0BB0105A30B4533803CAE92E243226B42
          24A15CDC7D9858A67A7A4891A42A047614D8857782CC3D89CBA791A472154D29
          BFA3290D688D248B574BB11C3DD97992E911E12005D6098145229A5671556F77
          338DCC220BC862B8CE85DF4F9034CE3F501D414BCD7956C90000000049454E44
          AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000044744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E536574526564546F426C61636B343B436F6E646974696F6E
          616C466F726D617474696E673B98A0D4C8000002D249444154785E4D904D685C
          5518869F7373D330C9CC346D8DC224216A37D5858A228822940856A9687ECD4C
          4B25585D68144A8A15244A37AE224840574550680B75E1602A81800846D4855D
          B8C8A2D4D8665A4D9BA449E6CE4C66EEBD73EEF99CCB3D48CFE1E17DCFE17BBF
          8F73902F67620014D076757C64E8467EECDCCD63AF5F593B3E11940AE357AE4F
          8C9E5B1E191A065C40C9DC19626E4D8CF17F78FEC5177A57F363F3EB6F9D90FA
          D9F7447FF681C8DC872D3D2DF54FA6E4F664415646872E5F3AFC7C1FE0C8EC34
          ABA3C300A85F8EBEF468293FBA519E3E2966F694C8C79322670A22D3E322A7F3
          221F9D10F3E9946CBF3F292BC3AFAE5F7CEED9070167E5B5575047FB7A53734F
          3FF57BCFC1FB1FCFA6814A192203825D0262C000D92C5E0D56AF6D2C3CB1B838
          0284EA8F2347DECCF564BFCA0D7442C54B02912401654004B0670C7465289502
          AEAF974F0EFEBAF48DDB81E4D3FBDA61671B8C80DC8B4930582FE06FB237DB4D
          E71D8E01175C9AD19329F1210C40489A609267401232366C7D574795B6307A0C
          687325D007DCDD2A441AB0C546126F9B8808AA8518137B5C1DA1B5E9069413F8
          CD6D5D6B40D08430408216CDB0A521E8F82E44B520C6FA60D727F49B1E805B0B
          FD3FBD5AC7E0FE94C651A0A2640A765A0CB11A00414542B9EE50F5F53220EE46
          3D28AEADABC103398D510206C4181050242A221069C4FA7FB6DAB9DDF0BF059A
          EECCADBFCF7FA11F9ADABFC73994DB2B104560042199AEAC62042258AB4069CB
          FCF8F6E68DF380765742BFF65BD57BC3D1E985A06EEE1BD86750F6D789C56EA3
          E1A6A7B876D7D95AAC7BA780C60FDD03D206C8CF8DEA467B24C554C37DA4E2F1
          B0AB22DA89708D21080D772BB07C07AEEEF053B1E18D7FED97FF02A2BC9B8166
          E1190005B840E6F3AE07DEB998EE5B2A667A77E6D3FDF25D3AB773A133B7349B
          EA7917C8DA3A15BE7C90622A87FA3EDD0F806018AAFDAB803D16D73616400361
          4C2B24DCB3FE03F304B94D918F11270000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001B744558745469746C65004164643B506C75733B426172733B526962
          626F6E3B9506332F0000036349444154785E35927D6C535518C69F73EE6DEB64
          63A3AEFB60A3A36E33B8C56581E0D8707E21CC1A43A2A22304FE3001512A86C4
          E900132451FF503367420043B244364C483031465C248B4441C0980C45B4D065
          CDBA4ECAE82AAC5DBBDE8FF3E1BD27F1397973DE9C3CBFF7233964226FC2D543
          A53E0280443E3FD752525AB14323FA06685A3381E492F329C6ADF39954E2F8C9
          C3DBA6018858DE940A9C2C5870C1D51BB6FAF61DBB327860F81A1BFE25297FB8
          3127C7EFE4E5D5745E9EBB9991239766E481937FE4DE1818DB0DC0EB322EABBA
          B63FD5EB7D6CCBBE6F1B83FE9E67BA82E084C0E4123697CAE0D109BC94805B0C
          E7AFCC606A66EEECF75FBCBB753AFAEB2201A0BD3E7861B02914D8DBF34408A9
          AC0D2181D3672E23319D81AB950D016CEBED824E809A722FC62E4CE17A343130
          D4DF73507FB9FFAB551E9F6FCF93EB82B879BB088D52504A14FCC9CE4E95F79D
          B80CD396284A8179C7D3DD1144F29FEC5BE1D73E1BA6BEB2C09BEDCD955A7CCE
          44D1744C1687C9045C05EBFC686F0DAADCB08413D2098E89B4E1BC5779965687
          5ED585D03ACBFDA548E7197EFA711C776EDFC5FF12200A7075F4E85975D7D4FA
          F1F4A635A82C5F02A2956CD46D2EEB1D160B455BC19FEE5E0F4A885A45828071
          81137D1B61DB0C1E5D43E4C8CF5858E4D0A1810BBA5CB76DEEBDB768C1E604AE
          EA6B1F40D9121F0A265385BC0E5457530109404A8010E27805EEE60598CDA15B
          8699C8E7CD4784EEC3F2BA00767C340A4AA9327E79300CE1505BDEFF0E9AA681
          5082150DD5604CA26858282E1693D428E42F6666B3909068EF68C5E6171FC7E6
          17BA611A260C93A9029C713CF7FC3A3C1BEE404B5B2398E0989FCBA190FD774C
          CFA46243B11B4B77ADADF67BB236478E10500AA5D2121D5C48354D3A674108A1
          56114C201E4BB1D9F86FA70880FB1EDD3E34B0A229B4E7E1350FC2E22E2011BF
          16C3FCBD050557562DC3CA964608B8B4C4E49F4924A27F1F193F1DD9AF03B0FE
          1AFDE03D113EDC6431B1A96575089212B4AD6D555F581280D902398343308EC9
          EB49DC9A981A75E043000CA46D09005A49457059DB4BC78E77EDFCDAEAFDF892
          DC3B1295EF7C13977D4E444E45E52BCE5BE7AE338555E10FDF0650EE32B30E4B
          D24C0212A8F210EAAED3D01969BB3FD0BCDDE32BEB06D56AD5D09CCDDA66EE62
          EED6EF43A9AB2331008603ABCEFF019D3AAD15CCD8D2E00000000049454E44AE
          426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000021744558745469746C65004170706C793B4F4B3B436865636B3B4261
          72733B526962626F6E3B6463C8680000037D49444154785E4D8E7F4C94051CC6
          3FEF7B77E02073EA92742577579B684891E62AB6C4526B6013696BC9DC5A0B33
          D0322DA716D3CA94A21A8E96E976AEB654688E409B46B859CC249500E3F81588
          234EE0F875DC1DF7A3BB7BDFF7DBC16AEBD9F3D9BEFF3CCFF7C13555CB58A801
          40014CC5E5696BF638D24FBEF7EDF2D683550F7B0E5666B4969C5A5EBBEBCB65
          2F0209803A116E6438F82377A66A60385007A0E4EFB2A5BC51B1B4AEF4EC5AB9
          D476583A87AA642C7055BA47CE4A43F72752713157F67D93DE54B0DFBE04308D
          867E9E290050725F4BBDB7F8E8B29EAA86B7C4E5BF203DDEE3D23E71585AC6F6
          48E7E4C7D2E777C870A05E7E68DE277B4F668C6EDE6BCF00D4017F350A607EF5
          48DAB99CECBC9CF4343BC3E1264CAA60C282AAA8288A028A30313E852DE509EE
          0C4D72EEF26967CD17FD4F0EDE0A064DF9BBEDEB6CD6C51F3C9DF5382EFF1540
          104014216E500C2ED6DDA4F67C3BEDB79BC9C95EC3E8F8784AD28288BBADC1D3
          6C4E98652A7C2C7D2543816674430304C4885B0755E1CC99EBCC51D750F14E35
          DBCB32E91DF98DCCA5ABE8FCB36733E0500D3132EF9EAB108C7AE9ED1BA6B4AC
          969F2E39896A11CE5F68212529975D5B4A395A59C40B79CF6049D0489AAD81AA
          3C0A9854436741140FE148809AEA16CA8AAEA34C65F1E9E7F524EBEBD99A7F80
          53751FB2707118EB836642311F31C63174497C286BEE6C55D3F48971DF2088C1
          A60D6BF9BAB6849D0547D8FD520D2F3F5F822FD8C7AFCEEF58B16A11FEC82831
          3DC6A87F8868C488745C9D0C9AF5A8D2E51EF15BE72FD248B127E2F5FE8DE3FB
          FDEC28280755E1FDCFB691BF310B6FC48566C4C030F08D458984B40E4057837E
          ADAAA7CB87A0E2090EB2E491594C1A4DD45C2EC779AB0E53B287C4399384A353
          718288A8F4767B09F8F4F380069094BBDD7AB3E474869CB8B1428E5DCB90AAB6
          0DB2E59055B2B621C72EAF93134D99723C8EE3F79572A83A5336EEB439EF9A67
          990FA82A1071F7855EF9E35AC0D3EB0C010A9EF000799B56F1EEDBAFC7BF87D0
          0D411185BEEE30AD8DFE88AB2B501CF0C4FC5706DE34CC0D7F15E9AB53BF6A17
          784ED78C4AB72BF6803DDD82B6B013D5A420064CB875FABB628CB8A21DEEDBA1
          A2D6FAB11B8066480C7EE92F045000737CD6BCA736DFB77F7D616A63EE769BCC
          B0C326CF6E4D6D5B5D70FF47C9732CF700164099CE4D3373FCA76CAB43052CFF
          62065440001D884E130F19FC4FFF00FE20CB5D5DF1FFF30000000049454E44AE
          426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000011744558745469746C650050617573653B53746F703B3B
          8A7A3C0000012249444154785EAD91C14AC4301086A7D68AE89328EC9BE81EF5
          A6AFA04751F02D647D0341104FB23E8908227A12B6AE2D6B366B9B99D4FE2565
          1743C8C51F063EBE0993494BFF996434DEBFB97E1C7EB4958FC6C35B3814180E
          3D9C71DE4B7AF5B0D7E4FAA9992E9E1B309CF370E82DBDCB1AA067664BD9464A
          2F933B02C3F53ECD127ACDEF97DE657DF509681AAB481A2170BF6AC07B1B101B
          A1DA7E93888063DE1F604C7F1383C33E3C40A812859BC0111F1850B322B602F6
          7CC53A32A01632A2A8D06F1DFBFE1D1CDB604E95D160CFB33038F21159135B03
          8EF8D06FC4411170D4FB03D8DAE9E717CD94E978D5174549E5CCF940B283939D
          B3A3F3C1E4F862501E9EEE5EC2A1C070E8E14CE75D923FDB6CB6B5ED846EEB07
          E0FC96E3B9F3168D5F3C1F3F11AF0B16D00000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000003F744558745469746C6500436F6E646974696F6E616C466F726D6174
          74696E7349636F6E5365745369676E73333B436F6E646974696F6E616C466F72
          6D617474696E673BC5369B60000002EB49444154785E5D536F48536F143EEF76
          27685991058549C36CA985454490CD597D8A82FC4384F8A1A2B0D035B5BEE497
          FA90066626044260189893A00F15094EC2922611A39A12A63FB7F99BD3253A37
          67B9393777DFB7F3BE779A74EECECE3D7F9EE73CEFBD5C70F95F084723E86AE3
          FDFCE2EA26FDD3DAE682AFB75A0C511E795E557FAC04FB123A71F8CCE09833C3
          CD47060067025C663A945ED3A47FDBF0AC9859BE36B0414F1B73CC75F188F93D
          56DF5EC46E341EEF3E5F99B70B01AA315F27E03C08F0E5BA23B9B75A4EF83ADF
          D5B021EF13F6D155C72CA3D758F7F025D63352C1FA9DB7D9E0542B7BDE6B62D5
          0FF4B3A5D70F683989A9311FC8DEBC6DC9A7CB759F0BF30B0EA667A44220E402
          CA647120C6008D89480881B48D5930ED5984BE81819EB6BBB6526CC6C8D53B47
          AFECC9CC68371872617E6902C11484AD81C5BF5242D2B4642D58ADA3E0189BBC
          6A7E68EF90240D29D36569613E3C053295D78657592832204E446E81B0077459
          BBC1EDF69663DA250190C31B360344681498185206293A41350817A4D81391E2
          95B2990251B13CFED624949C4649586C17A66C52404281C884AFF2534D0864C6
          B6F01D523C2ECF8796425B89860F5001123F854C5145D6D50881700417AED05F
          3C55C596E9907F6E09C1042895D119B2D3C43D15A4A246454DA8F0FB22105D8E
          0FF315526831FA7ADC1138B57DE70E04F235CA51D8BFC7614CBC4A3510187706
          617121FA125B2B2AEB2BB7D9EB0DFC3731BE006A2209CC9A028C3246BE5D51AF
          8109D76FF0FC1FE8EBED709AB11457057D91D04FE7E2C541DBB4DF3112048224
          04545C8120E1A6226A017662DF6E9B0DB87F046BB11C29ADDECF54D8973F757B
          86866D3EFDB7CFD3EFFB2D1E98F546418E4990A44981F88A0433DE08F45B26C1
          FE69E6C388CD57F0DD3AE3E038CA95D9A71E0B75892F2DF5645966E5D98A7DD6
          22634EB0C494C3CE19B383672A74D6C20BDA2AEC6F4ACC912F9E662832660329
          36E502614C487ED33ACA8992122E29C4A215478F7147108375F6070B79B97E38
          56EEF50000000049454E44AE426082}
      end
      item
        ImageClass = 'TdxPNGImage'
        Image.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          610000001974455874536F6674776172650041646F626520496D616765526561
          647971C9653C00000023744558745469746C650043616E63656C3B53746F703B
          457869743B426172733B526962626F6E3B4C9696B20000009449444154785E95
          93410A834010047D5C2027F3093F104C6461C5CD37F312C5D3641AD27810BAF1
          5030CC587510B68B88EE3BDCFAA46236F0FB190E66CA7B12C9125EFE24F1771E
          584C9009234626230FE514F1F21B2E8E22A2650654A42999011951320322A265
          E0FFF6411301219B88935F49511129F3A622567611C8B3905DA462794FD693EC
          231B5C2C19795E78CE131CCC3FD2409CCC2C3656140000000049454E44AE4260
          82}
      end>
  end
  object SpellChecker: TdxSpellChecker
    CheckAsYouTypeOptions.Active = True
    DictionaryItems = <
      item
        DictionaryTypeClassName = 'TdxUserSpellCheckerDictionary'
        DictionaryType.Enabled = False
        DictionaryType.DictionaryPath = '.\Dictionaries\user-xxx.dic'
      end>
    SpellingFormType = sftWord
    UseThreadedLoad = True
    OnCheckWord = SpellCheckerCheckWord
    OnSpellingComplete = SpellCheckerSpellingComplete
    Left = 552
    Top = 376
  end
  object FindDialog: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = FindDialogFind
    Left = 72
    Top = 352
  end
  object ReplaceDialog: TReplaceDialog
    Left = 164
    Top = 380
  end
  object PopupMenuTree: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'BarButton4'
      end
      item
        Visible = True
        ItemName = 'dxBarButton4'
      end
      item
        Visible = True
        ItemName = 'dxBarButton5'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'dxBarButton6'
      end
      item
        Visible = True
        ItemName = 'dxBarButton7'
      end
      item
        Visible = True
        ItemName = 'dxBarButton8'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'dxBarButton10'
      end>
    Ribbon = RibbonMain
    UseOwnFont = False
    Left = 276
    Top = 240
    PixelsPerInch = 96
  end
end
