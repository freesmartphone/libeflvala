# Headless GLib tests. testelementary calls Elm.run() with no quit path, so
# it is compiled as a smoke-build of the VAPI but not registered with `meson test`.
headless_tests = [
    ['testeina', 'testeina.vala'],
    ['testevas', 'testevas.vala'],
    ['testecore', 'testecore.vala'],
]

foreach t : headless_tests
    exe = executable(
        t[0],
        t[1],
        dependencies: efl_deps,
        install: false,
    )
    test(
        t[0],
        exe,
        timeout: 30,
        suite: 'eflvala',
    )
endforeach

executable(
    'testelementary',
    'testelementary.vala',
    dependencies: efl_deps,
    install: false,
)
