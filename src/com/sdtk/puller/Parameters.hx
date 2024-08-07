/*
    Copyright (C) 2023 Vis LLC - All Rights Reserved

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
    Simple Puller (SP) - Source code can be found on SourceForge.net
*/

package com.sdtk.puller;

#if !EXCLUDE_PARAMETERS
/**
  Handles command-line parameters.
**/
@:nativeGen
class Parameters extends com.sdtk.std.Parameters {
  private var _sources : Array<String> = new Array<String>();
  private var _output : Array<String> = new Array<String>();
  private var _stage : Int = -1;
  private var _parameterList : Array<String> = null;
  private static final GET_EXECUTE : Int = -1;
  private static final GET_EXTRACT : Int = -2;
  private static final GET_GIT_HTTP : Int = 0;
  private static final GET_GIT_CLIENT : Int = 1;
  private static final GET_HTTP : Int = 2;
  private static final GET_CUSTOM_WEB_API : Int = 3;
  private static final GET_CUSTOM_WEB_API_FILE : Int = 4;
  private static final GET_TORRENT : Int = 5;
  private static final GET_BLOB : Int = 6;

  public static function typeOfAccess(s : String) : Int {
    if (s.indexOf("https://github.com/") == 0) { // https://github.com/Vis-LLC/Simple-Data-Toolkit.git
        return GET_GIT_HTTP;
    } else if (s.indexOf("x-github-client://") == 0) { // x-github-client://openRepo/https://github.com/Vis-LLC/Simple-Data-Toolkit {
        return GET_GIT_CLIENT;
    } else if (s.indexOf("http://") == 0 || s.indexOf("https://") == 0) {
        return GET_HTTP;
    } else if (s.indexOf("{") == 0) {
        return GET_CUSTOM_WEB_API;
    } else if (s.indexOf("x-sdtk-custom-web-api://") == 0) {
        return GET_CUSTOM_WEB_API_FILE;
    } else {
        return GET_EXECUTE;
    }
  }

  public override function getParameter(i : Int) : Null<String> {
    if (_parameterList == null) {
      return super.getParameter(i);
    } else {
      if (i < _parameterList.length) {
        return _parameterList[i];
      } else {
        return null;
      }
    }
    // TODO - Remove
    //var parameters : Array<String> = ["https://github.com/rtyley/small-test-repo", "Build_Python.cmd", "dominarvis@gmail.com"];
    // ["https://github.com/Vis-LLC/Restricted-Roller.git", "Build_Python.cmd", "dominarvis@gmail.com"];
  }

  private static function endsWith(s : String, e : String) : Bool {
    return s.substr(s.length - e.length) == e;
  }

  private function isDataFile(s : String) : Bool {
    s = s.toLowerCase();
    return endsWith(s, ".csv") || endsWith(s, ".tsv") || endsWith(s, ".psv") || endsWith(s, ".json") || endsWith(s, ".xml") || endsWith(s, ".yaml") || endsWith(s, ".yml") || endsWith(s, ".json");
  }

  private function addParameterListSection(s : String) : Void {
    _parameterList.push(s);
  }

  private function setParameterList(sFile : String) : Void {
    var sFileType : String;
    var parameterListSection : Array<String> = _parameterList;
    _parameterList = new Array<String>();
    var i : Int = 0;
    {
      var sFile2 : Array<String> = sFile.toLowerCase().split(".");
      sFileType = sFile2[sFile2.length - 1];
      sFile2 = null;
    }
    var rReader : com.sdtk.std.FileReader = new com.sdtk.std.FileReader(sFile);
    var drReader : com.sdtk.table.DataTableReader = null;
    switch (sFile) {
      case "csv":
        drReader = com.sdtk.table.DelimitedReader.createCSVReader(rReader);
      case "tsv":
        drReader = com.sdtk.table.DelimitedReader.createTSVReader(rReader);
      case "psv":
        drReader = com.sdtk.table.DelimitedReader.createPSVReader(rReader);
      case "json":
        drReader = com.sdtk.table.KeyValueReader.createJSONReader(rReader);
    }
    rReader = null;
    drReader.start();
    while (drReader.hasNext()) {
      var rRow = drReader.next();
      var mRow = rRow.toHaxeMap();

      if (parameterListSection.length <= 0 || parameterListSection.indexOf(mRow.get("name")) >= 0) {
        switch (mRow.get("type")) {
          case "CustomWebAPI":
        }
      }
    }
    drReader.dispose();
  }

  public function new() {
    super();
    var i : Int = 0;
    var sParameter : Null<String>;

    do {
      sParameter = getParameter(i);
      if (isDataFile(sParameter) && i == 0) {
        _parameterList = new Array<String>();
        var sDataFile : String = sParameter;
        i++;
        sParameter = getParameter(i);
        while (sParameter != null) {
          addParameterListSection(sParameter);
          i++;
          sParameter = getParameter(i);
        }
        setParameterList(sDataFile);
        i = 0;
        continue;
      }
      if (i == (length() - 1)) {
        _output.push(sParameter);
      } else {
        _sources.push(sParameter);
      }
      i++;
    } while (sParameter != null);
  }

  public static function getSourceFrom(s : String) : Source {
    var input : com.sdtk.api.InputAPI = null;
    var mapping : Map<String, String> = new Map<String, String>();
    switch (typeOfAccess(s)) {
      case GET_GIT_HTTP, GET_GIT_CLIENT:
        input = com.sdtk.api.GitAPI.instance().parse(s);
      case GET_HTTP:
        {
          var custom = com.sdtk.api.CustomWebAPI.create(s);
          custom.setUrl(s);
          return Source.fromCustomWebAPI(custom);
        }
      case GET_CUSTOM_WEB_API:
        {
          var custom = com.sdtk.api.CustomWebAPI.singleFromJSON(s);
          return Source.fromCustomWebAPI(custom);
        }
      case GET_CUSTOM_WEB_API_FILE:
        {
          if (s.indexOf("x-sdtk-custom-web-api://") == 0) {
            s = s.substr("x-sdtk-custom-web-api://".length);
          }
          var custom = com.sdtk.api.CustomWebAPI.singleFromJSON((new com.sdtk.std.FileReader(s)).toString());
          return Source.fromCustomWebAPI(custom);
        }
    }
    return Source.fromInputAPI(input);
  }

  public function getSource() : Source {
    #if sys
      Sys.println("Stage: " + _stage + " of " + (_sources.length + _output.length));
    #end
    if (_stage > _sources.length || _stage < 0) {
      return null;
    } else {
      // TODO - Remove try
      try {
        return getSourceFrom(_sources[_stage]);
      } catch (ex : Any) {
        return null;
      }
    }
    return null;
  }

  public function getOutput() : Source {
    return null;
  }

  public function next() : Bool {
    _stage++;
    return _stage < (_sources.length + _output.length);
  }
}
#end
