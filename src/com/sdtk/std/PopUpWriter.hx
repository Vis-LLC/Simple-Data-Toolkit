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

/**
  Defines interface for sending log entries to a popup or alert.
**/
@:expose
@:nativeGen
class PopUpWriter extends Writer {
  public override function write(sLine : String) : Void {
    try {
      #if sys
        // TODO
      #elseif JS_SNOWFLAKE
        // TODO
      #elseif JS_WSH
        // TODO
      #elseif JS_NODE
        // TODO
      #elseif JS_BROWSER
        com.sdtk.std.JS_BROWSER.Window.alert(sLine);
      #else
        return null;
      #end
    } catch (msg : Dynamic) {
      return;
    }
  }
}
