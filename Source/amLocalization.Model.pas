unit amLocalization.Model;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  Generics.Collections,
  Generics.Defaults,
  Winapi.Windows, System.Classes,
  amLanguageInfo,
  amLocalization.Normalization;

const
  sModuleNameResourcestrings = 'resourcestrings';

type
  TCustomLocalizerItem = class;
  TLocalizerModule = class;
  TLocalizerItem = class;
  TLocalizerProperty = class;
  TLocalizerTranslation = class;

  TLocalizerModules = TObjectDictionary<string, TLocalizerModule>;
  TLocalizerItems = TObjectDictionary<string, TLocalizerItem>;
  TLocalizerProperties = TObjectDictionary<string, TLocalizerProperty>;

  TLocalizerObjectDelegate = reference to procedure(Item: TCustomLocalizerItem);
  TLocalizerModuleDelegate = reference to function(Item: TLocalizerModule): boolean;
  TLocalizerItemDelegate = reference to function(Item: TLocalizerItem): boolean;
  TLocalizerPropertyDelegate = reference to function(Prop: TLocalizerProperty): boolean;
  TLocalizerTranslationDelegate = reference to function(Prop: TLocalizerProperty; Translation: TLocalizerTranslation): boolean;

  TLocalizerItemState = (
    ItemStateNew,               // Item has been added since last update
    ItemStateUnused,            // Item has been removed since first update/last purge
    ItemStateUpdating           // Item is waiting for update.
                                // ItemStateUpdating flag is set by BeginLoad, cleared by Find*, and
                                // converted to ItemStateUnused by EndLoad.
    );
  TLocalizerItemStates = set of TLocalizerItemState;

  TLocalizerItemStatus = (ItemStatusTranslate, ItemStatusHold, ItemStatusDontTranslate);

  TLocalizerModuleKind = (mkOther, mkForm, mkString);
  TLocalizerModuleKinds = set of TLocalizerModuleKind;


// -----------------------------------------------------------------------------
//
// TTranslationLanguage
//
// -----------------------------------------------------------------------------
  TTranslationLanguage = class
  private
    FLanguage: TLanguageItem;
    FTranslatedCount: integer;
  public
    constructor Create(ALanguage: TLanguageItem);

    property Language: TLanguageItem read FLanguage;
    property TranslatedCount: integer read FTranslatedCount write FTranslatedCount;
  end;


// -----------------------------------------------------------------------------
//
// TTranslationLanguageList
//
// -----------------------------------------------------------------------------
  TTranslationLanguageList = class
  private
    FLanguages: TObjectDictionary<TLanguageItem, TTranslationLanguage>;
  protected
    function GetCount: integer;
    function GetItem(Index: integer): TTranslationLanguage;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(Language: TLanguageItem): TTranslationLanguage;
    procedure Remove(Language: TLanguageItem);
    procedure Delete(Index: integer);
    procedure Clear;
    function Find(Language: TLanguageItem): TTranslationLanguage;
    function Contains(Language: TLanguageItem): boolean;

    property Count: integer read GetCount;
    property Languages[Index: integer]: TTranslationLanguage read GetItem; default;

    function GetEnumerator: TEnumerator<TTranslationLanguage>;
  end;


// -----------------------------------------------------------------------------
//
// TBaseLocalizerItem
//
// -----------------------------------------------------------------------------
  TBaseLocalizerItem = class abstract
  strict private
    FName: string;
    FUpdateCount: integer;
    FChanged: boolean;
  strict protected
    procedure SetName(const Value: string); virtual;
    procedure DoChanged; virtual; abstract;
    procedure ClearChanged;
  protected
  public
    constructor Create(const AName: string);

    procedure Clear; virtual; abstract;

    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Changed;

    function Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean = False): boolean; virtual; abstract;

    property Name: string read FName write SetName;
  end;


// -----------------------------------------------------------------------------
//
// TLocalizerProject
//
// -----------------------------------------------------------------------------
  TLocalizerProjectState = (ProjectStateLoading);
  TLocalizerProjectStates = set of TLocalizerProjectState;

  TLocalizerModuleEvent = procedure(Module: TLocalizerModule) of object;
  TLocalizerTranslationEvent = procedure(Translation: TLocalizerTranslation) of object;

  TLocalizerPropertyList = TList<TLocalizerProperty>;

  ILocalizerProjectPropertyLookup = interface
    ['{4C3E4018-8F6B-469D-B417-A08484B926C6}']
    function Lookup(const Value: string): TLocalizerPropertyList; overload; // Lookup of sanitized value
    function Lookup(const Prop: TLocalizerProperty): TLocalizerPropertyList; overload;
  end;

  TLocalizerProject = class(TBaseLocalizerItem)
  strict private
    FSourceFilename: string;
    FStringSymbolFilename: string;
    FModules: TLocalizerModules;
    FSourceLanguage: TLanguageItem;
    FTranslationLanguages: TTranslationLanguageList;
    FState: TLocalizerProjectStates;
    FLoadCount: integer;
    FPropertyCount: integer;
    FStatusCount: array[TLocalizerItemStatus] of integer;
    FTranslatedCount: TDictionary<TTranslationLanguage, integer>;
    FModified: boolean;
    FUpdateCount: integer;
    FOnChanged: TNotifyEvent;
    FOnModuleChanged: TLocalizerModuleEvent;
    FOnTranslationWarning: TLocalizerTranslationEvent;
  strict protected
    procedure DoChanged; override;
    procedure SetModified(const Value: boolean);
    function GetStatusCount(Status: TLocalizerItemStatus): integer;
    function GetTranslatedCount(Language: TTranslationLanguage): integer;
    procedure SetItemStateRecursive(Value: TLocalizerItemState);
  protected
    procedure UpdateStatusCount(Status: TLocalizerItemStatus; Delta: integer);
    procedure UpdateTranslatedCount(Language: TTranslationLanguage; Delta: integer);
    procedure ModuleChanged(Module: TLocalizerModule);
    procedure NotifyWarnings(Translation: TLocalizerTranslation);
  public
    constructor Create(const AName: string; ASourceLanguage: TLanguageItem);
    destructor Destroy; override;

    procedure Clear; override;
    function Purge: boolean;

    function AddModule(const AName: string; Kind: TLocalizerModuleKind = mkOther): TLocalizerModule;
    function FindModule(const AName: string; IgnoreUnused: boolean = False): TLocalizerModule;

    procedure BeginLoad(MarkUpdating: boolean = False);
    procedure EndLoad(ClearUpdating: boolean = False; MarkUnused: boolean = False);

    function Traverse(Delegate: TLocalizerModuleDelegate; Sorted: boolean = False): boolean; reintroduce; overload;
    function Traverse(Delegate: TLocalizerItemDelegate; Sorted: boolean = False): boolean; reintroduce; overload;
    function Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean = False): boolean; reintroduce; overload; override;
    function Traverse(Delegate: TLocalizerPropertyDelegate; Kinds: TLocalizerModuleKinds; Sorted: boolean = False): boolean; reintroduce; overload;

    function CreatePropertyLookup(SanitizeRules: TSanitizeRules): ILocalizerProjectPropertyLookup;

    property State: TLocalizerProjectStates read FState;

    property SourceFilename: string read FSourceFilename write FSourceFilename;
    property StringSymbolFilename: string read FStringSymbolFilename write FStringSymbolFilename;

    property SourceLanguage: TLanguageItem read FSourceLanguage write FSourceLanguage;
    property TranslationLanguages: TTranslationLanguageList read FTranslationLanguages;

    property Modules: TLocalizerModules read FModules;

    property Modified: boolean read FModified write SetModified;

    // Total number of properties with State<>ItemStateUnused
    property PropertyCount: integer read FPropertyCount;
    // Property count by status, State<>ItemStateUnused
    property StatusCount[Status: TLocalizerItemStatus]: integer read GetStatusCount;
    property TranslatedCount[Language: TTranslationLanguage]: integer read GetTranslatedCount;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnModuleChanged: TLocalizerModuleEvent read FOnModuleChanged write FOnModuleChanged;
    property OnTranslationWarning: TLocalizerTranslationEvent read FOnTranslationWarning write FOnTranslationWarning;
  end;


// -----------------------------------------------------------------------------
//
// TCustomLocalizerItem
//
// -----------------------------------------------------------------------------
  TCustomLocalizerItem = class abstract(TBaseLocalizerItem)
  strict private
    FState: TLocalizerItemStates;
    FStatus: TLocalizerItemStatus;
    FPriority: integer;
    // FStatusCount holds the accumulated sum of the *actual* status of the item.
    // For parent items the sum is that of its children's FStatusCount
    FStatusCount: array[TLocalizerItemStatus] of integer;
    FTranslatedCount: TDictionary<TTranslationLanguage, integer>;
  strict protected
    procedure UpdateParentStatusCount(AStatus: TLocalizerItemStatus; Delta: integer); virtual; abstract;
    procedure UpdateParentTranslatedCount(Language: TTranslationLanguage; Delta: integer); virtual; abstract;

    procedure SetStatus(const Value: TLocalizerItemStatus);
    procedure DoSetStatus(const Value: TLocalizerItemStatus); virtual;
    procedure ApplyParentStatusChange(const Value: TLocalizerItemStatus);
    procedure ApplyDirectStatusChange(const Value: TLocalizerItemStatus);
    function GetState: TLocalizerItemStates; virtual;
    function GetInheritParentState: boolean; virtual;
    function GetEffectiveStatus: TLocalizerItemStatus; virtual;
    function GetStatusCount(AStatus: TLocalizerItemStatus): integer;
    function GetTranslatedCount(Language: TTranslationLanguage): integer;
    function GetIsUnused: boolean;
    procedure SetPriority(const Value: integer);
  protected
    procedure UpdateStatusCount(AStatus: TLocalizerItemStatus; Delta: integer);
    procedure UpdateTranslatedCount(Language: TTranslationLanguage; Delta: integer);
    function CalculateEffectiveStatus(AStatus: TLocalizerItemStatus): TLocalizerItemStatus;
    procedure NotifyWarnings(Translation: TLocalizerTranslation); virtual; abstract;
  public
    constructor Create(const AName: string);
    destructor Destroy; override;

    property State: TLocalizerItemStates read GetState;
    procedure SetState(const Value: TLocalizerItemState);
    procedure ClearState(const Value: TLocalizerItemState);

    property Status: TLocalizerItemStatus read FStatus write SetStatus;
    property InheritParentState: boolean read GetInheritParentState;
    property EffectiveStatus: TLocalizerItemStatus read GetEffectiveStatus;
    // Shortcut to test for ItemStateUnused
    property IsUnused: boolean read GetIsUnused;

    property Priority: integer read FPriority write SetPriority;

    property StatusCount[AStatus: TLocalizerItemStatus]: integer read GetStatusCount;
    property TranslatedCount[Language: TTranslationLanguage]: integer read GetTranslatedCount;
  end;


