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
    Simple Table Converter (STC) - Source code can be found in ConverterInputOptions.hx in Haxe on SourceForge.net
*/

package com.sdtk.table;

@:expose
@:nativeGen
class ConverterInputOperationsOptions {
    private var _values : Map<String, Dynamic>;

    public function new(?values : Null<Map<String, Dynamic>>) {
        if (values == null) {
            values = new Map<String, Dynamic>();
        }
        _values = values;
    }

    public function excludeColumn(value : String) : ConverterInputOperationsOptions {
        return mergeFilter("filterColumnsExclude", new com.sdtk.std.FilterBlockEqualString(value));
    }

    public function includeColumn(value : String) : ConverterInputOperationsOptions {
        return mergeFilter("filterColumnsInclude", new com.sdtk.std.FilterAllowEqualString(value));
    }

    public function excludeRow(value : String) : ConverterInputOperationsOptions {
        return mergeFilter("filterRowsExclude", new com.sdtk.std.FilterBlockEqualString(value));
    }

    public function includeRow(value : String) : ConverterInputOperationsOptions {
        return mergeFilter("filterRowsIncludee", new com.sdtk.std.FilterAllowEqualString(value));
    }

    private function mergeFilter(key : String, value : com.sdtk.std.Filter) : ConverterInputOperationsOptions {
        var current : Array<com.sdtk.std.Filter> = _values.get(key);

        if (current == null) {
            current = new Array<com.sdtk.std.Filter>();
        }

        current.push(value);
        _values.set(key, current);

        return this;
    }

    public function output() : ConverterOutputOptions {
        return new ConverterOutputOptions(_values);
    }
}

@:expose
@:nativeGen
class ConverterInputOperationsOptionsDelimited extends ConverterInputOperationsOptions {
    public function new(?values : Null<Map<String, Dynamic>>) {
        super(values);
    }

    public function excludeHeader(?value : Bool = true) : ConverterInputOperationsOptionsDelimited {
        return setValue("header", !value);
    }

    public function textOnly(?value : Bool = true) : ConverterInputOperationsOptionsDelimited {
        return setValue("textOnly", !value);
    }    

    private function setValue(key : String, value : Bool) : ConverterInputOperationsOptionsDelimited {
        var options : Map<String, Dynamic> = cast _values.get("inputOptions");
        if (options == null) {
            options = new Map<String, Dynamic>();
            _values.set("inputOptions", options);
        }
        options.set(key, value);

        return this;
    }
}