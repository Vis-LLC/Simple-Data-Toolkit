package com.sdtk.std;

#if (!cs && !java && !JS_BROWSER && !JS_NODE && !JS_WSH)
import haxe.io.Input;
import haxe.io.Output;

class AbstractReader extends Reader {
  private var _next : Null<String> = null;
  private var _reader : Null<Input>;
  private var _mode : Int = 0;
  

  public function new(iReader : Input) {
    super();
    _reader = iReader;
    _next = "";
  }

  public override function start() : Void {
    moveToNext();
  }

  private function moveToNext() {
      try {
            switch (_mode) {
                case 0:
                    _next = _reader.readString(1);
                case 1:
                    _next = _reader.readLine();
        }
          
      } catch (message : Dynamic) {
          dispose();
      }
  }

  public override function next() : String {
    var sValue : Null<String> = _next;
    if (sValue != null) {
        moveToNext();
    }
    return sValue;
  }

  public override function peek() : String {
    return _next;
  }

  public override function dispose() {
    if (_reader != null) {
      _reader.close();    
      _reader = null;
      _next = null;
    }
  }

    public override function unwrapOne() : Reader {
        _mode = 0;
        return this;
    }

    public override function unwrapAll() : Reader {
        _mode = 0;
        return this;
    }

    public override function switchToLineReader() : Reader {
        _mode = 1;
        return this;
    }

  public override function hasNext() : Bool {
    return (_next != null);
  }
}

class AbstractWriter extends Writer {
  private var _writer : Null<Output>;

  public function new(oWriter : Output) {
    super();
    _writer = oWriter;
  }

  public override function dispose() : Void {
    if (_writer != null) {
      _writer.close();
      _writer = null;
    }
  }

  public override function flush() : Void {
    _writer.flush();
  }  

  public override function write(str : String) : Void {
    _writer.writeString(str);
  }
}
#end