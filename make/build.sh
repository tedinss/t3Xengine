#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./build.sh <path_to_t3x_file>"
  exit 1
fi

T3X_FILE=$1
APP_NAME=$(basename "$T3X_FILE" .t3x)
BUILD_DIR="build_tmp"

echo "Preparing build for $APP_NAME..."

# Create temp build dir
mkdir -p $BUILD_DIR
cp package.json main.js $BUILD_DIR/
cp ../index.html $BUILD_DIR/

# Read the .t3x file and escape it for JS string
T3X_CONTENT=$(cat "$T3X_FILE" | sed 's/\\/\\\\/g' | sed 's/`/\\`/g' | sed 's/\$/\\\$/g')

# Modify index.html to auto-load the content
# We hide the UI and call compile() on window load
cat <<EOF > $BUILD_DIR/inject.js
window.addEventListener('load', () => {
  const content = \`$T3X_CONTENT\`;
  if (typeof compile === 'function') {
    compile(content);
    const ui = document.getElementById('ui');
    if (ui) ui.style.display = 'none';
  }
});
EOF

# Inject the script into index.html before </body>
sed -i 's/<\/body>/<script src="inject.js"><\/script><\/body>/' $BUILD_DIR/index.html

# Update package.json name
sed -i "s/\"name\": \"t3x-app\"/\"name\": \"t3x-$APP_NAME\"/" $BUILD_DIR/package.json

echo "Installing dependencies (this may take a while)..."
cd $BUILD_DIR
npm install --silent

echo "Building AppImage..."
npm run dist

echo "Done! Check $BUILD_DIR/dist/ for the AppImage."