// -----------------------------------------------------------------------------
//
// TCustomLocalizerChildItem
//
// -----------------------------------------------------------------------------
  TCustomLocalizerChildItem<TParentClass: TCustomLocalizerItem> = class abstract(TCustomLocalizerItem)
  strict private
    FParent: TParentClass;
  strict protected
    procedure UpdateParentStatusCount(AStatus: TLocalizerItemStatus; Delta: integer); override;
    procedure UpdateParentTranslatedCount(Language: TTranslationLanguage; Delta: integer); override;
    procedure DoChanged; override;

    function GetState: TLocalizerItemStates; override;
    function GetInheritParentState: boolean; override;
    function GetEffectiveStatus: TLocalizerItemStatus; override;
  protected
    procedure NotifyWarnings(Translation: TLocalizerTranslation); override;
    function GetParent: TParentClass;
    property Parent: TParentClass read GetParent;
  public
    constructor Create(AParent: TParentClass; const AName: string);
  end;


// -----------------------------------------------------------------------------
//
// TLocalizerModule
//
// -----------------------------------------------------------------------------
  TLocalizerModule = class(TCustomLocalizerItem)
  strict private
    FProject: TLocalizerProject;
    FKind: TLocalizerModuleKind;
    FItems: TLocalizerItems;
  strict protected
    procedure SetName(const Value: string); override;
    procedure UpdateParentStatusCount(AStatus: TLocalizerItemStatus; Delta: integer); override;
    procedure UpdateParentTranslatedCount(Language: TTranslationLanguage; Delta: integer); override;
    procedure DoChanged; override;
  protected
    procedure NotifyWarnings(Translation: TLocalizerTranslation); override;
  public
    constructor Create(AProject: TLocalizerProject; const AName: string);
    destructor Destroy; override;

    property Project: TLocalizerProject read FProject;
    property Kind: TLocalizerModuleKind read FKind write FKind;
    property Items: TLocalizerItems read FItems;

    procedure Clear; override;
    function Purge: boolean;
    class function PurgeModule(Module: TLocalizerModule; KeepTranslations: boolean): boolean;

    function FindItem(const AName: string; IgnoreUnused: boolean = False): TLocalizerItem; overload;
    function FindItem(AResourceID: Word; IgnoreUnused: boolean = False): TLocalizerItem; overload;
    function AddItem(const AName, ATypeName: string): TLocalizerItem; overload;
    function AddItem(AResourceID: Word; const ATypeName: string): TLocalizerItem; overload;

    function Traverse(Delegate: TLocalizerItemDelegate; Sorted: boolean = False): boolean; reintroduce; overload;
    function Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean = False): boolean; overload; override;
  end;


// -----------------------------------------------------------------------------
//
// TLocalizerItem
//
// -----------------------------------------------------------------------------
  TLocalizerItem = class(TCustomLocalizerChildItem<TLocalizerModule>)
  strict private
    FResourceID: integer;
    FTypeName: string;
    FProperties: TLocalizerProperties;
  strict protected
    procedure SetName(const Value: string); override;
  public
    constructor Create(AModule: TLocalizerModule; const AName, ATypeName: string);
    destructor Destroy; override;

    procedure Clear; override;
    function Purge: boolean;
    class function PurgeItem(Item: TLocalizerItem; KeepTranslations: boolean): boolean;

    function FindProperty(const AName: string; IgnoreUnused: boolean = False; UpdateState: boolean = True): TLocalizerProperty;
    function AddProperty(const AName: string): TLocalizerProperty; overload;
    function AddProperty(const AName: string; const AValue: string): TLocalizerProperty; overload;

    function Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean = False): boolean; override;

    property Module: TLocalizerModule read GetParent;
    property ResourceID: integer read FResourceID write FResourceID;
    property TypeName: string read FTypeName write FTypeName;
    property Properties: TLocalizerProperties read FProperties;
  end;


// -----------------------------------------------------------------------------
//
// TLocalizerTranslation
//
// -----------------------------------------------------------------------------
  TTranslationStatus = (
    tStatusObsolete,            // Source value has changed. Translation is obsolete.
    tStatusPending,             // Translation has not been performed.
    tStatusProposed,            // Translation has been proposed
    tStatusTranslated           // Translation complete
    );
    // Note:
    // Status > tStatusPending is considered "translated".
    // Take this into consideration if adding values or changing the order.
    // See GetIsTranslated and SetStatus.

  TTranslationWarning = (
    tWarningEmptiness,          // Source or translation is empty and the other is not
    tWarningAccelerator,        // Accelerator count mismatch
    tWarningFormatSpecifier,    // Format specifier count mismatch
    tWarningLineBreak,          // Linebreak count mismatch
    tWarningLeadSpace,          // Leading space count mismatch
    tWarningTrailSpace,         // Trailing space count mismatch
    tWarningTerminator,         // Translation is terminated differently than source
    tWarningPipe,               // Pipe character count mismatch
    tWarningSurround            // Surround character mismatch
  );
  TTranslationWarnings = set of TTranslationWarning;

  TLocalizerTranslation = class
  strict private
    FValue: string;
    FLanguage: TTranslationLanguage;
    FStatus: TTranslationStatus;
    FOwner: TLocalizerProperty;
    FUpdateCount: integer;
    FChanged: boolean;
    FWarnings: TTranslationWarnings;
  strict protected
    procedure SetWarnings(const Value: TTranslationWarnings);
    function GetIsTranslated: boolean;
    procedure SetStatus(const Value: TTranslationStatus);
    procedure SetValue(const Value: string);
    procedure Changed;
    procedure NotifyWarnings;
  public
    constructor Create(AOwner: TLocalizerProperty; ALanguage: TTranslationLanguage);
    destructor Destroy; override;

    procedure BeginUpdate;
    procedure EndUpdate;

    property Owner: TLocalizerProperty read FOwner;

    procedure Update(const AValue: string; AStatus: TTranslationStatus); overload;
    procedure Update(const AValue: string); overload;
    procedure UpdateWarnings;

    property Value: string read FValue write SetValue;
    property Language: TTranslationLanguage read FLanguage;
    property Status: TTranslationStatus read FStatus write SetStatus;
    property IsTranslated: boolean read GetIsTranslated;
    property Warnings: TTranslationWarnings read FWarnings write SetWarnings;
  end;

  TLocalizerTranslations = class
  strict private
    FTranslations: TDictionary<TTranslationLanguage, TLocalizerTranslation>;
    FOwner: TLocalizerProperty;
  strict private
    class var FDefaultStatus: TTranslationStatus;
  strict protected
    function GetCount: integer;
    function GetItem(Language: TTranslationLanguage): TLocalizerTranslation; overload;
    function GetItem(Index: integer): TLocalizerTranslation; overload;
  protected
    property Translations: TDictionary<TTranslationLanguage, TLocalizerTranslation> read FTranslations;
  public
    class constructor Create; overload;
    constructor Create(AOwner: TLocalizerProperty); overload;
    destructor Destroy; override;

    procedure Clear;

    function TryGetTranslation(Language: TTranslationLanguage; var Value: TLocalizerTranslation): boolean;
    function FindTranslation(Language: TTranslationLanguage): TLocalizerTranslation;
    function AddOrUpdateTranslation(Language: TTranslationLanguage; const Value: string): TLocalizerTranslation; overload;
    function AddOrUpdateTranslation(Language: TTranslationLanguage; const Value: string; Status: TTranslationStatus): TLocalizerTranslation; overload;
    procedure Remove(Language: TTranslationLanguage);

    property Owner: TLocalizerProperty read FOwner;
    property Items[Language: TTranslationLanguage]: TLocalizerTranslation read GetItem; default;
    property Items[Index: integer]: TLocalizerTranslation read GetItem; default;
    property Count: integer read GetCount;

    class property DefaultStatus: TTranslationStatus read FDefaultStatus write FDefaultStatus;
  end;


