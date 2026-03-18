#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
OBS_CONFIG="$HOME/Library/Application Support/obs-studio"
OBS_SCENES="$OBS_CONFIG/basic/scenes"
OBS_PROFILES="$OBS_CONFIG/basic/profiles"

echo "Exporting OBS config into repo..."
echo "  OBS config: $OBS_CONFIG"
echo "  Repo:       $REPO_DIR"
echo ""

# 1. Export scene collection (replace actual home dir with __HOME__ placeholder)
if [ -f "$OBS_SCENES/Untitled.json" ]; then
    sed "s|$HOME|__HOME__|g" "$OBS_SCENES/Untitled.json" > "$REPO_DIR/scenes/Untitled.json"
    echo "✓ Exported scene collection"
else
    echo "⚠ Scene collection not found at $OBS_SCENES/Untitled.json"
fi

# 2. Export profiles
for profile_dir in "$OBS_PROFILES"/*/; do
    profile_name="$(basename "$profile_dir")"
    target_dir="$REPO_DIR/profiles/$profile_name"
    mkdir -p "$target_dir"
    for file in "$profile_dir"*; do
        [ -f "$file" ] || continue
        sed "s|$HOME|__HOME__|g" "$file" > "$target_dir/$(basename "$file")"
    done
    echo "✓ Exported profile: $profile_name"
done

echo ""
echo "Done! Review changes with 'git diff' and commit when ready."
