@echo off
setlocal
git submodule update --init --recursive
if %errorlevel% neq 0 exit /b %errorlevel%
rd build /s /q
mkdir build
dotnet publish FlightStreamDeck.AddOn\FlightStreamDeck.AddOn.csproj -c Release -r win-x64 --self-contained
if %errorlevel% neq 0 exit /b %errorlevel%
XCopy FlightStreamDeck.AddOn\bin\Release\net9.0-windows\win-x64\publish build\tech.flighttracker.streamdeck.sdPlugin /e /h /c /i
if %errorlevel% neq 0 exit /b %errorlevel%

rem Package the plugin using Elgato's official Stream Deck CLI (@elgato/cli).
rem Elgato retired the standalone DistributionTool.exe; "streamdeck pack" replaces it.
set "STREAMDECK_CLI=%~dp0node_modules\.bin\streamdeck.cmd"

rem Ensure the CLI (and other dev dependencies) are installed locally.
if not exist "%STREAMDECK_CLI%" (
    echo Installing dev dependencies ^(@elgato/cli^)...
    call npm install
    if %errorlevel% neq 0 exit /b %errorlevel%
)

if not exist "%STREAMDECK_CLI%" (
    echo ERROR: Could not find the Stream Deck CLI at "%STREAMDECK_CLI%".
    echo Install it with: npm install -D @elgato/cli
    echo Docs: https://docs.elgato.com/streamdeck/sdk/introduction/distribution/
    exit /b 1
)

pushd build
rem --ignore-validation keeps the lenient behavior of the old DistributionTool;
rem remove it once manifest.json passes the current schema validation.
call "%STREAMDECK_CLI%" pack tech.flighttracker.streamdeck.sdPlugin -o . -f --no-update-check --ignore-validation
if %errorlevel% neq 0 (popd & exit /b %errorlevel%)
popd
endlocal
exit /b 0
