@echo off
set TARGET=appdirs

if "%1"=="help" goto usage
if "%1"=="--help" goto usage

where stable > nul
if errorlevel 1 goto nostable
where ponyc > nul
if errorlevel 1 goto noponyc

set GOTOCLEAN=false
if "%1"=="clean" (
  set GOTOCLEAN=true
  shift
)

set CONFIG=release
set DEBUG=
if "%1"=="config" (
  if "%2"=="debug" (
    set CONFIG=debug
    set DEBUG=--debug
  )
  shift
  shift
)

set BUILDDIR=build\%CONFIG%

if "%GOTOCLEAN%"=="true" goto clean
if "%1"=="test" goto test
if "%1"=="fetch" goto fetch

:build
if not exist "%BUILDDIR%" mkdir "%BUILDDIR%""
stable env ponyc %DEBUG% -o %BUILDDIR% %TARGET%
if errorlevel 1 goto error
goto done

:fetch
stable fetch
if errorlevel 1 goto error
goto done

:test
if not exist %BUILDDIR%\appdirs.exe (
  stable fetch
  stable env ponyc %DEBUG% -o %BUILDDIR% %TARGET%
)
if errorlevel 1 goto error
%BUILDDIR%\appdirs.exe
if errorlevel 1 goto error
goto done

:clean
if exist %BUILDDIR% rmdir /s /q %BUILDDIR%
goto done

:usage
echo Usage: make (help^|clean^|build^|test) [config=debug^|release]
goto done

:nostable
echo You need "stable.exe" (from https://github.com/ponylang/pony-stable) in your PATH.
goto error

:noponyc
echo You need "ponyc.exe" (from https://github.com/ponylang/ponyc) in your PATH.
goto error

:error
%COMSPEC% /c exit 1

:done
