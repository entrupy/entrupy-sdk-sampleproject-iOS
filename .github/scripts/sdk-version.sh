#!/usr/bin/env bash
# Prints the Entrupy SDK version the Sample App is released against, and whether the
# project links the SDK as a Swift package.
#
# Source of truth, in order:
#   1. the entrupy-sdk-iOS package reference in project.pbxproj (either
#      `kind = upToNextMajorVersion; minimumVersion = X;` or `kind = exactVersion; version = X;`)
#   2. the `SDK Version: X` footer the release pipeline appends to README.md
#      (the project is still on CocoaPods; only the tag check can run)
#
# Writes ver=<X> and spm=<true|false> to $GITHUB_OUTPUT (stdout when unset).
set -eo pipefail

PBX="Sample App.xcodeproj/project.pbxproj"
URL='repositoryURL = "https://github.com/entrupy/entrupy-sdk-iOS'

if grep -q "$URL" "$PBX"; then
  SPM=true
  VER=$(grep -A4 "$URL" "$PBX" | grep -oE '(minimumVersion|version) = [0-9.]+' | awk '{print $3}' | head -1 || true)
  [ -n "$VER" ] || { echo "::error::entrupy-sdk-iOS package reference in $PBX has no version requirement"; exit 1; }
else
  SPM=false
  echo "::warning::$PBX has no Swift package reference to entrupy-sdk-iOS (still on CocoaPods); reading the version from README.md"
  VER=$(grep -oE '^SDK Version: [0-9.]+' README.md | awk '{print $3}' | tail -1 || true)
  [ -n "$VER" ] || { echo "::error::no SDK version found: $PBX has no entrupy-sdk-iOS package reference and README.md has no 'SDK Version:' footer"; exit 1; }
fi

echo "SDK version: $VER (Swift package: $SPM)"
{ echo "ver=$VER"; echo "spm=$SPM"; } >> "${GITHUB_OUTPUT:-/dev/stdout}"
