#!/usr/bin/env bash

function _require_setup
{
    source '/etc/os-release'
    declare -ar PKGS=(shellcheck shfmt meson ninja-build pkg-config)
    case ${ID:?} in
        msys2) return 0 ;;
        debian | ubuntu)
            sudo apt-get update
            sudo apt-get install -y "${PKGS[@]}" valac libefl-all-dev libdbus-glib-1-dev
            ;;
        fedora | alma) sudo dnf install -y "${PKGS[@]}" vala efl-devel ;;
    esac 1>/dev/null
    shellcheck --external-sources "${0}"
    shfmt -ci -fn -i 4 -d "${0}"
}

set -euo pipefail
_require_setup
meson setup build
meson compile -C build
meson test -C build --print-errorlogs
DESTDIR="${PWD}/destdir" meson install -C build
