package com.sdtk.table;

import com.sdtk.std.*;

@:nativeGen
class INIHandler implements KeyValueHandler {
  private function new() { }

  public static var instance : KeyValueHandler = new INIHandler();

  public function favorReadAll() : Bool {
    return true;
  }

  public function oneRowPerFile() : Bool {
    return false;
  }

  private static function convertFrom(sValue : String) : String {
    sValue = StringTools.trim(sValue);
    sValue = StringTools.replace(sValue, "\\\\", "\\");
    sValue = StringTools.replace(sValue, "\\'", "'");
    sValue = StringTools.replace(sValue, "\\\"", "\"");
    sValue = StringTools.replace(sValue, "\\0", "\x00");
    sValue = StringTools.replace(sValue, "\\a", "\x07");
    sValue = StringTools.replace(sValue, "\\b", "\x08");
    sValue = StringTools.replace(sValue, "\\t", "\t");
    sValue = StringTools.replace(sValue, "\\r", "\r");
    sValue = StringTools.replace(sValue, "\\n", "\n");
    sValue = StringTools.replace(sValue, "\\;", ";");
    sValue = StringTools.replace(sValue, "\\#", "#");
    sValue = StringTools.replace(sValue, "\\=", "=");
    sValue = StringTools.replace(sValue, "\\:", ":");
    // TODO - \x????
    return sValue;
  }

  private static function convertTo(sValue : String) : String {
    sValue = StringTools.replace(sValue, "\\", "\\\\");
    sValue = StringTools.replace(sValue, "'", "\\'");
    sValue = StringTools.replace(sValue, "\"", "\\\"");
    sValue = StringTools.replace(sValue, "\x00", "\\0");
    sValue = StringTools.replace(sValue, "\x07", "\\a");
    sValue = StringTools.replace(sValue, "\x08", "\\b");
    sValue = StringTools.replace(sValue, "\t", "\\t");
    sValue = StringTools.replace(sValue, "\r", "\\r");
    sValue = StringTools.replace(sValue, "\n", "\\n");
    sValue = StringTools.replace(sValue, ";", "\\;");
    sValue = StringTools.replace(sValue, "#", "\\#");
    sValue = StringTools.replace(sValue, "=", "\\=");
    sValue = StringTools.replace(sValue, ":", "\\:");
    sValue = StringTools.trim(sValue);
    // TODO - \x????
    return sValue;
  }

  public function read(rReader : Reader) : Map<String, Dynamic> {
    rReader = rReader.switchToLineReader();
    var mMap : Map<String, Dynamic> = new Map<String, Dynamic>();
    while (rReader.hasNext()) {
      var sLine : String = rReader.peek();
      var sFirst : String = sLine.charAt(0);
      if (sFirst == "[") {
        break;
      } else if (sFirst == ";" || (sFirst == "#" && sLine.charAt(1) == " ")) {
        rReader.next();
        continue;
      } else {
        var iIndex : Int = sLine.indexOf("=");
        mMap.set(convertFrom(sLine.substr(0, iIndex)), convertFrom(sLine.substr(iIndex + 1)));
        rReader.next();
      }
    }
    return mMap;
  }

  public function write(wWriter : Writer, mMap : Map<String, Dynamic>) : Void {
    wWriter = wWriter.switchToLineWriter();
    
    {
      var value : Dynamic = mMap["__name__"];
      if (value != null) {
        wWriter.write("[" + convertTo(Std.string(value)) + "]\n");
        value = null;
      }
    }
    
    #if (hax_ver >= 4)
    for (key => value in mMap) {
    #else
    for (key in mMap.keys()) {
      var value : Dynamic = mMap[key];
    #end
      if (key != "__name__") {
        wWriter.write(convertTo(key) + "=" + convertTo(Std.string(value)) + "\n");
      }
    }
  }

  public function readAll(rReader : Reader, aMaps : Array<Map<String, Dynamic>>, aNames : Array<Dynamic>) : Void {
    rReader = rReader.switchToLineReader();
    while (rReader.hasNext()) {
      var sLine : String = rReader.peek();
      var sFirst : String = sLine.charAt(0);
      if (sFirst == ";" || (sFirst == "#" && sLine.charAt(1) == " ")) {
        continue;
      } else if (sFirst == "[") {
        var sKey : String = sLine.substr(1);
        if (sKey.charAt(sKey.length - 1) == "\n") {
          sKey = sKey.substr(0, sKey.length - 1);
        }
        if (sKey.charAt(sKey.length - 1) == "]") {
          sKey = sKey.substr(0, sKey.length - 1);
        }
        sKey = convertTo(sKey);
        rReader.next();
        aMaps.push(read(rReader));
        aNames.push(sKey);
      } else {
        aMaps.push(read(rReader));
        aNames.push("");
      }
    }
  }

  public function writeAll(wWriter : Writer, aMaps : Array<Map<String, Dynamic>>, aNames : Array<Dynamic>) : Void {
    var i : Int = 0;
    wWriter = wWriter.switchToLineWriter();
    while (i < aMaps.length) {
      wWriter.write("[" + convertTo(aNames[i]) + "]");
      write(wWriter, aMaps[i++]);
    }
  }
}