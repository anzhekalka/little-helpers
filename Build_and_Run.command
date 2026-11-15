#!/bin/bash
# Double-click this file to build Little Helpers and start it.
cd "$(dirname "$0")"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Apple's Command Line Tools are needed to build the app."
  echo "A window will appear: click Install. When it finishes, double-click this file again."
  xcode-select --install
  read -p "Press Enter to close this window."
  exit 1
fi

APP="Little Helpers.app"
echo "Building Little Helpers..."
pkill -x LittleHelpers 2>/dev/null
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"

if ! swiftc -O -swift-version 5 LittleHelpers.swift -o "$APP/Contents/MacOS/LittleHelpers" -framework AppKit; then
  echo
  read -p "The build failed (details above). Press Enter to close this window."
  exit 1
fi

codesign --force --sign - "$APP" >/dev/null 2>&1
open "$APP"
echo
echo "Little Helpers is running. Look for the paw icon in your menu bar."
echo "You can close this window."
