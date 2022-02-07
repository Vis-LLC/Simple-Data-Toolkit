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
    Standard/Core Library - Source code can be found on SourceForge.net
*/

package com.sdtk.std;

@:expose
@:nativeGen
class FilterAllowWithString extends Filter {
    private var _searchFor : String;

    public function new(sSearchFor : String) {
        super();
        _searchFor = sSearchFor;
    }

    public override function filter(sValue : Null<String>) : Null<String> {
        if (sValue != null) {
            if (sValue.indexOf(_searchFor) >= 0) {
                return sValue;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
}