@if "%DEBUG%"=="" @echo off
@setlocal enabledelayedexpansion

@REM
@REM Available decompiler types:
@REM   vf10: https://github.com/Vineflower/vineflower/tree/develop/1.10.0
@REM

if "%1"=="vf10" (
    set VF_REPO=https://s01.oss.sonatype.org/content/repositories/snapshots/org/vineflower/vineflower/1.10.0-SNAPSHOT/
    set URL=!VF_REPO!vineflower-1.10.0-20231209.170602-69.jar

    for /f %%i in ('curl -s !URL!.sha512') do (
        set EXPECTED_HASH=%%i
    )

    set FILE=%~dp0vineflower.jar
) else (
    echo Unknown source: %1
    exit /b 1
)

@REM Overwrite the filepath if specified.
if not "%2"=="" (
    set FILE=%2
)

set hash=""

@REM If the file does not exist, just download.
if not exist %FILE% (
    goto download
)

@REM Calculate the hash of decompiler.
for /f %%i in ('certutil -hashfile "%FILE%" SHA512 ^| find /i /v "SHA512" ^| find /i /v "certutil"') do set hash=%%i

@REM If the hash of decompiler is expected, exit this script.
if "%EXPECTED_HASH%"=="%hash%" (
    goto end
) else (
    goto download
)

:download

curl -s -L %URL% -o %FILE%

:end
