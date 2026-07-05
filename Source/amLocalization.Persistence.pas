unit amLocalization.Persistence;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Classes,
  SysUtils,
  amProgress.API,
  amLocalization.Model;

// -----------------------------------------------------------------------------
//
// TLocalizationProjectFiler
//
// -----------------------------------------------------------------------------
// Save and load project.
// -----------------------------------------------------------------------------
type
  TLocalizationSaveOption = (soOmitDontTranslateItems, soSort, soOmitNewState, soTransient);
  TLocalizationSaveOptions = set of TLocalizationSaveOption;

  TLocalizationLoadProperties = record
    FileFormatVersion: integer;
    ToolName: string;
    ToolVersion: integer;
  end;

  TLocalizationProjectFiler = class
  private
    const
      sModuleKind: array[TLocalizerModuleKind] of string = ('invalid', 'form', 'strings');
      sTranslationStatus: array[TTranslationStatus] of string = ('obsolete', 'pending', 'proposed', '');
      sItemState: array[TLocalizerItemState] of string = ('new', 'unused', '');
      sItemStatus: array[TLocalizerItemStatus] of string = ('', 'hold', 'skip');
  private
    class function EncodeString(const Value: string): string;
    class function DecodeStringOld(const Value: string): string;
    class function DecodeString(const Value: string): string;
  public
    class procedure LoadFromStream(Project: TLocalizerProject; var LoadProperties: TLocalizationLoadProperties; Stream: TStream; const Progress: IProgress = nil);
    class procedure LoadFromFile(Project: TLocalizerProject; var LoadProperties: TLocalizationLoadProperties; const Filename: string; const Progress: IProgress = nil);

    class procedure SaveToStream(Project: TLocalizerProject; Stream: TStream; AOptions: TLocalizationSaveOptions = []; const Progress: IProgress = nil);
    class procedure SaveToFile(Project: TLocalizerProject; const Filename: string; AOptions: TLocalizationSaveOptions = []; const Progress: IProgress = nil);
  end;

type
  ELocalizationPersistence = class(Exception);

const
  (* Versions:
  **
  **  (none)    First version.
  **            XML does not contain version number.
  **            File is ANSI encoded.
  **            Strings are DFM escaped.
  **            Locale/Language specified with Windows LCID values.
  **
  **   1        File contains version number and meta block.
  **
  **   2        File is UFT-8 encoded.
  **            Strings are HTML escaped.
  **
  **   3        Locale/Language specified with RFC 4646 language-region codes.
  **
  *)
  LocalizationFileFormatVersionUnknown = 1;             // Old verson that didn't write meta\version value
  LocalizationFileFormatVersionBadTextEncoding = 1;     // Old version with badly designed text encoding
  LocalizationFileFormatVersionCurrent = 3;             // Current version

const
  sLocalizationFileformatRoot = 'xlat';

resourcestring
  sProgressProjectLoading = 'Loading Project';
  sProgressProjectLoad = 'Loading...';
  sProgressProjectReadModules = 'Processing modules...';

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  Generics.Collections,
  Generics.Defaults,
  DateUtils,
  IOUtils,
  Windows,
  Variants,
  XMLDoc, XMLIntf,
  System.Character,
  System.NetEncoding,
//  amLocale,
  amLanguageInfo,
  amPath,
  amVersionInfo;

