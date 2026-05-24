# t3X AppImage Maker

This folder contains the tools to convert a `.t3x` game file into a standalone Linux AppImage.

## Requirements
- Node.js & npm
- Linux (for AppImage building)

## Usage
1. Place your `.t3x` file anywhere.
2. Run the build script from this directory:
   ```bash
   ./build.sh ../games/shooter.t3x
   ```
3. The script will:
   - Create a temporary build directory.
   - Bundle the `t3xengine` logic.
   - Inject the game code so it auto-starts.
   - Package everything into a single `.AppImage` file.

## Output
The resulting AppImage will be located in `make/build_tmp/dist/`.
