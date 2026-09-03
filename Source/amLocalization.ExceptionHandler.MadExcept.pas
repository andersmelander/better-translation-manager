unit amLocalization.ExceptionHandler.MadExcept;

(*
 * Copyright © 2026 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

{$ifndef MADEXCEPT}
{$message Fatal 'This unit requires that the MADEXCEPT symbol is defined'}
{$endif}
{$WARN SYMBOL_PLATFORM OFF}

interface

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  Generics.Collections,
  Windows,
  Forms,
  StrUtils,
  IOUtils,
  ShellAPI,
  Clipbrd,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts,
  System.NetEncoding,
  System.JSON,

  madExcept,
  madListModules,

  amVersionInfo,
  amCursorService,
  amLocalization.ExceptionHandler.Github,
  amLocalization.ExceptionHandler.API;

var
  sBugreportMailAddress: string = 'anders@melander.dk'; // Only for test

resourcestring
  sBugreportSendButton = 'Submit GitHub Issue';
  sBugreportShowButton = 'View details';
  sBugreportCloseButton = 'Quit application';
  sBugreportContinueButton = 'Continue application';
  sBugreportMessage = 'The application encountered a problem.'+#13#13+
    'To help us diagnose and correct the problem, you can submit an issue to our GitHub tracker.'+#13#13+
    'If you choose to continue the application, you should save your work as soon as possible and restart the application.'+#13;
  sBugreportMailSubject = 'Defect report - %s %s';
  sBugreportMailMessage = 'To help us locate and correct the cause of the problem please describe, in as much details as possible, what you were doing when the problem occurred';

{$include amLocalization.ExceptionHandler.Github.inc}

// -----------------------------------------------------------------------------

function BoolToStr(Value: boolean): string;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;

function StrToBool(const s: string): boolean;
begin
  // XML standard: 1, 0, true, false. However... MSXML represents True as -1.
  if (s = '1') or (s = '-1') or (AnsiSameText(s, 'true')) then
    Result := True
  else
    Result := False;
end;

// -----------------------------------------------------------------------------
//
//              TMadExceptInfoConsumer
//
// -----------------------------------------------------------------------------
type
  TMadExceptInfoConsumer = class(TInterfacedObject, IExceptionInfoConsumer)
  private
    FExceptIntf: IMEException;
  private
    // IExceptionInfoConsumer
    procedure AddExceptionInfo(const Section, Name, Value: string);
  public
    constructor Create(const AExceptIntf: IMEException);
  end;

constructor TMadExceptInfoConsumer.Create(const AExceptIntf: IMEException);
begin
  inherited Create;
  FExceptIntf := AExceptIntf;
end;

procedure TMadExceptInfoConsumer.AddExceptionInfo(const Section, Name, Value: string);
begin
  if (Section <> '') then
  begin
    var Index := FExceptIntf.BugReportSections.FindItem(Section);
    if (Index <> -1) then
    begin
      var s := FExceptIntf.BugReportSections.Contents[Section];
      if (s <> '') then
        s := s + #13#10;
      s := s + Name + #9 + Value;
      FExceptIntf.BugReportSections.Contents[Section] := s;
    end else
      FExceptIntf.BugReportSections.Add(Section, Name+#9+Value);
  end else
    FExceptIntf.BugReportHeader.Add(Name, Value);
end;

// -----------------------------------------------------------------------------
//
//              TMadExceptExceptionHandler
//
// -----------------------------------------------------------------------------
type
  TMadExceptExceptionHandler = class(TInterfacedObject, IExceptionHandler)
  private
    FExceptionCount: integer;
    FExceptionInfoProviders: TList<IExceptionInfoProvider>;

  private
    procedure Trace(const Topic, Msg: string);
    function GetGitHubGistToken: string;
    function CreateGitHubGist(const ExceptIntf: IMEException; var AStatus: string): string;
    function SendReportToGitHub(const ExceptIntf: IMEException): Boolean;

  protected // "protected" to shut compiler up about unused private methods
    // Registered exception handlers
    procedure MadExceptGlobalHandler(const exceptIntf: IMEException; var handled: boolean);
    procedure MadExceptHandlerSynced(const exceptIntf: IMEException; var handled: boolean);
    procedure MadExceptHandler(const exceptIntf: IMEException; var handled: boolean);
    procedure MadExceptActionHandler(action: TExceptAction; const exceptIntf: IMEException; var handled: boolean);

  private
    // IExceptionHandler
    procedure ExceptionHandler(const ExceptIntf: IUnknown; var Handled: boolean);
    procedure RegisterExceptionInfoProvider(const ExceptionInfoProvider: IExceptionInfoProvider);
    procedure UnregisterExceptionInfoProvider(const ExceptionInfoProvider: IExceptionInfoProvider);

  public
    constructor Create;
    destructor Destroy; override;
  end;

constructor TMadExceptExceptionHandler.Create;
begin
  inherited Create;

   // Note: This is called both before and after resource strings has been localized ... huh?
  MESettings.SendBtnCaption := sBugreportSendButton;
  MESettings.ShowBtnCaption := sBugreportShowButton;
  MESettings.CloseBtnCaption := sBugreportCloseButton;
  MESettings.ContinueBtnCaption := sBugreportContinueButton;
  MESettings.ExceptMsg := sBugreportMessage;
  MESettings.MailSubject := sBugreportMailSubject;
  MESettings.MailBody := sBugreportMailMessage;
  MESettings.MailAddr := sBugreportMailAddress;
  MESettings.MailViaMapi := False;
  MESettings.MailViaMailto := False;

  RegisterExceptionHandler(MadExceptHandler, stDontSync);
  RegisterExceptActionHandler(MadExceptActionHandler, stTrySyncCallOnSuccess);
end;

destructor TMadExceptExceptionHandler.Destroy;
begin
  UnregisterExceptActionHandler(MadExceptActionHandler);
  UnregisterExceptionHandler(MadExceptHandler);
  inherited;
end;

procedure TMadExceptExceptionHandler.ExceptionHandler(const ExceptIntf: IInterface; var Handled: boolean);
begin
  MadExceptHandler(ExceptIntf as IMEException, Handled);
end;

procedure TMadExceptExceptionHandler.MadExceptGlobalHandler(const exceptIntf: IMEException; var handled: boolean);
begin
//  Trace('Exception (handled)', exceptIntf.ExceptClass+':'+exceptIntf.ExceptMessage);
  Handled := True;
end;

procedure TMadExceptExceptionHandler.MadExceptActionHandler(action: TExceptAction; const exceptIntf: IMEException; var handled: boolean);
begin
  if (action = eaSendBugReport) then
  begin
    handled := True; // Intercept madExcept default mail sending
    SaveCursor(crAppStart);
    SendReportToGitHub(exceptIntf);
  end;
end;

function TMadExceptExceptionHandler.GetGitHubGistToken: string;

  function ROT47(const Input: string): string;
  begin
    SetLength(Result, Length(Input));

    for var i := Low(Input) to High(Input) do
    begin
      var c := Input[i];
      case c of
        #33..#126: Result[i] := Char(33 + ((Ord(c) + 47 - 33) mod 94));
      else
        Result[i] := c;
      end;
    end;
  end;

begin
{.$define ENCODE_GITHUB_GIST_TOKEN}
{.$define SAVE_GITHUB_GIST_SECRET}
{$define DECODE_GITHUB_GIST_TOKEN}

  (*
  ** Ultra-Super Secure Encryption :-/
  *)
  Result := '';

  // Unencrypted->encrypted token
{$if defined(ENCODE_GITHUB_GIST_TOKEN)}
  Result := GetEnvironmentVariable('GITHUB_GIST_TOKEN');
  if (Result = '') and TFile.Exists('GITHUB_GIST_TOKEN') then
    Result := TFile.ReadAllText('GITHUB_GIST_TOKEN', TEncoding.ASCII);

  if (Result <> '') then
  begin
    Result := ROT47(Result);
    Result := ReverseString(Result);
    Result := TNetEncoding.Base64.Encode(Result);

{$if defined(SAVE_GITHUB_GIST_SECRET)}
    TFile.WriteAllText('GITHUB_GIST_SECRET', Result, TEncoding.ASCII);
    Result := '';
{$ifend}
  end;
{$ifend}

  // Encrypted->unencrypted token
{$if defined(DECODE_GITHUB_GIST_TOKEN)}
  if (Result = '') then
  begin
    Result := GetEnvironmentVariable('GITHUB_GIST_SECRET');
    if (Result = '') then
    begin
      if TFile.Exists('GITHUB_GIST_SECRET') then
        Result := TFile.ReadAllText('GITHUB_GIST_SECRET', TEncoding.ASCII)
      else
        Result := sGithubToken;
    end;
  end;

  if (Result <> '') then
  begin
    Result := TNetEncoding.Base64.Decode(Result);
    Result := ReverseString(Result);
    Result := ROT47(Result);
  end;
{$ifend}
end;

function TMadExceptExceptionHandler.CreateGitHubGist(const ExceptIntf: IMEException; var AStatus: string): string;
begin
  Result := '';
  AStatus := '';

  var Token := GetGitHubGistToken;
  if (Token = '') then
  begin
    AStatus := 'No token';
    Exit;
  end;

  var HTTP := THTTPClient.Create;
  try
    var Headers: TNetHeaders := [
      TNetHeader.Create('Authorization', 'Bearer ' + Token),
      TNetHeader.Create('Accept', 'application/vnd.github+json'),
      TNetHeader.Create('User-Agent', 'amTranslationManager')
    ];
    HTTP.ContentType := 'application/json';

    var RequestBody := TJSONObject.Create;
    try
      RequestBody.AddPair('description', 'Bug Report - amTranslationManager');
      RequestBody.AddPair('public', TJSONBool.Create(False)); // Create a "secret" Gist

      var FilesObj := TJSONObject.Create;

      // 1. Add bug report
      var FileContentObj := TJSONObject.Create;
      FileContentObj.AddPair('content', ExceptIntf.BugReport);
      FilesObj.AddPair('bugreport.txt', FileContentObj);

      // 2. Get PNG screenshot from madExcept, Base64 encode it and embed in markdown
      (*
      ** Disabled as there's currently no way of getting an image into the Gist
      ** other than as a text file with Base64 encoded data. The code below was
      ** my final futile attempt.

      var sPNG := ExceptIntf.Screenshot.AsPngStr;
      if (sPNG <> '') then
      begin
        var Base64PNG := 'data:image/png;base64,' +TNetEncoding.Base64.EncodeBytesToString(PAnsiChar(sPNG), Length(sPNG));
        sPNG := '';
        var Markdown := '### Screenshot'#10 +
          '![Screenshot](' + Base64PNG + ')' + #10;
        Base64PNG := '';

        var ScreenshotObj := TJSONObject.Create;
        ScreenshotObj.AddPair('content', Markdown);
        FilesObj.AddPair('screenshot.md', ScreenshotObj);
      end;
      *)

      RequestBody.AddPair('files', FilesObj);

      var StringStream := TStringStream.Create(RequestBody.ToJSON, TEncoding.UTF8);
      try
        var Response := HTTP.Post('https://api.github.com/gists', StringStream, nil, Headers);

        if (Response.StatusCode <> 201) and (Response.StatusCode <> 200) then
        begin
          AStatus := Format('%d: %s', [Response.StatusCode, Response.StatusText]);
          exit;
        end;

        var ResponseObj := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
        if (ResponseObj = nil) then
          exit;

        try
          Result := ResponseObj.GetValue<string>('html_url');
        finally
          ResponseObj.Free;
        end;
      finally
        StringStream.Free;
      end;
    finally
      RequestBody.Free;
    end;
  finally
    HTTP.Free;
  end;
end;

function TMadExceptExceptionHandler.SendReportToGitHub(const ExceptIntf: IMEException): Boolean;
const
  sGithubAccount = 'andersmelander';
  sGithubRepo = 'better-translation-manager';
  sGithubCreateIssueURL = 'https://github.com/%s/%s/issues/new?title=%s&body=%s&labels=bug,auto-generated';
begin
  Result := False;
  try

    var AppName := Application.Title;
    if (AppName = '') then
      AppName := TPath.GetFileName(ParamStr(0));
    var AppVersion := TVersionInfo.FileVersionString(ParamStr(0));

    // 1. Create Gist (if token available)
    var GistUrl := '';
    var GistStatus := '';
    try
      GistUrl := CreateGitHubGist(ExceptIntf, GistStatus);
    except
      on E: Exception do
        GistStatus := E.Message;
    end;

    // 2. Construct Title and Body
    var IssueTitle := Format('[Automated incident report] %s: %s', [ExceptIntf.ExceptClass, ExceptIntf.ExceptMessage]);

    var IssueBody := Format('### Environment & Incident Details'#10 +
      '- **Application**: %s %s'#10 +
      '- **Exception**: `%s`'#10 +
      '- **Message**: %s'#10#10 +
      '### User Comments'#10 +
      '> %s'#10#10,
      [AppName, AppVersion, ExceptIntf.ExceptClass, ExceptIntf.ExceptMessage, ExceptIntf.MailBody]);

    IssueBody := IssueBody + '### Bug report attachment'#10;
    if (GistUrl <> '') then
      IssueBody := IssueBody + Format('**[View full bug report (GitHub Gist)](%s)**'#10, [GistUrl])
    else
    begin
      IssueBody := IssueBody +
        Format('The bug report has been saved locally on your system in `%s`. Please attach it to this issue and delete this line.'#10#10, [TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), ExceptIntf.BugReportFile)]);
      IssueBody := IssueBody +
        Format('(The error reporter was unable to upload the bug report automatically: %s)'#10, [GistStatus]);
    end;

    // 3. Build Web UI URL
    var IssueUrl := Format(sGithubCreateIssueURL, [sGithubAccount, sGithubRepo, TURLEncoding.URL.Encode(IssueTitle), TURLEncoding.URL.Encode(IssueBody)]);

    // 4. Launch web browser
    ShellExecute(0, 'open', PChar(IssueUrl), nil, nil, SW_SHOWNORMAL);
    Result := True;

  except
    on E: Exception do
    begin
      // Failed. We are in an error handler already do don't try again.
      // Save the new error "somewhere"
      Clipboard.AsText := E.Message;
    end;
  end;
end;

procedure TMadExceptExceptionHandler.MadExceptHandler(const ExceptIntf: IMEException; var Handled: boolean);

  function DeletePrefix(const Prefix, Value: string): string;
  begin
    Result := Value;
    if (StartsStr(Prefix, Result)) then
      Delete(Result, 1, Length(Prefix));
  end;

var
  s: string;
  ExceptionSettings: IMESettings;
begin
  // Ignore frozen app when debugging
  if (ExceptIntf.ExceptType = etFrozen) and (DebugHook <> 0) then
  begin
    Handled := True;
    exit;
  end;

  if (FExceptionCount > 0) and (Supports(ExceptIntf, IMESettings, ExceptionSettings)) then
  begin
    // Only enable "Send" button the first time an exception occurs. We are not interested in secondary errors.
    ExceptionSettings.SendBtnVisible := False;
  end;
  Inc(FExceptionCount);

  (*
  ** Email setup
  *)
  s := Application.Title;
  if (s = '') then
    s := TPath.GetFileName(ParamStr(0));
  ExceptIntf.MailSubject := Format(ExceptIntf.MailSubject, [s, TVersionInfo.FileVersionString(ParamStr(0))]);

  Trace('Exception', ExceptIntf.ExceptClass+':'+ExceptIntf.ExceptMessage);

  if (FExceptionInfoProviders <> nil) and (FExceptionInfoProviders.Count > 0) then
  begin
    var ExceptionInfoConsumer: IExceptionInfoConsumer;
    ExceptionInfoConsumer := TMadExceptInfoConsumer.Create(ExceptIntf);

    for var ExceptionInfoProvider in FExceptionInfoProviders do
      ExceptionInfoProvider.GetExceptionInfo(ExceptIntf, ExceptionInfoConsumer);
  end;
end;

procedure TMadExceptExceptionHandler.MadExceptHandlerSynced(const exceptIntf: IMEException; var handled: boolean);
begin

end;

procedure TMadExceptExceptionHandler.RegisterExceptionInfoProvider(const ExceptionInfoProvider: IExceptionInfoProvider);
begin
  if (FExceptionInfoProviders = nil) then
    FExceptionInfoProviders := TList<IExceptionInfoProvider>.Create;

  FExceptionInfoProviders.Add(ExceptionInfoProvider);
end;

procedure TMadExceptExceptionHandler.UnregisterExceptionInfoProvider(const ExceptionInfoProvider: IExceptionInfoProvider);
begin
  if (FExceptionInfoProviders <> nil) then
    FExceptionInfoProviders.Remove(ExceptionInfoProvider);
end;

procedure TMadExceptExceptionHandler.Trace(const Topic, Msg: string);
begin

end;

// -----------------------------------------------------------------------------

function CreateMadExceptExceptionHandler: IExceptionHandler;
begin
  Result := TMadExceptExceptionHandler.Create;
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

initialization
  RegisterExceptionHandlerFactory(CreateMadExceptExceptionHandler);
  // Only report leaks in debug builds
{$ifdef RELEASE}
  MadExcept.StopLeakChecking(False);
  MadExcept.ClearLeaks(False);
{$endif RELEASE}
end.
