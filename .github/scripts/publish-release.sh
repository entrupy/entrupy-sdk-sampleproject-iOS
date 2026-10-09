#!/usr/bin/env bash
# Tags <ver> at <commit> and creates the GitHub release, once.
# Usage: publish-release.sh <ver> <commit>
# Needs GH_TOKEN with contents: write. Never moves or deletes an existing tag.
set -eo pipefail

VER="$1"
COMMIT="$2"
[ -n "$VER" ] && [ -n "$COMMIT" ] || { echo "usage: $0 <ver> <commit>"; exit 2; }

if gh release view "$VER" >/dev/null 2>&1; then
  # Peeled ref (annotated tag) sorts after the plain one; take the last line.
  TAGGED=$(git ls-remote origin "refs/tags/$VER" "refs/tags/$VER^{}" | awk '{print $1}' | tail -1)
  if [ "$TAGGED" = "$COMMIT" ]; then
    echo "Release $VER already exists at $COMMIT, nothing to do"
  else
    echo "::warning::Release $VER already exists and its tag points at ${TAGGED:-nothing}, not at $COMMIT. Left untouched; this job never moves tags."
  fi
  exit 0
fi

if git ls-remote --exit-code --tags origin "refs/tags/$VER" >/dev/null 2>&1; then
  echo "::error::Tag $VER already exists but has no GitHub release. Check what the tag points at and create the release by hand; this job never moves or deletes tags."
  exit 1
fi

gh release create "$VER" --target "$COMMIT" --title "Release $VER" \
  --notes "Sample App for Entrupy SDK $VER. SDK release: https://github.com/entrupy/entrupy-sdk-iOS/releases/tag/$VER"
echo "Published release $VER at $COMMIT"
