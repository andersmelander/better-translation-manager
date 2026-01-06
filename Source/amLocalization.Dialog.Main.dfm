object FormMain: TFormMain
  Left = 0
  Top = 0
  Action = ActionMain
  Caption = 'Better Translation Manager'
  ClientHeight = 653
  ClientWidth = 1060
  Color = clBtnFace
  ParentFont = True
  ShowHint = True
  OnClick = ActionMainExecute
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShortCut = FormShortCut
  OnShow = FormShow
  TextHeight = 15
  object RibbonMain: TdxRibbon
    Left = 0
    Top = 0
    Width = 1060
    Height = 154
    ApplicationButton.Visible = False
    BarManager = BarManager
    Style = rs2016
    ColorSchemeAccent = rcsaBlue
    ColorSchemeName = 'TheBezier'
    PopupMenuItems = []
    QuickAccessToolbar.Toolbar = BarManagerBarQuickAccess
    SupportNonClientDrawing = True
    Contexts = <>
    TabAreaSearchToolbar.Visible = False
    TabAreaToolbar.Toolbar = BarManagerBarFeedback
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
        end
        item
          ToolbarName = 'BarManagerBarMark'
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
          ToolbarName = 'BarManagerBarMachineTranslation'
        end
        item
          ToolbarName = 'BarManagerBarStopList'
        end>
      KeyTip = 'T'
      Index = 2
    end
    object RibbonTabTools: TdxRibbonTab
      Caption = 'Tools'
      Groups = <
        item
          ToolbarName = 'BarManagerBarMigrate'
        end
        item
          ToolbarName = 'BarManagerBarExport'
        end
        item
          Caption = 'Settings'
          ToolbarName = 'BarManagerBarSettings'
        end
        item
          ToolbarName = 'BarManagerBarIntegration'
        end>
      Index = 3
    end
  end
  object StatusBar: TdxRibbonStatusBar
    Left = 0
    Top = 630
    Width = 1060
    Height = 23
    Color = clBtnFace
    Images = DataModuleMain.ImageListSmall
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        PanelStyle.AutoHint = True
        Fixed = False
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        PanelStyle.ImageIndex = 53
        Visible = False
        Width = 20
        OnClick = StatusBarPanels1Click
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 20
        OnClick = StatusBarPanels2Click
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 220
      end>
    Ribbon = RibbonMain
    OnHint = StatusBarHint
    ParentFont = True
    OnMouseDown = StatusBarMouseDown
    OnMouseMove = StatusBarMouseMove
  end
  object LayoutControlMain: TdxLayoutControl
    Left = 0
    Top = 154
    Width = 1060
    Height = 476
    Align = alClient
    TabOrder = 2
    AutoSize = True
    LayoutLookAndFeel = DataModuleMain.LayoutSkinLookAndFeelTight
    ShowDesignSelectors = False
    ExplicitTop = 121
    ExplicitHeight = 509
    object TreeListModules: TcxTreeList
      Left = 3
      Top = 3
      Width = 246
      Height = 432
      Bands = <
        item
          FixedKind = tlbfLeft
          Options.Moving = False
          Options.OnlyOwnColumns = True
        end>
      Images = DataModuleMain.ImageListTree
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.CellHints = True
      OptionsBehavior.ImmediateEditor = False
      OptionsBehavior.ExpandOnDblClick = False
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = TreeListColumnModuleName
      OptionsBehavior.RecordScrollMode = rsmByRecord
      OptionsBehavior.ShowHourGlass = False
      OptionsCustomizing.BandCustomizing = False
      OptionsCustomizing.BandMoving = False
      OptionsCustomizing.ColumnFiltering = bTrue
      OptionsCustomizing.ColumnVertSizing = False
      OptionsCustomizing.StackedColumns = False
      OptionsData.AnsiSort = True
      OptionsData.CaseInsensitive = True
      OptionsData.Deleting = False
      OptionsSelection.MultiSelect = True
      OptionsView.CellEndEllipsis = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.DynamicIndent = True
      OptionsView.FixedSeparatorWidth = 1
      OptionsView.GridLineColor = 16050401
      OptionsView.GridLines = tlglHorz
      OptionsView.ShowRoot = False
      OptionsView.TreeLineStyle = tllsNone
      PopupMenu = PopupMenuTree
      ScrollbarAnnotations.CustomAnnotations = <>
      Styles.Inactive = DataModuleMain.StyleSelectedInactive
      Styles.Selection = DataModuleMain.StyleSelected
      Styles.OnGetContentStyle = TreeListModulesStylesGetContentStyle
      Styles.Indicator = DataModuleMain.StyleDefault
      Styles.UseOddEvenStyles = bFalse
      TabOrder = 0
      OnCompare = TreeListModulesCompare
      OnFocusedColumnChanged = TreeListModulesFocusedColumnChanged
      OnFocusedNodeChanged = TreeListModulesFocusedNodeChanged
      OnGetNodeImageIndex = TreeListModulesGetNodeImageIndex
      object TreeListColumnModuleName: TcxTreeListColumn
        BestFitMaxWidth = 200
        Caption.AlignVert = vaTop
        Caption.Text = 'Module'
        Options.Editing = False
        Options.Filtering = False
        Width = 160
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        SortOrder = soAscending
        SortIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object TreeListColumnModuleStatus: TcxTreeListColumn
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.ImmediatePost = True
        Properties.ImmediateUpdateText = True
        Properties.Items = <
          item
            Description = 'Translate'
            ImageIndex = 0
            Value = 0
          end
          item
            Description = 'Hold'
            ImageIndex = 5
            Value = 1
          end
          item
            Description = 'Don'#39't translate'
            ImageIndex = 2
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
    object LabelCountTranslated: TcxLabel
      Left = 64
      Top = 438
      Caption = '99.999'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 1
      Transparent = True
      AnchorX = 97
    end
    object LabelCountPending: TcxLabel
      Left = 210
      Top = 438
      Caption = '999.999'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 5
      Transparent = True
      AnchorX = 249
    end
    object LabelCountTranslatedPercent: TcxLabel
      Left = 107
      Top = 438
      Caption = '(100%)'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 3
      Transparent = True
      AnchorX = 143
    end
    object LabelCountModuleTranslated: TcxLabel
      Left = 70
      Top = 457
      Caption = '9.999'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 2
      Transparent = True
      AnchorX = 97
    end
    object LabelCountModuleTranslatedPercent: TcxLabel
      Left = 113
      Top = 456
      Caption = '(25%)'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 4
      Transparent = True
      AnchorX = 143
    end
    object LabelCountModulePending: TcxLabel
      Left = 216
      Top = 457
      Caption = '99.999'
      Style.HotTrack = False
      Style.TransparentBorder = False
      Properties.Alignment.Horz = taRightJustify
      Properties.ShowAccelChar = False
      TabOrder = 6
      Transparent = True
      AnchorX = 249
    end
    object GridItems: TcxGrid
      Left = 259
      Top = 3
      Width = 798
      Height = 348
      TabOrder = 7
      object GridItemsTableView: TcxGridTableView
        PopupMenu = PopupMenuTree
        OnMouseDown = GridItemsTableViewMouseDown
        OnMouseMove = GridItemsTableViewMouseMove
        OnMouseUp = GridItemsTableViewMouseUp
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <
          item
            Alignment = saaClient
            Color = -2134606020
            MinHeight = 4
          end
          item
            Alignment = saaCenter
            Color = -2143501245
          end
          item
            Alignment = saaCenter
            Color = -2134623172
          end
          item
            Color = -2143513404
          end>
        ScrollbarAnnotations.ShowErrors = False
        ScrollbarAnnotations.ShowSearchResults = False
        ScrollbarAnnotations.ShowSelectedRows = False
        OnCanFocusRecord = GridItemsTableViewCanFocusRecord
        OnCellDblClick = GridItemsTableViewCellDblClick
        OnCustomDrawCell = GridItemsTableViewCustomDrawCell
        OnEditing = GridItemsTableViewEditing
        OnFocusedItemChanged = GridItemsTableViewFocusedItemChanged
        OnFocusedRecordChanged = GridItemsTableViewFocusedRecordChanged
        OnPopulateCustomScrollbarAnnotationRowIndexList = GridItemsTableViewPopulateCustomScrollbarAnnotationRowIndexList
        OnInitEdit = GridItemsTableViewInitEdit
        DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnCompare = GridItemsTableViewDataControllerCompare
        DataController.OnRecordChanged = GridItemsTableViewDataControllerRecordChanged
        OptionsBehavior.CellHints = True
        OptionsBehavior.FocusCellOnTab = True
        OptionsBehavior.IncSearch = True
        OptionsBehavior.IncSearchItem = GridItemsTableViewColumnItemName
        OptionsBehavior.FixedGroups = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsBehavior.ImmediateEditor = False
        OptionsBehavior.RecordScrollMode = rsmByPixel
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnHidingOnGrouping = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.ColumnsQuickCustomizationShowCommands = False
        OptionsData.Deleting = False
        OptionsData.Inserting = False
        OptionsSelection.MultiSelect = True
        OptionsView.CellEndEllipsis = True
        OptionsView.NoDataToDisplayInfoText = ' '
        OptionsView.GridLineColor = 16050401
        OptionsView.GridLines = glHorizontal
        OptionsView.GroupByBox = False
        OptionsView.GroupByHeaderLayout = ghlHorizontal
        OptionsView.Indicator = True
        OptionsView.IndicatorWidth = 50
        Styles.Content = DataModuleMain.StyleDefault
        Styles.UseOddEvenStyles = bFalse
        Styles.OnGetContentStyle = GridItemsTableViewStylesGetContentStyle
        Styles.Inactive = DataModuleMain.StyleSelectedInactive
        Styles.Indicator = DataModuleMain.StyleDefault
        Styles.Selection = DataModuleMain.StyleSelected
        OnCustomDrawIndicatorCell = GridItemsTableViewCustomDrawIndicatorCell
        object GridItemsTableViewColumnItemName: TcxGridColumn
          Caption = 'Element'
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          Options.Editing = False
          Options.FilteringAddValueItems = False
          Options.Grouping = False
          VisibleForEditForm = bFalse
          Width = 198
        end
        object GridItemsTableViewColumnType: TcxGridColumn
          Caption = 'Type'
          Visible = False
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          Options.Editing = False
          Options.Focusing = False
          VisibleForEditForm = bFalse
          Width = 100
        end
        object GridItemsTableViewColumnValueName: TcxGridColumn
          Caption = 'Name'
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          Options.Editing = False
          Options.FilteringAddValueItems = False
          SortIndex = 0
          SortOrder = soAscending
          VisibleForEditForm = bFalse
          Width = 125
        end
        object GridItemsTableViewColumnID: TcxGridColumn
          Caption = 'ID'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.ShowAccelChar = False
          Visible = False
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          Options.Editing = False
          Options.Focusing = False
          Options.FilteringAddValueItems = False
          Options.Grouping = False
          VisibleForEditForm = bFalse
          Width = 100
        end
        object GridItemsTableViewColumnStatus: TcxGridColumn
          Caption = 'Status'
          DataBinding.ValueType = 'Integer'
          RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemStatus
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          OnGetFilterValues = GridItemsTableViewColumnStatusStateGetFilterValues
          Options.FilteringAddValueItems = False
          Options.FilteringFilteredItemsList = False
          VisibleForEditForm = bFalse
          Width = 70
        end
        object GridItemsTableViewColumnEffectiveStatus: TcxGridColumn
          Caption = 'Effective status'
          DataBinding.ValueType = 'Integer'
          RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemStatus
          Visible = False
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          OnGetFilterValues = GridItemsTableViewColumnStatusStateGetFilterValues
          Options.Editing = False
          Options.Focusing = False
          Options.FilteringAddValueItems = False
          Options.FilteringFilteredItemsList = False
          VisibleForEditForm = bFalse
          Width = 70
        end
        object GridItemsTableViewColumnState: TcxGridColumn
          Caption = 'State'
          DataBinding.ValueType = 'Integer'
          RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemState
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          OnGetFilterValues = GridItemsTableViewColumnStatusStateGetFilterValues
          Options.FilteringAddValueItems = False
          Options.FilteringFilteredItemsList = False
          VisibleForEditForm = bFalse
          Width = 70
        end
        object GridItemsTableViewColumnSource: TcxGridColumn
          Caption = 'Source text'
          PropertiesClassName = 'TcxMemoProperties'
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          Options.Editing = False
          Options.FilteringAddValueItems = False
          Options.Grouping = False
          Width = 120
        end
        object GridItemsTableViewColumnTarget: TcxGridColumn
          Caption = 'Translation'
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.ButtonGlyph.SourceDPI = 96
          Properties.ButtonGlyph.Data = {
            89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
            610000018149444154785E95923D4B03411086DF5C2E460E430E41B40BB68221
            3F40447F806552041B4BB11003DA58A8AD42D04AB051080876829595075A5858
            F851586A224802621203979C97CBBAB364C346EE223EF0B2373737F30EB307C6
            9890C4B66D936B9BABDAFABC65AD8F4B46278F49DB50A03A1D84520CE02ADCB8
            4845CA1B08B9454858380E777C6F8B7F93300C630912750272702A678CDD2150
            CEFB919844D66AE867959C0711A9AC8BEF64AC2BE3A7B4D6A329C7FE9A2C8169
            7148429D3A62C56984BC3A34FB9AF63407C0522730A140C5438D5318E52CA2F5
            4304D16BC01763758693625904B97DC7B2C2D9892F63E46D869E459E4593E0DC
            CB062AFB7CD320B476091235E6796A72C20D6B7E0D763C73D172277641E8CD1B
            1061E70904BDE779725E8324E0477AF19E67FBAEAFF390A0EBAB521E44C035A2
            3BDA4E7B74052AEED8261D0722AFA0C39F732FB670DC9CB2F10BCBF71602A640
            3E9FEF29081D03C8E572F80B0DC1D40A858270A7B3CBEB7F1ACCA7D3E95A2693
            018962BF063F167DE6F72ACA936D0000000049454E44AE426082}
          Properties.ImmediatePost = True
          Properties.IncrementalSearch = False
          Properties.ValidationOptions = [evoShowErrorIcon]
          OnGetCellHint = GridItemsTableViewColumnGetCellHint
          OnValidateDrawValue = GridItemsTableViewColumnTargetValidateDrawValue
          Options.FilteringAddValueItems = False
          Options.Grouping = False
          Width = 120
        end
      end
      object GridItemsLevel: TcxGridLevel
        GridView = GridItemsTableView
      end
    end
    object EditSourceText: TcxRichEdit
      Left = 259
      Top = 386
      TabStop = False
      Properties.PlainText = True
      Properties.ReadOnly = True
      Properties.ScrollBars = ssBoth
      Properties.WordWrap = False
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 8
      Height = 87
      Width = 277
    end
    object EditTargetText: TcxRichEdit
      Left = 552
      Top = 386
      Properties.PlainText = True
      Properties.ReadOnly = True
      Properties.ScrollBars = ssBoth
      Properties.WordWrap = False
      Properties.OnEditValueChanged = EditTargetTextPropertiesEditValueChanged
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 9
      OnEnter = EditTargetTextEnter
      OnExit = EditTargetTextExit
      Height = 87
      Width = 480
    end
    object ButtonTextEditApply: TcxButton
      Left = 1035
      Top = 367
      Width = 22
      Height = 22
      Action = ActionTextEditApply
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 10
    end
    object ButtonTextEditCancel: TcxButton
      Left = 1035
      Top = 392
      Width = 22
      Height = 22
      Action = ActionTextEditCancel
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 11
    end
    object ButtonTextEditPrev: TcxButton
      Left = 1035
      Top = 417
      Width = 22
      Height = 22
      Action = ActionTextEditPrevious
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 12
    end
    object ButtonTextEditNext: TcxButton
      Left = 1035
      Top = 442
      Width = 22
      Height = 22
      Action = ActionTextEditNext
      PaintStyle = bpsGlyph
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.AllowAllUp = True
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 13
    end
    object LayoutControlMainGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      UseIndent = False
      Index = -1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = LayoutGroupStatsTranslated
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 'Translated:'
      Control = LabelCountTranslated
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 33
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = LayoutGroupStatsPending
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 'Pending:'
      Control = LabelCountPending
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 39
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = LayoutGroupStatsPercent
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Visible = False
      Control = LabelCountTranslatedPercent
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 36
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutGroupStatsPercent: TdxLayoutGroup
      Parent = LayoutGroupStatus
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 2
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = LayoutGroupStatsTranslated
      AlignHorz = ahClient
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 'Module:'
      Control = LabelCountModuleTranslated
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 27
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = LayoutGroupStatsPercent
      AlignHorz = ahClient
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Visible = False
      Control = LabelCountModuleTranslatedPercent
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 30
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = LayoutGroupStatsPending
      AlignHorz = ahClient
      CaptionOptions.ShowAccelChar = False
      CaptionOptions.Text = 'Pending:'
      Control = LabelCountModulePending
      ControlOptions.AlignHorz = ahRight
      ControlOptions.OriginalHeight = 15
      ControlOptions.OriginalWidth = 33
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object LayoutGroupStatsTranslated: TdxLayoutGroup
      Parent = LayoutGroupStatus
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 0
    end
    object LayoutGroupStatsPending: TdxLayoutGroup
      Parent = LayoutGroupStatus
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = 4
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = LayoutGroupStatus
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      Index = 3
    end
    object dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem
      Parent = LayoutGroupStatus
      SizeOptions.Height = 10
      SizeOptions.Width = 4
      Index = 1
    end
    object LayoutGroupStatus: TdxLayoutGroup
      Parent = LayoutGroupModules
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 3
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object LayoutItemModules: TdxLayoutItem
      Parent = LayoutGroupModules
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = TreeListModules
      ControlOptions.OriginalHeight = 440
      ControlOptions.OriginalWidth = 240
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutGroupModules: TdxLayoutGroup
      Parent = LayoutControlMainGroup_Root
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = 0
    end
    object LayoutItemMain: TdxLayoutItem
      Parent = LayoutGroupMain
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = GridItems
      ControlOptions.OriginalHeight = 387
      ControlOptions.OriginalWidth = 714
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutSplitterItemModules: TdxLayoutSplitterItem
      Parent = LayoutControlMainGroup_Root
      AlignHorz = ahLeft
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      AllowCloseOnClick = True
      Index = 1
    end
    object LayoutGroupEditors: TdxLayoutGroup
      Parent = LayoutGroupMain
      AlignVert = avBottom
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 2
    end
    object LayoutGroupMain: TdxLayoutGroup
      Parent = LayoutControlMainGroup_Root
      AlignHorz = ahClient
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 2
      ShowBorder = False
      Index = 2
    end
    object LayoutSplitterItemMainEditors: TdxLayoutSplitterItem
      Parent = LayoutGroupMain
      AlignVert = avBottom
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      AllowCloseOnClick = True
      Index = 1
    end
    object LayoutItemEditorSource: TdxLayoutItem
      Parent = LayoutGroupEditors
      AlignVert = avClient
      CaptionOptions.Text = 'Lorem ipsum'
      CaptionOptions.Layout = clTop
      Control = EditSourceText
      ControlOptions.OriginalHeight = 87
      ControlOptions.OriginalWidth = 277
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object LayoutItemEditorTarget: TdxLayoutItem
      Parent = LayoutGroupEditors
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Lorem ipsum'
      CaptionOptions.Layout = clTop
      Control = EditTargetText
      ControlOptions.OriginalHeight = 87
      ControlOptions.OriginalWidth = 405
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object LayoutSplitterItemEditors: TdxLayoutSplitterItem
      Parent = LayoutGroupEditors
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      Index = 1
    end
    object LayoutGroupEditorButtons: TdxLayoutGroup
      Parent = LayoutGroupEditors
      CaptionOptions.Text = 'Hidden Group'
      CaptionOptions.Visible = False
      Hidden = True
      ItemIndex = 3
      ShowBorder = False
      Index = 3
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = LayoutGroupEditorButtons
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ButtonTextEditApply
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = LayoutGroupEditorButtons
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ButtonTextEditCancel
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = LayoutGroupEditorButtons
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ButtonTextEditPrev
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = LayoutGroupEditorButtons
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ButtonTextEditNext
      ControlOptions.OriginalHeight = 22
      ControlOptions.OriginalWidth = 22
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = DataModuleMain.ImageListSmall
    ImageOptions.LargeImages = DataModuleMain.ImageListLarge
    ImageOptions.UseLargeImagesForLargeIcons = True
    ImageOptions.UseLeftBottomPixelAsTransparent = False
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    Style = bmsUseLookAndFeel
    UseSystemFont = True
    Left = 428
    Top = 16
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
          ItemName = 'BarButtonOpenProject'
        end
        item
          BeginGroup = True
          ViewLevels = [ivlLargeControlOnly, ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
          Visible = True
          ItemName = 'BarButtonNewProject'
        end
        item
          Visible = True
          ItemName = 'BarButtonSaveProject'
        end
        item
          Visible = True
          ItemName = 'BarButtonSaveProjectAs'
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
      DockedLeft = 168
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonUpdateProject'
        end
        item
          Visible = True
          ItemName = 'BarButtonBuildProject'
        end
        item
          ViewLevels = [ivlLargeControlOnly, ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
          Visible = True
          ItemName = 'BarButtonPurge'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'ButtonProjectLocateSource'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarMigrate: TdxBar
      Caption = 'Migration'
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton21'
        end
        item
          Visible = True
          ItemName = 'dxBarButton22'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end>
      OneOnRow = False
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
      DockedLeft = 390
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
      DockedLeft = 179
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonStatusTranslate'
        end
        item
          Visible = True
          ItemName = 'BarButtonStatusDontTranslate'
        end
        item
          Visible = True
          ItemName = 'BarButtonStatusHold'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagetBarTranslationState: TdxBar
      Caption = 'State'
      CaptionButtons = <>
      DockedLeft = 294
      DockedTop = 0
      FloatLeft = 818
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonStatePropose'
        end
        item
          Visible = True
          ItemName = 'BarButtonStateAccept'
        end
        item
          Visible = True
          ItemName = 'BarButtonStateReject'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarProofing: TdxBar
      Caption = 'Validation'
      CaptionButtons = <
        item
          Hint = 'Settings'
          OnClick = BarManagerBarProofingCaptionButtons0Click
        end>
      DockedLeft = 242
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
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton26'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
          ViewLevels = [ivlLargeControlOnly, ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
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
      DockedLeft = 66
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
          ItemName = 'dxBarButton25'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'BarButtonGotoNext'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarMachineTranslation: TdxBar
      Caption = 'Machine Translation'
      CaptionButtons = <>
      DockedLeft = 434
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonAutoTranslate'
        end
        item
          Visible = True
          ItemName = 'BarButtonTM'
        end
        item
          Visible = True
          ItemName = 'BarButtonTMAdd'
        end
        item
          Visible = True
          ItemName = 'BarButtonTMLookup'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'ButtonTranslationMemoryUpdate'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarExport: TdxBar
      Caption = 'Export'
      CaptionButtons = <>
      DockedLeft = 319
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarButton20'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarMark: TdxBar
      Caption = 'Mark'
      CaptionButtons = <>
      DockedLeft = 529
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ButtonItemBookmark'
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
    object BarManagerBarQuickAccess: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Quick Access'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      Hidden = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ButtonSettings'
        end
        item
          Visible = True
          ItemName = 'dxBarButton35'
        end>
      OneOnRow = True
      Row = 0
      ShowMark = False
      SizeGrip = False
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarFeedback: TdxBar
      Caption = 'Feedback'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarEditItemSearch'
        end
        item
          Visible = True
          ItemName = 'BarButtonFeedback'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarStopList: TdxBar
      Caption = 'Stop List'
      CaptionButtons = <>
      DockedLeft = 754
      DockedTop = 0
      FloatLeft = 998
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonStopList'
        end
        item
          ViewLevels = [ivlLargeControlOnly, ivlSmallIconWithText, ivlSmallIcon, ivlControlOnly]
          Visible = True
          ItemName = 'RibbonGalleryItemStopList'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarIntegration: TdxBar
      Caption = 'Integration'
      CaptionButtons = <>
      DockedLeft = 490
      DockedTop = 0
      FloatLeft = 992
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton23'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBarSettings: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedLeft = 425
      DockedTop = 0
      FloatLeft = 1088
      FloatTop = 2
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'ButtonSettings'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarButtonOpenProject: TdxBarLargeButton
      Action = ActionProjectOpen
      Category = 0
      ButtonStyle = bsDropDown
      DropDownMenu = PopupMenuRecentFiles
    end
    object BarButtonNewProject: TdxBarLargeButton
      Action = ActionProjectNew
      Category = 0
    end
    object BarButtonSaveProject: TdxBarButton
      Action = ActionProjectSave
      Category = 0
      LargeImageIndex = 2
    end
    object BarButtonUpdateProject: TdxBarLargeButton
      Action = ActionProjectUpdate
      Category = 0
    end
    object BarButtonBuildProject: TdxBarLargeButton
      Action = ActionBuild
      Category = 0
      ButtonStyle = bsDropDown
      DropDownMenu = PopupMenuBuild
    end
    object dxBarButton2: TdxBarButton
      Action = ActionImportXLIFF
      Category = 0
    end
    object BarEditItemSourceLanguage: TcxBarEditItem
      Align = iaRight
      Caption = '&Source:'
      Category = 0
      Hint = 'Source language'
      Visible = ivAlways
      Width = 120
      PropertiesClassName = 'TcxExtLookupComboBoxProperties'
      Properties.OnEditValueChanged = BarEditItemSourceLanguagePropertiesEditValueChanged
      RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemLanguage
    end
    object BarEditItemTargetLanguage: TcxBarEditItem
      Align = iaRight
      Caption = 'T&arget:'
      Category = 0
      Hint = 'Target language'
      Visible = ivAlways
      OnEnter = BarEditItemTargetLanguageEnter
      OnExit = BarEditItemTargetLanguageExit
      Width = 120
      PropertiesClassName = 'TcxExtLookupComboBoxProperties'
      Properties.OnEditValueChanged = BarEditItemTargetLanguagePropertiesEditValueChanged
      Properties.OnInitPopup = BarEditItemTargetLanguagePropertiesInitPopup
      RepositoryItem = DataModuleMain.EditRepositoryComboBoxItemFilteredTargetLanguage
    end
    object BarButtonPurgeProject: TdxBarButton
      Action = ActionProjectPurge
      Category = 0
    end
    object BarButtonStatusTranslate: TdxBarButton
      Action = ActionStatusTranslate
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object BarButtonStatusDontTranslate: TdxBarButton
      Action = ActionStatusDontTranslate
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object BarButtonStatusHold: TdxBarButton
      Action = ActionStatusHold
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
    object BarButtonStatePropose: TdxBarButton
      Action = ActionTranslationStatePropose
      Category = 0
    end
    object BarButtonStateAccept: TdxBarButton
      Action = ActionTranslationStateAccept
      Category = 0
    end
    object BarButtonStateReject: TdxBarButton
      Action = ActionTranslationStateReject
      Category = 0
    end
    object BarButtonSpellCheck: TdxBarLargeButton
      Action = ActionProofingCheck
      Category = 0
      LargeImageIndex = 6
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
      LargeImageIndex = 7
      SyncImageIndex = False
      ImageIndex = 15
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
    object BarButtonAutoTranslate: TdxBarLargeButton
      Action = ActionAutomationTranslate
      Category = 0
      ButtonStyle = bsDropDown
      DropDownMenu = PopupMenuTranslateProviders
      LargeImageIndex = 11
    end
    object BarButtonTM: TdxBarButton
      Action = ActionTranslationMemory
      Category = 0
    end
    object BarButtonGotoNext: TdxBarSubItem
      Action = ActionGotoNext
      Category = 0
      LargeImageIndex = 9
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton27'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem3'
        end
        item
          Visible = True
          ItemName = 'ButtonGotoBookmark'
        end>
    end
    object dxBarSubItem1: TdxBarSubItem
      Action = ActionImportFile
      Category = 0
      LargeImageIndex = 10
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end>
    end
    object dxBarButton18: TdxBarButton
      Action = ActionImportFileSource
      Category = 0
    end
    object dxBarButton19: TdxBarButton
      Action = ActionImportFileTarget
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = ActionExportCSV
      Category = 0
    end
    object dxBarButton20: TdxBarButton
      Action = ActionExportExcel
      Category = 0
    end
    object dxBarButton21: TdxBarButton
      Action = ActionImportCSV
      Category = 0
    end
    object dxBarButton22: TdxBarButton
      Caption = 'Import from Excel'
      Category = 0
      Enabled = False
      Hint = 'Import from Excel'
      Visible = ivAlways
      ImageIndex = 60
    end
    object BarButtonTMAdd: TdxBarButton
      Action = ActionTranslationMemoryAdd
      Category = 0
    end
    object BarButtonTMLookup: TdxBarButton
      Action = ActionTranslationMemoryTranslate
      Category = 0
    end
    object dxBarButton25: TdxBarButton
      Action = ActionFindNext
      Category = 0
      ShortCut = 16460
    end
    object dxBarButton26: TdxBarButton
      Action = ActionValidate
      Category = 0
      LargeImageIndex = 13
    end
    object dxBarButton16: TdxBarButton
      Action = ActionGotoNextUntranslated
      Category = 0
    end
    object dxBarButton27: TdxBarButton
      Action = ActionGotoNextWarning
      Category = 0
    end
    object ButtonGotoBookmark: TdxBarButton
      Action = ActionGotoNextBookmark
      Category = 0
      Hint = 'Find bookmarked item'
      ButtonStyle = bsDropDown
      DropDownMenu = PopupMenuBookmark
    end
    object ButtonItemBookmarkAny: TdxBarButton
      Action = ActionGotoBookmarkAny
      Category = 0
    end
    object ButtonItemBookmark: TdxBarButton
      Action = ActionEditMark
      Category = 0
      ButtonStyle = bsCheckedDropDown
      DropDownMenu = PopupMenuBookmark
    end
    object dxBarSubItem2: TdxBarSubItem
      Action = ActionGotoNextStatus
      Category = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton28'
        end
        item
          Visible = True
          ItemName = 'dxBarButton29'
        end
        item
          Visible = True
          ItemName = 'dxBarButton30'
        end>
    end
    object dxBarSubItem3: TdxBarSubItem
      Action = ActionGotoNextState
      Category = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton31'
        end
        item
          Visible = True
          ItemName = 'dxBarButton33'
        end
        item
          Visible = True
          ItemName = 'dxBarButton32'
        end
        item
          Visible = True
          ItemName = 'dxBarButton24'
        end>
    end
    object dxBarButton28: TdxBarButton
      Action = ActionGotoNextStatusTranslate
      Category = 0
      Visible = ivNotInCustomizing
    end
    object dxBarButton29: TdxBarButton
      Action = ActionGotoNextStatusHold
      Category = 0
      Visible = ivNotInCustomizing
    end
    object dxBarButton30: TdxBarButton
      Action = ActionGotoNextStatusDontTranslate
      Category = 0
      Visible = ivNotInCustomizing
    end
    object dxBarButton31: TdxBarButton
      Action = ActionGotoNextStateNew
      Category = 0
      Visible = ivNotInCustomizing
    end
    object dxBarButton32: TdxBarButton
      Action = ActionGotoNextStateUnused
      Category = 0
      Visible = ivNotInCustomizing
    end
    object dxBarButton33: TdxBarButton
      Action = ActionGotoNextStateExisting
      Category = 0
      Visible = ivNotInCustomizing
    end
    object BarButtonFeedbackPositive: TdxBarButton
      Action = ActionFeedbackPositive
      Category = 0
    end
    object BarButtonFeedbackNegative: TdxBarButton
      Action = ActionFeedbackNegative
      Category = 0
    end
    object BarButtonFeedbackHide: TdxBarButton
      Action = ActionFeedbackHide
      Category = 0
      Visible = ivNotInCustomizing
    end
    object BarButtonFeedback: TdxBarSubItem
      Action = ActionFeedback
      Category = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonFeedbackPositive'
        end
        item
          Visible = True
          ItemName = 'BarButtonFeedbackNegative'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BarButtonFeedbackHide'
        end>
    end
    object BarEditItemSearch: TcxBarEditItem
      Caption = 'Search'
      Category = 0
      Hint = 'Search'
      Visible = ivAlways
      PropertiesClassName = 'TdxOfficeSearchBoxProperties'
      Properties.BarManager = BarManager
      Properties.Nullstring = '(search)'
      Properties.Ribbon = RibbonMain
      Properties.SearchSource = RibbonMain
      Properties.ShowResultPaths = True
      Properties.UseNullString = True
    end
    object dxBarButton35: TdxBarButton
      Action = ActionAbout
      Category = 0
      LargeImageIndex = 14
    end
    object BarButtonStopList: TdxBarButton
      Action = ActionStopList
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = ActionStopListApply
      Category = 0
    end
    object RibbonGalleryItemStopList: TdxRibbonGalleryItem
      Action = ActionStopListAdd
      Category = 0
      GalleryOptions.ColumnCount = 1
      GalleryFilter.Categories = <>
      GalleryInRibbonOptions.Collapsed = True
      GalleryInRibbonOptions.MinColumnCount = 1
      GalleryInMenuOptions.DropDownGalleryResizing = gsrNone
      GalleryInMenuOptions.ItemTextKind = itkCaptionAndDescription
      ItemLinks = <>
      ItemOptions.ShowDescriptions = True
      ItemOptions.ShowShortCuts = True
      OnPopup = RibbonGalleryItemStopListPopup
      object RibbonGalleryItemGroup: TdxRibbonGalleryGroup
        Options.AssignedValues = [avItemTextKind]
        Options.ItemTextKind = itkCaptionAndDescription
        object dxRibbonGalleryItem1Group1Item1: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddModule
          ActionIndex = nil
        end
        object dxRibbonGalleryItem1Group1Item2: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddElement
          ActionIndex = nil
        end
        object dxRibbonGalleryItem1Group1Item3: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddType
          ActionIndex = nil
        end
        object dxRibbonGalleryItem1Group1Item4: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddName
          ActionIndex = nil
        end
        object dxRibbonGalleryItem1Group1Item5: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddTypeAndName
          ActionIndex = nil
        end
        object dxRibbonGalleryItem1Group1Item6: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddValue
          ActionIndex = nil
        end
        object RibbonGalleryItemGroupItem7: TdxRibbonGalleryGroupItem
          Action = ActionStopListAddTypeNameValue
          ActionIndex = nil
        end
      end
    end
    object ButtonBuildAll: TdxBarButton
      Caption = 'All languages'
      Category = 0
      Hint = 'All languages'
      Visible = ivAlways
      OnClick = ButtonBuildAllClick
    end
    object ButtonSeparatorBuild: TdxBarSeparator
      Category = 0
      Visible = ivNotInCustomizing
      ShowCaption = False
    end
    object dxBarButton1: TdxBarButton
      Action = ActionProjectRecover
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = ActionClearBookmarks
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = ActionTranslationMemoryLocate
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = ActionImportPO
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = ActionValidationWarningDismiss
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = ActionValidationWarningResolve
      Category = 0
    end
    object BarSeparatorValidationWarningHeader: TdxBarSeparator
      Caption = 'Warnings:'
      Category = 0
      Hint = 'Warnings:'
      Visible = ivAlways
    end
    object dxBarSeparator2: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object dxBarButton15: TdxBarButton
      Action = ActionGotoAgain
      Category = 0
      ShortCut = 114
    end
    object ButtonTranslationMemoryUpdate: TdxBarButton
      Action = ActionTranslationMemoryUpdate
      Category = 0
    end
    object ButtonProjectLocateSource: TdxBarButton
      Action = ActionProjectLocateSource
      Category = 0
    end
    object dxBarButton23: TdxBarButton
      Action = ActionIntegrationTracking
      Category = 0
      ButtonStyle = bsChecked
    end
    object BarButtonSaveProjectAs: TdxBarButton
      Action = ActionProjectSaveAs
      Category = 0
    end
    object ButtonSettings: TdxBarLargeButton
      Action = ActionSettings
      Category = 0
      LargeImageIndex = 12
      SyncImageIndex = False
      ImageIndex = 52
    end
    object BarButtonPurgeSelected: TdxBarButton
      Action = ActionPurgeSelected
      Category = 0
    end
    object BarButtonPurge: TdxBarSubItem
      Action = ActionPurge
      Category = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BarButtonPurgeProject'
        end
        item
          Visible = True
          ItemName = 'BarButtonPurgeSelected'
        end>
    end
    object dxBarButton24: TdxBarButton
      Action = ActionGotoNextStateObsolete
      Category = 0
    end
  end
  object OpenDialogXLIFF: TOpenDialog
    Filter = 
      'XLIFF files (*.xlf;*.xliff)|*.xlf;*.xliff|Delphi form translatio' +
      'ns (*.dfn)|*.dfn|Delphi resourcestring translations (*.rcn)|*.rc' +
      'n|All supported files (*.xlf;*.xliff;*.dfn;*.rcn)|*.xlf;*.xliff;' +
      '*.dfn;*.rcn|All files (*.*)|*.*'
    FilterIndex = 4
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 512
  end
  object ActionList: TActionList
    Images = DataModuleMain.ImageListSmall
    Left = 356
    Top = 16
    object ActionProofingCheck: TAction
      Category = 'Validation'
      Caption = 'Spell check'
      Hint = 'Perform spell check on the whole project'
      ImageIndex = 13
      ShortCut = 118
      OnExecute = ActionProofingCheckExecute
      OnUpdate = ActionProofingCheckUpdate
    end
    object ActionProjectOpen: TAction
      Category = 'File'
      Caption = 'Open project'
      Hint = 'Open an existing translation project'
      ImageIndex = 0
      ShortCut = 16463
      OnExecute = ActionProjectOpenExecute
    end
    object ActionProjectSave: TAction
      Category = 'File'
      Caption = 'Save'
      Hint = 'Save the current translation project'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = ActionProjectSaveExecute
      OnUpdate = ActionProjectSaveUpdate
    end
    object ActionProjectSaveAs: TAction
      Category = 'File'
      Caption = 'Save as...'
      Hint = 'Save the current translation project to a new file'
      ImageIndex = 2
      ShortCut = 24659
      OnExecute = ActionProjectSaveAsExecute
      OnUpdate = ActionProjectSaveAsUpdate
    end
    object ActionProofingCheckSelected: TAction
      Category = 'Validation'
      Caption = 'Check selected'
      Hint = 'Perform spell check on the selected items'
      ImageIndex = 13
      ShortCut = 8310
      OnExecute = ActionProofingCheckSelectedExecute
      OnUpdate = ActionProofingCheckSelectedUpdate
    end
    object ActionProjectNew: TAction
      Category = 'File'
      Caption = 'New project'
      Hint = 'Create a new translation project'
      ImageIndex = 1
      ShortCut = 24654
      OnExecute = ActionProjectNewExecute
    end
    object ActionProjectUpdate: TAction
      Category = 'Project'
      Caption = 'Update'
      Hint = 'Update project from source'
      ImageIndex = 3
      ShortCut = 116
      OnExecute = ActionProjectUpdateExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionBuild: TAction
      Category = 'Project'
      Caption = 'Build...'
      Hint = 'Build translated resource module'
      ImageIndex = 4
      ShortCut = 120
      OnExecute = ActionBuildExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionImportXLIFF: TAction
      Category = 'Import'
      Caption = 'Import XLIFF...'
      Hint = 
        'Import translations from XLIFF file (used by Delphi amongst othe' +
        'rs)'
      ImageIndex = 77
      OnExecute = ActionImportXLIFFExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionProjectPurge: TAction
      Category = 'Project'
      Caption = 'Purge all unused...'
      Hint = 'Remove all unused items'
      ImageIndex = 6
      ShortCut = 24622
      OnExecute = ActionProjectPurgeExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionTranslationStatePropose: TAction
      Category = 'Translation'
      Caption = '&Propose translation'
      ImageIndex = 7
      ShortCut = 32848
      OnExecute = ActionTranslationStateProposeExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionTranslationStateAccept: TAction
      Category = 'Translation'
      Caption = 'Accept &translation'
      ImageIndex = 8
      ShortCut = 32852
      OnExecute = ActionTranslationStateAcceptExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionTranslationStateReject: TAction
      Category = 'Translation'
      Caption = '&Reject translation'
      ImageIndex = 9
      ShortCut = 32850
      OnExecute = ActionTranslationStateRejectExecute
      OnUpdate = ActionTranslationStateUpdate
    end
    object ActionStatusTranslate: TAction
      Category = 'Translation'
      AutoCheck = True
      Caption = 'Translate'
      ImageIndex = 10
      OnExecute = ActionStatusTranslateExecute
      OnUpdate = ActionStatusTranslateUpdate
    end
    object ActionStatusDontTranslate: TAction
      Category = 'Translation'
      AutoCheck = True
      Caption = '&Don'#39't translate'
      ImageIndex = 12
      ShortCut = 32836
      OnExecute = ActionStatusDontTranslateExecute
      OnUpdate = ActionStatusDontTranslateUpdate
    end
    object ActionStatusHold: TAction
      Category = 'Translation'
      AutoCheck = True
      Caption = '&Hold'
      ImageIndex = 11
      ShortCut = 32840
      OnExecute = ActionStatusHoldExecute
      OnUpdate = ActionStatusHoldUpdate
    end
    object ActionProofingLiveCheck: TAction
      Category = 'Validation'
      AutoCheck = True
      Caption = 'Live check'
      Hint = 'Enable or disable check-as-you-type spell check'
      ImageIndex = 14
      OnExecute = ActionProofingLiveCheckExecute
      OnUpdate = ActionProofingLiveCheckUpdate
    end
    object ActionEditPaste: TAction
      Category = 'Edit'
      Caption = 'Paste'
      Enabled = False
      Hint = 'Paste from clipboard'
      ImageIndex = 15
      OnExecute = ActionEditPasteExecute
    end
    object ActionEditCopy: TAction
      Category = 'Edit'
      Caption = 'Copy'
      Hint = 'Copy to clipboard'
      ImageIndex = 17
      OnExecute = ActionEditCopyExecute
      OnUpdate = ActionEditCopyUpdate
    end
    object ActionEditCut: TAction
      Category = 'Edit'
      Caption = 'Cut'
      Hint = 'Cut to clipboard'
      ImageIndex = 16
      Visible = False
    end
    object ActionFindSearch: TAction
      Category = 'Find'
      Caption = 'Find'
      Hint = 'Search for text'
      ImageIndex = 18
      ShortCut = 16454
      OnExecute = ActionFindSearchExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionFindReplace: TAction
      Category = 'Find'
      Caption = 'Find and replace'
      Hint = 'Find and replace text'
      ImageIndex = 19
      ShortCut = 24646
      Visible = False
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionMain: TAction
      Caption = 'Better Translation Manager'
      OnExecute = ActionMainExecute
      OnUpdate = ActionMainUpdate
    end
    object ActionImportFile: TAction
      Category = 'Import'
      Caption = 'Import application'
      Hint = 
        'Update source or target values from arbitrary application or lib' +
        'rary file'
      ImageIndex = 21
      OnExecute = ActionImportFileExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionImportFileSource: TAction
      Category = 'Import'
      Caption = 'Import source language'
      Hint = 'Import values in the source language from an external file'
      OnExecute = ActionImportFileSourceExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionImportFileTarget: TAction
      Category = 'Import'
      Caption = 'Import target language'
      Hint = 'Import translated values from an external file'
      OnExecute = ActionImportFileTargetExecute
      OnUpdate = ActionImportFileTargetUpdate
    end
    object ActionAutomationTranslate: TAction
      Category = 'Automation'
      Caption = 'Auto translate...'
      Hint = 'Perform machine translation on the selected items'
      ImageIndex = 22
      OnExecute = ActionAutomationTranslateExecute
      OnUpdate = ActionAutomationTranslateUpdate
    end
    object ActionTranslationMemory: TAction
      Category = 'Automation'
      Caption = 'Translation Memory'
      Hint = 'Open Translation Memory'
      ImageIndex = 23
      OnExecute = ActionTranslationMemoryExecute
      OnUpdate = ActionTranslationMemoryIsEnabled
    end
    object ActionTranslationMemoryAdd: TAction
      Category = 'Automation'
      Caption = 'Add to TM'
      Hint = 'Add the selected translations to the Translation Memory'
      ImageIndex = 24
      ShortCut = 24641
      OnExecute = ActionTranslationMemoryAddExecute
      OnUpdate = ActionTranslationMemoryAddUpdate
    end
    object ActionTranslationMemoryTranslate: TAction
      Category = 'Automation'
      Caption = 'Translate from TM'
      Hint = 'Translate the selected items from Translation Memory'
      ImageIndex = 25
      ShortCut = 24660
      OnExecute = ActionTranslationMemoryTranslateExecute
      OnUpdate = ActionTranslationMemoryTranslateUpdate
    end
    object ActionFindNext: TAction
      Category = 'Find'
      Caption = 'Find next'
      Hint = 'Go to next search match'
      ImageIndex = 26
      ShortCut = 114
      OnExecute = ActionFindNextExecute
      OnUpdate = ActionFindNextUpdate
    end
    object ActionGotoNext: TAction
      Category = 'Find'
      Caption = 'Goto...'
      ImageIndex = 20
      ShortCut = 16455
      OnExecute = ActionDummyExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoAgain: TAction
      Category = 'Find'
      Caption = 'Same again'
      ShortCut = 16460
      OnExecute = ActionGotoAgainExecute
      OnUpdate = ActionGotoAgainUpdate
    end
    object ActionGotoNextUntranslated: TAction
      Category = 'Find'
      Caption = 'Next untranslated'
      Hint = 'Find the next untranslated item'
      ImageIndex = 10
      ShortCut = 16462
      OnExecute = ActionGotoNextUntranslatedExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextWarning: TAction
      Category = 'Find'
      Caption = 'Next warning'
      Hint = 'Find next item that has validation warnings'
      ImageIndex = 53
      ShortCut = 16471
      OnExecute = ActionGotoNextWarningExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextBookmark: TAction
      Category = 'Find'
      Caption = 'Bookmark...'
      Hint = 'Find next bookmarked item'
      ImageIndex = 43
      SecondaryShortCuts.Strings = (
        'Shift+F4')
      ShortCut = 115
      OnExecute = ActionGotoNextBookmarkExecute
    end
    object ActionGotoBookmarkAny: TAction
      Tag = -1
      Category = 'Bookmark'
      Caption = 'A&ny bookmark'
      ImageIndex = 49
      OnExecute = ActionGotoBookmarkAnyExecute
    end
    object ActionEditMark: TAction
      Tag = -1
      Category = 'Bookmark'
      Caption = 'Set bookmark'
      ImageIndex = 49
      SecondaryShortCuts.Strings = (
        'Shift+Ctrl+B')
      ShortCut = 16450
      OnExecute = ActionEditMarkExecute
      OnUpdate = ActionEditMarkUpdate
    end
    object ActionValidate: TAction
      Category = 'Validation'
      Caption = '&Validate project'
      ImageIndex = 48
      OnExecute = ActionValidateExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextStatus: TAction
      Category = 'Find'
      Caption = 'Next with Status...'
      OnExecute = ActionDummyExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextStatusTranslate: TAction
      Category = 'Find'
      Caption = 'Translate'
      ImageIndex = 8
      OnExecute = ActionGotoNextStatusExecute
    end
    object ActionGotoNextStatusHold: TAction
      Tag = 1
      Category = 'Find'
      Caption = 'Hold'
      ImageIndex = 11
      OnExecute = ActionGotoNextStatusExecute
    end
    object ActionGotoNextStatusDontTranslate: TAction
      Tag = 2
      Category = 'Find'
      Caption = 'Don'#39't translate'
      ImageIndex = 12
      OnExecute = ActionGotoNextStatusExecute
    end
    object ActionGotoNextState: TAction
      Category = 'Find'
      Caption = 'Next with State...'
      OnExecute = ActionDummyExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextStateNew: TAction
      Category = 'Find'
      Caption = 'New'
      ImageIndex = 50
      OnExecute = ActionGotoNextStateNewExecute
    end
    object ActionGotoNextStateExisting: TAction
      Tag = 1
      Category = 'Find'
      Caption = 'Existing'
      ImageIndex = 10
      OnExecute = ActionGotoNextStateExistingExecute
    end
    object ActionGotoNextStateUnused: TAction
      Tag = 2
      Category = 'Find'
      Caption = 'Unused'
      ImageIndex = 51
      OnExecute = ActionGotoNextStateUnusedExecute
    end
    object ActionSettings: TAction
      Category = 'File'
      Caption = 'Settings'
      Hint = 'Settings'
      ImageIndex = 52
      OnExecute = ActionSettingsExecute
    end
    object ActionFeedback: TAction
      Category = 'Feedback'
      Caption = 'Feedback...'
      Hint = 'Let us know how we'#39're doing'
      ImageIndex = 56
      OnExecute = ActionDummyExecute
    end
    object ActionFeedbackPositive: TAction
      Category = 'Feedback'
      Caption = 'BTM made me happy because...'
      Hint = 'Provide positive feedback'
      ImageIndex = 54
      OnExecute = ActionFeedbackPositiveExecute
    end
    object ActionFeedbackNegative: TAction
      Category = 'Feedback'
      Caption = 'BTM made me sad because...'
      Hint = 'Provide negative feedback'
      ImageIndex = 55
      OnExecute = ActionFeedbackNegativeExecute
    end
    object ActionFeedbackHide: TAction
      Category = 'Feedback'
      Caption = 'Hide feedback button'
      OnExecute = ActionFeedbackHideExecute
    end
    object ActionAbout: TAction
      Category = 'File'
      Caption = 'About...'
      Hint = 'About...'
      ImageIndex = 57
      OnExecute = ActionAboutExecute
    end
    object ActionImportCSV: TAction
      Category = 'Import'
      Caption = 'Import CSV...'
      Hint = 'Import translations from a delimited text file'
      ImageIndex = 61
      OnExecute = ActionImportCSVExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionStopList: TAction
      Category = 'StopList'
      Caption = 'Stop List...'
      Hint = 'List of items that should never be translated'
      ImageIndex = 70
      OnExecute = ActionStopListExecute
    end
    object ActionStopListApply: TAction
      Category = 'StopList'
      Caption = 'Apply stop list...'
      Hint = 'Apply stop list to the project'
      ImageIndex = 71
      OnExecute = ActionStopListApplyExecute
      OnUpdate = ActionStopListApplyUpdate
    end
    object ActionStopListAdd: TAction
      Category = 'StopList'
      Caption = 'Add to stop list...'
      ImageIndex = 69
      ShortCut = 24624
      OnExecute = ActionDummyExecute
      OnUpdate = ActionHasItemFocusedUpdate
    end
    object ActionStopListAddModule: TAction
      Category = 'StopList'
      Caption = 'Module:'
      ShortCut = 24625
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasItemFocusedUpdate
    end
    object ActionStopListAddElement: TAction
      Tag = 1
      Category = 'StopList'
      Caption = 'Element:'
      ShortCut = 24626
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionStopListAddType: TAction
      Tag = 2
      Category = 'StopList'
      Caption = 'Type:'
      ShortCut = 24627
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionStopListAddName: TAction
      Tag = 3
      Category = 'StopList'
      Caption = 'Name:'
      ShortCut = 24628
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionStopListAddTypeAndName: TAction
      Tag = 4
      Category = 'StopList'
      Caption = 'Type and Name:'
      ShortCut = 24629
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionStopListAddValue: TAction
      Tag = 5
      Category = 'StopList'
      Caption = 'Value:'
      ShortCut = 24630
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionEditTranslationText: TAction
      Category = 'Edit'
      Hint = 'Open text editor'
      ShortCut = 16397
      OnExecute = ActionEditTranslationTextExecute
      OnUpdate = ActionEditTranslationTextUpdate
    end
    object ActionTranslationSuggestionList: TAction
      Category = 'Edit'
      Hint = 'Translation suggestions'
      ImageIndex = 72
      ShortCut = 32808
      OnExecute = ActionTranslationSuggestionListExecute
      OnUpdate = ActionTranslationSuggestionListUpdate
    end
    object ActionProjectRecover: TAction
      Category = 'Project'
      Caption = 'Recover...'
      Hint = 'Recover translations from renamed or moved items'
      ImageIndex = 74
      OnExecute = ActionProjectRecoverExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionClearBookmarks: TAction
      Category = 'Bookmark'
      Caption = 'Clear bookmarks...'
      OnExecute = ActionClearBookmarksExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionTranslationMemoryLocate: TAction
      Category = 'Automation'
      Caption = 'Locate in TM'
      Hint = 'Locate the focused source/target pair in the Translation Memory'
      ImageIndex = 75
      ShortCut = 24652
      OnExecute = ActionTranslationMemoryLocateExecute
      OnUpdate = ActionTranslationMemoryLocateUpdate
    end
    object ActionExportCSV: TAction
      Category = 'Import'
      Caption = 'Save to CSV...'
      Hint = 'Export the entire project to a Comma Separated Values file'
      ImageIndex = 63
      OnExecute = ActionExportCSVExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionExportExcel: TAction
      Category = 'Import'
      Caption = 'Save to Excel...'
      Enabled = False
      ImageIndex = 62
    end
    object ActionImportPO: TAction
      Category = 'Import'
      Caption = 'Import PO...'
      Hint = 'Import translations from GNU gettext (or dxGetText)'
      ImageIndex = 76
      OnExecute = ActionImportPOExecute
      OnUpdate = ActionImportFileTargetUpdate
    end
    object ActionValidationWarningDismiss: TAction
      Category = 'Validation'
      Caption = 'Dismiss warning'
      Hint = 
        'Hide the validation warning until the project is validated again' +
        ' or the value is changed'
      ImageIndex = 78
      OnExecute = ActionValidationWarningDismissExecute
      OnUpdate = ActionValidationWarningDismissUpdate
    end
    object ActionValidationWarningResolve: TAction
      Category = 'Validation'
      Caption = 'Resolve problem'
      Hint = 
        'Attempt to resolve the validation problem by applying the approp' +
        'riate equalization rules to the value'
      ImageIndex = 79
      OnExecute = ActionValidationWarningResolveExecute
      OnUpdate = ActionValidationWarningResolveUpdate
    end
    object ActionTextEditApply: TAction
      Category = 'Edit'
      Hint = 'Apply'
      ImageIndex = 80
      ShortCut = 16397
      OnExecute = ActionEditTranslationTextExecute
      OnUpdate = ActionTextEditFocusedUpdate
    end
    object ActionTextEditCancel: TAction
      Category = 'Edit'
      Hint = 'Cancel'
      ImageIndex = 81
      ShortCut = 27
      OnExecute = ActionTextEditCancelExecute
      OnUpdate = ActionTextEditFocusedUpdate
    end
    object ActionTextEditPrevious: TAction
      Category = 'Edit'
      Hint = 'Go to previous'
      ImageIndex = 82
      ShortCut = 16422
      OnExecute = ActionTextEditPreviousExecute
      OnUpdate = ActionTextEditPreviousUpdate
    end
    object ActionTextEditNext: TAction
      Category = 'Edit'
      Hint = 'Go to next'
      ImageIndex = 83
      ShortCut = 16424
      OnExecute = ActionTextEditNextExecute
      OnUpdate = ActionTextEditNextUpdate
    end
    object ActionStopListAddTypeNameValue: TAction
      Tag = 6
      Category = 'StopList'
      Caption = 'Type, Name and Value'
      ShortCut = 24631
      OnExecute = ActionStopListAddExecute
      OnUpdate = ActionHasActivePropertyUpdate
    end
    object ActionTranslationMemoryUpdate: TAction
      Category = 'Automation'
      Caption = 'Update TM'
      Hint = 'Update the Translation Memory with translations from the project'
      ImageIndex = 85
      OnExecute = ActionTranslationMemoryUpdateExecute
      OnUpdate = ActionTranslationMemoryUpdateUpdate
    end
    object ActionProjectLocateSource: TAction
      Category = 'Project'
      Caption = 'Locate source...'
      Hint = 'Locate the source application file'
      ImageIndex = 86
      OnExecute = ActionProjectLocateSourceExecute
      OnUpdate = ActionHasProjectUpdate
    end
    object ActionIntegrationTracking: TAction
      Category = 'Integration'
      AutoCheck = True
      Caption = 'Track focus'
      Hint = 
        'Enable focus synchronization between application being translate' +
        'd and translation manager'
      OnExecute = ActionIntegrationTrackingExecute
    end
    object ActionPurgeSelected: TAction
      Category = 'Translation'
      Caption = 'Purge selected item(s)...'
      Hint = 'Remove unused items from among the selected items'
      ImageIndex = 6
      ShortCut = 16430
      OnExecute = ActionPurgeSelectedExecute
      OnUpdate = ActionPurgeSelectedUpdate
    end
    object ActionPurge: TAction
      Category = 'Project'
      Caption = 'Purge'
      Hint = 'Removed unused items'
      ImageIndex = 6
      OnExecute = ActionDummyExecute
      OnUpdate = ActionHasModulesUpdate
    end
    object ActionGotoNextStateObsolete: TAction
      Tag = 3
      Category = 'Find'
      Caption = 'Obsolete'
      ImageIndex = 88
      OnExecute = ActionGotoNextStateObsoleteExecute
    end
  end
  object OpenDialogProject: TOpenDialog
    Filter = 'Translation projects (*.xlat)|*.xlat|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 364
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
    OnAutoCorrectStart = SpellCheckerCheckStart
    OnCheckAsYouTypeStart = SpellCheckerCheckStart
    OnCheckWord = SpellCheckerCheckWord
    OnSpellingComplete = SpellCheckerSpellingComplete
    Left = 448
    Top = 204
  end
  object PopupMenuTree: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'BarButtonStatusTranslate'
      end
      item
        Visible = True
        ItemName = 'BarButtonStatusDontTranslate'
      end
      item
        Visible = True
        ItemName = 'BarButtonStatusHold'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'BarButtonStatePropose'
      end
      item
        Visible = True
        ItemName = 'BarButtonStateAccept'
      end
      item
        Visible = True
        ItemName = 'BarButtonStateReject'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'BarButtonPurgeSelected'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'dxBarButton10'
      end
      item
        Visible = True
        ItemName = 'ButtonItemBookmark'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'BarButtonTMLookup'
      end
      item
        Visible = True
        ItemName = 'RibbonGalleryItemStopList'
      end>
    Ribbon = RibbonMain
    UseOwnFont = False
    Left = 80
    Top = 232
    PixelsPerInch = 96
  end
  object OpenDialogEXE: TOpenDialog
    Filter = 
      'Applications (*.exe)|*.exe|Library modules (*.dll)|*.dll|Delphi ' +
      'package (*.bpl)|*.bpl|All modules (*.exe, *.dll, *.bpl)|*.exe;*.' +
      'dll;*.bpl|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 412
  end
  object PopupMenuBookmark: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'ButtonItemBookmarkAny'
      end>
    Ribbon = RibbonMain
    UseOwnFont = False
    OnPopup = PopupMenuBookmarkPopup
    Left = 80
    Top = 288
    PixelsPerInch = 96
  end
  object PopupMenuRecentFiles: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <>
    Ribbon = RibbonMain
    UseOwnFont = False
    Left = 80
    Top = 177
    PixelsPerInch = 96
  end
  object OpenDialogDRC: TOpenDialog
    Filter = 'Symbol files (*.drc)|*.drc|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 448
    Top = 464
  end
  object SaveDialogProject: TSaveDialog
    Filter = 'Translation projects (*.xlat)|*.xlat|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 556
    Top = 364
  end
  object SaveDialogEXE: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 556
    Top = 416
  end
  object TimerHint: TTimer
    Enabled = False
    OnTimer = TimerHintTimer
    Left = 296
    Top = 244
  end
  object HintStyleController: TcxHintStyleController
    Global = False
    HintStyleClassName = 'TdxScreenTipStyle'
    HintStyle.ScreenTipLinks = <>
    HintStyle.ScreenTipActionLinks = <>
    HintHidePause = 5000
    Left = 296
    Top = 356
  end
  object ScreenTipRepository: TdxScreenTipRepository
    AssignedFonts = [stbFooter]
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clGray
    FooterFont.Height = -12
    FooterFont.Name = 'Segoe UI'
    FooterFont.Style = []
    Left = 296
    Top = 308
    PixelsPerInch = 96
    object ScreenTipTranslationMemory: TdxScreenTip
      Header.Glyph.SourceDPI = 96
      Header.Glyph.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000018149444154785E95923D4B03411086DF5C2E460E430E41B40BB68221
        3F40447F806552041B4BB11003DA58A8AD42D04AB051080876829595075A5858
        F851586A224802621203979C97CBBAB364C346EE223EF0B2373737F30EB307C6
        9890C4B66D936B9BABDAFABC65AD8F4B46278F49DB50A03A1D84520CE02ADCB8
        4845CA1B08B9454858380E777C6F8B7F93300C630912750272702A678CDD2150
        CEFB919844D66AE867959C0711A9AC8BEF64AC2BE3A7B4D6A329C7FE9A2C8169
        7148429D3A62C56984BC3A34FB9AF63407C0522730A140C5438D5318E52CA2F5
        4304D16BC01763758693625904B97DC7B2C2D9892F63E46D869E459E4593E0DC
        CB062AFB7CD320B476091235E6796A72C20D6B7E0D763C73D172277641E8CD1B
        1061E70904BDE779725E8324E0477AF19E67FBAEAFF390A0EBAB521E44C035A2
        3BDA4E7B74052AEED8261D0722AFA0C39F732FB670DC9CB2F10BCBF71602A640
        3E9FEF29081D03C8E572F80B0DC1D40A858270A7B3CBEB7F1ACCA7D3E95A2693
        018962BF063F167DE6F72ACA936D0000000049454E44AE426082}
      Header.Text = 'Translation Memory'
      Description.PlainText = False
      Description.Text = 
        '{\rtf1\fbidis\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0' +
        ' Segoe UI;}{\f1\fnil\fcharset178 Segoe UI;}{\f2\fnil\fcharset2 S' +
        'ymbol;}}'#13#10'{\colortbl ;\red76\green76\blue76;\red0\green128\blue2' +
        '55;}'#13#10'\viewkind4\uc1\pard\ltrpar\cf1\lang1030\f0\fs18 Lorem ipsu' +
        'm dolor:\par'#13#10'\pard{\pntext\f2\'#39'B7\tab}{\*\pn\pnlvlblt\pnf2\pnin' +
        'dent0{\pntxtb\'#39'B7}}\ltrpar\fi-200\li200\cf2\f1\rtlch\'#39'c5\'#39'e1\'#39'db' +
        '\'#39'c7\'#39'c1 \'#39'c7\'#39'e1\'#39'c3\'#39'e3\'#39'd1\cf1\f0\ltrch\par'#13#10'\cf2{\pntext\f2\' +
        #39'B7\tab}Two\cf1\par'#13#10'}'#13#10
      Footer.Text = 'Click to translate from Translation Memory'
    end
  end
  object TaskDialogTranslate: TTaskDialog
    Buttons = <>
    CommonButtons = [tcbYes, tcbNo]
    DefaultButton = tcbNo
    FooterIcon = 1
    FooterText = 'X of the selected values are not elegible for translation.'
    RadioButtons = <>
    Text = 
      'Do you want to perform machine translation on the selected X val' +
      'ues?'
    Title = 'Translate using XXX?'
    VerificationText = 'Only translate strings that have not already been translated'
    Left = 448
    Top = 288
  end
  object PopupMenuTranslateProviders: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <>
    Ribbon = RibbonMain
    UseOwnFont = False
    OnPopup = PopupMenuTranslateProvidersPopup
    Left = 80
    Top = 336
    PixelsPerInch = 96
  end
  object TimerToast: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerToastTimer
    Left = 296
    Top = 224
  end
  object PopupMenuBuild: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'ButtonBuildAll'
      end
      item
        Visible = True
        ItemName = 'ButtonSeparatorBuild'
      end>
    Ribbon = RibbonMain
    UseOwnFont = False
    OnPopup = PopupMenuBuildPopup
    Left = 80
    Top = 386
    PixelsPerInch = 96
  end
  object TaskDialogImportUpdate: TTaskDialog
    Buttons = <
      item
        Caption = 'Keep'
        Default = True
        CommandLinkHint = 'Do not replace existing translations. Only add new ones.'
        ModalResult = 100
      end
      item
        Caption = 'Update'
        CommandLinkHint = 'Existing translations are updated. New ones are added.'
        ModalResult = 101
      end>
    Caption = 'Translation import'
    Flags = [tfAllowDialogCancellation, tfUseCommandLinks]
    RadioButtons = <>
    Text = 
      'The project already contains %.0n %s translations. How would you' +
      ' like these existing translations to be handled?'
    Title = 'Replace existing translations?'
    Left = 716
    Top = 220
  end
  object PopupMenuValidationWarning: TdxRibbonPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'BarSeparatorValidationWarningHeader'
      end
      item
        Visible = True
        ItemName = 'dxBarSeparator2'
      end
      item
        Visible = True
        ItemName = 'dxBarButton8'
      end
      item
        Visible = True
        ItemName = 'dxBarButton6'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'dxBarButton27'
      end>
    Ribbon = RibbonMain
    UseOwnFont = False
    OnPopup = PopupMenuValidationWarningPopup
    Left = 80
    Top = 442
    PixelsPerInch = 96
  end
  object TimerBlink: TTimer
    Enabled = False
    Interval = 300
    OnTimer = TimerBlinkTimer
    Left = 296
    Top = 174
  end
end
