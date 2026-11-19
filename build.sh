#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <app-dir> [extra flatpak-builder args...]" >&2
  echo "Example: $0 antigravity" >&2
  exit 1
fi

APP_DIR="$1"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/${APP_DIR}"

if [[ ! -d "${TARGET_DIR}" ]]; then
  echo "Error: directory '${TARGET_DIR}' not found." >&2
  exit 1
fi

MANIFEST="$(find "${TARGET_DIR}" -maxdepth 1 \( -name '*.yml' -o -name '*.yaml' -o -name '*.json' \) | head -n 1)"
if [[ -z "${MANIFEST}" ]]; then
  echo "Error: no Flatpak manifest found in '${TARGET_DIR}'." >&2
  exit 1
fi

if command -v flatpak-builder >/dev/null 2>&1; then
  BUILDER=(flatpak-builder)
elif flatpak info org.flatpak.Builder >/dev/null 2>&1; then
  BUILDER=(flatpak run org.flatpak.Builder)
else
  echo "Error: neither 'flatpak-builder' nor 'org.flatpak.Builder' is installed." >&2
  echo "Install one with:" >&2
  echo "  flatpak install flathub org.flatpak.Builder" >&2
  echo "or your distro package manager (e.g. sudo dnf install flatpak-builder)." >&2
  exit 1
fi

BUILD_DIR="${SCRIPT_DIR}/build-dir/${APP_DIR}"
STATE_DIR="${SCRIPT_DIR}/.flatpak-builder"

# Ensure the Flathub remote is configured for --user installs
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Building ${MANIFEST}..."
exec "${BUILDER[@]}" \
  --force-clean \
  --user \
  --install \
  --install-deps-from=flathub \
  --state-dir="${STATE_DIR}" \
  "$@" \
  "${BUILD_DIR}" \
  "${MANIFEST}"
