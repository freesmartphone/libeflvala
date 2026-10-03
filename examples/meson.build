examples = [
    {
        'name': 'eina',
        'sources': files('eina/eina.vala'),
        'needs_library': false,
    },
    {
        'name': 'ecore',
        'sources': files('ecore/ecore.vala'),
        'needs_library': false,
    },
    {
        'name': 'ecore_signals',
        'sources': files('ecore-signals/ecore_signals.vala'),
        'needs_library': false,
    },
    {
        'name': 'ecore-glib',
        'sources': files('ecore-glib/ecore-glib.vala'),
        'needs_library': false,
    },
    {
        'name': 'edje',
        'sources': files('edje/edje.vala'),
        'needs_library': false,
    },
    {
        'name': 'elementary-vapi',
        'sources': files(
            'elementary/abstract.vala',
            'elementary/main.vala',
            'elementary/background.vala',
            'elementary/genlist.vala',
            'elementary/hoversel.vala',
        ),
        'needs_library': false,
    },
    {
        'name': 'application',
        'sources': files('library/application/application.vala'),
        'needs_library': true,
    },
    {
        'name': 'dialer',
        'sources': files('library/dialer/dialer.vala'),
        'needs_library': true,
    },
    {
        'name': 'viewstates',
        'sources': files('library/viewstates/viewstates.vala'),
        'needs_library': true,
    },
]

foreach spec : examples
    if spec['needs_library'] and not get_option('library')
        continue
    endif

    example_deps = efl_deps
    if spec['needs_library']
        example_deps += eflvala_dep
    endif

    executable(
        spec['name'],
        spec['sources'],
        dependencies: example_deps,
        install: true,
    )
endforeach
