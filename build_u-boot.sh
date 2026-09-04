#!/bin/bash

# Builds a set of u-boot images (normal, normal + console, and recovery-only) for this
# device, moves it to "vendor/$oem/$device", regenerates makefiles, then commits changes.

set -e

# Resolve this script's real location, even if invoked via symlink or relative path
SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
DEVICE_DIR="$(dirname "$SCRIPT")"

DEVICE="$(basename "$DEVICE_DIR")"                    # m5
TOP="$(cd "$DEVICE_DIR/../../.." && pwd)"             # srctree root

BUILDER="$TOP/hardware/amlogic/u-boot_build/build_${DEVICE}.sh"

if [ ! -x "$BUILDER" ]; then
    echo "error: $BUILDER not found or not executable" >&2
    exit 1
fi

cd "$(dirname "$BUILDER")"
exec ./"$(basename "$BUILDER")" "$@"
