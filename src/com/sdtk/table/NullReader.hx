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
  Defines interface for processing objects as tables.
**/
@:expose
@:nativeGen
class NullReader extends DataTableReader {
  private static var _instance : DataTableReader;

  public static function instance() : DataTableReader {
    if (_instance == null) {
        _instance = new NullReader();
    }
    return _instance;
  }

  private function new() {
    super();
  }
  
  public override function hasNext() : Bool {
    return false;
  }

  public override function next() : Dynamic {
    return null;
  }

  public override function iterator() : Iterator<Dynamic> {
    return this;
  }

  public override function flip() : DataTableWriter {
    return NullWriter.instance();
  } 

  public override function reset() : Void {
  }  
}
