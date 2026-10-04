# Contributing to libeflvala

Thank you for your interest in contributing to libeflvala! This document outlines how you can help improve the project.

## Getting Started

### Prerequisites

- Git
- Meson (>= 0.61.0)
- Ninja
- Vala compiler (valac)
- pkg-config
- EFL development libraries (eina, evas, ecore, edje, elementary)

#### Debian/Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y meson ninja-build valac pkg-config libglib2.0-dev libefl-all-dev
```

#### Fedora/AlmaLinux

```bash
sudo dnf install -y meson ninja-build vala efl-devel glib2-devel
```

#### MSYS2 (Windows)

```bash
pacman -S --needed base-devel git meson ninja vala mingw-w64-x86_64-efl
```

## Building

### Meson (Recommended)

```bash
# Clone the repository
git clone https://github.com/theavege/libeflvala.git
cd libeflvala

# Configure and build
meson setup build
meson compile -C build

# Run tests
meson test -C build --print-errorlogs

# Install
meson install -C build
```

### Autotools (Legacy)

```bash
./autogen.sh
make
make install
```

### Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `-Dlibrary=false` | Skip building the eflvala library | true |
| `-Dexamples=false` | Skip building examples | true |
| `-Dtests=false` | Skip building tests | true |

## Code Style

### Shell Scripts

- Use `shellcheck` to lint shell scripts
- Format with `shfmt -ci -fn -i 4 -d`
- All scripts must pass `shellcheck --external-sources`

### Vala Code

- Use `--fatal-warnings` and `--enable-checking` flags
- Follow Vala coding conventions
- Ensure all VAPI files are properly formatted

### C Code

- Use GNU99 standard
- Follow EFL coding conventions where applicable

## Pull Request Guidelines

1. **Fork the repository** and create a feature branch from `master`
2. **Keep commits atomic** - each commit should address a single logical change
3. **Write descriptive commit messages** - explain what and why, not just what
4. **Reference issues** - use `Closes #123` or `Fixes #456` in commit messages
5. **Include tests** - add tests for new functionality or bug fixes
6. **Update documentation** - keep README and other docs up to date
7. **Pass CI checks** - ensure all GitHub Actions workflows pass

## Reporting Issues

When reporting issues, please include:

- Version of libeflvala (or git commit hash)
- Version of EFL libraries
- Version of Vala compiler
- Operating system and distribution
- Steps to reproduce the issue
- Expected vs actual behavior
- Relevant logs or error messages

## VAPI Generation

The VAPI files in the `vapi/` directory are manually maintained bindings for EFL libraries. When adding new bindings:

1. Follow the existing VAPI style and conventions
2. Include all relevant types, functions, and constants
3. Add proper `[CCode(...)]` attributes where needed
4. Document complex APIs with comments
5. Test the bindings with example code

## Testing

### Running Tests

```bash
meson test -C build --print-errorlogs
```

### Adding Tests

- Place test files in the `tests/` directory
- Use descriptive names (e.g., `test_eina.vala`, `test_ecore.vala`)
- Test both success and error cases
- Keep tests focused and fast

## Code Review Process

1. All pull requests require at least one approval from a maintainer
2. CI must pass before merging
3. Code style and formatting will be checked
4. Large changes may require discussion in an issue first

## Maintainers

- [@theavege](https://github.com/theavege)

## License

By contributing to this project, you agree to license your contributions under the [LGPL-2.1-or-later](COPYING) license.
