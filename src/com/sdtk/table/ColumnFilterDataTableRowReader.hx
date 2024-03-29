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

@:expose
@:nativeGen
class ColumnFilterDataTableRowReader extends DataTableRowReader {
    private var _reader : Null<DataTableRowReader>;
    private var _remove : Null<Array<Bool>>;
    private var _current : Dynamic;

    public function new(dtrrReader : DataTableRowReader, iRemove : Array<Bool>) {
        super();
        reuse(dtrrReader, iRemove);
    }

    public function reuse(dtrrReader : DataTableRowReader, iRemove : Array<Bool>) {
        _reader = dtrrReader;
        _remove = iRemove;
        _current = null;
        _started = false;
        _index = -1;
    }

    private override function startI() {
        _reader.start();
        check();
        super.startI();
    }

    public function check() {
        if (_reader != null) {
            var current : Dynamic = null;
            current = _reader.next();
            while (_remove[_reader.index()]) {
                current = null;
                if (_reader.index() >= _remove.length - 1) {
                    break;
                }
                current = _reader.next();
            }
            _current = current;
        }
    }

    public override function hasNext() : Bool {
        return _current != null;
    }

    public override function next() : Dynamic {
        var oCurrent : Dynamic = _current;
        incrementTo(_reader.name(), oCurrent, _reader.rawIndex());
        check();
        return oCurrent;
    }

    public override function isAutoNamed() : Bool {
        return _reader.isAutoNamed();
    }

    public override function isNameIndex() : Bool {
  	    return _reader.isNameIndex();
    }
    
  #if cs
    @:native('Dispose')
  #elseif java
    @:native('close')
  #end
    public override function dispose() {
        if (_reader != null) {
            super.dispose();
            _reader.dispose();
            _reader = null;
            _remove = null;
            _current = null;
        }
    }
}