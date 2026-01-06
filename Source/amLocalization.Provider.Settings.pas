unit amLocalization.Provider.Settings;

(*
 * Copyright © 2025 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

uses
  amRegConfig;

type
  TCustomTranslationManagerProviderSettings = class(TConfigurationSection)
  private
    FEnabled: boolean;
  protected
    procedure ApplyDefault; override;
  public
  published
    property Enabled: boolean read FEnabled write FEnabled default True;
  end;

implementation

{ TCustomTranslationManagerProviderSettings }

procedure TCustomTranslationManagerProviderSettings.ApplyDefault;
begin
  inherited;
  FEnabled := True;
end;

end.
