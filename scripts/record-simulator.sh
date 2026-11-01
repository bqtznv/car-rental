#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ "$(uname -s)" != Darwin ]]; then
  echo 'Simulator recording requires macOS and Xcode.' >&2
  exit 1
fi
mkdir -p build
if [[ -e build/OpenRoad-demo.mp4 ]]; then
  echo 'Preserving existing build/OpenRoad-demo.mp4. Move or rename it before recording again.' >&2
  exit 1
fi
echo 'Recording the booted simulator. Press Control-C to finish and finalize the MP4.'
exec xcrun simctl io booted recordVideo --codec=h264 build/OpenRoad-demo.mp4
