@if "%DEBUG%"=="" @echo off

@REM The decompile type. 
@REM If setting this value to "local", this script does not attempt to download the decompiler.
@REM The available types for downloading the decompiler are listed in download.bat
set DECOMPILER_TYPE=vf10

@REM The decompiler filepath.
@REM If DECOMPILER_TYPE is "local", the decompiler should be present at this filepath.
set DECOMPILER_FILE=%~dp0vineflower.jar

@REM The options passed to the decompiler.
@REM This options are for VineFlower. (https://github.com/Vineflower/vineflower)
set DECOMPILER_OPTS=-nns=true -tcs=true -vvm=true -iec=true -jrt=current "-ind=    " -jvn=false -dcc=true

@REM The directory that has the library jars.
set LIBRARY_DIR=%~dp0libs\

@REM The command to launch JVM to run the decompiler.
set JAVA_CMD=java


if "%1"=="" (
    echo Please specify the jar file.
    exit /b 1
) else (
    set JAR=%1
)

if "%2"=="" (
    set OUT=out
) else (
    set OUT=%2
)

@REM Attempt to download the decompiler.
if not "%DECOMPILER_TYPE%"=="local" (
    call download.bat %DECOMPILER_TYPE% %DECOMPILER_FILE%
)

@REM Collect libraries from the directory.
@setlocal enabledelayedexpansion
for /R %LIBRARY_DIR% %%i in (*.jar) do (
   set library=%%i
   set libraries=!libraries! --add-external="!library!"
)

%JAVA_CMD% -jar %DECOMPILER_FILE% %DECOMPILER_OPTS% %libraries% %JAR% %OUT%
