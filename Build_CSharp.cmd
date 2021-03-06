#!/bin/sh
@ECHO OFF
pushd .
cd "%~dp0"
cd $(dirname "$0")
mkdir out 2> NUL
haxe -cs out com.sdtk -cp src -D %* $*
haxe -cs out -main com.sdtk.log.Transfer -cp src -D %* $*
haxe -cs out -main com.sdtk.table.Converter -cp src -D %* $*
haxe -cs out -main com.sdtk.calendar.Create -cp src -D %* $*
move out\bin\Transfer.exe out\slg.exe > NUL 2> NUL
move out\bin\Create.exe out\calendar.exe > NUL 2> NUL
move out\bin\Converter.exe out\stc.exe > NUL 2> NUL
move out\bin\out.dll out\sdtk.dll > NUL 2> NUL


REM sh ./Build_Docs
REM cmd /c .\Build_Docs
popd