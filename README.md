## Flight Tracker Stream Deck Plugin

This is a plugin for Elgato Stream Deck to interface with flight simulators via SimConnect.

The current code target x64 and the latest SimConnect from Microsoft Flight Simulator. 
However, if you compile for x86 and reference SimConnect SDK from FSX, this plugin should also work with FSX and P3D.

### For Users

If you just want to use the plugin with your Stream Deck, take a look at [User Guide](docs/USERGUIDE.md).

### For Developers

#### Build Requirements

- Windows
- .NET SDK 9.x (the project targets `net9.0-windows`)
- Node.js + npm (used to install and run Elgato's packaging CLI)

#### Build The Plugin Package

Run this from the repository root:

```powershell
.\build.bat
```

What `build.bat` now does:

1. Updates git submodules (`git submodule update --init --recursive`)
2. Cleans and recreates the `build` folder
3. Publishes the add-on with `dotnet publish` for `win-x64`
4. Copies publish output to `build\tech.flighttracker.streamdeck.sdPlugin`
5. Packages with Elgato's official CLI (`@elgato/cli`) via:

```powershell
streamdeck pack tech.flighttracker.streamdeck.sdPlugin -o . -f --no-update-check --ignore-validation
```

Notes:

- The script auto-runs `npm install` if `node_modules\.bin\streamdeck.cmd` is missing.
- The old standalone `DistributionTool.exe` is no longer required for this repository build flow.
- Packaging uses `--ignore-validation` to keep compatibility with the previous, more lenient packaging behavior.
- Expected output package location:
	`build\tech.flighttracker.streamdeck.streamDeckPlugin`

#### Manual Installation

Copy the output to `%appdata%\Elgato\StreamDeck\Plugins\tech.flighttracker.streamdeck.sdPlugin` and restart Stream Deck software. You can find a deploy.bat file that does the same thing.

### TODO

- [ ] Data list for generic button
- [ ] Sample profile