// -----------------------------------------------------------------------------
//
// TLocalizerProperty
//
// -----------------------------------------------------------------------------
  TPropertyFlag = (
    FlagBookmark0,
    FlagBookmark1,
    FlagBookmark2,
    FlagBookmark3,
    FlagBookmark4,
    FlagBookmark5,
    FlagBookmark6,
    FlagBookmark7,
    FlagBookmark8,
    FlagBookmark9,
    FlagBookmarkA,
    FlagBookmarkB,
    FlagBookmarkC,
    FlagBookmarkD,
    FlagBookmarkE,
    FlagBookmarkF
  );
  TPropertyFlags = set of TPropertyFlag;

  TLocalizerProperty = class(TCustomLocalizerChildItem<TLocalizerItem>)
  strict private
    FValue: string;
    FTranslations: TLocalizerTranslations;
    FFlags: TPropertyFlags;
    FSynthesized: boolean;
  strict protected
    procedure SetValue(const Value: string);
    procedure SetFlags(const Value: TPropertyFlags);
    function GetTranslatedValue(Language: TTranslationLanguage): string;
    procedure SetTranslatedValue(Language: TTranslationLanguage; const Value: string);
    procedure DoSetStatus(const Value: TLocalizerItemStatus); override;
  public
    constructor Create(AItem: TLocalizerItem; const AName: string);
    destructor Destroy; override;

    procedure Clear; override;
    class function PurgeProperty(Prop: TLocalizerProperty; KeepTranslations: boolean): boolean;

    function Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean = False): boolean; overload; override;
    function Traverse(Delegate: TLocalizerTranslationDelegate): boolean; reintroduce; overload;

    function HasTranslation(Language: TTranslationLanguage): boolean;
    function TryGetTranslatedValue(Language: TTranslationLanguage; var TranslatedValue: string): boolean;

    property Item: TLocalizerItem read GetParent;
    property Value: string read FValue write SetValue;
    property TranslatedValue[Language: TTranslationLanguage]: string read GetTranslatedValue write SetTranslatedValue;

    property Translations: TLocalizerTranslations read FTranslations;

    procedure SetFlag(const Value: TPropertyFlag);
    procedure ClearFlag(const Value: TPropertyFlag);
    property Flags: TPropertyFlags read FFlags write SetFlags;

    property Synthesized: boolean read FSynthesized write FSynthesized;
  end;


// -----------------------------------------------------------------------------
//
// TTextComparer
//
// -----------------------------------------------------------------------------
type
  TTextComparer = class(TEqualityComparer<string>)
  public
    function GetHashCode(const Value: String): Integer; override;
    function Equals(const Left, Right: string): Boolean; override;
  end;

// Locale invariant text comparision. Use when sort order needs to be stable
// regardless of current user locale.
function InvariantCompareText(const S1, S2: string): Integer;
function InvariantSameText(const S1, S2: string): Boolean;

// -----------------------------------------------------------------------------
//
// String list handling
//
// -----------------------------------------------------------------------------
type
  TStringListHandling = (
    slIgnore,           // String list properties are not supported.
    slStringLines,      // String list propeties are handled as CR-delimited strings.
    slSplit             // Individual strings in string list propeties are handled as individual string properties.
    );

var
  StringListHandling: TStringListHandling = slSplit;

// -----------------------------------------------------------------------------
//
// Strings
//
// -----------------------------------------------------------------------------
resourcestring
  sTranslationValidationWarningEmptyness        = 'Source or translation is empty and the other is not';
  sTranslationValidationWarningAccelerator      = 'Accelerator count mismatch';
  sTranslationValidationWarningFormatSpecifier  = 'Format specifier count mismatch';
  sTranslationValidationWarningLineBreak        = 'Linebreak count mismatch';
  sTranslationValidationWarningLeadSpace        = 'Leading space count mismatch';
  sTranslationValidationWarningTrailSpace       = 'Trailing space count mismatch';
  sTranslationValidationWarningTerminator       = 'Translation is terminated differently than source';
  sTranslationValidationWarningPipe             = 'Pipe character count mismatch';
  sTranslationValidationWarningSurround         = 'Surround character mismatch';

const
  // Note: Must use PResStringRec or values will be of the language active at the time System._InitResStrings was called,
  // which means that the user language selection will not affect the values as it should.
  sTranslationValidationWarnings: array[TTranslationWarning] of PResStringRec = (
    @sTranslationValidationWarningEmptyness,
    @sTranslationValidationWarningAccelerator,
    @sTranslationValidationWarningFormatSpecifier,
    @sTranslationValidationWarningLineBreak,
    @sTranslationValidationWarningLeadSpace,
    @sTranslationValidationWarningTrailSpace,
    @sTranslationValidationWarningTerminator,
    @sTranslationValidationWarningPipe,
    @sTranslationValidationWarningSurround);

resourcestring
  sLocalizerItemStatusTranslate         = 'Translate';
  sLocalizerItemStatusHold              = 'Hold';
  sLocalizerItemStatusDontTranslate     = 'Don''t translate';

const
  sLocalizerItemStatus: array[TLocalizerItemStatus] of PResStringRec = (
    @sLocalizerItemStatusTranslate,
    @sLocalizerItemStatusHold,
    @sLocalizerItemStatusDontTranslate);

resourcestring
  sLocalizerTranslationStatusObsolete   = 'Obsolete';
  sLocalizerTranslationStatusPending    = 'Pending';
  sLocalizerTranslationStatusProposed   = 'Proposed';
  sLocalizerTranslationStatusTranslated = 'Translated';

const
  sLocalizerTranslationStatus: array[TTranslationStatus] of PResStringRec = (
    @sLocalizerTranslationStatusObsolete,
    @sLocalizerTranslationStatusPending,
    @sLocalizerTranslationStatusProposed,
    @sLocalizerTranslationStatusTranslated);

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  IOUtils,
  Variants,
  System.Character,
  System.SysUtils,
  System.Hash,
  TypInfo,
  XMLDoc, XMLIntf,
  amLocalization.Index;

function InvariantCompareText(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_INVARIANT, NORM_IGNORECASE, PChar(S1), Length(S1), PChar(S2), Length(S2)) - CSTR_EQUAL;
end;

function InvariantSameText(const S1, S2: string): Boolean;
begin
  Result := InvariantCompareText(S1, S2) = 0;
end;

// -----------------------------------------------------------------------------
//
// TTextComparer
//
// -----------------------------------------------------------------------------
function TTextComparer.Equals(const Left, Right: string): Boolean;
begin
  Result := (Length(Left) = Length(Right)) and (AnsiSameText(Left, Right));
end;

function TTextComparer.GetHashCode(const Value: String): Integer;
var
  s: string;
begin
  s := AnsiUppercase(Value);
  Result := THashBobJenkins.GetHashValue(s);
end;


// -----------------------------------------------------------------------------
//
// TCustomLocalizerItem
//
// -----------------------------------------------------------------------------
constructor TBaseLocalizerItem.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;

// -----------------------------------------------------------------------------

procedure TBaseLocalizerItem.SetName(const Value: string);
begin
  FName := Value;
end;

// -----------------------------------------------------------------------------

procedure TBaseLocalizerItem.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TBaseLocalizerItem.EndUpdate;
begin
  Dec(FUpdateCount);

  if (FChanged) and (FUpdateCount = 0) then
  begin
    DoChanged;
    ClearChanged;
  end;
end;

// -----------------------------------------------------------------------------

procedure TBaseLocalizerItem.Changed;
begin
  BeginUpdate;
  FChanged := True;
  EndUpdate;
end;

procedure TBaseLocalizerItem.ClearChanged;
begin
  FChanged := False;
end;


// -----------------------------------------------------------------------------
//
// TCustomLocalizerItem
//
// -----------------------------------------------------------------------------
constructor TCustomLocalizerItem.Create(const AName: string);
begin
  inherited Create(AName);
  FState := [ItemStateNew];
  FTranslatedCount := TDictionary<TTranslationLanguage, integer>.Create;
end;

destructor TCustomLocalizerItem.Destroy;
begin
  FTranslatedCount.Free;
  inherited;
end;

function TCustomLocalizerItem.GetInheritParentState: boolean;
begin
  Result := False;
end;

function TCustomLocalizerItem.GetState: TLocalizerItemStates;
begin
  Result := FState;
end;

procedure TCustomLocalizerItem.SetPriority(const Value: integer);
begin
  if (FPriority = Value) then
    exit;

  FPriority := Value;

  Changed;
end;

procedure TCustomLocalizerItem.SetState(const Value: TLocalizerItemState);
var
  TranslatedCount: TPair<TTranslationLanguage, integer>;
begin
  if (Value in FState) then
    Exit;

  // Note: We must call UpdateParentStatusCount before ItemStateUnused state is set
  // as UpdateParentStatusCount will not propagate if State=ItemStateUnused.
  if (Value = ItemStateUnused) then
  begin
    // Item is being disabled - Remove stats from parent
    UpdateParentStatusCount(ItemStatusTranslate, -FStatusCount[ItemStatusTranslate]);
    UpdateParentStatusCount(ItemStatusDontTranslate, -FStatusCount[ItemStatusDontTranslate]);
    UpdateParentStatusCount(ItemStatusHold, -FStatusCount[ItemStatusHold]);
    if (FStatus = ItemStatusTranslate) then
      for TranslatedCount in FTranslatedCount do
        UpdateParentTranslatedCount(TranslatedCount.Key, -TranslatedCount.Value);
  end;

  Include(FState, Value);

  if (Value = ItemStateUnused) then
    Changed;
end;

procedure TCustomLocalizerItem.ClearState(const Value: TLocalizerItemState);
var
  TranslatedCount: TPair<TTranslationLanguage, integer>;
