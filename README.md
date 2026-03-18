# OBS Setup

Portable OBS Studio scene collection, profiles, and assets — shared across machines via Git.

## Scenes

| Scene | Resolution | Description |
|-------|-----------|-------------|
| **Agentic Hamburg** | 1920x1080 | Webcam + iPhone camera with rounded frame overlay + Agentic Hamburg overlay |
| **DL School** | 1920x1080 | iPhone camera + screen capture |
| **Vertical Scene** | 1080x1920 | Vertical format — requires Aitum Vertical plugin (see below) |

## Setup on a new Mac

```bash
# 1. Clone the repo
git clone git@github.com:stefanmunz/obs-setup.git ~/code/play/obs

# 2. Install OBS if needed
brew install --cask obs

# 3. Quit OBS if it's running, then import
cd ~/code/play/obs
./import.sh
```

This will:
- Copy assets into `~/Library/Application Support/obs-studio/assets/`
- Copy scene collection and profile into OBS's config directory
- Expand all file paths for the current user's home directory

After importing, open OBS and **re-select your hardware sources** in each scene (see [Limitations](#limitations)).

## Workflow

### Export (after editing scenes in OBS)

```bash
./export.sh
git add -A && git commit -m "describe your changes"
git push
```

This copies the scene collection and profile back into the repo, replacing absolute paths with portable `__HOME__` placeholders.

### Import (after pulling changes, or on a new machine)

```bash
git pull
./import.sh
```

Quit OBS before running import. You need to re-run import after every `git pull` to update the scenes, profile, and assets in OBS's config directory.

## Adding new assets

1. Place images/media in the appropriate `assets/` subfolder in the repo (e.g. `assets/agentic-hamburg/`, `assets/shared/`)
2. In OBS, browse to `~/Library/Application Support/obs-studio/assets/...` when selecting images
3. Export and commit

## Repo structure

```
assets/
  agentic-hamburg/     Overlays for Agentic Hamburg meetup
  shared/              Shared assets (logos, frames)
scenes/
  Untitled.json        Scene collection (all scenes in one file)
profiles/
  Landscape 1080p/     Profile (1920x1080)
import.sh              Repo -> OBS
export.sh              OBS -> Repo
```

## Limitations

- **Hardware sources are machine-specific.** Camera devices (iPhone, capture cards) and screen captures use device IDs that differ between machines. After importing on a new Mac, you need to manually re-select these sources once in OBS. This only needs to be done once per machine — the selection persists after that.
- **macOS only.** The scripts assume `~/Library/Application Support/obs-studio/` as the OBS config path. Linux and Windows use different locations.
- **Single scene collection.** OBS stores all scenes in one file (`Untitled.json`). There's no per-scene version control — any export overwrites the entire collection.
- **Recording output paths.** The profile defaults to `~/Movies` for recordings. This is fine on macOS but may need adjusting on other setups.
- **OBS must be closed** during import, otherwise OBS will overwrite the imported files when it quits.

## Vertical video (optional)

The "Vertical Scene" uses a second canvas at 1080x1920. OBS does not have native multi-canvas UI — you need the **Aitum Vertical** plugin (v1.6.2+, requires OBS 31.1+):

https://obsproject.com/forum/resources/aitum-vertical.1715/

Install the plugin, and the existing "Aitum Vertical" canvas configuration will be picked up automatically. Without the plugin, only the landscape scenes work.
