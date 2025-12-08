unit amLocalization.Import.XLIFF;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

// Define QUOTED_STRINGS to require source strings to be quoted.
// The XLIFF produced by Delphi's ETM tool quotes strings but
// (unsurprisingly) it seems that most other tools doesn't.
{.$define QUOTED_STRINGS}

uses
  Classes,
  amLocalization.Model,
  amLocalization.Engine;

// -----------------------------------------------------------------------------
//
// TModuleImporterXLIFF
//
// -----------------------------------------------------------------------------
type
  TModuleImporterXLIFF = class
  private type
    TSkipReason = (
      skipUnchanged,      // Translation is unchanged
      skipNotFound       // Property not found
    );
    TSkipCounts = array[TSkipReason] of integer;
  private
    FTranslationCount: TTranslationCounts;
    FSkipCounts: TSkipCounts;
  protected
  public
    class constructor Create;

    function LoadFromStream(Project: TLocalizerProject; Stream: TStream; const FileName: string = ''): TLocalizerModule; overload;
    function LoadFromFile(Project: TLocalizerProject; const Filename: string): TLocalizerModule; overload;

    property TranslationCounts: TTranslationCounts read FTranslationCount;
    property SkipCounts: TSkipCounts read FSkipCounts;
  end;


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  UITypes,
  IOUtils,
  Variants,
  Windows,
  SysUtils,
  Dialogs,
  Controls,
  msxmldom,
  XMLDoc, XMLIntf,
  amLanguageInfo,
  amDialog.Manager.API,
  amLocalization.Dialog.SelectModule.API;

// -----------------------------------------------------------------------------
//
// TModuleImporterXLIFF
//
// -----------------------------------------------------------------------------
class constructor TModuleImporterXLIFF.Create;
begin
  // Can't remember why this was necessary
  msxmldom.MSXMLDOMDocumentFactory.AddDOMProperty('ProhibitDTD', False);
end;

function TModuleImporterXLIFF.LoadFromFile(Project: TLocalizerProject; const Filename: string): TLocalizerModule;
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadFromStream(Project, Stream, Filename);
  finally
    Stream.Free;
  end;
end;

// -----------------------------------------------------------------------------

  (*
  ** status:
  ** 0          Untranslated
  ** 1          Translated
  ** 2          Auto translated
  ** 3          Unused
  ** 4          Newly translated
  ** 5          Hold
  ** 6          Don't translate
  ** 7          Egged
  *)
type
  TETMTranslationStatus = (tsUntranslated, tsTranslated, tsAutoTranslated, tsUnused, tsNewlyTranslated, tsHold, tsDontTranslate, tsEgged, tsFinal, tsApproved, tsUnknown);

const
  TranslationStatusMap: array[TETMTranslationStatus] of TTranslationStatus = (
    tStatusPending,             // tsUntranslated
    tStatusProposed,            // tsTranslated
    tStatusProposed,            // tsAutoTranslated
    tStatusPending,             // tsUnused
    tStatusProposed,            // tsNewlyTranslated
    tStatusPending,             // tsHold
    tStatusPending,             // tsDontTranslate
    tStatusPending,             // tsEgged
    tStatusTranslated,          // tsFinal
    tStatusTranslated,          // tsApproved
    tStatusObsolete);           // tsUnknown


