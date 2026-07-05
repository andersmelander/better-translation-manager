unit amLocalization.Data.ModuleItemsDataSource;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  cxCustomData,
  amLocalization.Model;


// -----------------------------------------------------------------------------
//
// TLocalizerModuleItemsDataSource
//
// -----------------------------------------------------------------------------
// Custom data source for the module items grid.
// -----------------------------------------------------------------------------
type
  TTranslationMemoryPeekResult = (prNone, prQueued, prFound);

  TLocalizerModuleItemsDataSource = class(TcxCustomDataSource)
  strict private
    const
      ItemIndexName             = 0;
      ItemIndexType             = 1;
      ItemIndexValueName        = 2;
      ItemIndexID               = 3;
      ItemIndexPriority         = 4;
      ItemIndexStatus           = 5;
      ItemIndexEffectiveStatus  = 6;
      ItemIndexState            = 7;
      ItemIndexSourceValue      = 8;
      ItemIndexTargetValue      = 9;
  strict private
    type
      TItem = record
        Prop: TLocalizerProperty;
        PeekResult: TTranslationMemoryPeekResult;
      end;
  strict private
    FModule: TLocalizerModule;
    FTranslationLanguage: TTranslationLanguage;
    FItems: array of TItem;
  private
    procedure LoadData;
    function GetPeekResult(Index: integer): TTranslationMemoryPeekResult;
    procedure SetPeekResult(Index: integer; const Value: TTranslationMemoryPeekResult);
  protected
    procedure SetModule(const Value: TLocalizerModule);
    procedure SetTranslationLanguage(const Value: TTranslationLanguage);
    function GetProperty(Index: integer): TLocalizerProperty;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
  public
    constructor Create(AModule: TLocalizerModule);
    destructor Destroy; override;

    procedure DataChanged; override;

    function IndexOfItem(Item: TLocalizerItem): integer;
    function IndexOfProperty(Prop: TLocalizerProperty): integer;
    procedure Clear;
    procedure Refresh;

    property Module: TLocalizerModule read FModule write SetModule;
    property TranslationLanguage: TTranslationLanguage read FTranslationLanguage write SetTranslationLanguage;

    property RecordCount: integer read GetRecordCount;
    property Properties[Index: integer]: TLocalizerProperty read GetProperty;
    property PeekResult[Index: integer]: TTranslationMemoryPeekResult read GetPeekResult write SetPeekResult;
  end;

implementation

uses
  Variants;

// -----------------------------------------------------------------------------
//
// TLocalizerModuleItemsDataSource
//
// -----------------------------------------------------------------------------
procedure TLocalizerModuleItemsDataSource.Clear;
begin
  FTranslationLanguage := nil;
  Module := nil;
end;

constructor TLocalizerModuleItemsDataSource.Create(AModule: TLocalizerModule);
begin
  inherited Create;

  Module := AModule;
end;

procedure TLocalizerModuleItemsDataSource.DataChanged;
begin
  inherited;

  // Work around for DevExpress bug t918956
  // https://supportcenter.devexpress.com/ticket/details/t918956
  DataController.DataControllerInfo.ClearSelectionAnchor;
end;

destructor TLocalizerModuleItemsDataSource.Destroy;
begin
  inherited;
end;

function TLocalizerModuleItemsDataSource.GetPeekResult(Index: integer): TTranslationMemoryPeekResult;
begin
  Result := FItems[Index].PeekResult;
end;

procedure TLocalizerModuleItemsDataSource.SetPeekResult(Index: integer; const Value: TTranslationMemoryPeekResult);
begin
  FItems[Index].PeekResult := Value;
end;

function TLocalizerModuleItemsDataSource.GetProperty(Index: integer): TLocalizerProperty;
begin
  Result := FItems[Index].Prop;
end;

function TLocalizerModuleItemsDataSource.GetRecordCount: Integer;
begin
  Result := Length(FItems);
end;

function TLocalizerModuleItemsDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
var
  ItemIndex: integer;
  Prop: TLocalizerProperty;
  Translation: TLocalizerTranslation;
