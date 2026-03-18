#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
OBS_CONFIG="$HOME/Library/Application Support/obs-studio"
OBS_SCENES="$OBS_CONFIG/basic/scenes"
OBS_PROFILES="$OBS_CONFIG/basic/profiles"
OBS_ASSETS="$OBS_CONFIG/assets"

# Check OBS is not running
if pgrep -x "OBS" > /dev/null 2>&1; then
    echo "Error: OBS is running. Please quit OBS first."
    exit 1
fi

echo "Importing OBS config from repo into OBS..."
echo "  Repo:       $REPO_DIR"
echo "  OBS config: $OBS_CONFIG"
echo ""

# 1. Copy assets
mkdir -p "$OBS_ASSETS"
cp -R "$REPO_DIR/assets/"* "$OBS_ASSETS/"
echo "✓ Copied assets into $OBS_ASSETS"

# 2. Copy and expand scene collection (replace __HOME__ with actual home dir)
mkdir -p "$OBS_SCENES"
sed "s|__HOME__|$HOME|g" "$REPO_DIR/scenes/Untitled.json" > "$OBS_SCENES/Untitled.json"
echo "✓ Installed scene collection"

# 3. Copy and expand profiles
mkdir -p "$OBS_PROFILES"
for profile_dir in "$REPO_DIR/profiles"/*/; do
    profile_name="$(basename "$profile_dir")"
    target_dir="$OBS_PROFILES/$profile_name"
    mkdir -p "$target_dir"
    for file in "$profile_dir"*; do
        [ -f "$file" ] || continue
        sed "s|__HOME__|$HOME|g" "$file" > "$target_dir/$(basename "$file")"
    done
    echo "✓ Installed profile: $profile_name"
done

echo ""
echo "Done! Open OBS and verify your scenes."
echo ""
echo "NOTE: You may need to re-select hardware sources (camera, capture card, iPhone)"
echo "      in each scene — device IDs are machine-specific."
