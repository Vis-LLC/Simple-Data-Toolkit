/*
    Copyright (C) 2019 Vis LLC - All Rights Reserved

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/*
    Simple Data Toolkit
    Simple Table Converter (STC) - Source code can be found in Converter.hx in Haxe on SourceForge.net
*/

package com.sdtk.table;

import com.sdtk.std.*;

@:expose
@:nativeGen
class FileSystemReader extends DataTableReader {
  private var _handler : Null<FileSystemHandler> = null;
  private var _reader : Null<Reader> = null;
  private var _previous : Null<FileSystemRowReader> = null;
  private var _current : Null<FileSystemRowReader> = null;

  private function new(fshHandler : FileSystemHandler, rReader : Reader) {
    super();
    _handler = fshHandler;
    _reader = rReader;
  }

  public static function createCMDDirReader(rReader : Reader) {
    return new FileSystemReader(CMDDirHandler.instance(), rReader);
  }

  private function check(reuse : Bool) : Void {
    if (reuse == false) {
      _current = new FileSystemRowReader(_handler, _reader, _current);
    } else {
      if (_previous == null) {
        check(false);
      } else {
        _previous.reuse(_handler, _reader, _current);
        _current = _previous;
      }
    }
  }

  private override function startI() : Void {
    _reader.start();
    check(false);
  }

  #if cs
    @:native('Dispose')
  #elseif java
    @:native('close')
  #end
  public override function dispose() : Void {
    if (_reader != null) {
      _reader.dispose();
      _reader = null;
      _handler = null;
      _previous = null;
      _current = null;
    }
  }

  public override function hasNext() : Bool {
    return _current != null;
  }

  private function nextI(reuse : Bool) : Dynamic {
    if (_current != null) {
      var fsrrCurrent : Null<FileSystemRowReader> = _current;
      check(reuse);
      _previous = fsrrCurrent;
      return fsrrCurrent;
    } else {
      return null;
    }
  }

  public override function nextReuse(rowReader : Null<DataTableRowReader>) : Dynamic {
    return nextI(true);
  }

  public override function next() : Dynamic {
    return nextI(false);
  }

  public override function reset() : Void {
    _reader.reset();
    _previous = null;
    _current = null;
  }    
}
