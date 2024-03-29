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
    Simple Table Converter (STC) - Source code can be found on SourceForge.net
*/

package com.sdtk.table;

#if !EXCLUDE_PARAMETERS
/**
  Handles command-line parameters.
**/
@:nativeGen
class Parameters extends com.sdtk.std.Parameters {
  private var _output : Null<String>;
  private var _input : Null<String>;
  private var _filterRowsExclude : Null<String>;
  private var _filterColumnsExclude : Null<String>;
  private var _filterRowsInclude : Null<String>;
  private var _filterColumnsInclude : Null<String>;
  private var _sortRowsBy : Null<String>;
  private var _runInTestMode : Bool = false;
  private var _verbose : Bool = false;
  private var _recordPass : Bool = false;
  private var _leftTrim : Bool = false;
  private var _rightTrim : Bool = false;
  private var _inputOptions : Map<String, Dynamic> = null;
  private var _outputOptions : Map<String, Dynamic> = null;
  
  private static function setValue(options : Map<String, Dynamic>, key : String, value : Dynamic) : Map<String, Dynamic> {
    if (options == null) {
      options = new Map<String, Dynamic>();
    }
    options.set(key, value);
    return options;
  }

  public function new() {
    super();
    var i : Int = 0;
    var sParameter : Null<String>;
    var sLocations : Array<String> = new Array<String>();

    do {
      sParameter = getParameter(i);
      if (sParameter != null) {
        switch (sParameter.toUpperCase()) {
          case "INCLUDEROWS":
            i++;
            _filterRowsInclude = getParameter(i);
          case "EXCLUDEROWS":
            i++;
            _filterRowsExclude = getParameter(i);
          case "INCLUDECOLUMNS":
            i++;
            _filterColumnsInclude = getParameter(i);
          case "EXCLUDECOLUMNS":
            i++;
            _filterColumnsExclude = getParameter(i);
          case "ORDERBY":
            i++;
            _sortRowsBy = getParameter(i);
          case "TRIM":
            _leftTrim = true;
            _rightTrim = true;
          case "LEFTTRIM":
            _leftTrim = true;
          case "RIGHTTRIM":
            _rightTrim = true;
          case "EXCLUDEHEADER":
            if (sLocations.length == 1) {
              _inputOptions = setValue(_inputOptions, "header", false);
            } else if (sLocations.length == 2) {
              _outputOptions = setValue(_outputOptions, "header", false);
            }
          case "TEXTONLY":
            if (sLocations.length == 1) {
              _inputOptions = setValue(_inputOptions, "textOnly", true);
            } else if (sLocations.length == 2) {
              _outputOptions = setValue(_outputOptions, "textOnly", true);
            }
          case "CREATEORREPLACE":
            _outputOptions = setValue(_outputOptions, "sqlType", "CreateOrReplace");
            i++;
            _outputOptions = setValue(_outputOptions, "tableName", getParameter(i));
          case "CREATE":
            _outputOptions = setValue(_outputOptions, "sqlType", "Create");
            i++;
            _outputOptions = setValue(_outputOptions, "tableName", getParameter(i));
          case "INSERT":
            _outputOptions = setValue(_outputOptions, "sqlType", "Insert");
            i++;
            _outputOptions = setValue(_outputOptions, "tableName", getParameter(i));
          case "RUNTESTS":
            _runInTestMode = true;
          case "RECORDPASS":
            _recordPass = true;
          case "VERBOSE":
            _verbose = true;
          case "RUNTIME":
            Stopwatch.setActual("Converter");
          case "PROFILE":
            Stopwatch.setDefaultActual(true);
          case "VERSION":
            printVersion();
          default:
            sLocations.push(sParameter);
        }
      }
      i++;
    } while (sParameter != null);
    switch (sLocations.length) {
      case 0:
        
      case 1:
        setInput(sLocations[0]);
      case 2:
        setInput(sLocations[0]);
        setOutput(sLocations[1]);
      default:
          throw "More than two files specified.  This indicates that the tool was run improperly.";
    }
  }

  public function fullPrint() : Void {
    printName();
    printVersion();
    printDetails();
  }

  public function printName() : Void {
    print("Simple Data Toolkit - Simple Table Converter");
  }

  public function printVersion() : Void {
    print("Version " + com.sdtk.std.Version.get());
  }

