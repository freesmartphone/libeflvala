eflvala_sources = files(
    'application.vala',
    'genlist.vala',
    'statemachine.vala',
    'pager_compat.c',
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
    requires: [eina_pc_name, 'evas', 'ecore', 'edje', 'elementary'],
    subdirs: 'eflvala-1.0',
)

eflvala_dep = declare_dependency(
    link_with: eflvala_lib,
    include_directories: include_directories('.'),
    dependencies: efl_deps,
)
