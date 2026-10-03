install_data(
    files(
        'images/panel_01.jpg',
        'images/plant_01.jpg',
        'images/rock_01.jpg',
        'images/rock_02.jpg',
        'images/sky_01.jpg',
        'images/sky_02.jpg',
        'images/sky_03.jpg',
        'images/sky_04.jpg',
        'images/wood_01.jpg',
        'images/logo.png',
        'images/logo_small.png',
    ),
    install_dir: get_option('datadir') / 'libeflvala' / 'images',
)

edje_sources = files(
    'objects/test.edc',
    'objects/over.png',
    'objects/under.png',
    'objects/sky.jpg',
    'objects/clo.png',
)

custom_target(
    'test.edj',
    input: 'objects/test.edc',
    output: 'test.edj',
    command: [
        edje_cc,
        '-v',
        '-id', meson.current_source_dir() / 'objects',
        '-fd', meson.current_source_dir() / 'objects',
        '@INPUT@',
        '@OUTPUT@',
    ],
    depend_files: edje_sources,
    install: true,
    install_dir: get_option('datadir') / 'libeflvala' / 'objects',
)
