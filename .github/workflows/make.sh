#!/usr/bin/env bash

function _require_setup
{
    source '/etc/os-release'
    declare -ar PKGS=(shellcheck shfmt meson ninja-build pkg-config)
    case ${ID:?} in
        msys2) return 0 ;;
        debian | ubuntu)
            sudo apt-get update
            sudo apt-get install -y "${PKGS[@]}" valac libefl-all-dev libgee-0.8-dev
            ;;
        fedora | alma) sudo dnf install -y "${PKGS[@]}" vala efl-devel libgee-devel ;;
    esac 1>/dev/null
    shellcheck --external-sources "${0}"
    shfmt -ci -fn -i 4 -d "${0}"
}

set -xeuo pipefail
_require_setup

declare -ar VAR=(
    --verbose
    --fatal-warnings
    --Xcc=-O3
    --cc=clang
    --vapidir=vapi
    --enable-{checking,mem-profiler,gobject-tracing}
    --pkg=elm
)

vala "${VAR[@]}" --pkg gee-0.8 'tests/testecore.vala'
eina_test_dir="$(mktemp -d)"
trap 'rm -rf "$eina_test_dir"' EXIT
valac "${VAR[@]}" --pkg gee-0.8 --directory "$eina_test_dir" eflvala/collections.vala 'tests/testeina.vala' -o "$eina_test_dir/testeina.exe"
"$eina_test_dir/testeina.exe"
vala "${VAR[@]}" --pkg gee-0.8 'tests/testevas.vala'

meson setup build
meson compile -C build
meson test -C build --print-errorlogs
DESTDIR="${PWD}/destdir" meson install -C build