begin
  if (not (Value in FState)) then
    Exit;

  Exclude(FState, Value);

  if (Value = ItemStateUnused) then
  begin
    // Item was enabled - Add stats back to parent
    UpdateParentStatusCount(ItemStatusTranslate, FStatusCount[ItemStatusTranslate]);
    UpdateParentStatusCount(ItemStatusDontTranslate, FStatusCount[ItemStatusDontTranslate]);
    UpdateParentStatusCount(ItemStatusHold, FStatusCount[ItemStatusHold]);
    if (FStatus = ItemStatusTranslate) then
      for TranslatedCount in FTranslatedCount do
        UpdateParentTranslatedCount(TranslatedCount.Key, TranslatedCount.Value);
  end;

  if (Value = ItemStateUnused) then
    Changed;
end;

procedure TCustomLocalizerItem.DoSetStatus(const Value: TLocalizerItemStatus);
begin
  ApplyParentStatusChange(Value);
end;

procedure TCustomLocalizerItem.ApplyDirectStatusChange(const Value: TLocalizerItemStatus);
var
  UpdateTranslated: boolean;
  TranslatedCount: TPair<TTranslationLanguage, integer>;
begin
  // Apply change in effective status count - Only used by property

  UpdateTranslated := ((FStatus = ItemStatusTranslate) <> (Value = ItemStatusTranslate));

  UpdateStatusCount(FStatus, -1);
  if (not (ItemStateUnused in FState)) then
  begin
    if (UpdateTranslated) and (FStatus = ItemStatusTranslate) then
      for TranslatedCount in FTranslatedCount do
        UpdateParentTranslatedCount(TranslatedCount.Key, -TranslatedCount.Value);
  end;

  FStatus := Value;

  UpdateStatusCount(FStatus, 1);
  if (not (ItemStateUnused in FState)) then
  begin
    if (UpdateTranslated) and (FStatus = ItemStatusTranslate) then
      for TranslatedCount in FTranslatedCount do
        UpdateParentTranslatedCount(TranslatedCount.Key, TranslatedCount.Value);
  end;
end;

procedure TCustomLocalizerItem.ApplyParentStatusChange(const Value: TLocalizerItemStatus);
var
  TranslatedCount: TPair<TTranslationLanguage, integer>;
begin
  if (ItemStateUnused in FState) then
    Exit;

  // Remove all counts belonging to this item from parent
  UpdateParentStatusCount(ItemStatusTranslate, -FStatusCount[ItemStatusTranslate]);
  UpdateParentStatusCount(ItemStatusHold, -FStatusCount[ItemStatusHold]);
  UpdateParentStatusCount(ItemStatusDontTranslate, -FStatusCount[ItemStatusDontTranslate]);
  if (FStatus = ItemStatusTranslate) then
    for TranslatedCount in FTranslatedCount do
      UpdateParentTranslatedCount(TranslatedCount.Key, -TranslatedCount.Value);

  FStatus := Value;

  // Reapply all counts belonging to this item to parent
  case FStatus of
    ItemStatusTranslate:
      begin
        UpdateParentStatusCount(ItemStatusTranslate, FStatusCount[ItemStatusTranslate]);
        UpdateParentStatusCount(ItemStatusHold, FStatusCount[ItemStatusHold]);
        UpdateParentStatusCount(ItemStatusDontTranslate, FStatusCount[ItemStatusDontTranslate]);
      end;

    ItemStatusHold:
      begin
        UpdateParentStatusCount(ItemStatusHold, FStatusCount[ItemStatusTranslate]+FStatusCount[ItemStatusHold]);
        UpdateParentStatusCount(ItemStatusDontTranslate, FStatusCount[ItemStatusDontTranslate]);
      end;

    ItemStatusDontTranslate:
      begin
        UpdateParentStatusCount(ItemStatusDontTranslate, FStatusCount[ItemStatusTranslate]+FStatusCount[ItemStatusHold]+FStatusCount[ItemStatusDontTranslate]);
      end;
  end;
  if (FStatus = ItemStatusTranslate) then
    for TranslatedCount in FTranslatedCount do
      UpdateParentTranslatedCount(TranslatedCount.Key, TranslatedCount.Value);

(* Another way - even more verbose:

  // Remove all counts belonging to this item from parent
  UpdateParentStatusCount(ItemStatusTranslate, -FStatusCount[ItemStatusTranslate]);
  UpdateParentStatusCount(ItemStatusHold, -FStatusCount[ItemStatusHold]);
  UpdateParentStatusCount(ItemStatusDontTranslate, -FStatusCount[ItemStatusDontTranslate]);

  FStatus := Value;

  // Reapply all counts belonging to this item to parent
  UpdateParentStatusCount(ItemStatusTranslate, FStatusCount[ItemStatusTranslate]);
  UpdateParentStatusCount(ItemStatusHold, FStatusCount[ItemStatusHold]);
  UpdateParentStatusCount(ItemStatusDontTranslate, FStatusCount[ItemStatusDontTranslate]);
*)
end;

procedure TCustomLocalizerItem.SetStatus(const Value: TLocalizerItemStatus);
begin
  if (FStatus = Value) then
    Exit;

  BeginUpdate;
  try
    DoSetStatus(Value);

    Changed;
  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomLocalizerItem.GetStatusCount(AStatus: TLocalizerItemStatus): integer;
begin
  if (not (ItemStateUnused in FState)) then
    Result := FStatusCount[AStatus]
  else
    Result := 0;
end;

function TCustomLocalizerItem.GetTranslatedCount(Language: TTranslationLanguage): integer;
begin
  if (ItemStateUnused in FState) or (not FTranslatedCount.TryGetValue(Language, Result)) then
    Result := 0;
end;

function TCustomLocalizerItem.GetIsUnused: boolean;
begin
  Result := (ItemStateUnused in State); // Note: Must use State to invoke virtual GetState!
end;

