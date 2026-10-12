project(
    'libeflvala',
    'c',
    'vala',
    version: '0.1.0.0',
    license: 'LGPL-2.1-or-later',
    meson_version: '>= 0.61.0',
    default_options: [
        'c_std=gnu99',
        'warning_level=1',
        'buildtype=debugoptimized',
    ],
)

# EFL's eina_lock uses pthread_rwlock/spinlock/barrier, which glibc hides
# under ISO C (-std=c99 / __STRICT_ANSI__). gnu99 + _GNU_SOURCE expose them.
# Meson runs valac -C, so --Xcc has no effect (and is a fatal warning);
# pass -O3 as a C flag instead.
add_project_arguments('-D_GNU_SOURCE', '-O3', language: 'c')

# This project targets the classic EFL 1.27 API; elementary still ships
# its 1.x pkg-config files and `elm_*` C API. The version is enforced below once the
# individual EFL libraries have been resolved.
efl_target_version = '1.27'

valac = meson.get_compiler('vala')
pkgc = find_program('pkg-config')
edje_cc = find_program('edje_cc')

vapi_dir = meson.current_source_dir() / 'vapi'

# Warnings are fatal for our own Vala sources so regressions (deprecated
# Gee/Eina API use, redundant modifiers, ownership mismatches, ...) break
# the build automatically instead of scrolling by in `meson compile`
# output. valac has supported --fatal-warnings since 0.36; guard with a
# version check (Meson's Vala compiler class has no has_argument()) so
# ancient toolchains can still configure. Meson runs valac with -C
# (codegen only), so this affects the Vala front end exclusively, never cc.
if valac.version().version_compare('>=0.36')
    add_project_arguments('--fatal-warnings', language: 'vala')
endif

add_project_arguments(
    '--vapidir', vapi_dir,
    '--enable-checking',
    language: 'vala',
)

# Vala-only arguments (Meson 1.1+): `--pkg` must reach valac but never cc.
add_project_arguments('--pkg', 'gee-0.8', language: 'vala')

# pkg-config name for Eina: modern EFL ships eina.pc, older trees used eina-0.
eina_pc = dependency('eina', required: false)
if eina_pc.found()
    eina_pc_name = 'eina'
else
    eina_pc = dependency('eina-0')
    eina_pc_name = 'eina-0'
endif

glib_dep = dependency('glib-2.0', version: '>=2.18')
gobject_dep = dependency('gobject-2.0', version: '>=2.18')

# GObject-based collections (Gee.List, Gee.HashMap, ...) come from libgee.
# The pkg-config name is versioned: modern libgee ships gee-0.8.pc, older
# trees used a plain gee.pc. The VAPI is always named `gee-0.8`.
gee_pc = dependency('gee-0.8', required: false)
if gee_pc.found()
    gee_pc_name = 'gee-0.8'
else
    gee_pc = dependency('gee')
    gee_pc_name = 'gee'
endif
# Pass the PkgConfigDependency to Vala targets for its include paths and
# linker flags only; Meson additionally emits `--pkg <pc name>` for it, so
# valac resolves the matching system VAPI (gee-0.8.pc -> gee-0.8.vapi).
# This deliberately avoids declare_dependency(vala_args: ...): that keyword
# does not exist in Meson (it was added as compiler-specific args only in
# later versions), and passing the .pc object keeps configure working on
# any Meson >= 0.61. A duplicate `--pkg gee-0.8` may appear next to the
# project-wide one -- harmless, since valac loads each package once.
gee_dep = gee_pc

# Bindings target EFL 1.27: require at least that version of each library.
evas_dep = dependency('evas', version: '>=' + efl_target_version)
ecore_dep = dependency('ecore', version: '>=' + efl_target_version)
ecore_evas_dep = dependency('ecore-evas', version: '>=' + efl_target_version)
edje_dep = dependency('edje', version: '>=' + efl_target_version)
elementary_dep = dependency('elementary', version: '>=' + efl_target_version)

# PkgConfigDependency objects whose names match in-tree or Vala VAPI files.
# Meson emits `--pkg <name>` for these; `--vapidir` makes valac pick our copies.
# gee is handled separately via gee_dep (see above) to avoid a duplicate
# `--pkg gee-0.8`.
efl_pc_deps = [
    glib_dep,
    gobject_dep,
    evas_dep,
    ecore_dep,
    edje_dep,
]

# When the pkg-config name does not match a VAPI name, do not pass the
# PkgConfigDependency to Vala targets — Meson would emit `--pkg <pc name>`
# and valac would look for a matching .vapi. Feed CFLAGS/LIBS only instead.
# elementary's VAPI is named elm. Ecore_Evas declarations are part of
# ecore.vapi, so its pkg-config dependency contributes only C flags/link flags.
pkg_c_only_names = ['elementary', 'ecore-evas']
vala_extra = [valac.find_library('elm', dirs: vapi_dir)]

if eina_pc_name == 'eina'
    # Re-resolve with the EFL 1.27 lower bound now that we know the name.
    eina_pc = dependency('eina', version: '>=' + efl_target_version)
    efl_pc_deps += eina_pc
else
    eina_pc = dependency('eina-0', version: '>=' + efl_target_version)
    pkg_c_only_names += eina_pc_name
    vala_extra += valac.find_library('eina', dirs: vapi_dir)
endif

pkg_c_only = []
foreach name : pkg_c_only_names
    pkg_c_only += declare_dependency(
        compile_args: run_command(pkgc, '--cflags', name, check: true).stdout().strip().split(),
        link_args: run_command(pkgc, '--libs', name, check: true).stdout().strip().split(),
    )
endforeach

efl_deps = efl_pc_deps + pkg_c_only + vala_extra + [gee_dep]

subdir('vapi')

if get_option('library')
    subdir('eflvala')
endif

subdir('data')

if get_option('tests')
    subdir('tests')
endif

if get_option('examples')
    subdir('examples')
endif

summary(
    {
        'library': get_option('library'),
        'examples': get_option('examples'),
        'tests': get_option('tests'),
        'EFL target': efl_target_version,
        'eina': eina_pc.version(),
        'gee': gee_pc.version(),
        'evas': evas_dep.version(),
        'ecore': ecore_dep.version(),
        'edje': edje_dep.version(),
        'elementary': elementary_dep.version(),
        'vala': valac.version(),
    },
    section: 'Configuration',
)
