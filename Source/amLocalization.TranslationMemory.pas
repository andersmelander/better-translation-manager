unit amLocalization.TranslationMemory;

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
  System.SysUtils, System.Classes, Data.DB, Windows,

  amLanguageInfo,
  amProgress.API,
  amLocalization.Normalization,
  amLocalization.Model,
  amLocalization.Provider;

type
  TTranslationMemoryMergeStats = record
    Added: integer;             // New row added with value
    Merged: integer;            // Value merged into existing row
    Skipped: integer;           // Value skipped (e.g. empty value)
    Duplicate: integer;         // Exact duplicate found
  end;

  TTranslationMemoryDuplicateAction = (
    tmDupActionPrompt,          // Prompt to select action
    tmDupActionAbort,           // Abort import
    tmDupActionAddAll,          // Add all duplicates
    tmDupActionRejectAll        // Reject all duplicates
  );

type
  TDuplicate = record
    SourceValue: string;
    Value: string;
    RecordID: int64;
  end;

  TDuplicateValues = class(TList<TDuplicate>)
  public
    EmptyCount: integer;
  end;

  TDuplicateTerms = TObjectDictionary<string, TDuplicateValues>;

  TDuplicates = TObjectDictionary<TField, TDuplicateTerms>;

type
  TTranslationMemoryRecordList = TList<integer>;
  TTranslationMemoryLookupIndex = TObjectDictionary<string, TTranslationMemoryRecordList>;

type
  ITranslationMemoryPeek = interface
    ['{8D4D5538-3A16-4220-9FDF-F88B8A7DED6C}']
    procedure EnqueueQuery(Prop: TLocalizerProperty);
    procedure Cancel;
  end;

  ITranslationMemoryLookup = interface
    ['{92F65B1C-78E2-4784-B795-9C61BB3AF50D}']
    function Lookup(const Value: string): TTranslationMemoryRecordList;
    function GetValues: TArray<string>;
  end;

  ITranslationMemory = interface
    ['{8D4D5538-3A16-4220-9FDF-F88B8A7DED6C}']
    function CreateField(LanguageItem: TLanguageItem): TField;
    function FieldToLanguage(Field: TField): TLanguageItem;
    function SaveTableTranslationMemoryClone: IInterface;
    function AddTerm(SourceField: TField; const SourceValue, SanitizedSourceValue: string; TargetField: TField; const TargetValue: string;
      Duplicates: TDuplicates; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction): TTranslationMemoryDuplicateAction;
    procedure Lock;
    procedure Unlock;
    function GetTranslationMemoryDataSet: TDataSet;
    property TranslationMemoryDataSet: TDataSet read GetTranslationMemoryDataSet;


    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const Filename: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const Filename: string);

    procedure BeginAdd;
    function Add(SourceLanguage: TLanguageItem; const SourceValue: string; TargetLanguage: TLanguageItem; const TargetValue: string; var Stats: TTranslationMemoryMergeStats; DuplicateAction: TTranslationMemoryDuplicateAction = tmDupActionPrompt): TTranslationMemoryDuplicateAction; overload;
    procedure EndAdd;

    function CheckSave: boolean;
    function CheckLoaded(Force: boolean = False): boolean;
    procedure SetLoaded; // For use when loading TMX as main TM

    function GetLanguages: TArray<TLanguageItem>;
    function CreateLookup(Language: TLanguageItem; SanitizeKinds: TSanitizeRules; const Progress: IProgress = nil): ITranslationMemoryLookup;
    function CreateBackgroundLookup(SourceLanguage, TargetLanguage: TLanguageItem; AResultHandler: TNotifyEvent): ITranslationMemoryPeek;
    function HasSourceTerm(Prop: TLocalizerProperty; SourceLanguage: TLanguageItem): boolean;
    function FindTerms(Language: TLanguageItem; const Value: string; LookupResult: TTranslationLookupResult; RankResult: boolean = False): boolean;
    function FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; Translations: TStrings): boolean; overload;
    function FindTranslations(Prop: TLocalizerProperty; SourceLanguage, TargetLanguage: TLanguageItem; LookupResult: TTranslationLookupResult): boolean; overload;

    function GetIsLoaded: boolean;
    function GetModified: boolean;
    function GetIsAvailable: boolean;
    function GetHasData: boolean;

    property IsLoaded: boolean read GetIsLoaded;
    property IsAvailable: boolean read GetIsAvailable;
    property HasData: boolean read GetHasData;
    property Modified: boolean read GetModified;
  end;

type
  TranslationMemory = class abstract
  private
    class var FPrimaryProvider: ITranslationMemory;
  private
    class constructor Create;
    class destructor Destroy;
  public
    class property PrimaryProvider: ITranslationMemory read FPrimaryProvider;
  end;


type
  ETranslationMemory = class(Exception);

resourcestring
  sTranslationMemoryLoading = 'Loading Translation Memory';
  sTranslationMemoryLoad = 'Loading...';
  sTranslationMemoryReadingTerms = 'Reading terms...';
  sTranslationMemoryIndexingTerms = 'Indexing terms...';
  sTranslationMemoryAddingTerms = 'Adding terms...';
  sTranslationMemoryLoadingTerms = 'Loading terms...';
  sTranslationMemorySaving = 'Saving Translation Memory';


implementation

uses
  amLocalization.TranslationMemory.Data;

class constructor TranslationMemory.Create;
begin
  FPrimaryProvider := TDataModuleTranslationMemory.Create(nil);
end;

class destructor TranslationMemory.Destroy;
begin
  FPrimaryProvider := nil;
end;

end.