function IsAnsi(c: char): boolean; Inline;
begin
  Result := (c <= #$FF);
end;

function EscapeChar(c: Char; IsUnicode: boolean): string;
begin
//  if (TCharacter.GetUnicodeCategory(c) in [TUnicodeCategory.ucControl, TUnicodeCategory.ucUnassigned, TUnicodeCategory.ucPrivateUse]) then
    Result := Format('\x%.4X', [Ord(c)]);
//  else
//    Result := c;
end;

const
  UnicodePrefix = 'L';

type
  SetOfChar = set of AnsiChar;

function Escape(const s: string; Quote: boolean = False; DontEscape: SetOfChar = []; ForceUnicode: boolean = False): string;
var
  i: integer;
  IsUnicode: boolean;
  p: PChar;
  Lines: integer;
  Chunk: string;
begin
  IsUnicode := ForceUnicode;
  p := PChar(s);
  for i := 1 to Length(s) do
  begin
    if (Ord(p^) > 127) then
    begin
      IsUnicode := True;
      break;
    end;
    inc(p);
  end;

  Result := '';
  if (IsUnicode) then
    Result := Result + UnicodePrefix;

  if (Quote) then
    Result := Result + '"';

  Lines := 1;
  p := PChar(s);
  for i := 1 to Length(s) do
  begin
    if (IsAnsi(p^)) and (AnsiChar(p^) in DontEscape) then
      Chunk := p^
    else
    case integer(p^) of
      0: Chunk := '\0';
      8: Chunk := '\a'; // Not standard
      9: Chunk := '\t';
      10: Chunk := '\n';
      13: Chunk := '\r';
      34: Chunk := '""'; // "
      92: Chunk := '\\'; // \
      32..33, 35..91, 93..127: Chunk := p^;
    else
      Chunk := EscapeChar(p^, IsUnicode);
    end;
    inc(p);

    // Max length of single string must be 4097
    // Split long strings with continuation character: \
    // We split at 4000 to make room for margin and end delimiter. Not the best
    // solution but "good enough".
    if ((Length(Result) + Length(Chunk)) div Lines > 4000) then
    begin
      Result := Result + '\'+#13#10;
      inc(Lines);
    end;
    Result := Result + Chunk;
  end;

  if (Quote) then
    Result := Result + '"';
end;

function Unescape(const Value: string): string;
var
  p: PChar;
  LastChar: char;
  Escaped: boolean;
  s: string;
  First: boolean;

  procedure Push(c: char);
  begin
    Result := Result + c;
    LastChar := #0;
    Escaped := False;
  end;

  procedure Flush;
  begin
    Result := Result + LastChar;
    LastChar := #0;
    Escaped := False;
  end;

  procedure Purge;
  begin
    LastChar := #0;
    Escaped := False;
  end;

  function Fetch: char;
  begin
    if (p^ <> #0) then
      inc(p);
    Result := p^;
  end;

begin
  Result := '';
  p := PChar(Value);

  // Skip initial 'L'
  if (p^ <> #0) and (p^ = 'L') then
    inc(p);

  Purge;
  First := True;

  while (p^ <> #0) do
  begin
    if (Escaped) then
    begin
      if (p^ = 'x') then
      begin
        s := '$'+Fetch;
        s := s + Fetch;
        s := s + Fetch;
        s := s + Fetch;
        Push(Char(StrToInt(s)));
      end else
      if (p^ = 'r') then
        Push(#13)
      else
      if (p^ = 'n') then
        Push(#10)
      else
      if (p^ = 't') then
        Push(#9)
      else
        Push(p^);
    end else
    if (p^ = '"') then
    begin
      if (First) then
        Purge // just ignore it
      else
      if (LastChar = '"') then
        Flush
      else
        LastChar := p^;
    end else
    if (p^ = '''') then
    begin
      if (First) then
        Purge // just ignore it
      else
      if (LastChar = '''') then
        Flush
      else
        LastChar := p^;
    end else
    if (p^ = '\') then
      Escaped := True
    else
      Push(p^);

    First := False;
    inc(p);
  end;
end;

function TModuleImporterXLIFF.LoadFromStream(Project: TLocalizerProject; Stream: TStream; const FileName: string): TLocalizerModule;
type
  TImportDelegate = reference to function(Module: TLocalizerModule; const ItemName, ItemType, PropertyName, SourceValue: string; var Prop: TLocalizerProperty): boolean;
var
  TranslationLanguage: TTranslationLanguage;

  procedure Skip(Reason: TSkipReason);
  begin
    Inc(FSkipCounts[Reason]);
    Inc(FTranslationCount.CountSkipped);
  end;

  function ProcessNodes(const BodyNode: IXMLNode; Module: TLocalizerModule; Delegate: TImportDelegate): boolean;

    function GetNodeText(const Node: IXMLNode): string;
    var
      ChildNode: IXMLNode;
    begin
      // Contrary to the documented behavior, Node.IsTextElement returns False
      // if the node is a text node...
      if (Node.NodeType = ntText) or (Node.IsTextElement) then
        Exit(Node.text);

      Result := '';

      ChildNode := Node.ChildNodes.First;
      while (ChildNode <> nil) do
      begin
        Result := Result + GetNodeText(ChildNode);
        ChildNode := ChildNode.NextSibling;
      end;
    end;

  var
    Node, NextNode: IXMLNode;
    Child: IXMLNode;
    TargetNode: IXMLNode;
    PropChild, NextPropChild: IXMLNode;

    Localize: boolean;
    TranslationStatus: TETMTranslationStatus;

    s: string;
    i: integer;
    Value: string;

    ItemName, ItemType, PropertyName: string;
    SourceValue, TargetValue: string;
    Prop: TLocalizerProperty;

    Translation: TLocalizerTranslation;
  begin
    Result := True;
    Node := BodyNode.ChildNodes.First;

    while (Node <> nil) do
    begin
      Localize := True;
      if (Node.NodeName = 'trans-unit') then
      begin
        TranslationStatus := tsUnknown;

        if (Node.Attributes['translate'] = 'no') then
          Localize := False;

        s := VarToStr(Node.Attributes['resname']);
        if (s = '') then
          s := VarToStr(Node.Attributes['id']);
        if (s <> '') then
        begin
          // Build a property path from the resname value.
          // Old: I:FormSearch.I:PanelMain.O:PageControl.O:TabSheetTextSearch.O:TopPanel.O:Bevel1.Properties.LineOptions.Visible
          // New: FormSearch\PanelMain\PageControl\TabSheetTextSearch\TopPanel\Bevel1.Properties.LineOptions.Visible
          // Item name: FormSearch\PanelMain\PageControl\TabSheetTextSearch\TopPanel\Bevel1
          // Property name: Properties.LineOptions.Visible
          i := 1;
          while (i < Length(s)-1) do
          begin
            if (s[i] = 'I') or (s[i] = 'O') then
            begin
              if (s[i+1] = ':') then
              begin
                if (i > 1) and (s[i-1] = '.') then
                begin
                  Dec(i);
                  Delete(s, i, 1);
                end;
                Delete(s, i, 1);
                s[i] := '\';
              end;
            end;
            inc(i);
          end;

          // Property name starts at first '.'
          i := Pos('.', s);
          if (i > 0) then
          begin
            ItemName := Copy(s, 1, i-1);
            PropertyName := Copy(s, i+1);
          end else
          begin
            ItemName := s;
            PropertyName := '';
          end;
          ItemType := '';

          // Get Source value
          Child := Node.ChildNodes.FindNode('source');
          if (Child <> nil) then
          begin
            s := GetNodeText(Child);

            // Only quoted strings are translated
{$ifdef QUOTED_STRINGS}
            if (Localize) then
            begin
              if ((not s.StartsWith('''')) or (not s.EndsWith(''''))) and
                 ((not s.StartsWith('"'))  or (not s.EndsWith('"'))) then
                Localize := False;
            end;
{$endif QUOTED_STRINGS}

            SourceValue := Unescape(s);
          end else
            SourceValue := '';

          // Get Target value
          TranslationStatus := tsUnknown;
          TargetNode := Node.ChildNodes.FindNode('target');
          if (TargetNode <> nil) then
          begin
            s := GetNodeText(TargetNode);
            TargetValue := Unescape(s);

            Value := TargetNode.Attributes['state'];
            if (Value = 'final') then
              TranslationStatus := tsFinal
            else
            if (Value = 'translated') then
              TranslationStatus := tsTranslated
            else
            if (Value = 'signed-off') then
              TranslationStatus := tsApproved
            else
            if (Value = 'new') then
              TranslationStatus := tsUntranslated
            else
            if (Value = 'x-ignore') then
              TranslationStatus := tsDontTranslate
            else
            if (Value = 'x-unused') then
              TranslationStatus := tsUnused
            else
            if (Value = 'x-hold') then
              TranslationStatus := tsHold
            else
              TranslationStatus := tsUnknown;
          end else
            TargetValue := '';

          Child := Node.ChildNodes.FindNode('prop-group');

          if (Child <> nil) then
          begin
            PropChild := Child.ChildNodes.First;
            while (PropChild <> nil) do
            begin
              NextPropChild := PropChild.NextSibling;
              Value := PropChild.Attributes['prop-type'];
              if (Value = 'Type') then
              begin
                ItemType := PropChild.Text;
                if (ItemType.StartsWith('C:')) then
                  Delete(ItemType, 1, 2);
              end else
              if (Value = 'Localize') then
              begin
                // Ignore item if Localize=0
                if (PropChild.Text = '0') then
                  Localize := False;
              end else
              if (Value = 'Status') and (TranslationStatus = tsUnknown) then
              begin
                TranslationStatus := TETMTranslationStatus(StrToIntDef(PropChild.Text, Ord(tsUnknown)));

                // Change variations of Translated
                (*
                if (TranslationStatus in [tsAutoTranslated, tsNewlyTranslated]) then
                begin
                  TranslationStatus := tsTranslated;
                end else
                *)
                // Change "Untranslated" to "Don't translate" for non-string values
                // String in .dfn are ' delimited. Strings in .rcn are " delimited.
                if (TranslationStatus = tsUntranslated) then
                begin
                  if (Length(SourceValue) < 2) or (IsAnsi(SourceValue[1]) and (not(AnsiChar(SourceValue[1]) in ['"', '''']))) then
                    TranslationStatus := tsDontTranslate;
                end;

              end;
              PropChild := NextPropChild;
            end;

          end;

        end else
          Localize := False;


        if (Localize) then
        begin
          if (ItemName.StartsWith('\')) then
            Delete(ItemName, 1, 1);
          ItemName := ItemName.Replace('\', '.', [rfReplaceAll]);

          if (not ItemType.IsEmpty) then
          begin
            i := Pos(' ', ItemType);
            if (i > 0) then
              SetLength(ItemType, i -1);
          end;

          // Sanity check - don't add if node is invalid
          if (Localize) and (TranslationStatus in [tsEgged, tsUnknown]) then
          begin
            // Rescue "valid" translations without status or state
            if (TranslationStatus <> tsUnknown) or (TargetValue.IsEmpty) or (TargetValue = SourceValue) then
              Localize := False;
          end;

          if (Localize) then
          begin
            Prop := nil;
            if (not Delegate(Module, ItemName, ItemType, PropertyName, SourceValue, Prop)) then
              Exit(False);

            if (Prop <> nil) then
            begin
              // TODO : XLIFF should not modify language invariant properties
              case TranslationStatus of
                tsUnused:
                  Prop.SetState(ItemStateUnused);

                tsDontTranslate:
                  Prop.Status := ItemStatusDontTranslate;

                tsHold:
                  Prop.Status := ItemStatusHold;
              else
                Prop.Status := ItemStatusTranslate;
              end;

              if (TargetNode = nil) then
              begin
                if (TranslationStatusMap[TranslationStatus] in [tStatusProposed, tStatusTranslated]) then
                  // Translation without target value (implicit: target=source)
                  TargetValue := SourceValue
                else
                  Localize := False;
              end;

              if (Localize) then
              begin
                var NewStatus := TranslationStatusMap[TranslationStatus];

                // Mark new translation obsolete if source value has changed
                if (NewStatus in [tStatusProposed, tStatusTranslated]) and (SourceValue <> Prop.Value) then
                  NewStatus := tStatusObsolete;

                if (Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
                begin
                  if (Translation.Value <> TargetValue) or (Translation.Status <> NewStatus) then
                  begin
                    Translation.Update(TargetValue, NewStatus);
                    Inc(FTranslationCount.CountUpdated);
                  end else
                    Skip(skipUnchanged);
                end else
                begin
                  Prop.Translations.AddOrUpdateTranslation(TranslationLanguage, TargetValue, NewStatus);
                  Inc(FTranslationCount.CountAdded);
                end;
              end;
            end else
              Skip(skipNotFound);
          end;
        end;
      end;

      NextNode := Node.NextSibling;

      Node := NextNode;
    end;
  end;

  function FindModule(const BodyNode: IXMLNode): TLocalizerModule;
  var
    Module: TLocalizerModule;
  begin
    Module := nil;

    if (not ProcessNodes(BodyNode, nil,
      function(AModule: TLocalizerModule; const ItemName, ItemType, PropertyName, SourceValue: string; var Prop: TLocalizerProperty): boolean
      begin
        Result := Project.Traverse(
          function(Item: TLocalizerItem): boolean
          begin
            // Exit if we find an item name match
            Result := not AnsiSameText(Item.Name, ItemName);
            if (not Result) then
             Module := Item.Module;
          end);
      end)) then
    begin
      Assert(Module <> nil);
      Result := Module;
    end else
      Result := nil;
  end;

var
  ModuleName: string;
  ModuleKind: TLocalizerModuleKind;
  SourceFilename: string;
  XML: IXMLDocument;
  Header: IXMLNode;
  Body: IXMLNode;
  Node: IXMLNode;
  SourceLanguageName, TargetLanguageName: string;
resourcestring
  sXLIFFMissingModuleName = 'The XLIFF file does not specify a module name';
  sXLIFFMissingModuleNamePrompt = 'Please specify which module to import the translations into.';
  sXLIFFLanguageMismatchTitle = 'Source language mismatch';
  sXLIFFLanguageMismatch = 'The source language of the project does not match the source language of the import file.'#13#13+
    'Project source language: %s'#13+
    'Import source language: %s';
begin
  XML := TXMLDocument.Create(nil);
  XML.Options := [doNodeAutoIndent];
  XML.Active := True;

  XML.LoadFromStream(Stream);

  if (XML.DocumentElement.NodeName <> 'xliff') then
    raise Exception.CreateFmt('XML document root node is not named "xliff": %s', [XML.DocumentElement.NodeName]);

  Node := XML.DocumentElement.ChildNodes.FindNode('file');
  if (Node = nil) then
    raise Exception.Create('xliff node not found: xliff\file');

  SourceLanguageName := Node.Attributes['source-language'];
  TargetLanguageName := Node.Attributes['target-language'];

  // Translate Language Name to Locale ID
  var SourceLanguageItem := LanguageInfo.FindLocaleName(SourceLanguageName);
  if (SourceLanguageItem = nil) then
    SourceLanguageItem := LanguageInfo.FindISO3166Name(SourceLanguageName);
  if (SourceLanguageItem = nil) then
    SourceLanguageItem := LanguageInfo.FindLanguageShortName(SourceLanguageName);
  if (SourceLanguageItem = nil) then
    SourceLanguageItem := LanguageInfo.FindLanguageName(SourceLanguageName);
  if (SourceLanguageItem = nil) then
    SourceLanguageItem := LanguageInfo.FindCountry(SourceLanguageName);

  if (SourceLanguageItem = nil) then
    raise Exception.CreateFmt('Unknown source language: %s', [SourceLanguageName]);

  // Translate Language Name to Locale ID
  var TargetLanguageItem := LanguageInfo.FindLocaleName(TargetLanguageName);
  if (TargetLanguageItem = nil) then
    TargetLanguageItem := LanguageInfo.FindISO3166Name(TargetLanguageName);
  if (TargetLanguageItem = nil) then
    TargetLanguageItem := LanguageInfo.FindLanguageShortName(TargetLanguageName);
  if (TargetLanguageItem = nil) then
    TargetLanguageItem := LanguageInfo.FindLanguageName(TargetLanguageName);
  if (TargetLanguageItem = nil) then
    TargetLanguageItem := LanguageInfo.FindCountry(TargetLanguageName);

  if (TargetLanguageItem = nil) then
    raise Exception.CreateFmt('Unknown target language: %s', [TargetLanguageName]);

  // Verify that module source language matches project
  if (SourceLanguageItem.LocaleName <> Project.SourceLanguage.LocaleName) then
  begin
    if (TaskMessageDlg(sXLIFFLanguageMismatchTitle,
      Format(sXLIFFLanguageMismatch, [Project.SourceLanguage.LanguageName, SourceLanguageItem.LanguageName]),
      mtWarning, [mbIgnore, mbAbort], 0, mbAbort) = mrAbort) then
      Exit(nil);
  end;

  SourceFilename := Node.Attributes['original'];
  if (SourceFilename = '') then
    SourceFilename := Node.Attributes['ts'];

  if (Node.Attributes['datatype'] ='delphiform') then
    ModuleKind := mkForm
  else
  if (AnsiSameText(TPath.GetExtension(Filename), '.rcn')) then
    ModuleKind := mkString
  else
  if (AnsiSameText(TPath.GetExtension(Filename), '.dfn')) then
    ModuleKind := mkForm
  else
  if (SourceFilename <> '') and (AnsiSameText(TPath.GetExtension(SourceFilename), '.drc')) then
    ModuleKind := mkString
  else
    ModuleKind := mkForm;

  if (ModuleKind = mkString) then
    ModuleName := sModuleNameResourcestrings
  else
    ModuleName := '';

  Header := Node.ChildNodes.FindNode('header');

  Body := Node.ChildNodes.FindNode('body');
  if (Body = nil) then
    raise Exception.Create('xliff node not found: xliff\file\body');

  // If the XLIFF doesn't specify the module name (Delphi doesn't store the
  // name for DFM XLIFFs) then we will have to search for a match between
  // the items in the XLIFF and the existing items in the project.
  // Another possibility would be to parse the item names and deduce the
  // module name from that.
  if (ModuleName = '') then
  begin
    Assert(ModuleKind = mkForm);
    Result := FindModule(Body);

    // If we still haven't got a module name then we must ask the user for it.
    if  (Result = nil) then
    begin
      var DialogSelectModule := DialogManager.CreateDialog(IDialogSelectModule) as IDialogSelectModule;
      Result := DialogSelectModule.Execute(Project, sXLIFFMissingModuleName, sXLIFFMissingModuleNamePrompt);
      if (Result = nil) then
        Exit(nil);
    end;
  end else
    Result := Project.AddModule(ModuleName);

  if (Result.Kind = mkOther) then
    Result.Kind := ModuleKind;

  TranslationLanguage := Result.Project.TranslationLanguages.Add(TargetLanguageItem);

  FillChar(FTranslationCount, SizeOf(FTranslationCount), 0);

  Project.BeginUpdate;
  try

    ProcessNodes(Body, Result,
      function(Module: TLocalizerModule; const ItemName, ItemType, PropertyName, SourceValue: string; var Prop: TLocalizerProperty): boolean
      var
        Item: TLocalizerItem;
      begin
        Item := Module.FindItem(ItemName, True);
        if (Item <> nil) then
          Prop := Item.FindProperty(PropertyName, True)
        else
          Prop := nil;

        Result := True;
      end);

  finally
    Project.EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

end.
