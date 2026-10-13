eflvala_sources = files(
    'application.vala',
    'collections.vala',
    'genlist.vala',
    'statemachine.vala',
)

eflvala_lib = shared_library(
    'eflvala',
    eflvala_sources,
    dependencies: efl_deps,
    vala_header: 'eflvala.h',
    vala_vapi: 'eflvala-1.0.vapi',
    version: '0.1.0',
    soversion: '0',
    install: true,
    install_dir: [
        true,
        get_option('includedir') / 'eflvala-1.0',
        get_option('datadir') / 'vala' / 'vapi',
    ],
)

install_data(
    'eflvala-1.0.deps',
    install_dir: get_option('datadir') / 'vala' / 'vapi',
)

pkg = import('pkgconfig')
pkg.generate(
    eflvala_lib,
    name: 'libeflvala',
    filebase: 'eflvala-1.0',
    description: 'EFL Vala Convenience Objects',
    version: meson.project_version(),
    requires: [eina_pc_name, gee_pc_name, 'evas', 'ecore', 'edje', 'elementary'],
    subdirs: 'eflvala-1.0',
)

# Consumers (tests, examples) include the generated `eflvala.h` header, which
# valac emits in eflvala/'s *build* directory. Meson resolves an
# include_directories('.') object relative to each consumer's own subdir, so
# re-declare it from the root meson.build where '.' == <root>/eflvala: the
# resulting -I flags point at both <root>/eflvala (source tree) and
# <builddir>/eflvala (where eflvala.h lives), independent of the caller.
# See https://mesonbuild.com/Include-directories.html
subdir_files = files('meson.build')
eflvala_inc = include_directories('.', is_system: false)

eflvala_dep = declare_dependency(
    link_with: eflvala_lib,
    dependencies: efl_deps,
    include_directories: eflvala_inc,
)
