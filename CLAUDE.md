# Appdirs

A Pony library for detecting platform-specific user directories (data, config, cache, logs, state, home). Port of the Python [appdirs](https://github.com/ActiveState/appdirs) library. Cross-platform: Windows, macOS, Linux/Unix.

## Building and Testing

```bash
make test       # build and run all tests (unit tests + build examples)
make unit-tests # run unit tests only
make clean      # clean build artifacts and dependencies
```

Uses `corral` for dependency management (fetched automatically by the Makefile). No external dependencies beyond the Pony standard library.

## Project Structure

- `appdirs/appdirs.pony` - Core `AppDirs` class and public API
- `appdirs/known_folders.pony` - Windows FFI for `SHGetKnownFolderPath`
- `appdirs/windows_codepages.pony` - Windows codepage constants
- `appdirs/_test.pony` - PonyTest unit tests
- `examples/simple-example/` - Example usage

## Architecture

Single main class `AppDirs` with constructor parameters (`env_vars`, `app_name`, optional `app_author`, `app_version`, `roaming`, `osx_as_unix`) and eight public methods returning platform-appropriate directory paths. Platform logic is handled via `ifdef` compile-time conditionals. All public methods are partial (`?`) — they raise errors when the home directory is unavailable.

Windows support uses FFI to `SHGetKnownFolderPath`. macOS defaults to `~/Library/...` paths but can be switched to XDG via `osx_as_unix`. Linux/Unix uses XDG base directory spec with standard fallbacks.

## Conventions

- Follows [Pony standard library style guide](https://github.com/ponylang/ponyc/blob/main/STYLE_GUIDE.md) (80-column line limit)
- Test-file types annotated with `\nodoc\`
- Tests are platform-conditional using `ifdef` directives
- Squash merge only; PR titles become CHANGELOG entries