begin
  if (Integer(ARecordHandle) < 0) then
    Exit('');

  Prop := FItems[Integer(ARecordHandle)].Prop;
  ItemIndex := GetDefaultItemID(integer(AItemHandle));

  case ItemIndex of
    ItemIndexName:
      Result := Prop.Item.Name;

    ItemIndexType:
      Result := Prop.Item.TypeName;

    ItemIndexValueName:
      Result := Prop.Name;

    ItemIndexID:
      Result := Prop.Item.ResourceID;

    ItemIndexStatus:
      Result := Ord(Prop.Status);

    ItemIndexEffectiveStatus:
      Result := Ord(Prop.EffectiveStatus);

    ItemIndexState:
      if (Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
        Result := Ord(Translation.Status)
      else
        Result := Ord(tStatusPending);

    ItemIndexSourceValue:
      Result := Prop.Value;

    ItemIndexTargetValue:
      // Don't use Prop.TranslatedValue[] here. We need to get "obsolete" values too
      if (Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
        Result := Translation.Value
      else
        Result := Prop.Value;

    ItemIndexPriority:
      Result := Prop.Priority;

  else
    Result := Null;
  end;
end;

function TLocalizerModuleItemsDataSource.IndexOfItem(Item: TLocalizerItem): integer;
begin
  Result := Length(FItems)-1;
  while (Result >= 0) and (FItems[Result].Prop.Item <> Item) do
    Dec(Result);
end;

function TLocalizerModuleItemsDataSource.IndexOfProperty(Prop: TLocalizerProperty): integer;
begin
  Result := Length(FItems)-1;
  while (Result >= 0) and (FItems[Result].Prop <> Prop) do
    Dec(Result);
end;

procedure TLocalizerModuleItemsDataSource.LoadData;
var
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
  n: integer;
begin
  if (FModule = nil) then
  begin
    SetLength(FItems, 0);
    Exit;
  end;

  n := 0;
  for Item in FModule.Items.Values.ToArray do
    Inc(n, Item.Properties.Count);

  SetLength(FItems, n);

  n := 0;
  for Item in FModule.Items.Values.ToArray do
    for Prop in Item.Properties.Values.ToArray do
    begin
      FItems[n].Prop := Prop;
      FItems[n].PeekResult := prNone;
      Inc(n);
    end;
end;

procedure TLocalizerModuleItemsDataSource.Refresh;
begin
  LoadData;

  DataChanged;
end;

procedure TLocalizerModuleItemsDataSource.SetModule(const Value: TLocalizerModule);
begin
  if (FModule = Value) then
    Exit;

  FModule := Value;
  LoadData;

  DataChanged;
end;

procedure TLocalizerModuleItemsDataSource.SetTranslationLanguage(const Value: TTranslationLanguage);
begin
  if (FTranslationLanguage = Value) then
    Exit;

  FTranslationLanguage := Value;

  DataChanged;
end;

procedure TLocalizerModuleItemsDataSource.SetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle; const AValue: Variant);
var
  ItemIndex: integer;
  Prop: TLocalizerProperty;
  Translation: TLocalizerTranslation;
  TranslationStatus: TTranslationStatus;
begin
  if (Integer(ARecordHandle) < 0) then
    Exit;

  Prop := FItems[Integer(ARecordHandle)].Prop;
  ItemIndex := GetDefaultItemID(integer(AItemHandle));

  case ItemIndex of
    ItemIndexStatus:
      if (VarIsOrdinal(AValue)) then
        Prop.Status := TLocalizerItemStatus(AValue);

    ItemIndexState:
      if (VarIsOrdinal(AValue)) then
      begin
        TranslationStatus := TTranslationStatus(AValue);

        if (TranslationStatus = tStatusPending) then
        begin
          // Remove translation
          Prop.Translations.Remove(TranslationLanguage);
        end else
        begin
          // Add translation if we haven't already got one
          if (not Prop.Translations.TryGetTranslation(TranslationLanguage, Translation)) then
            Translation := Prop.Translations.AddOrUpdateTranslation(TranslationLanguage, Prop.Value);
          Translation.Status := TranslationStatus;
        end;
      end;

    ItemIndexTargetValue:
      begin
        Translation := Prop.Translations.AddOrUpdateTranslation(TranslationLanguage, VarToStr(AValue));
        Translation.UpdateWarnings;

        FItems[Integer(ARecordHandle)].PeekResult := TTranslationMemoryPeekResult.prNone;
      end;

    ItemIndexPriority:
      if (VarIsOrdinal(AValue)) then
        Prop.Priority := AValue;

  end;
end;

end.