  public function printDetails() : Void {
    print("Copyright (C) 2019 Vis LLC - All Rights Reserved");
    print("");
    print("Project Home - https://sourceforge.net/projects/simple-data-toolkit/");
    print("");
    print("This program is free software: you can redistribute it and/or modify");
    print("it under the terms of the GNU Lesser General Public License as published by");
    print("the Free Software Foundation, either version 3 of the License, or");
    print("(at your option) any later version.");
    print("");
    print("This program is distributed in the hope that it will be useful,");
    print("but WITHOUT ANY WARRANTY; without even the implied warranty of");
    print("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the");
    print("GNU General Public License for more details.");
    print("");
    print("You should have received a copy of the GNU Lesser General Public License");
    print("along with this program.  If not, see <https://www.gnu.org/licenses/>.");
  }

  private inline function print(s : String) : Void {
    #if JS_BROWSER
      com.sdtk.std.JS_BROWSER.Console.log
    #elseif JS_SNOWFLAKE
      com.sdtk.stdcom.sdtk.std.JS_SNOWFLAKE.Logger.log
    #elseif JS_WSH
      com.sdtk.std.JS_WSH.WScript.Echo
    #elseif JS_NODE
      com.sdtk.std.JS_NODE.Console.log
    #else
      Sys.println
    #end
    (
      s
    );
  }

  private function getType(sLocation : String) : Int {
    var iDot : Int = sLocation.indexOf(".");
    var iHash : Int = sLocation.indexOf("#");

    if (iDot == 0 || iHash == 0) {
      return 0;
    } else if (iDot > 0) {
      return 1;
    } else {
      return -1;
    }
  }

  private function setInput(sLocation : String) : Void {
    switch (getType(sLocation)) {
      case 0:
        _input = sLocation;
      case 1:
        _input = sLocation;
    }
  }

  private function setOutput(sLocation : String) : Void {
    switch (getType(sLocation)) {
      case 0:
        _output = sLocation;
      case 1:
        _output = sLocation;
    }
  }

  public function getRunInTestMode() : Bool {
  	return _runInTestMode;
  }
  
  public function getRecordPass(): Bool {
  	return _recordPass;
  }
  
  public function getVerbose() : Bool {
  	return _verbose;
  }
  
  /**
  
  **/
  public function getOutput() : Null<String> {
    return _output;
  }

  /**
  
  **/
  public function getInput() : Null<String> {
    return _input;
  }

  private static function endsWith(s : String, t : String) : Bool {
    return (s.length - s.lastIndexOf(t)) == t.length;
  }

  private static function getFormat(sName : Null<String>) : Null<Format> {
    if (sName == null || sName.length <= 0) {
      return Format.CSV;
    }
    sName = sName.toLowerCase();
    switch (sName.substr(sName.lastIndexOf("."))) {
      case ".tex":
        return Format.TEX;
      case ".txt":
        return Format.RAW;
      case ".csv":
        return Format.CSV;
      case ".psv":
        return Format.PSV;
      case ".tsv":
        return Format.TSV;
      case ".html":
        return Format.HTMLTable;
      case ".json":
        return Format.JSON;
      case ".ini":
        return Format.INI;
      case ".sql":
        return Format.SQL;
      case ".hx":
        return Format.Haxe;
      case ".py":
        return Format.Python;
      case ".java":
        return Format.Java;
      case ".cs":
        return Format.CSharp;
      case ".properties":
        return Format.PROPERTIES;
      default:
        if (sName.indexOf("dbtype=") >= 0) {
          return Format.DB;
        }
        return null;
    }
  }

  public function getOutputFormat() : Null<Format> {
    return getFormat(getOutput());
  }

  public function getInputFormat() : Null<Format> {
    return getFormat(getInput());
  }

  /**
  
  **/
  public function getFilterRowsExclude() : Null<String> {
    return _filterRowsExclude;
  }

  /**
  
  **/
  public function getFilterRowsInclude() : Null<String> {
    return _filterRowsInclude;
  }

  /**
  
  **/
  public function getFilterColumnsExclude() : Null<String> {
    return _filterColumnsExclude;
  }

  /**
  
  **/
  public function getFilterColumnsInclude() : Null<String> {
    return _filterColumnsInclude;
  }
  
  /**
  
  **/
  public function getSortRowsBy() : Null<String> {
    return _sortRowsBy;
  }

  public function getLeftTrim() : Bool {
    return _leftTrim;
  }

  public function getRightTrim() : Bool {
    return _rightTrim;
  }

  public function getInputOptions() : Map<String, Dynamic> {
    return _inputOptions;
  }

  public function getOutputOptions() : Map<String, Dynamic> {
    return _outputOptions;
  }  
}
#end
