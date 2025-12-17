program amLocalization.Tests;

(*
  One, and only one, of the following must be defined in the project options:

  RUNNER_TESTINSIGHT            Use the TestInsight runner. Requires that TestInsight has been installed.
  RUNNER_GUI                    Use the default GUI runner.
  RUNNER_CONSOLE                Use the console runner. Produces NUnit compatible XML log files.
*)


{$if (not defined(RUNNER_TESTINSIGHT)) and (not defined(RUNNER_GUI)) and (not defined(RUNNER_CONSOLE))}
{$define RUNNER_CONSOLE}
//{$message Fatal 'One of RUNNER_TESTINSIGHT, RUNNER_GUI or RUNNER_CONSOLE must be defined'}
{$ifend}

{$if (defined(RUNNER_GUI)) and (defined(RUNNER_CONSOLE))}
{$undef RUNNER_GUI}
{$ifend}

{$if defined(RUNNER_CONSOLE)}
{$apptype CONSOLE}
{$ifend}

{$STRONGLINKTYPES ON}

uses
  {$if defined(MADEXCEPT)}
  madStackTrace,
  {$ifend }
  System.SysUtils,
  {$if defined(MADEXCEPT)}
  DUnitX.IoC,
  {$ifend }
  {$if defined(RUNNER_TESTINSIGHT)}
  TestInsight.DUnitX,
  {$ifend }
  {$if defined(RUNNER_GUI)}
  DUnitX.Loggers.GUI.VCL,
  {$ifend }
  {$if defined(RUNNER_CONSOLE)}
  DUnitX.Loggers.Console,
  {$ifend }
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  amLocalization.Provider.Ollama.Core in '..\amLocalization.Provider.Ollama.Core.pas',
  amLocalization.Provider.Ollama.Core.Tests in 'amLocalization.Provider.Ollama.Core.Tests.pas';

{$if defined(RUNNER_TESTINSIGHT)}
procedure ExecuteTestInsight;
begin
  TestInsight.DUnitX.RunRegisteredTests;
end;
{$ifend}

{$if defined(RUNNER_GUI)}
procedure ExecuteGUIRunner;
begin
  DUnitX.Loggers.GUI.VCL.Run;
end;
{$ifend}

{$if defined(RUNNER_CONSOLE)}
procedure ExecuteConsoleRunner;
var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      // Do not set error code. Otherwise Bamboo will abort job instead of parsing the result
      ; // System.ExitCode := EXIT_ERRORS;

{$ifndef CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$endif}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end;
{$ifend}

// Work around for broken Delphi 10.3 compiler support in bundled DUnitX
{$if defined(MADEXCEPT)}
type
  TMadExcept4StackTraceProvider = class(TInterfacedObject, IStacktraceProvider)
  public
    function GetStackTrace(const ex: Exception; const exAddressAddress: Pointer): string;
    function PointerToLocationInfo(const Addrs: Pointer): string;
    function PointerToAddressInfo(Addrs: Pointer): string;
  end;

function TMadExcept4StackTraceProvider.GetStackTrace(const ex: Exception; const exAddressAddress: Pointer): string;
begin
  Result := madStackTrace.StackTrace(false, false, false, nil, nil,
    exAddressAddress, false,
    false, 0, 0, nil,
    @exAddressAddress);
end;

function TMadExcept4StackTraceProvider.PointerToAddressInfo(Addrs: Pointer): string;
begin
  Result := String(StackAddrToStr(Addrs));
end;

function TMadExcept4StackTraceProvider.PointerToLocationInfo(const Addrs: Pointer): string;
begin
  Result := String(StackAddrToStr(Addrs));
end;
{$ifend}

begin
{$if defined(MADEXCEPT)}
  TDUnitXIoC.DefaultContainer.RegisterType<IStacktraceProvider, TMadExcept4StackTraceProvider>(true);
{$ifend}

{$if defined(RUNNER_TESTINSIGHT)}
  ExecuteTestInsight;
{$elseif defined(RUNNER_GUI)}
  ExecuteGUIRunner;
{$else}
  ExecuteConsoleRunner;
{$ifend}
end.
