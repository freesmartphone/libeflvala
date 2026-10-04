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

evas_dep = dependency('evas')
ecore_dep = dependency('ecore')
edje_dep = dependency('edje')
elementary_dep = dependency('elementary')

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
    efl_pc_deps += eina_pc
else
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

efl_deps = efl_pc_deps + pkg_c_only + vala_extra

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
        'eina': eina_pc.version(),
        'evas': evas_dep.version(),
        'ecore': ecore_dep.version(),
        'edje': edje_dep.version(),
        'elementary': elementary_dep.version(),
        'vala': valac.version(),
    },
    section: 'Configuration',
)
