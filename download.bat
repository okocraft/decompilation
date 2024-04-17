@if "%DEBUG%"=="" @echo off
@setlocal enabledelayedexpansion

@REM
@REM Available decompiler types:
@REM   vf: https://github.com/Vineflower/vineflower/
@REM   vf10 (Deprecated, use vf instead): https://github.com/Vineflower/vineflower/ 
@REM

if "%1"=="vf" (
    goto vf
) else if "%1"=="vf10" (
    goto vf
) else (
    echo Unknown source: %1
    exit /b 1
)

@REM Define the url of Vineflower
:vf

set VF_REPO=https://repo.maven.apache.org/maven2/org/vineflower/vineflower/1.10.1/
set URL=!VF_REPO!vineflower-1.10.1.jar

for /f %%i in ('curl -s !URL!.sha512') do (
    set EXPECTED_HASH=%%i
)

set FILE=%~dp0vineflower.jar

goto hash

:hash

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
