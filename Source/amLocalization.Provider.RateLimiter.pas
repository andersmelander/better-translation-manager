unit amLocalization.Provider.RateLimiter;

(*
 * Copyright © 2026 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

// -----------------------------------------------------------------------------
//
// IRateLimiter
//
// -----------------------------------------------------------------------------
type
  IRateLimiter = interface
    ['{39E244CD-E0D6-48D7-A192-8B3A061A0309}']
    procedure SetMaxRPM(Value: integer);
    procedure WaitForSlot;
  end;


// -----------------------------------------------------------------------------
//
// CreateRateLimiter
//
// -----------------------------------------------------------------------------
// Retuirns a rate limiter object
// -----------------------------------------------------------------------------
function CreateRateLimiter(AMaxRPM: integer): IRateLimiter;


// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

implementation

uses
  System.Generics.Collections,
  System.Classes,
  System.SyncObjs;

// -----------------------------------------------------------------------------
//
// TRateLimiter
//
// -----------------------------------------------------------------------------
type
  TRateLimiter = class(TInterfacedObject, IRateLimiter)
  strict private
    FRequestTimes: TList<UInt64>;
    FLock: TCriticalSection;
    FMaxRPM: Integer;
  private
    // IRateLimiter
    procedure SetMaxRPM(Value: integer);
    procedure WaitForSlot;
  public
    constructor Create(AMaxRPM: Integer);
    destructor Destroy; override;
  end;

// -----------------------------------------------------------------------------

constructor TRateLimiter.Create(AMaxRPM: Integer);
begin
  inherited Create;
  FMaxRPM := AMaxRPM;
  FRequestTimes := TList<UInt64>.Create;
  FLock := TCriticalSection.Create;
end;

destructor TRateLimiter.Destroy;
begin
  FRequestTimes.Free;
  FLock.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TRateLimiter.SetMaxRPM(Value: integer);
begin
  FMaxRPM := Value;
end;

// -----------------------------------------------------------------------------

procedure TRateLimiter.WaitForSlot;

  procedure DeleteOldRequestsSince(Now: UInt64);
  begin
    // Remove requests older than 60 seconds
    while (FRequestTimes.Count > 0) and (Now - FRequestTimes[0] > 60000) do
      FRequestTimes.Delete(0);
  end;

begin
  FLock.Enter;
  try
    var Now := TThread.GetTickCount64;

    // Remove requests older than 60 seconds
    DeleteOldRequestsSince(Now);

    if (FRequestTimes.Count >= FMaxRPM) then
    begin
      // We have exceeded max RPM; Wait for "time since oldest request" and "a bit"
      var SleepTime := 60000 - (Now - FRequestTimes[0]) + 100;

      if (SleepTime > 0) then
      begin
        FLock.Leave;
        try

          TThread.Sleep(Cardinal(SleepTime));

        finally
          FLock.Enter;
        end;

        Now := TThread.GetTickCount64;
        DeleteOldRequestsSince(Now);
      end;
    end;

    FRequestTimes.Add(TThread.GetTickCount64);
  finally
    FLock.Leave;
  end;
end;


// -----------------------------------------------------------------------------
//
// CreateRateLimiter
//
// -----------------------------------------------------------------------------
function CreateRateLimiter(AMaxRPM: integer): IRateLimiter;
begin
  Result := TRateLimiter.Create(AMaxRPM);
end;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

end.
