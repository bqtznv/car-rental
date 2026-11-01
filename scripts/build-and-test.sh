#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != Darwin ]]; then
  echo 'This script requires macOS with Xcode and an iOS Simulator runtime.' >&2
  exit 1
fi
command -v xcodebuild >/dev/null
command -v python3 >/dev/null
SIMULATOR_ID="$(xcrun simctl list devices booted --json | python3 -c '
import json,sys
devices=[d for group in json.load(sys.stdin)["devices"].values() for d in group if d.get("state")=="Booted" and d.get("isAvailable",False)]
if len(devices)!=1:
    sys.exit("Boot exactly one iOS simulator in Xcode before running this script.")
print(devices[0]["udid"])
')"
xcrun simctl bootstatus "$SIMULATOR_ID" -b
xcodebuild -project CarRental.xcodeproj -scheme CarRental -configuration Debug \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO test
xcrun simctl install "$SIMULATOR_ID" build/DerivedData/Build/Products/Debug-iphonesimulator/CarRental.app
xcrun simctl launch "$SIMULATOR_ID" com.example.openroad
