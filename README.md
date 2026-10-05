efl.vapi & libeflvala
=====================

[![GitHub Actions](https://github.com/theavege/libeflvala/actions/workflows/make.yml/badge.svg)](https://github.com/theavege/libeflvala/actions/workflows/make.yml)
[![License: LGPL-2.1-or-later](https://img.shields.io/badge/License-LGPL--2.1--or--later-blue.svg)](COPYING)
[![Vala](https://img.shields.io/badge/Vala-0.56+-009639.svg)](https://vala.dev)
[![EFL](https://img.shields.io/badge/EFL-1.28+-4A90D9.svg)](https://www.enlightenment.org)

**efl.vapi** contains Vala bindings for the Enlightenment Foundation Libraries (EFL).
It is usable with or without **libeflvala**.

**libeflvala** contains additional convenience objects for applications written in Vala using the EFL.

## Features

- Vala bindings for EFL core libraries: eina, evas, ecore, edje, elementary
- Convenience objects and utilities for EFL development in Vala
- Meson and Autotools build systems
- Comprehensive examples and tests

## Quick Start

### Prerequisites

#### Debian/Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y meson ninja-build valac pkg-config libefl-all-dev
```

#### MSYS2 (Windows)

```bash
pacman -S --needed base-devel git meson ninja vala mingw-w64-x86_64-efl
```

### Building

#### Meson (Recommended)

```bash
# Clone the repository
git clone https://github.com/theavege/libeflvala.git
cd libeflvala

# Configure and build
meson setup build
meson compile -C build

# Run tests
meson test -C build --print-errorlogs

# Install (optional)
meson install -C build
```

### Build Options

| Meson Option | Description | Default |
|--------------|-------------|---------|
| `-Dlibrary=false` | Skip building the eflvala library | `true` |
| `-Dexamples=false` | Skip building examples | `true` |
| `-Dtests=false` | Skip building tests | `true` |

Example with options:
```bash
meson setup build -Dlibrary=false -Dexamples=true
meson compile -C build
```

## Project Structure

```
libeflvala/
├── vapi/                   # Vala API bindings for EFL
│   ├── eina.vapi           # Eina bindings
│   ├── evas.vapi           # Evas bindings
│   ├── ecore.vapi          # Ecore bindings
│   ├── edje.vapi           # Edje bindings
│   └── elm.vapi            # Elementary bindings
├── eflvala/                # libeflvala library source
│   ├── application.vala    # Application convenience class
│   ├── genlist.vala        # Genlist utilities
│   └── statemachine.vala   # State machine implementation
├── examples/               # Example applications
│   ├── ecore/              # Ecore examples
│   ├── evas/               # Evas examples
│   ├── edje/               # Edje examples
│   └── elementary/         # Elementary examples
├── tests/                  # Test suites
│   ├── testecore.vala      # Ecore tests
│   ├── testeina.vala       # Eina tests
│   ├── testevas.vala       # Evas tests
│   └── testelementary.vala # Elementary tests
└── data/                   # Data files and resources
```

## Usage

### Using VAPI Files

Add the VAPI directory to your Vala compiler flags:

```bash
valac --vapidir /usr/local/share/vala/vapi your_program.vala
```

Or with Meson:

```meson
project('my-app', 'vala')
dep = dependency('eina')
# Your sources...
```

### Using libeflvala

Link against the libeflvala library:

```meson
project('my-app', 'vala')
eflvala_dep = dependency('eflvala-1.0')
# Your sources...
```

## Documentation

- [EFL Documentation](https://docs.enlightenment.org)
- [Vala Documentation](https://vala.dev/docs)
- [Contribution Guidelines](CONTRIBUTING.md)

## Roadmap

- Complete Elementary support
- Expand Evas bindings
- Add Ecore input and file system support
- Improve Edje bindings
- Add comprehensive documentation and examples

## Contributing

Contributions are welcome! Please read our [Contribution Guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This project is licensed under the **LGPL-2.1-or-later** - see the [COPYING](COPYING) file for details.

## Authors

See [AUTHORS](AUTHORS) and [THANKS](THANKS) files for contributors.

## Support

- GitHub Issues: [https://github.com/freesmartphone/libeflvala/issues](https://github.com/freesmartphone/libeflvala/issues)
