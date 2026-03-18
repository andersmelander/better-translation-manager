unit amLocalization.Export.XLIFF;

(*
 * Copyright © 2026 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  System.Classes,
  amLocalization.Model;

// -----------------------------------------------------------------------------
//
// TLocalizerXLIFFWriter
//
// -----------------------------------------------------------------------------
// Exports a BTM project in XLIFF 2.0 format
// - https://docs.oasis-open.org/xliff/xliff-core/v2.0/xliff-core-v2.0.html
//
// Mapping:
//   Module -> file
//   Item -> group
//   Property -> unit
//
// -----------------------------------------------------------------------------
type
  TLocalizerXLIFFWriter = class
  private
    FWriter: TTextWriter;
    FLanguage: TTranslationLanguage;
    FIndent: string;
    FLevel: integer;

  private
    procedure BeginTag(const Tag: string; const Attributes: string = ''); overload;
    procedure BeginTag(const Tag: string; const AFormat: string; const AArgs: array of const); overload;
    procedure EndTag(const Tag: string);
    procedure WriteTag(const Tag: string; const Content: string = '');

    procedure WriteIndent;
    procedure WriteLine(const S: string);

    function EscapeXml(const Value: string): string;
    function NMToken(const Value: string): string;

    procedure WriteProperty(AProp: TLocalizerProperty; var Index: integer);
    procedure WriteItem(AItem: TLocalizerItem; var Index: integer);
    procedure WriteModule(AModule: TLocalizerModule);

  public
    constructor Create(AWriter: TTextWriter; ALanguage: TTranslationLanguage);

    procedure Write(AProject: TLocalizerProject); overload;
    procedure Write(AModule: TLocalizerModule); overload;
  end;


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  System.SysUtils,
  amLanguageInfo;

constructor TLocalizerXLIFFWriter.Create(AWriter: TTextWriter; ALanguage: TTranslationLanguage);
begin
  inherited Create;
  FWriter := AWriter;
  FLanguage := ALanguage;
  FIndent := '';
end;

procedure TLocalizerXLIFFWriter.BeginTag(const Tag, AFormat: string; const AArgs: array of const);
begin
  BeginTag(Tag, Format(AFormat, AArgs));
end;

procedure TLocalizerXLIFFWriter.BeginTag(const Tag, Attributes: string);
begin
  if (Attributes <> '') then
    WriteLine(Format('<%s %s>', [Tag, Attributes]))
  else
    WriteLine(Format('<%s>', [Tag]));

  Inc(FLevel);
end;

procedure TLocalizerXLIFFWriter.EndTag(const Tag: string);
begin
  Dec(FLevel);
  WriteLine(Format('</%s>', [Tag]));
end;

procedure TLocalizerXLIFFWriter.WriteIndent;
begin
  if (FLevel = 0) then
    exit;

  if (FLevel * 2 > Length(FIndent)) then
    FIndent := FIndent + '  ';

  FWriter.Write(Copy(FIndent, 1, FLevel * 2));
end;

procedure TLocalizerXLIFFWriter.WriteLine(const S: string);
begin
  WriteIndent;
  FWriter.WriteLine(S);
end;

procedure TLocalizerXLIFFWriter.WriteTag(const Tag: string; const Content: string);
begin
  if (Content = '') then
    WriteLine('<' + Tag + '/>')
  else
    WriteLine('<' + Tag + '>' + EscapeXml(Content) + '</' + Tag + '>');
end;

function TLocalizerXLIFFWriter.EscapeXml(const Value: string): string;
begin
  // TODO : See TLocalizationProjectFiler.EncodeString

  Result := Value;

  Result := Result.Replace('&', '&amp;');
  Result := Result.Replace('<', '&lt;');
  Result := Result.Replace('>', '&gt;');
  Result := Result.Replace('"', '&quot;');
  Result := Result.Replace('''', '&apos;');
end;

function TLocalizerXLIFFWriter.NMToken(const Value: string): string;
begin
  Result := Value;

  Result := Result.Replace('[', ':');
  Result := Result.Replace(']', ':');
end;

procedure TLocalizerXLIFFWriter.Write(AProject: TLocalizerProject);
begin
  WriteLine('<?xml version="1.0" encoding="UTF-8"?>');
  BeginTag('xliff', 'version="2.0" xmlns="urn:oasis:names:tc:xliff:document:2.0" srcLang="%s" trgLang="%s"', [AProject.SourceLanguage.LocaleName, FLanguage.Language.LocaleName]);

  AProject.Traverse(
    function(Module: TLocalizerModule): boolean
    begin
      if (Module.Status = ItemStatusTranslate) and (not Module.IsUnused) then
        WriteModule(Module);
      Result := True;
    end, True);

  EndTag('xliff');
end;

procedure TLocalizerXLIFFWriter.Write(AModule: TLocalizerModule);
begin
  WriteLine('<?xml version="1.0" encoding="UTF-8"?>');
  BeginTag('xliff', 'version="2.0" xmlns="urn:oasis:names:tc:xliff:document:2.0" srcLang="%s" trgLang="%s"', [AModule.Project.SourceLanguage.LocaleName, FLanguage.Language.LocaleName]);

  if (AModule.Status = ItemStatusTranslate) and (not AModule.IsUnused) then
    WriteModule(AModule);

  EndTag('xliff');
end;

procedure TLocalizerXLIFFWriter.WriteModule(AModule: TLocalizerModule);
begin
  if (AModule.StatusCount[ItemStatusTranslate] = 0) then
    exit;

  BeginTag('file', 'id="%s" original="%s"', [EscapeXml(AModule.Name), EscapeXml(AModule.Name)]);

  // Sequential property counter for use by properties that have no ID (i.e. resourcestrings)
  var Index: integer := 0;

  AModule.Traverse(
    function(Item: TLocalizerItem): boolean
    begin
      if (Item.Status = ItemStatusTranslate) and (not Item.IsUnused) then
        WriteItem(Item, Index);
      Result := True;
    end, True);

  EndTag('file');
end;

procedure TLocalizerXLIFFWriter.WriteItem(AItem: TLocalizerItem; var Index: integer);
begin
  if (AItem.StatusCount[ItemStatusTranslate] = 0) then
    exit;

  var ItemName := NMToken(AItem.Name);
  BeginTag('group', 'id="%s"', [ItemName]);

  var PropIndex := Index;

  AItem.Traverse(
    function(Prop: TLocalizerProperty): boolean
    begin
      if (Prop.Status = ItemStatusTranslate) and (not Prop.IsUnused) then
        WriteProperty(Prop, PropIndex);

      Result := True;
    end, True);

  Index := PropIndex;

  EndTag('group');
end;

procedure TLocalizerXLIFFWriter.WriteProperty(AProp: TLocalizerProperty; var Index: integer);
var
  Translation: TLocalizerTranslation;
  TargetValue: string;
  State: string;
  TranslateAttr: string;
const
  sXliffStates: array[TTranslationStatus] of string = (
    'initial',          // tStatusObsolete
    'initial',          // tStatusPending
    'translated',       // tStatusProposed
    'final'             // tStatusTranslated
  );
begin
  if (AProp.EffectiveStatus = ItemStatusDontTranslate) then
    TranslateAttr := ' translate="no"'
  else
    TranslateAttr := '';

  // <unit id> must be unique within <file>.
  // For properties, we use Use Item.Name+Prop.Name to make it so.
  // For resourcestrings, we use a unique integer ID.
  var UnitID: string;
  if (AProp.Item.Module.Kind = mkString) then
  begin
    UnitID := IntToStr(Index);
    Inc(Index);
  end else
  begin
    var ItemName := NMToken(AProp.Item.Name);
    var PropName := NMToken(AProp.Name);
    UnitID := ItemName + '.' + PropName;
  end;

  BeginTag('unit', 'id="%s"%s', [UnitID, TranslateAttr]);

  var IsObsolete := False;
  var SubState := '';
  if AProp.Translations.TryGetTranslation(FLanguage, Translation) then
  begin
    TargetValue := Translation.Value;
    State := sXliffStates[Translation.Status];
    IsObsolete := (Translation.Status = tStatusObsolete);
  end else
  begin
    TargetValue := '';
    State := 'initial';
  end;

  if IsObsolete then
  begin
    // <notes> must appear before <segment>
    BeginTag('notes');
    WriteTag('note', 'Obsolete translation');
    EndTag('notes');

    SubState := ' subState="btm_status:obsolete"';
  end;

  BeginTag('segment', 'state="%s"%s', [State, SubState]);
  WriteTag('source', AProp.Value);
  if (TargetValue <> '') then
    WriteTag('target', TargetValue);
  EndTag('segment');

  EndTag('unit');
end;

end.
