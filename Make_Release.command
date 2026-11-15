#!/bin/bash
# Double-click to build a ready-to-share "Little Helpers.app" and zip it for GitHub.
cd "$(dirname "$0")"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Apple's Command Line Tools are needed. Click Install, then run this file again."
  xcode-select --install
  read -p "Press Enter to close this window."
  exit 1
fi

APP="Little Helpers.app"
rm -rf build LittleHelpers-mac.zip
mkdir -p "build/$APP/Contents/MacOS"
cp Info.plist "build/$APP/Contents/Info.plist"

echo "Building for Apple silicon..."
if ! swiftc -O -swift-version 5 -target arm64-apple-macos11 LittleHelpers.swift \
     -o build/lh-arm64 -framework AppKit; then
  read -p "The build failed (details above). Press Enter to close this window."
  exit 1
fi

echo "Building for Intel..."
if swiftc -O -swift-version 5 -target x86_64-apple-macos11 LittleHelpers.swift \
     -o build/lh-x86_64 -framework AppKit; then
  lipo -create build/lh-arm64 build/lh-x86_64 -output "build/$APP/Contents/MacOS/LittleHelpers"
  echo "Made one app that runs on both Apple silicon and Intel Macs."
else
  cp build/lh-arm64 "build/$APP/Contents/MacOS/LittleHelpers"
  echo "Intel build failed, so this app runs on Apple silicon Macs only."
fi

codesign --force --sign - "build/$APP"
ditto -c -k --keepParent "build/$APP" LittleHelpers-mac.zip
rm -rf build

echo
echo "Done: LittleHelpers-mac.zip is ready to upload to a GitHub release."
open -R LittleHelpers-mac.zip
