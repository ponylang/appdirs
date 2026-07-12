# Appdirs

A Pony library for platform-specific user directories (data, config, cache, logs, state, home). A port of Python's [appdirs](https://github.com/ActiveState/appdirs), for Windows, macOS, and Linux/Unix.

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

## Building and testing

```bash
make test                # build + run all tests, build examples
make unit-tests          # unit tests only
make test-one t=TestName # run a single test by name
make clean               # clean build artifacts and dependencies
```

## Architecture

One `AppDirs` class (in `appdirs.pony`) exposes eight partial (`?`) methods returning platform-appropriate paths; the platform is chosen at construction.

## Conventions

- Tests are platform-conditional via `ifdef`.
- `\nodoc\` on test classes.
