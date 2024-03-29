/*
    Copyright (C) 2019 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    Simple Data Toolkit
    Simple Table Converter (STC) - Source code can be found in Converter.hx in Haxe on SourceForge.net
*/

package com.sdtk.table;

/**
  CSV file structure
**/
@:expose
@:nativeGen
class CSVInfo implements DelimitedInfo {
  private function new() {
  }

  private static var _instance : DelimitedInfo;

  public static function instance() : DelimitedInfo {
    if (_instance == null) {
        _instance = new CSVInfo();
    }
    return _instance;
  }

  public function fileStart() : String {
    return "";
  }

  public function fileEnd() : String {
    return "";
  }

  public function delimiter() : String {
    return ",";
  }

  public function rowDelimiter() : String {
    return "\n";
  }

  public function boolStart() : String {
    return "";
  }

  public function boolEnd() : String {
    return "";
  }

  public function stringStart() : String {
    return "\"";
  }

  public function stringEnd() : String {
    return "\"";
  }

  public function intStart() : String {
    return "";
  }

  public function intEnd() : String {
    return "";
  }

  public function floatStart() : String {
    return "";
  }

  public function floatEnd() : String {
    return "";
  }

  public function replacements() : Array<String> {
    return ["\\\\", "\\", "\"\"", "\"", "\\\n", "\n", "\\\t", "\t", "\\\r", "\r"];
  }

  public function replacementIndicator() : Null<String> {
    return "\\";
  }

  public function widthMinimum() : Int {
    return -1;
  }

  public function widthMaximum() : Int {
    return -1;
  }  
}
