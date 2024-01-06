@if "%DEBUG%"=="" @echo off

@REM The decompile type. 
@REM If setting this value to "local", this script does not attempt to download the decompiler.
@REM The available types for downloading the decompiler are listed in download.bat
call :setIfAbsent DECOMPILER_TYPE vf10

@REM The decompiler filepath.
@REM If DECOMPILER_TYPE is "local", the decompiler should be present at this filepath.
call :setIfAbsent DECOMPILER_FILE %~dp0vineflower.jar

@REM The options passed to the decompiler.
@REM This options are for VineFlower. (https://github.com/Vineflower/vineflower)
call :setIfAbsent DECOMPILER_OPTS "-nns=true -tcs=true -vvm=true -iec=true -jrt=current -jvn=false -dcc=true"

@REM The directory that has the library jars.
call :setIfAbsent LIBRARY_DIR %~dp0libs\

@REM The command to launch JVM to run the decompiler.
call :setIfAbsent JAVA_CMD java

@REM The script filepath that downloads the decompiler
call :setIfAbsent DOWNLOAD_BAT %~dp0\download.bat

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
    call %DOWNLOAD_BAT% %DECOMPILER_TYPE% %DECOMPILER_FILE%
)

@REM Collect libraries from the directory.
@setlocal enabledelayedexpansion
for /R %LIBRARY_DIR% %%i in (*.jar) do (
   set library=%%i
   set libraries=!libraries! --add-external="!library!"
)

%JAVA_CMD% -jar %DECOMPILER_FILE% %DECOMPILER_OPTS% %libraries% %JAR% %OUT%

:setIfAbsent
if not defined %1 (
    set "%1=%~2"
)
exit /b 0
