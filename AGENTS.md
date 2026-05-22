# Appdirs

A Pony library for detecting platform-specific user directories (data, config, cache, logs, state, home). Port of the Python [appdirs](https://github.com/ActiveState/appdirs) library. Cross-platform: Windows, macOS, Linux/Unix.

<!-- contributor-only -->
## Contributing with an AI assistant

This is a Pony project. The ponylang org maintains a set of LLM coding skills. Get set up with them before contributing:

- **Not set up yet?** Install them once:

  ```bash
  git clone https://github.com/ponylang/llm-skills.git
  cd llm-skills
  python install.py
  ```

- **Already set up?** Make sure you're on the latest. If you installed with the script above, `git pull` in the directory where you cloned `llm-skills` and the symlinked skills update automatically — if you set them up another way, refresh them however that setup expects.

See the [llm-skills README](https://github.com/ponylang/llm-skills) for details and other harnesses.

When you start working on this project, load the `pony-skills` skill — it tells your assistant which Pony skill to use for each task.

Read [CONTRIBUTING.md](CONTRIBUTING.md).
<!-- /contributor-only -->

## Building and Testing

```bash
make test       # build and run all tests (unit tests + build examples)
make unit-tests # run unit tests only
make test-one t=TestName       # run a single test by name
make clean      # clean build artifacts and dependencies
```

Uses `corral` for dependency management (fetched automatically by the Makefile). No external dependencies beyond the Pony standard library.

## Project Structure

- `appdirs/appdirs.pony` - Core `AppDirs` class and public API
- `appdirs/known_folders.pony` - Windows FFI for `SHGetKnownFolderPath`
- `appdirs/windows_code_pages.pony` - Windows codepage constants
- `appdirs/_test.pony` - PonyTest unit tests
- `examples/simple-example/` - Example usage

## Architecture

Single main class `AppDirs` with constructor parameters (`env_vars`, `app_name`, optional `app_author`, `app_version`, `roaming`, `osx_as_unix`) and eight public methods returning platform-appropriate directory paths. Platform logic is handled via a `_Platform` match type with `ifdef` used only at construction time. All public methods are partial (`?`) — they raise errors when the home directory is unavailable.

Windows support uses FFI to `SHGetKnownFolderPath`. macOS defaults to `~/Library/...` paths but can be switched to XDG via `osx_as_unix`. Linux/Unix uses XDG base directory spec with standard fallbacks.

## Conventions

- Follows [Pony standard library style guide](https://github.com/ponylang/ponyc/blob/main/STYLE_GUIDE.md) (80-column line limit), enforced by `pony-lint` in CI
- Test-file types annotated with `\nodoc\`
- Tests are platform-conditional using `ifdef` directives
- Squash merge only; PR titles become CHANGELOG entries