// -----------------------------------------------------------------------------
//
// TLocalizationProjectFiler
//
// -----------------------------------------------------------------------------
class function TLocalizationProjectFiler.DecodeStringOld(const Value: string): string;
begin
  Result := StringReplace(Value, '##', '#', [rfReplaceAll]);
  Result := StringReplace(Result, '#13', #13, [rfReplaceAll]);
  Result := StringReplace(Result, '#10', #10, [rfReplaceAll]);
  Result := StringReplace(Result, '#9', #9, [rfReplaceAll]);
end;

class function TLocalizationProjectFiler.DecodeString(const Value: string): string;
begin
  Result := TNetEncoding.HTML.Decode(Value);
end;

class function TLocalizationProjectFiler.EncodeString(const Value: string): string;
var
  i, DestinationPos: Integer;

  procedure Encode(const AStr: string);
  begin
    if (DestinationPos+Length(AStr)-1 > Length(Result)) then
      // Grow target * 4
      SetLength(Result, Length(Result) + Length(AStr) + (Length(Value)-i+1)*4);

    Move(AStr[1], Result[DestinationPos], Length(AStr) * SizeOf(Char));
    Inc(DestinationPos, Length(AStr));
  end;

begin
  // Initial twice oversize to avoid reallocation
  SetLength(Result, Length(Value) * 2);

  DestinationPos := 1;
  for i := 1 to Length(Value) do
  begin
    // Handle reserved chars first
    (* These are automatically handled by MSXML
    var Handled := True;
    case Value[i] of
      '&': Encode('&amp;');
      '<': Encode('&lt;');
      '>': Encode('&gt;');
      '"': Encode('&quot;');
    else
      Handled := False;
    end;

    if (Handled) then
      continue;
    *)

    // Handle unicode range
    // Any Unicode character, excluding the surrogate blocks, FFFE, and FFFF and the restricted chars.
    // See https://www.w3.org/TR/xml11/#charsets
    case Value[i] of
      #$20..#$7E,
      #$A0..#$D7FF,
      #$E000..#$FFFD:
        begin
          if (DestinationPos > Length(Result)) then
            // Grow target * 4
            SetLength(Result, Length(Result) + (Length(Value)-i+1)*4);
          Result[DestinationPos] := Value[i];
          Inc(DestinationPos);
        end;
    else
      Encode('&#'+IntToStr(Ord(Value[i]))+';');
    end;
  end;
  // Trim oversize
  SetLength(Result, DestinationPos - 1);
end;

// -----------------------------------------------------------------------------

class procedure TLocalizationProjectFiler.LoadFromFile(Project: TLocalizerProject; var LoadProperties: TLocalizationLoadProperties; const Filename: string; const Progress: IProgress);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Project, LoadProperties, Stream, Progress);
  finally
    Stream.Free;
  end;
end;

// -----------------------------------------------------------------------------

class procedure TLocalizationProjectFiler.LoadFromStream(Project: TLocalizerProject; var LoadProperties: TLocalizationLoadProperties; Stream: TStream; const Progress: IProgress);

  function StringToModuleKind(const Value: string): TLocalizerModuleKind;
  begin
    for Result := Low(Result) To High(Result) do
      if (Value = sModuleKind[Result]) then
        Exit;
    Result := Low(Result);
  end;

  function StringToTranslationStatus(const Value: string): TTranslationStatus;
  begin
    for Result := Low(Result) To High(Result) do
      if (Value = sTranslationStatus[Result]) then
        Exit;
    Result := Low(Result);
  end;

  function StringToItemState(Item: TCustomLocalizerItem; const Value: string): TLocalizerItemStates;
  var
    StateValues: TArray<string>;
    StateValue: string;
    State: TLocalizerItemState;
  begin
    Result := [];
    if (Value = '') then
      Exit;
    StateValues := Value.Split([',']);
    for StateValue in StateValues do
      for State := Low(sItemState) To High(sItemState) do
        if (StateValue = sItemState[State]) then
        begin
          Item.SetState(State);
          Include(Result, State);
          break;
        end;
  end;

  function StringToItemStatus(const Value: string): TLocalizerItemStatus;
  begin
    for Result := Low(Result) To High(Result) do
      if (Value = sItemStatus[Result]) then
        Exit;
    Result := Low(Result);
  end;

  function StringToPropFlags(const Value: string): TPropertyFlags;
  var
    c: Char;
    n: integer;
  begin
    Result := [];
    if (Value = '') then
      Exit;
    for c in Uppercase(Value) do
    begin
      if (c.IsDigit) then
        n := Ord(c)-Ord('0')
      else
        n := 10+Ord(c)-Ord('A');
      if (n >= Ord(Low(TPropertyFlag))) and (n <= Ord(High(TPropertyFlag))) then
        Include(Result, TPropertyFlag(n));
    end;
  end;

type
  TTextDecoder = reference to function(const Value: string): string;
var
  XML: IXMLDocument;
  RootNode, ProjectNode, Node: IXMLNode;
  LanguagesNode, LanguageNode: IXMLNode;
  ModulesNode, ModuleNode: IXMLNode;
  ItemsNode, ItemNode: IXMLNode;
  PropsNode, PropNode: IXMLNode;
  XlatsNode, XlatNode: IXMLNode;
  Module: TLocalizerModule;
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
  Language: TTranslationLanguage;
  TranslationStatus: TTranslationStatus;
  s: string;
  TextDecoder: TTextDecoder;
resourcestring
  sUnsupportedFutureVersion = 'The translation project file requires a newer version of Better Translation Manager.'#13+
    'This version, %s, supports project file formats up to version %s.'#13+
    'The file was saved with version %s in project file format version %s.';
  sBadFile = 'Malformed project file; The file can not be loaded.'#13'%s';
begin
  if (Progress <> nil) then
    Progress.UpdateMessage(sProgressProjectLoad);

  LoadProperties := Default(TLocalizationLoadProperties);

  TextDecoder := DecodeString;
  LoadProperties.FileFormatVersion := LocalizationFileFormatVersionUnknown;

  XML := TXMLDocument.Create(nil);
  XML.Options := XML.Options + [doAttrNull];
  XML.ParseOptions := XML.ParseOptions + [poPreserveWhiteSpace];

  try

    XML.LoadFromStream(Stream);

  except
    on E: Exception do
      // madExcept eats the inner exception so we have to pass its info in the new exception
      Exception.RaiseOuterException(ELocalizationPersistence.CreateFmt(sBadFile, [E.Message]));
  end;

  RootNode := XML.ChildNodes[sLocalizationFileformatRoot];
  if (RootNode = nil) then
    raise ELocalizationPersistence.CreateFmt('Malformed project file. Root element not found: %s', [sLocalizationFileformatRoot]);

  Node := RootNode.ChildNodes['meta'];
  if (Node <> nil) then
  begin
    LoadProperties.FileFormatVersion := StrToIntDef(Node.ChildValues['version'], LocalizationFileFormatVersionUnknown);
    LoadProperties.ToolName := VarToStr(Node.ChildValues['tool']);
    LoadProperties.ToolVersion := StrToIntDef(Node.ChildValues['toolversion'], 0);
  end;

  // Reject future file format versions
  if (LoadProperties.FileFormatVersion > LocalizationFileFormatVersionCurrent) then
  begin
    var ThisToolVersion := TVersionInfo.FileVersionString(ParamStr(0));
    raise ELocalizationPersistence.CreateFmt(sUnsupportedFutureVersion,
      [ThisToolVersion, IntToStr(LocalizationFileFormatVersionCurrent), LoadProperties.ToolVersion, LoadProperties.FileFormatVersion.ToString]);
  end;

  // Select text decoder based on file format version
  if (LoadProperties.FileFormatVersion = LocalizationFileFormatVersionBadTextEncoding) then
    TextDecoder := DecodeStringOld;

  ProjectNode := RootNode.ChildNodes['project'];
  if (ProjectNode = nil) then
    raise ELocalizationPersistence.CreateFmt('Malformed project file. Project element not found: %s', ['project']);

  Project.BeginUpdate;
  try
    Project.Clear;

    Project.SourceFilename := VarToStr(ProjectNode.Attributes['sourcefile']);
    if (not Project.SourceFilename.IsEmpty) and (TPath.GetExtension(Project.SourceFilename).IsEmpty) then
      Project.SourceFilename := Project.SourceFilename + '.exe';

    // UI will handle if the symbol file doesn't exist
    Project.StringSymbolFilename := VarToStr(ProjectNode.Attributes['stringsymbolfile']);

    s := VarToStr(ProjectNode.Attributes['language']);
    var LanguageItem := LanguageInfo.FindLocale(s);

    if (LanguageItem = nil) then
      raise ELocalizationPersistence.CreateFmt('Unknown language: %s', [s]);

    Project.SourceLanguage := LanguageItem;

    LanguagesNode := ProjectNode.ChildNodes.FindNode('targetlanguages');
    if (LanguagesNode <> nil) then
      LanguageNode := LanguagesNode.ChildNodes.First
    else
      LanguageNode := nil;

    // Pre-create target languages.
    // This ensures that they are present in the language list even if there are no translations for them yet.
    while (LanguageNode <> nil) do
    begin
      if (LanguageNode.NodeName = 'language') then
      begin
        s := VarToStr(LanguageNode.Attributes['language']);
        LanguageItem := LanguageInfo.FindLocale(s);

        if (LanguageItem = nil) then
          raise ELocalizationPersistence.CreateFmt('Unknown language: %s', [s]);

        Project.TranslationLanguages.Add(LanguageItem);
      end;
      LanguageNode := LanguageNode.NextSibling;
    end;

    ModulesNode := ProjectNode.ChildNodes.FindNode('modules');
    if (ModulesNode = nil) then
      exit;

    if (Progress <> nil) then
      Progress.Progress(psBegin, 0, ModulesNode.ChildNodes.Count, sProgressProjectReadModules);

    ModuleNode := ModulesNode.ChildNodes.First;
    while (ModuleNode <> nil) do
    begin
      if (Progress <> nil) then
        Progress.AdvanceProgress;

      if (ModuleNode.NodeName = 'module') then
      begin
        Module := Project.AddModule(VarToStr(ModuleNode.Attributes['name']));
        Module.ClearState(ItemStateNew);
        Module.Kind := StringToModuleKind(VarToStr(ModuleNode.Attributes['type']));
        StringToItemState(Module, VarToStr(ModuleNode.Attributes['state']));
        Module.Status := StringToItemStatus(VarToStr(ModuleNode.Attributes['status']));
        Module.Priority := StrToIntDef(VarToStr(ModuleNode.Attributes['priority']), 0);

        ItemsNode := ModuleNode.ChildNodes.FindNode('items');
        if (ItemsNode <> nil) then
        begin
          ItemNode := ItemsNode.ChildNodes.First;
          while (ItemNode <> nil) do
          begin
            if (ItemNode.NodeName = 'item') then
            begin
              Item := Module.AddItem(VarToStr(ItemNode.Attributes['name']), VarToStr(ItemNode.Attributes['type']));
              Item.ClearState(ItemStateNew);
              Item.ResourceID := StrToIntDef(VarToStr(ItemNode.Attributes['id']), 0);
              StringToItemState(Item, VarToStr(ItemNode.Attributes['state']));
              Item.Status := StringToItemStatus(VarToStr(ItemNode.Attributes['status']));

              PropsNode := ItemNode.ChildNodes.FindNode('properties');
              if (PropsNode <> nil) then
              begin
                PropNode := PropsNode.ChildNodes.First;
                while (PropNode <> nil) do
                begin
                  if (PropNode.NodeName = 'property') then
                  begin
                    s := VarToStr(PropNode.ChildValues['value']);
                    s := TextDecoder(s);
                    Prop := Item.AddProperty(VarToStr(PropNode.Attributes['name']), s);
                    Prop.ClearState(ItemStateNew);
                    StringToItemState(Prop, VarToStr(PropNode.Attributes['state']));
                    Prop.Status := StringToItemStatus(VarToStr(PropNode.Attributes['status']));
                    Prop.Priority := StrToIntDef(VarToStr(PropNode.Attributes['priority']), 0);
                    Prop.Flags := StringToPropFlags(VarToStr(PropNode.Attributes['flags']));
                    Prop.Synthesized := AnsiSameText(VarToStr(PropNode.Attributes['synthesized']), 'true');

                    XlatsNode := PropNode.ChildNodes.FindNode('translations');
                    if (XlatsNode <> nil) then
                    begin
                      XlatNode := XlatsNode.ChildNodes.First;
                      while (XlatNode <> nil) do
                      begin
                        if (XlatNode.NodeName = 'translation') then
                        begin
                          s := VarToStr(XlatNode.Attributes['language']);
                          LanguageItem := LanguageInfo.FindLocale(s);

                          if (LanguageItem = nil) then
                            raise ELocalizationPersistence.CreateFmt('Unknown language: %s', [s]);

                          Language := Project.TranslationLanguages.Add(LanguageItem);

                          TranslationStatus := StringToTranslationStatus(VarToStr(XlatNode.Attributes['status']));
                          s := TextDecoder(XlatNode.Text);
                          Prop.Translations.AddOrUpdateTranslation(Language, s, TranslationStatus);
                        end;
                        XlatNode := XlatNode.NextSibling;
                      end;
                    end;
                  end;
                  PropNode := PropNode.NextSibling;
                end;
              end else
              if (Module.Kind = mkString) and (Item.Status = ItemStatusDontTranslate) then
              begin
                // If a resourcestring was saved without the single property it /should/ contain then it must be because
                // the property was marked "Don't translate". We restore the original state here so the property will
                // appear again. We must do this as there is no way to directly modify the status of an Item in the UI.

                // Restore status
                Item.Status := ItemStatusTranslate;

                // Add the resourcestring property.
                // We don't have the value anymore, so we just add an empty string. The user must recover the value by
                // doing a refresh if they need it.
                Prop := Item.AddProperty('', '');
                Prop.ClearState(ItemStateNew);

                // Mark the property "Don't translate"
                Prop.Status := ItemStatusDontTranslate;
              end;
            end;
            ItemNode := ItemNode.NextSibling;
          end;
        end;
      end;
      ModuleNode := ModuleNode.NextSibling;
    end;
    if (Progress <> nil) then
      Progress.Progress(psEnd, 1, 1);
  finally
    Project.EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

class procedure TLocalizationProjectFiler.SaveToFile(Project: TLocalizerProject; const Filename: string; AOptions: TLocalizationSaveOptions; const Progress: IProgress);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(Project, Stream, AOptions, Progress);
  finally
    Stream.Free;
  end;
end;

// -----------------------------------------------------------------------------

class procedure TLocalizationProjectFiler.SaveToStream(Project: TLocalizerProject; Stream: TStream; AOptions: TLocalizationSaveOptions; const Progress: IProgress);

  procedure WriteItemState(const Node: IXMLNode; Item: TCustomLocalizerItem);
  var
    ItemState: TLocalizerItemStates;
    State: TLocalizerItemState;
    s: string;
  begin
    if (Item.InheritParentState) then
      Exit;

    ItemState := Item.State;
    if (soOmitNewState in AOptions) then
      Exclude(ItemState, ItemStateNew); // Excluding "New" makes it easier to do version control on a project
    if (Item.State = []) then
      Exit;

    s := '';
    for State in ItemState do
    begin
      if (s <> '') then
        s := s + ',';
      s := s + sItemState[State];
    end;

    if (s <> '') then
      Node.Attributes['state'] := s;
  end;

  procedure WriteItemStatus(const Node: IXMLNode; ItemStatus: TLocalizerItemStatus); overload;
  begin
    if (ItemStatus <> ItemStatusTranslate) then
      Node.Attributes['status'] := sItemStatus[ItemStatus];
  end;

  procedure WriteItemStatus(const Node: IXMLNode; Item: TCustomLocalizerItem); overload;
  begin
    WriteItemStatus(Node, Item.Status);
  end;

  procedure WriteItemPriority(const Node: IXMLNode; Item: TCustomLocalizerItem);
  begin
    if (Item.Priority <> 0) then
      Node.Attributes['priority'] := Item.Priority;
  end;

  procedure WriteItemName(const Node: IXMLNode; Item: TCustomLocalizerItem);
  begin
    if (not Item.Name.IsEmpty) then
      Node.Attributes['name'] := Item.Name;
  end;

  procedure WriteItemID(const Node: IXMLNode; ID: integer);
  begin
    // We no longer save the ID - It isn't used for anything
    (*
    if (ID <> 0) and (ID <> -1) then
      Node.Attributes['id'] := ID;
    *)
  end;

  procedure WritePropFlags(const Node: IXMLNode; Prop: TLocalizerProperty);
  var
    s: string;
    Flag: TPropertyFlag;
  begin
    if (Prop.Flags = []) then
      Exit;
    s := '';
    for Flag in Prop.Flags do
      if (Flag in [FlagBookmark0..FlagBookmark9]) then
        s := s + Char(Ord('0') + Ord(Flag) - Ord(FlagBookmark0))
      else
        s := s + Char(Ord('A') + Ord(Flag) - Ord(FlagBookmarkA));
    Node.Attributes['flags'] := s;
  end;

  procedure WritePropOptions(const Node: IXMLNode; Prop: TLocalizerProperty);
  begin
    if (Prop.Synthesized) then
      Node.Attributes['synthesized'] := 'true';
  end;

var
  XML: IXMLDocument;
  RootNode, Node: IXMLNode;
  ProjectNode: IXMLNode;
  LanguagesNode, LanguageNode: IXMLNode;
  ModulesNode, ModuleNode: IXMLNode;
  ItemsNode, ItemNode: IXMLNode;
  PropsNode, PropNode: IXMLNode;
  XlatsNode, XlatNode: IXMLNode;
  Module: TLocalizerModule;
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
  i: integer;
begin
  XML := TXMLDocument.Create(nil);
  XML.Options := [doNodeAutoIndent];
  XML.Active := True;
  XML.Encoding := 'utf-8';

  RootNode := XML.AddChild(sLocalizationFileformatRoot);


  Node := RootNode.AddChild('meta');
  Node.AddChild('version').Text := IntToStr(LocalizationFileFormatVersionCurrent);
  if (soTransient in AOptions) then
    Node.AddChild('created').Text := DateToISO8601(Now, False);
  Node.AddChild('tool').Text := TPath.GetFileNameWithoutExtension(ParamStr(0));
  Node.AddChild('toolversion').Text := TVersionInfo.FileVersionString(ParamStr(0));


  Node := RootNode.AddChild('options');
  // Store the stringlist handling setting that was used with the project
  Node.AddChild('stringlisthandling').Text := IntToStr(Ord(StringListHandling));
  // Indicate if Status="Don't Translate" items were included
  Node.AddChild('omitdonttranslate').Text := (not(soOmitDontTranslateItems in AOptions)).ToString(TUseBoolStrs.True);
  // Indicate if nodes are sorted
  Node.AddChild('sorted').Text := (soSort in AOptions).ToString(TUseBoolStrs.True);
  // Indicate if State="New" is saved
  Node.AddChild('omitnewstate').Text := (soOmitNewState in AOptions).ToString(TUseBoolStrs.True);
  // Indicate if purely transient/informationmal attributes are saved
  Node.AddChild('transient').Text := (soTransient in AOptions).ToString(TUseBoolStrs.True);


  ProjectNode := RootNode.AddChild('project');
  // Paths are assumed to be absolute or relative to the project file
  ProjectNode.Attributes['sourcefile'] := Project.SourceFilename;
  ProjectNode.Attributes['stringsymbolfile'] := Project.StringSymbolFilename;
  ProjectNode.Attributes['language'] := Project.SourceLanguage.LocaleName;
  if (soTransient in AOptions) then
    ProjectNode.Attributes['properties'] := Project.StatusCount[ItemStatusTranslate];

  LanguagesNode := ProjectNode.AddChild('targetlanguages');
  for i := 0 to Project.TranslationLanguages.Count-1 do
  begin
    LanguageNode := LanguagesNode.AddChild('language');
    LanguageNode.Attributes['language'] := Project.TranslationLanguages[i].Language.LocaleName;
    if (soTransient in AOptions) then
      LanguageNode.Attributes['translated'] := Project.TranslationLanguages[i].TranslatedCount;
  end;

  ModulesNode := ProjectNode.AddChild('modules');

  var Modules := Project.Modules.Values.ToArray;
  if (soSort in AOptions) then
    TArray.Sort<TLocalizerModule>(Modules, TComparer<TLocalizerModule>.Construct(
      function(const Left, Right: TLocalizerModule): Integer
      begin
        Result := (Ord(Right.Kind) - Ord(Left.Kind)); // Reversed to order resourcestrings before forms
        if (Result = 0) then
          Result := InvariantCompareText(Left.Name, Right.Name);
      end));

  for Module in Modules do
  begin
    ModuleNode := ModulesNode.AddChild('module');
    WriteItemName(ModuleNode, Module);
    ModuleNode.Attributes['type'] := sModuleKind[Module.Kind];
    WriteItemState(ModuleNode, Module);
    WriteItemStatus(ModuleNode, Module);
    WriteItemPriority(ModuleNode, Module);

    if (soOmitDontTranslateItems in AOptions) and (Module.Status = ItemStatusDontTranslate) then
      continue;

    if (soTransient in AOptions) then
      ModuleNode.Attributes['properties'] := Module.StatusCount[ItemStatusTranslate];

    ItemsNode := nil;

    var Items := Module.Items.Values.ToArray;
    if (soSort in AOptions) then
      TArray.Sort<TLocalizerItem>(Items, TComparer<TLocalizerItem>.Construct(
        function(const Left, Right: TLocalizerItem): Integer
        begin
          Result := InvariantCompareText(Left.Name, Right.Name);
        end));

    for Item in Items do
    begin
      if (Progress <> nil) then
        Progress.AdvanceProgress;

      if (ItemsNode = nil) then
        ItemsNode := ModuleNode.AddChild('items');

      ItemNode := ItemsNode.AddChild('item');
      WriteItemName(ItemNode, Item);
      WriteItemID(ItemNode, Item.ResourceID);
      if (Item.TypeName <> '') then
        ItemNode.Attributes['type'] := Item.TypeName;
      WriteItemState(ItemNode, Item);

      var ItemStatus := Item.Status;
      // For resourcestrings there's only one property per item. If the property is marked "Don't translate"
      // then we don't want to save an empty item. We avoid this by applying the "Don't translate" status to
      // the item.
      if (soOmitDontTranslateItems in AOptions) and (ItemStatus <> ItemStatusDontTranslate) then
      begin
        if (Module.Kind = mkString) and (Item.Properties.Count = 1) and (Item.Properties.Values.ToArray[0].Status = ItemStatusDontTranslate) then
          ItemStatus := ItemStatusDontTranslate;
      end;

      WriteItemStatus(ItemNode, ItemStatus);

      if (soOmitDontTranslateItems in AOptions) and (ItemStatus = ItemStatusDontTranslate) then
        continue;

      PropsNode := nil;

      var Properties := Item.Properties.Values.ToArray;
      if (soSort in AOptions) then
        TArray.Sort<TLocalizerProperty>(Properties, TComparer<TLocalizerProperty>.Construct(
          function(const Left, Right: TLocalizerProperty): Integer
          begin
            Result := InvariantCompareText(Left.Name, Right.Name);
          end));

      for Prop in Properties do
      begin
        if (PropsNode = nil) then
          PropsNode := ItemNode.AddChild('properties');

        PropNode := PropsNode.AddChild('property');
        WriteItemName(PropNode, Prop);
        WriteItemState(PropNode, Prop);
        WriteItemStatus(PropNode, Prop);
        WriteItemPriority(PropNode, Prop);
        WritePropFlags(PropNode, Prop);
        WritePropOptions(PropNode, Prop);

        if (soOmitDontTranslateItems in AOptions) and (Prop.Status = ItemStatusDontTranslate) then
          continue;

        PropNode.AddChild('value').NodeValue := EncodeString(Prop.Value);

        XlatsNode := nil;
        Prop.Traverse(
          function(Prop: TLocalizerProperty; Translation: TLocalizerTranslation): boolean
          begin
            // No need to save pending translations
            if (Translation.Status = tStatusPending) then
              Exit(True);

            if (XlatsNode = nil) then
              XlatsNode :=  PropNode.AddChild('translations');

            XlatNode := XlatsNode.AddChild('translation');
            XlatNode.Attributes['language'] := Translation.Language.Language.LocaleName;
            if (Translation.Status <> tStatusTranslated) then
              XlatNode.Attributes['status'] := sTranslationStatus[Translation.Status];
            XlatNode.Text := EncodeString(Translation.Value);
            Result := True;
          end);
      end;
    end;
  end;

  XML.SaveToStream(Stream);
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

end.
