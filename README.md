# sixpak

Personal Flatpak manifests.

## Apps

| App | App ID | Version | Runtime |
| --- | --- | --- | --- |
| [Antigravity](./antigravity) | `google.antigravity.Antigravity` | `2.33.0` | `org.freedesktop.Platform//26.08` + `org.electronjs.Electron2.BaseApp//26.08` |

## Prerequisites

Install `flatpak-builder` (either via your distro package manager or from Flathub):

```bash
# Option A: Flathub (recommended)
flatpak install flathub org.flatpak.Builder

# Option B: Fedora
sudo dnf install flatpak-builder
```

## Build & Install

```bash
./build.sh antigravity
```

`build.sh` automatically pulls any missing SDK/BaseApp dependencies from Flathub (`--install-deps-from=flathub`) and installs the built app for your user (`--user --install`).

## Run

```bash
flatpak run google.antigravity.Antigravity
```

## Exporting a `.flatpak` bundle (optional)

```bash
./build.sh antigravity --repo=repo
flatpak build-bundle repo antigravity.flatpak google.antigravity.Antigravity
```