procedure TCustomLocalizerItem.UpdateStatusCount(AStatus: TLocalizerItemStatus; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  Inc(FStatusCount[AStatus], Delta);

  Assert(FStatusCount[AStatus] >= 0);

  if (not (ItemStateUnused in FState)) then
    UpdateParentStatusCount(AStatus, Delta);
end;

procedure TCustomLocalizerItem.UpdateTranslatedCount(Language: TTranslationLanguage; Delta: integer);
var
  Value: integer;
begin
  if (Delta = 0) then
    Exit;

  if (not FTranslatedCount.TryGetValue(Language, Value)) then
    Value := 0;

  Inc(Value, Delta);

  Assert(Value >= 0);

  FTranslatedCount.AddOrSetValue(Language, Value);

  if (not (ItemStateUnused in FState)) and (Status = ItemStatusTranslate) then
    UpdateParentTranslatedCount(Language, Delta);
end;

function TCustomLocalizerItem.GetEffectiveStatus: TLocalizerItemStatus;
begin
  Result := Status;
end;

function TCustomLocalizerItem.CalculateEffectiveStatus(AStatus: TLocalizerItemStatus): TLocalizerItemStatus;
begin
  Result := EffectiveStatus;
  if (AStatus >= Result) then
    Result := AStatus;
end;


// -----------------------------------------------------------------------------
//
// TCustomLocalizerChildItem
//
// -----------------------------------------------------------------------------
constructor TCustomLocalizerChildItem<TParentClass>.Create(AParent: TParentClass; const AName: string);
begin
  inherited Create(AName);
  FParent := AParent;
end;

// -----------------------------------------------------------------------------

procedure TCustomLocalizerChildItem<TParentClass>.DoChanged;
begin
  FParent.Changed;
end;

// -----------------------------------------------------------------------------

function TCustomLocalizerChildItem<TParentClass>.GetEffectiveStatus: TLocalizerItemStatus;
begin
  Result := Parent.CalculateEffectiveStatus(Status);
end;

function TCustomLocalizerChildItem<TParentClass>.GetInheritParentState: boolean;
begin
  //  If the parent is unused, the children are also unused.
  //  If the parent is new, the children are also new.
  Result := ([ItemStateUnused, ItemStateNew] * Parent.State <> []);
end;

function TCustomLocalizerChildItem<TParentClass>.GetParent: TParentClass;
begin
  Result := FParent;
end;

function TCustomLocalizerChildItem<TParentClass>.GetState: TLocalizerItemStates;
begin
  if (InheritParentState) then
    Result := Parent.State
  else
    Result := inherited GetState;
end;

procedure TCustomLocalizerChildItem<TParentClass>.UpdateParentStatusCount(AStatus: TLocalizerItemStatus; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  FParent.UpdateStatusCount(AStatus, Delta);
end;

procedure TCustomLocalizerChildItem<TParentClass>.UpdateParentTranslatedCount(Language: TTranslationLanguage; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  FParent.UpdateTranslatedCount(Language, Delta);
end;

// -----------------------------------------------------------------------------

procedure TCustomLocalizerChildItem<TParentClass>.NotifyWarnings(Translation: TLocalizerTranslation);
begin
  FParent.NotifyWarnings(Translation);
end;


// -----------------------------------------------------------------------------
//
// TTranslationLanguage
//
// -----------------------------------------------------------------------------
constructor TTranslationLanguage.Create(ALanguage: TLanguageItem);
begin
  inherited Create;

  FLanguage := ALanguage;
end;

// -----------------------------------------------------------------------------
//
// TTranslationLanguageList
//
// -----------------------------------------------------------------------------
constructor TTranslationLanguageList.Create;
begin
  inherited Create;

  FLanguages := TObjectDictionary<TLanguageItem, TTranslationLanguage>.Create([doOwnsValues]);
end;

destructor TTranslationLanguageList.Destroy;
begin
  FLanguages.Free;
  inherited;
end;

function TTranslationLanguageList.Add(Language: TLanguageItem): TTranslationLanguage;
begin
  if (not FLanguages.TryGetValue(Language, Result)) then
  begin
    Result := TTranslationLanguage.Create(Language);
    FLanguages.Add(Language, Result);
  end;
end;

procedure TTranslationLanguageList.Clear;
begin
  FLanguages.Clear;
end;

function TTranslationLanguageList.Contains(Language: TLanguageItem): boolean;
begin
  Result := FLanguages.ContainsKey(Language);
end;

procedure TTranslationLanguageList.Delete(Index: integer);
begin
  FLanguages.Remove(FLanguages.Keys.ToArray[Index]);
end;

function TTranslationLanguageList.Find(Language: TLanguageItem): TTranslationLanguage;
begin
  if (not FLanguages.TryGetValue(Language, Result)) then
    Result := nil;
end;

function TTranslationLanguageList.GetCount: integer;
begin
  Result := FLanguages.Count;
end;

function TTranslationLanguageList.GetEnumerator: TEnumerator<TTranslationLanguage>;
begin
  Result := FLanguages.Values.GetEnumerator;
end;

function TTranslationLanguageList.GetItem(Index: integer): TTranslationLanguage;
begin
  Result := FLanguages.Values.ToArray[Index];
end;

procedure TTranslationLanguageList.Remove(Language: TLanguageItem);
begin
  FLanguages.Remove(Language);
end;


// -----------------------------------------------------------------------------
//
// TLocalizerProject
//
// -----------------------------------------------------------------------------
constructor TLocalizerProject.Create(const AName: string; ASourceLanguage: TLanguageItem);
begin
  inherited Create(AName);
  FModules := TLocalizerModules.Create([doOwnsValues], TTextComparer.Create);
  FTranslationLanguages := TTranslationLanguageList.Create;
  FTranslatedCount := TDictionary<TTranslationLanguage, integer>.Create;
  FSourceLanguage := ASourceLanguage;
end;

destructor TLocalizerProject.Destroy;
begin
  FOnChanged := nil;
  FOnModuleChanged := nil;
  FModules.Free;
  FTranslationLanguages.Free;
  FTranslatedCount.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TLocalizerProject.CreatePropertyLookup(SanitizeRules: TSanitizeRules): ILocalizerProjectPropertyLookup;
begin
  Result := TLocalizerProjectPropertyLookup.Create(Self, SanitizeRules);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.SetModified(const Value: boolean);
begin
  FModified := Value;

  if (not FModified) then
    ClearChanged;
end;

procedure TLocalizerProject.DoChanged;
begin
  FModified := True;

  if (Assigned(FOnChanged)) then
    FOnChanged(Self);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.Clear;
var
  Status: TLocalizerItemStatus;
begin
  FModules.Clear;
  FTranslationLanguages.Clear;
  FPropertyCount := 0;
  for Status := Low(TLocalizerItemStatus) to High(TLocalizerItemStatus) do
    FStatusCount[Status] := 0;
end;

// -----------------------------------------------------------------------------

function TLocalizerProject.Purge: boolean;
var
  Module: TLocalizerModule;
begin
  Result := False;
  for Module in Modules.Values.ToArray do // ToArray for stability since we delete from dictionary
  begin
    if (Module.Kind = mkOther) or (ItemStateUnused in Module.State) then
    begin
      Module.Free;
      Result := True;
      continue;
    end;

    if (Module.Purge) then
      Result := True;

    (*
    Do not delete empty module.
    If it has become empty because it's marked "Don't Translate" (or whatever)
    and we delete it, then the "Don't Translate" status will be lost and the
    module will reappear without "Don't Translate" next time we update the
    project.

    if (Module.Items.Count = 0) then
    begin
      Module.Free;
      Result := True;
    end;
    *)
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.BeginLoad(MarkUpdating: boolean);
var
  Module: TLocalizerModule;
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
begin
  Inc(FLoadCount);
  if (FLoadCount = 1) then
  begin
    Include(FState, ProjectStateLoading);

    if (MarkUpdating) then
    begin
      BeginUpdate;
      try
        for Module in Modules.Values do
        begin
          Module.SetState(ItemStateUpdating);

          for Item in Module.Items.Values do
          begin
            Item.SetState(ItemStateUpdating);

            for Prop in Item.Properties.Values do
              Prop.SetState(ItemStateUpdating);
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
  end;
end;

procedure TLocalizerProject.EndLoad(ClearUpdating, MarkUnused: boolean);
var
  Module: TLocalizerModule;
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
begin
  Dec(FLoadCount);
  if (FLoadCount = 0) then
  begin
    // Referencing an item during "load" will clear the ItemStateUpdating flag set in BeginLoad.
    // Any items that still have ItemStateUpdating set in EndLoad will have ItemStateUnused set instead.
    // This way we can mark the items that were not refenced during update/import/etc.
    if (ClearUpdating or MarkUnused) then
    begin
      BeginUpdate;
      try
        for Module in Modules.Values do
        begin
          if (ItemStateUpdating in Module.State) then
          begin
            if (MarkUnused) then
              Module.SetState(ItemStateUnused);

            if (ClearUpdating) then
              Module.ClearState(ItemStateUpdating);
          end;

          for Item in Module.Items.Values do
          begin
            if (ItemStateUpdating in Item.State) then
            begin
              if (MarkUnused) then
                Item.SetState(ItemStateUnused);

              if (ClearUpdating) then
                Item.ClearState(ItemStateUpdating);
            end;

            for Prop in Item.Properties.Values do
              if (ItemStateUpdating in Prop.State) then
              begin
                if (MarkUnused) then
                  Prop.SetState(ItemStateUnused);

                if (ClearUpdating) then
                  Prop.ClearState(ItemStateUpdating);
              end;
          end;
        end;
      finally
        EndUpdate;
      end;
    end;
    Exclude(FState, ProjectStateLoading);
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.ModuleChanged(Module: TLocalizerModule);
begin
  if (FUpdateCount = 0) and (Assigned(FOnModuleChanged)) then
    FOnModuleChanged(Module);

  Changed;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.NotifyWarnings(Translation: TLocalizerTranslation);
begin
  if (Assigned(FOnTranslationWarning)) then
    FOnTranslationWarning(Translation);
end;

// -----------------------------------------------------------------------------

function TLocalizerProject.GetStatusCount(Status: TLocalizerItemStatus): integer;
begin
  Result := FStatusCount[Status];
end;

function TLocalizerProject.GetTranslatedCount(Language: TTranslationLanguage): integer;
begin
  if (not FTranslatedCount.TryGetValue(Language, Result)) then
    Result := 0;
end;

procedure TLocalizerProject.UpdateStatusCount(Status: TLocalizerItemStatus; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  Inc(FPropertyCount, Delta);
  Assert(FPropertyCount >= 0);

  Inc(FStatusCount[Status], Delta);
  Assert(FStatusCount[Status] >= 0);
end;

procedure TLocalizerProject.UpdateTranslatedCount(Language: TTranslationLanguage; Delta: integer);
var
  Value: integer;
begin
  if (Delta = 0) then
    Exit;

  if (not FTranslatedCount.TryGetValue(Language, Value)) then
    Value := 0;

  Inc(Value, Delta);

  Assert(Value >= 0);

  FTranslatedCount.AddOrSetValue(Language, Value);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProject.SetItemStateRecursive(Value: TLocalizerItemState);
var
  Module: TLocalizerModule;
  Item: TLocalizerItem;
  Prop: TLocalizerProperty;
begin
  BeginUpdate;
  try
    for Module in Modules.Values do
    begin
      Module.SetState(Value);
      for Item in Module.Items.Values do
      begin
        Item.SetState(Value);
        for Prop in Item.Properties.Values do
          Prop.SetState(Value);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

function TLocalizerProject.Traverse(Delegate: TLocalizerModuleDelegate; Sorted: boolean): boolean;
var
  SortedModules: TArray<TLocalizerModule>;
  Module: TLocalizerModule;
begin
  Result := True;

  SortedModules := Modules.Values.ToArray;

  if (Sorted) then
    TArray.Sort<TLocalizerModule>(SortedModules, TComparer<TLocalizerModule>.Construct(
      function(const Left, Right: TLocalizerModule): Integer
      begin
        Result := (Ord(Right.Kind) - Ord(Left.Kind)); // Reversed to order resourcestrings before forms
        if (Result = 0) then
          Result := InvariantCompareText(Left.Name, Right.Name);
      end));

  for Module in SortedModules do
    if (not Delegate(Module)) then
      Exit(False);
end;

function TLocalizerProject.Traverse(Delegate: TLocalizerItemDelegate; Sorted: boolean): boolean;
begin
  Result := Traverse(
    function(Module: TLocalizerModule): boolean
    begin
      Result := Module.Traverse(Delegate, Sorted);
    end, Sorted);
end;

function TLocalizerProject.Traverse(Delegate: TLocalizerPropertyDelegate; Kinds: TLocalizerModuleKinds; Sorted: boolean): boolean;
begin
  Result := Traverse(
    function(Module: TLocalizerModule): boolean
    begin
      if (Module.Kind in Kinds) then
        Result := Module.Traverse(Delegate, Sorted)
      else
        Result := True;
    end, Sorted);
end;

function TLocalizerProject.Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean): boolean;
begin
  Result := Traverse(
    function(Module: TLocalizerModule): boolean
    begin
      Result := Module.Traverse(Delegate, Sorted);
    end, Sorted);
end;

// -----------------------------------------------------------------------------

function TLocalizerProject.AddModule(const AName: string; Kind: TLocalizerModuleKind): TLocalizerModule;
begin
  Result := FindModule(AName);

  if (Result = nil) then
  begin
    Result := TLocalizerModule.Create(Self, AName);
    Result.Kind := Kind;
  end;
end;

function TLocalizerProject.FindModule(const AName: string; IgnoreUnused: boolean): TLocalizerModule;
begin
  if (FModules.TryGetValue(AName, Result)) and ((not IgnoreUnused) or (not Result.IsUnused)) then
  begin
    if (ProjectStateLoading in State) then
      Result.ClearState(ItemStateNew);
    Result.ClearState(ItemStateUpdating);
    Result.ClearState(ItemStateUnused);
  end else
    Result := nil;
end;


// -----------------------------------------------------------------------------
//
// TLocalizerModule
//
// -----------------------------------------------------------------------------
constructor TLocalizerModule.Create(AProject: TLocalizerProject; const AName: string);
begin
  inherited Create(AName);
  FItems := TLocalizerItems.Create([doOwnsValues], TTextComparer.Create);
  BeginUpdate;
  try
    FProject := AProject;
    FProject.Modules.Add(Name, Self);
    Changed;
  finally
    EndUpdate;
  end;
end;

destructor TLocalizerModule.Destroy;
begin
  BeginUpdate; // No EndUpdate

  Clear;
  FProject.Modules.ExtractPair(Name);
  FItems.Free;

  inherited;
end;

// -----------------------------------------------------------------------------

function TLocalizerModule.Purge: boolean;
var
  Item: TLocalizerItem;
begin
  Result := False;

  BeginUpdate;
  try
    for Item in FItems.Values.ToArray do // ToArray for stability since we delete from dictionary
    begin
      if (ItemStateUnused in Item.State) then
      begin
        Item.Free;
        Result := True;
        continue;
      end;

      if (Item.Purge) then
        Result := True;

      (*
      Do not delete empty item.
      See explanation in TLocalizerProject.Purge

      if (Item.Properties.Count = 0) then
      begin
        Item.Free;
        Result := True;
      end;
      *)
    end;

    if (Result) then
      Changed;
  finally
    EndUpdate;
  end;
end;

class function TLocalizerModule.PurgeModule(Module: TLocalizerModule; KeepTranslations: boolean): boolean;
begin
  Result := False;

  Module.BeginUpdate;
  try

    if (KeepTranslations) or (not Module.IsUnused) then
    begin
      for var Item in Module.Items.Values.ToArray do // ToArray for stability since we delete from dictionary
        TLocalizerItem.PurgeItem(Item, KeepTranslations);
    end;

  finally
    Module.EndUpdate;
  end;

  // Do not delete empty entity unless it's unused.
  // See explanation in TLocalizerProject.Purge

  if (Module.IsUnused) then
  begin
    // Delete Module if we are deleting unconditionally or the Module has no items left
    if (not KeepTranslations) or (Module.Status = ItemStatusDontTranslate) or (Module.Items.Count = 0) then
    begin
      Result := True;
      Module.Changed;
      Module.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerModule.Clear;
begin
  BeginUpdate;
  try

    FItems.Clear;

  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerModule.DoChanged;
begin
  FProject.ModuleChanged(Self);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerModule.SetName(const Value: string);
begin
  if (Name = Value) then
    exit;

  BeginUpdate;
  try
    FProject.Modules.ExtractPair(Name);

    inherited SetName(Value);

    FProject.Modules.Add(Name, Self);

    Changed;
  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerModule.UpdateParentStatusCount(AStatus: TLocalizerItemStatus; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  if (not (ItemStateUnused in State)) then
    // Update project with the effective status
    FProject.UpdateStatusCount(CalculateEffectiveStatus(AStatus), Delta);
end;

procedure TLocalizerModule.UpdateParentTranslatedCount(Language: TTranslationLanguage; Delta: integer);
begin
  if (Delta = 0) then
    Exit;

  if (not (ItemStateUnused in State)) then
    // Update project with the effective status
    FProject.UpdateTranslatedCount(Language, Delta);
end;

// -----------------------------------------------------------------------------

function TLocalizerModule.Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean): boolean;
begin
  Result := Traverse(
    function(Item: TLocalizerItem): boolean
    begin
      Result := Item.Traverse(Delegate, Sorted);
    end, Sorted);
end;

function TLocalizerModule.Traverse(Delegate: TLocalizerItemDelegate; Sorted: boolean): boolean;
var
  SortedItems: TArray<TLocalizerItem>;
  Item: TLocalizerItem;
begin
  Result := True;

  SortedItems := Items.Values.ToArray;

  if (Sorted) then
    TArray.Sort<TLocalizerItem>(SortedItems, TComparer<TLocalizerItem>.Construct(
      function(const Left, Right: TLocalizerItem): Integer
      begin
        Result := (Ord(Left.Module.Kind) - Ord(Right.Module.Kind));
        if (Result = 0) then
        begin
          if (Left.Module.Kind = mkForm) or ((Left.ResourceID = 0) and  (Right.ResourceID = 0)) then
            Result := InvariantCompareText(Left.Name, Right.Name)
          else
          begin
            if (Left.ResourceID = 0) then
              Result := -1
            else
            if (Right.ResourceID = 0) then
              Result := 1
            else
            if (Left.ResourceID > Right.ResourceID) then
              Result := 1
            else
            if (Left.ResourceID < Right.ResourceID) then
              Result := -1
            else
              Result := 0;
          end;
        end;
      end));

  for Item in SortedItems do
    if (not Delegate(Item)) then
      Exit(False);
end;

// -----------------------------------------------------------------------------

function TLocalizerModule.FindItem(const AName: string; IgnoreUnused: boolean): TLocalizerItem;
begin
  if (FItems.TryGetValue(AName, Result)) and ((not IgnoreUnused) or (not Result.IsUnused)) then
  begin
    if (ProjectStateLoading in Project.State) then
      Result.ClearState(ItemStateNew);
    Result.ClearState(ItemStateUpdating);
    Result.ClearState(ItemStateUnused);
  end else
    Result := nil;
end;

function TLocalizerModule.FindItem(AResourceID: Word; IgnoreUnused: boolean): TLocalizerItem;
var
  Item: TPair<string, TLocalizerItem>;
begin
  Result := FindItem(IntToStr(AResourceID), IgnoreUnused);

  if (Result = nil) then
    for Item in Items do
      if (Item.Value.ResourceID = AResourceID) and ((not IgnoreUnused) or (not Result.IsUnused)) then
      begin
        Result := Item.Value;
        if (ProjectStateLoading in Project.State) then
          Result.ClearState(ItemStateNew);
        Result.ClearState(ItemStateUpdating);
        Result.ClearState(ItemStateUnused);
        break;
      end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerModule.NotifyWarnings(Translation: TLocalizerTranslation);
begin
  FProject.NotifyWarnings(Translation);
end;

// -----------------------------------------------------------------------------

function TLocalizerModule.AddItem(const AName, ATypeName: string): TLocalizerItem;
begin
  Result := FindItem(AName);
  if (Result = nil) then
    Result := TLocalizerItem.Create(Self, AName, ATypeName);
end;

function TLocalizerModule.AddItem(AResourceID: Word; const ATypeName: string): TLocalizerItem;
begin
  Result := FindItem(AResourceID);

  if (Result = nil) then
  begin
    Result := TLocalizerItem.Create(Self, IntToStr(AResourceID), ATypeName);
    Result.ResourceID := AResourceID;
  end;
end;


// -----------------------------------------------------------------------------
//
// TLocalizerItem
//
// -----------------------------------------------------------------------------
constructor TLocalizerItem.Create(AModule: TLocalizerModule; const AName, ATypeName: string);
begin
  inherited Create(AModule, AName);
  FProperties := TLocalizerProperties.Create([doOwnsValues], TTextComparer.Create);
  FResourceID := -1;

  BeginUpdate;
  try
    FTypeName := ATypeName;
    Module.Items.Add(Name, Self);
    Changed;
  finally
    EndUpdate;
  end;
end;

destructor TLocalizerItem.Destroy;
begin
  BeginUpdate;
  try
    Clear;
    Module.Items.ExtractPair(Name);
    FProperties.Free;
    Changed;
  finally
    EndUpdate;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

function TLocalizerItem.Purge: boolean;
var
  Prop: TLocalizerProperty;
begin
  Result := False;
  BeginUpdate;
  try

    for Prop in Properties.Values.ToArray do // ToArray for stability since we delete from dictionary
      if (ItemStateUnused in Prop.State) then
      begin
        Prop.Free;
        Result := True;
      end;

    if (Result) then
      Changed;
  finally
    EndUpdate;
  end;
end;

class function TLocalizerItem.PurgeItem(Item: TLocalizerItem; KeepTranslations: boolean): boolean;
begin
  Result := False;

  Item.BeginUpdate;
  try

    if ((KeepTranslations) or (not Item.IsUnused)) and (Item.Status <> ItemStatusDontTranslate)  then
    begin
      for var Prop in Item.Properties.Values.ToArray do // ToArray for stability since we delete from dictionary
        TLocalizerProperty.PurgeProperty(Prop, KeepTranslations);
    end;

  finally
    Item.EndUpdate;
  end;

  // Do not delete empty entity unless it's unused.
  // See explanation in TLocalizerProject.Purge

  if (Item.IsUnused) then
  begin
    // Delete Item if we are deleting unconditionally or the Item has no properties left
    if (not KeepTranslations) or (Item.Status = ItemStatusDontTranslate) or (Item.Properties.Count = 0) then
    begin
      Result := True;
      Item.Changed;
      Item.Free;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerItem.Clear;
begin
  BeginUpdate;
  try

    FProperties.Clear;

  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerItem.SetName(const Value: string);
begin
  if (Name = Value) then
    exit;

  BeginUpdate;
  try
    Module.Items.ExtractPair(Name);

    inherited SetName(Value);

    Module.Items.Add(Name, Self);

    Changed;
  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

function TLocalizerItem.Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean): boolean;
var
  SortedProps: TArray<TLocalizerProperty>;
  Prop: TLocalizerProperty;
begin
  Result := True;

  SortedProps := Properties.Values.ToArray;

  if (Sorted) then
    TArray.Sort<TLocalizerProperty>(SortedProps, TComparer<TLocalizerProperty>.Construct(
      function(const Left, Right: TLocalizerProperty): Integer
      begin
        Result := InvariantCompareText(Left.Name, Right.Name);
      end));

  for Prop in SortedProps do
    if (not Delegate(Prop)) then
      Exit(False);
end;

// -----------------------------------------------------------------------------

function TLocalizerItem.FindProperty(const AName: string; IgnoreUnused: boolean; UpdateState: boolean): TLocalizerProperty;
begin
  if (FProperties.TryGetValue(AName, Result)) and ((not IgnoreUnused) or (not Result.IsUnused)) then
  begin
    if (ProjectStateLoading in Module.Project.State) then
      Result.ClearState(ItemStateNew);

    if (UpdateState) then
      Result.ClearState(ItemStateUpdating);

    Result.ClearState(ItemStateUnused);
  end else
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TLocalizerItem.AddProperty(const AName: string): TLocalizerProperty;
begin
  Result := FindProperty(AName);

  if (Result = nil) then
    Result := TLocalizerProperty.Create(Self, AName);
end;

function TLocalizerItem.AddProperty(const AName, AValue: string): TLocalizerProperty;
begin
  BeginUpdate;
  try
    Result := AddProperty(AName);
    Result.Value := AValue;
  finally
    EndUpdate;
  end;
end;


// -----------------------------------------------------------------------------
//
// TLocalizerProperty
//
// -----------------------------------------------------------------------------
constructor TLocalizerProperty.Create(AItem: TLocalizerItem; const AName: string);
begin
  inherited Create(AItem, AName);
  BeginUpdate;
  try
    Item.Properties.Add(Name, Self);
    FTranslations := TLocalizerTranslations.Create(Self);
    UpdateStatusCount(Status, 1);
    Changed;
  finally
    EndUpdate;
  end;
end;

destructor TLocalizerProperty.Destroy;
begin
  BeginUpdate;
  try
    UpdateStatusCount(Status, -1);
    Clear;
    Item.Properties.ExtractPair(Name);
    FTranslations.Free;
    Changed;
  finally
    EndUpdate;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProperty.Clear;
begin
  BeginUpdate;
  try

    FTranslations.Clear;

  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProperty.DoSetStatus(const Value: TLocalizerItemStatus);
begin
  ApplyDirectStatusChange(Value);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProperty.SetTranslatedValue(Language: TTranslationLanguage; const Value: string);
begin
  Translations.AddOrUpdateTranslation(Language, Value);
end;

function TLocalizerProperty.GetTranslatedValue(Language: TTranslationLanguage): string;
var
  Translation: TLocalizerTranslation;
begin
  if (Translations.TryGetTranslation(Language, Translation)) and (Translation.IsTranslated) then
    Result := Translation.Value
  else
    Result := Value;
end;

function TLocalizerProperty.TryGetTranslatedValue(Language: TTranslationLanguage; var TranslatedValue: string): boolean;
var
  Translation: TLocalizerTranslation;
begin
  Result := (Translations.TryGetTranslation(Language, Translation)) and (Translation.IsTranslated);
  if (Result) then
    TranslatedValue := Translation.Value;
end;

// -----------------------------------------------------------------------------

function TLocalizerProperty.HasTranslation(Language: TTranslationLanguage): boolean;
var
  Translation: TLocalizerTranslation;
begin
  Result := (Translations.TryGetTranslation(Language, Translation)) and (Translation.IsTranslated);
end;

// -----------------------------------------------------------------------------

class function TLocalizerProperty.PurgeProperty(Prop: TLocalizerProperty; KeepTranslations: boolean): boolean;
begin
  if (not Prop.IsUnused) then
    Exit(False);

  if (KeepTranslations) and (Prop.Status <> ItemStatusDontTranslate) then
    // Keep property if it has translations
    for var Translation in Prop.Translations.Translations.Values do
      if (Translation.IsTranslated) then
        Exit(False);

  Result := True;
  Prop.Changed;
  Prop.Free;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProperty.SetValue(const Value: string);
var
  Translation: TPair<TTranslationLanguage, TLocalizerTranslation>;
begin
  if (FValue = Value) then
    exit;

  BeginUpdate;
  try

    // If value changes then all existing translations are obsolete
    for Translation in FTranslations.Translations do
      if (Translation.Value.IsTranslated) then
        Translation.Value.Status := tStatusObsolete;

    FValue := Value;

    Changed;

  finally
    EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerProperty.SetFlags(const Value: TPropertyFlags);
begin
  if (FFlags = Value) then
    Exit;

  FFlags := Value;

  Changed;
end;

procedure TLocalizerProperty.SetFlag(const Value: TPropertyFlag);
begin
  if (Value in FFlags) then
    Exit;

  if (Value in [FlagBookmark0..FlagBookmark9]) then
    FFlags := FFlags - [FlagBookmark0..FlagBookmark9] + [Value]
  else
    Include(FFlags, Value);

  Changed;
end;

procedure TLocalizerProperty.ClearFlag(const Value: TPropertyFlag);
begin
  if (not (Value in FFlags)) then
    Exit;

  Exclude(FFlags, Value);

  Changed;
end;

// -----------------------------------------------------------------------------

function TLocalizerProperty.Traverse(Delegate: TLocalizerPropertyDelegate; Sorted: boolean): boolean;
begin
  Result := Delegate(Self);
end;

function TLocalizerProperty.Traverse(Delegate: TLocalizerTranslationDelegate): boolean;
var
  Translation: TPair<TTranslationLanguage, TLocalizerTranslation>;
begin
  Result := True;

  for Translation in FTranslations.Translations do
    if (not Delegate(Self, Translation.Value)) then
      Exit(False);
end;


// -----------------------------------------------------------------------------
//
// TLocalizerTranslation
//
// -----------------------------------------------------------------------------
constructor TLocalizerTranslation.Create(AOwner: TLocalizerProperty; ALanguage: TTranslationLanguage);
begin
  inherited Create;
  FOwner := AOwner;
  FLanguage := ALanguage;
//  FLanguage.Translations.Add(Self);
end;

destructor TLocalizerTranslation.Destroy;
begin
//  FLanguage.Translations.Remove(Self);

  if (IsTranslated) then
  begin
    Dec(FLanguage.FTranslatedCount);
    FOwner.UpdateTranslatedCount(FLanguage, -1);
  end;

  Warnings := [];

  inherited;
end;

// -----------------------------------------------------------------------------

function TLocalizerTranslation.GetIsTranslated: boolean;
begin
  Result := (FStatus > tStatusPending);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerTranslation.NotifyWarnings;
begin
  FOwner.NotifyWarnings(Self);
end;

// -----------------------------------------------------------------------------

procedure TLocalizerTranslation.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TLocalizerTranslation.EndUpdate;
begin
  Dec(FUpdateCount);
  if (FChanged) and (FUpdateCount = 0) then
  begin
    Owner.Changed;
    FChanged := False;
  end;
end;

procedure TLocalizerTranslation.Changed;
begin
  BeginUpdate;
  FChanged := True;
  EndUpdate;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerTranslation.SetStatus(const Value: TTranslationStatus);
var
  OldStatus: TTranslationStatus;
begin
  if (FStatus = Value) then
    Exit;

  BeginUpdate;
  try

    OldStatus := FStatus;

    FStatus := Value;

    if (OldStatus <= tStatusPending) and (Value > tStatusPending) then
    begin
      Inc(FLanguage.FTranslatedCount);
      FOwner.UpdateTranslatedCount(FLanguage, 1);
    end else
    if (OldStatus > tStatusPending) and (Value <= tStatusPending) then
    begin
      Dec(FLanguage.FTranslatedCount);
      FOwner.UpdateTranslatedCount(FLanguage, -1);
      FWarnings := [];
    end;

    Changed;

  finally
    EndUpdate;
  end;
end;

procedure TLocalizerTranslation.SetValue(const Value: string);
begin
  if (FValue = Value) then
    Exit;

  FValue := Value;
  UpdateWarnings;

  Changed;
end;

procedure TLocalizerTranslation.SetWarnings(const Value: TTranslationWarnings);
var
  OldWarnings: TTranslationWarnings;
begin
  if (FWarnings = Value) then
    Exit;

  OldWarnings := FWarnings;

  FWarnings := Value;

  if ((FWarnings = []) <> (OldWarnings = [])) then
    NotifyWarnings;
end;

procedure TLocalizerTranslation.Update(const AValue: string);
begin
  Update(AValue, TLocalizerTranslations.DefaultStatus);
end;

procedure TLocalizerTranslation.Update(const AValue: string; AStatus: TTranslationStatus);
begin
  if (FValue = AValue) and (FStatus = AStatus) then
    Exit;

  BeginUpdate;
  try

    FValue := AValue;
    SetStatus(AStatus);

    Changed;

  finally
    EndUpdate;
  end;
end;


type
  TAcceleratorState = (asNone, asStart);
  TFormatState = (fsNone, fsStart, fsNumber, fsIndex, fsJustification, fsWidth, fsDot, fsPrecision, fsType);

procedure TLocalizerTranslation.UpdateWarnings;

  procedure Count(const Value: string; var CountAccelerator, CountFormat, CountLineBreak, CountLeadSpace, CountTrailSpace, CountPipe: integer);
  var
    i: integer;
    c, LastChar: Char;
    SkipAccelerator, SkipFormat: boolean;
    AcceleratorState: TAcceleratorState;
    FormatState: TFormatState;
    IsLeadIn: boolean;
  begin
    CountAccelerator := 0;
    CountFormat := 0;
    CountLineBreak := 0;
    CountLeadSpace := 0;
    CountTrailSpace := 0;
    CountPipe := 0;

    LastChar := #0;
    SkipAccelerator := False;
    SkipFormat := False;
    AcceleratorState := asNone;
    FormatState := fsNone;
    IsLeadIn := True;

    for i := 1 to Length(Value) do
    begin
      c := Value[i];
      if (IsLeadChar(c)) then
      begin
        LastChar := c;
        continue; // TODO : We should skip the next char
      end;

      if (c = ' ') then
      begin
        if (IsLeadIn) then
          Inc(CountLeadSpace)
        else
          Inc(CountTrailSpace)
      end else
      begin
        IsLeadIn := False;
        CountTrailSpace := 0;

        if (c = #13) then
        begin
          Inc(CountLineBreak);
          SkipAccelerator := True;
        end else
        if (c = #10) then
        begin
          if (LastChar <> #13) then
            Inc(CountLineBreak);
          SkipAccelerator := True;
        end else
        if (c = '|') then
          Inc(CountPipe);
      end;

      if (not SkipAccelerator) then
      begin
        if (c = cAcceleratorPrefix) then
        begin
          case AcceleratorState of
            asNone:
              AcceleratorState := asStart;
            asStart:
              AcceleratorState := asNone; // Escaped &&
          end;
        end else
        if (AcceleratorState = asStart) then
        begin
          AcceleratorState := asNone;
          if (c = ' ') then
            SkipAccelerator := True // Very common to have a space after & but highly unlikely that space is an accelerator key
          else
          if (CountAccelerator = 0) then
            Inc(CountAccelerator) // Only one allowed per caption
          else
            SkipAccelerator := True;
        end;
      end;

      if (not SkipFormat) then
      begin
        // Format string state machine
        case c of
          '%':
            case FormatState of
              fsNone:
                FormatState := fsStart;
              fsStart:
                FormatState := fsNone;          // Escaped: %%
            else
              SkipFormat := True;
            end;

          '0'..'9':
            case FormatState of
              fsNone:
                ; // skip
              fsStart,
              fsNumber:
                FormatState := fsNumber;
              fsIndex,
              fsWidth,
              fsJustification:
                FormatState := fsWidth;
              fsDot:
                FormatState := fsPrecision;
            else
              SkipFormat := True;
            end;

          ':':
            case FormatState of
              fsNone:
                ; // skip
              fsNumber:
                FormatState := fsIndex;
            else
              SkipFormat := True; // Invalid
            end;

          '-':
            case FormatState of
              fsNone:
                ; // skip
              fsStart,
              fsIndex:
                FormatState := fsJustification;
            else
              SkipFormat := True; // Invalid
            end;

          '.':
            case FormatState of
              fsNone:
                ; // skip
              fsStart,
              fsIndex,
              fsJustification,
              fsWidth:
                FormatState := fsDot;
            else
              SkipFormat := True; // Invalid
            end;

          'd', 'u', 'e', 'f', 'g', 'n', 'm', 'p', 's', 'x':
            case FormatState of
              fsNone:
                ; // skip
              fsStart,
              fsIndex,
              fsJustification,
              fsWidth,
              fsPrecision:
                begin
                  Inc(CountFormat);
                  FormatState := fsNone; // Got one - Start over
                end
            else
              SkipFormat := True; // Invalid
            end;
        else
          case FormatState of
            fsNone:
              ;
          else
            SkipFormat := True;
          end;
        end;
      end;

      LastChar := c;
    end;

    if (AcceleratorState <> asNone) then
      // & but no chars left for accelerator key
      SkipAccelerator := True;

    if (FormatState <> fsNone) then
      SkipFormat := True;

    if (SkipAccelerator) then
      CountAccelerator := 0;

    if (SkipFormat) then
      CountFormat := 0;
  end;

var
  OldWarnings: TTranslationWarnings;
  SourceCountAccelerator, TargetCountAccelerator: integer;
  SourceCountFormat, TargetCountFormat: integer;
  SourceCountLineBreak, TargetCountLineBreak: integer;
  SourceCountLeadSpace, TargetCountLeadSpace: integer;
  SourceCountTrailSpace, TargetCountTrailSpace: integer;
  SourceCountPipe, TargetCountPipe: integer;
begin
  OldWarnings := FWarnings;
  FWarnings := [];

  if (Value = Owner.Value) then
    Exit;

  if (Value.IsEmpty <> Owner.Value.IsEmpty) then
  begin
    Include(FWarnings, tWarningEmptiness);
    // None of the other tests makes sense
    Exit;
  end;

  Count(Value, TargetCountAccelerator, TargetCountFormat, TargetCountLineBreak, TargetCountLeadSpace, TargetCountTrailSpace, TargetCountPipe);
  Count(Owner.Value, SourceCountAccelerator, SourceCountFormat, SourceCountLineBreak, SourceCountLeadSpace, SourceCountTrailSpace, SourceCountPipe);

  // Only consider target accelerators if source has them.
  // If source doesn't have them then any & in the target probably isn't accelerators.
  if (SourceCountAccelerator > 0) and (SourceCountAccelerator <> TargetCountAccelerator) then
    Include(FWarnings, tWarningAccelerator);

  if (SourceCountFormat <> TargetCountFormat) then
    Include(FWarnings, tWarningFormatSpecifier);

  if (SourceCountLineBreak <> TargetCountLineBreak) then
    Include(FWarnings, tWarningLineBreak);

  if (SourceCountLeadSpace <> TargetCountLeadSpace) then
    Include(FWarnings, tWarningLeadSpace);

  if (SourceCountTrailSpace <> TargetCountTrailSpace) then
    Include(FWarnings, tWarningTrailSpace);

  if (GetTextEnding(Value) <> GetTextEnding(Owner.Value)) or (Value[Value.Length].IsPunctuation <> Owner.Value[Owner.Value.Length].IsPunctuation) then
    Include(FWarnings, tWarningTerminator);

  if (SourceCountPipe <> TargetCountPipe) then
    Include(FWarnings, tWarningPipe);

  if (GetTextSurroundIndex(Value) <> GetTextSurroundIndex(Owner.Value)) then
    Include(FWarnings, tWarningSurround);

  if ((FWarnings = []) <> (OldWarnings = [])) then
    NotifyWarnings;
end;

// -----------------------------------------------------------------------------
//
// TLocalizerTranslations
//
// -----------------------------------------------------------------------------
class constructor TLocalizerTranslations.Create;
begin
  FDefaultStatus := tStatusProposed;
end;

constructor TLocalizerTranslations.Create(AOwner: TLocalizerProperty);
begin
  inherited Create;
  FTranslations := TObjectDictionary<TTranslationLanguage, TLocalizerTranslation>.Create([doOwnsValues]);
  FOwner := AOwner;
end;

destructor TLocalizerTranslations.Destroy;
begin
  FTranslations.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TLocalizerTranslations.AddOrUpdateTranslation(Language: TTranslationLanguage; const Value: string): TLocalizerTranslation;
begin
  Result := AddOrUpdateTranslation(Language, Value, FDefaultStatus);
end;

function TLocalizerTranslations.AddOrUpdateTranslation(Language: TTranslationLanguage; const Value: string; Status: TTranslationStatus): TLocalizerTranslation;
begin
  if (not FTranslations.TryGetValue(Language, Result)) then
  begin
    Result := TLocalizerTranslation.Create(Owner, Language);
    FTranslations.Add(Language, Result);
  end;

  Result.Update(Value, Status);

  // TLocalizerTranslation.Update() will call Changed
  // Owner.Changed;
end;

// -----------------------------------------------------------------------------

procedure TLocalizerTranslations.Clear;
begin
  FTranslations.Clear;
  Owner.Changed;
end;

// -----------------------------------------------------------------------------

function TLocalizerTranslations.FindTranslation(Language: TTranslationLanguage): TLocalizerTranslation;
begin
  if (not FTranslations.TryGetValue(Language, Result)) then
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TLocalizerTranslations.GetCount: integer;
begin
  Result := FTranslations.Count;
end;

function TLocalizerTranslations.GetItem(Index: integer): TLocalizerTranslation;
begin
  Result := FTranslations.Values.ToArray[Index];
end;

function TLocalizerTranslations.GetItem(Language: TTranslationLanguage): TLocalizerTranslation;
begin
  Result := FTranslations[Language];
end;

// -----------------------------------------------------------------------------

procedure TLocalizerTranslations.Remove(Language: TTranslationLanguage);
begin
  FTranslations.Remove(Language);

  Owner.Changed;
end;

// -----------------------------------------------------------------------------

function TLocalizerTranslations.TryGetTranslation(Language: TTranslationLanguage; var Value: TLocalizerTranslation): boolean;
begin
  Result := FTranslations.TryGetValue(Language, Value);
end;


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

end.
