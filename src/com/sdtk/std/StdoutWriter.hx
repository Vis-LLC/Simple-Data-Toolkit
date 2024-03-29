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

#if JS_BROWSER
@:expose
@:nativeGen
class StdoutWriter extends Writer {
    public function new() {
        super();
    }

    public override function write(str : String) : Void {
        com.sdtk.std.JS_BROWSER.Console.log(str);
    }

    public override function flip() : Reader {
        return new StdinReader();
    } 
}
#elseif JS_SNOWFLAKE
@:expose
@:nativeGen
class StdoutWriter extends Writer {
    public function new() {
        super();
    }

    public override function write(str : String) : Void {
        com.sdtk.std.JS_SNOWFLAKE.Logger.log(str);
    }
}
#elseif JS_WSH
@:expose
@:nativeGen
class StdoutWriter extends Writer {
    private var _stdout : com.sdtk.std.JS_WSH.FileStreamObject;

    public function new() {
        super();
        var fso : com.sdtk.std.JS_WSH.ActiveXObject = new com.sdtk.std.JS_WSH.ActiveXObject("Scripting.FileSystemObject");
        _stdout = fso.GetStandardStream(1);
    }

    public override function dispose() : Void {
        if (_stdout != null) {
            _stdout.Close();
            _stdout = null;
        }
    }

    public override function write(str : String) : Void {
        _stdout.Write(str);
    }

    public override function flip() : Reader {
        return new StdinReader();
    } 
}
#elseif JS_NODE
@:expose
@:nativeGen
class StdoutWriter extends Writer {
    public function new() {
        super();
    }

    public override function dispose() : Void {
    }

    public override function write(str : String) : Void {
        Process.stdout.write(str);
    }

    public override function flip() : Reader {
        return new StdinReader();
    } 
}
#elseif cs
@:expose
@:nativeGen
class StdoutWriter extends com.sdtk.std.CSHARP.AbstractWriter {
    public function new() {
        super(new com.sdtk.std.CSHARP.StreamWriter(com.sdtk.std.CSHARP.SystemI.OpenStandardOutput()));
    }

    public override function flip() : Reader {
        return new StdinReader();
    }
}
#elseif java
@:expose
@:nativeGen
class StdoutWriter extends Writer {
    private var _writer : Null<com.sdtk.std.JAVA.PrintStream>;

    public function new() {
        super();
        _writer = com.sdtk.std.JAVA.SystemI.Out;
    }

    public override function write(str : String) : Void {
        _writer.print(str);
    }

    public override function flush() : Void {
        _writer.flush();
    }

    @:native('close') public override function dispose() : Void {
        if (_writer != null) {
            _writer.dispose();
            _writer = null;
        }
    }

    public override function flip() : Reader {
        return new StdinReader();
    }
}
#elseif python
@:expose
@:nativeGen
class StdoutWriter extends FileWriter {
    public function new() {
        super(null, false);
    }

    private override function open(bAppend : Bool) : Void {
        _out = python.Syntax.code("sys.stdout");
    }

    private override function close() : Void {
        _out = python.Syntax.code("{0}.flush()", _out);
    }

    public override function flip() : Reader {
        return new StdinReader();
    }
}
#elseif php
@:expose
@:nativeGen
class StdoutWriter extends FileWriter {
    public function new() {
        super("php://stdout", false);
    }

    public override function flip() : Reader {
        return new StdinReader();
    } 
}
#else
import haxe.io.Output;

@:expose
@:nativeGen
class StdoutWriter extends com.sdtk.std.HAXE.AbstractWriter {
  public function new() {
    super(Sys.stdout());
  }

  public override function flip() : Reader {
    return new StdinReader();
  } 
}
#end
// TODO