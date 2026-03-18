unit amLocalization.Common;

(*
 * Copyright © 2019 Anders Melander
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *)

interface

// File filters
resourcestring
  sResourceModuleFilter = '%s resource modules (*.%1:s)|*.%1:s|';
  sFileFilterGeneric = '%0:s files (*.%1:s)|*.%1:s';
  sFileFilterAll = 'All supported files (%0:s)|%0:s';
  sFileTextFilter = 'Text files (*.txt)|*.txt';
  sFileFilterCSV = 'CSV files (*.csv)|*.csv';
  sFileFilterPO = 'GNU GetText PO files (*.po)|*.po';
  sFileFilterXLIFF = 'XLIFF files (*.xliff;*.xlf)|*.xliff;*.xlf';

implementation

end.
