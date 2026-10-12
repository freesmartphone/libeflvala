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

# This project targets EFL 1.28 (the last release of the classic,
# pre-ESS EFL series; elementary still ships its 1.x pkg-config files
# and `elm_*` C API there). The version is enforced below once the
# individual EFL libraries have been resolved.
efl_target_version = '1.28'

valac = meson.get_compiler('vala')
pkgc = find_program('pkg-config')
edje_cc = find_program('edje_cc')

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(
    '--vapidir', vapi_dir,
    '--fatal-warnings',
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
# trees used a plain gee.pc. The VAPI is always named `gee-0.8`; it is
# normally provided by libgee itself (system-wide), only fall back to an
# in-tree copy if one ever exists under vapi/.
gee_pc = dependency('gee-0.8', required: false)
if gee_pc.found()
    gee_pc_name = 'gee-0.8'
else
    gee_pc = dependency('gee')
    gee_pc_name = 'gee'
endif
gee_vapi = valac.find_library('gee-0.8', dirs: vapi_dir, required: false)
if not gee_vapi.found()
    # valac resolves `--pkg gee-0.8` from its own VAPI search path.
    gee_vapi = 'gee-0.8'
endif
# `--pkg gee-0.8` is injected project-wide via add_project_arguments(...,
# language: 'vala') above so it reaches valac but never cc; here we only
# need the pkg-config dependency for includes/links (and the VAPI lookup).
gee_dep = declare_dependency(
    dependencies: [gee_pc],
)

# Bindings target EFL 1.28: require at least that version of each library.
evas_dep = dependency('evas', version: '>=' + efl_target_version)
ecore_dep = dependency('ecore', version: '>=' + efl_target_version)
edje_dep = dependency('edje', version: '>=' + efl_target_version)
elementary_dep = dependency('elementary', version: '>=' + efl_target_version)

# PkgConfigDependency objects whose names match in-tree or Vala VAPI files.
# Meson emits `--pkg <name>` for these; `--vapidir` makes valac pick our copies.
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
# elementary's VAPI is named elm.
pkg_c_only_names = ['elementary']
vala_extra = [valac.find_library('elm', dirs: vapi_dir)]

if eina_pc_name == 'eina'
    # Re-resolve with the EFL 1.28 lower bound now that we know the name.
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
