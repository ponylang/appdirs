use "ponytest"
use "cli"

actor \nodoc\ Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_AppDirsDefaultsTest)
    test(_AppDirsVersionTest)
    test(_AppDirsNoHomeTest)
    test(_AppDirsAppAuthorTest)
    test(_AppDirsWindowsRoamingTest)
    test(_AppDirsUnixXDGVarsTest)
    test(_AppDirsOsxAsUnixTest)

primitive  \nodoc\ _ExpectError

type _ErrorOr[T] is ( T | _ExpectError )

class  \nodoc\ _ExpectedAppDirs
  let home_dir: _ErrorOr[String]
  let user_data_dir: _ErrorOr[String]
  let site_data_dirs: _ErrorOr[Array[String] val]
  let user_config_dir: _ErrorOr[String]
  let site_config_dirs: _ErrorOr[Array[String] val]
  let user_cache_dir: _ErrorOr[String]
  let user_state_dir: _ErrorOr[String]
  let user_log_dir: _ErrorOr[String]

  new create(
    home_dir': _ErrorOr[String],
    user_data_dir': _ErrorOr[String],
    site_data_dirs': _ErrorOr[Array[String] val],
    user_config_dir': _ErrorOr[String],
    site_config_dirs': _ErrorOr[Array[String] val],
    user_cache_dir': _ErrorOr[String],
    user_state_dir': _ErrorOr[String],
    user_log_dir': _ErrorOr[String]) =>
    home_dir = home_dir'
    user_data_dir = user_data_dir'
    site_data_dirs = site_data_dirs'
    user_config_dir = user_config_dir'
    site_config_dirs = site_config_dirs'
    user_cache_dir = user_cache_dir'
    user_state_dir = user_state_dir'
    user_log_dir = user_log_dir'



primitive  \nodoc\ _AppDirsTestUtil
  fun test(app_dirs: AppDirs, expected: _ExpectedAppDirs, h: TestHelper, loc: SourceLoc = __loc) ? =>
    match expected.home_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_home_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_home_dir()? where loc=loc)
    end
    match expected.user_data_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_data_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_data_dir()? where loc=loc)
    end
    match expected.site_data_dirs
    | _ExpectError =>
      h.assert_error({()? => app_dirs.site_data_dirs()? } where loc=loc)
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_data_dirs()? where loc=loc)
    end

    match expected.user_config_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_config_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_config_dir()? where loc=loc)
    end
    match expected.site_config_dirs
    | _ExpectError =>
      h.assert_error({()? => app_dirs.site_config_dirs()? } where loc=loc)
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_config_dirs()? where loc=loc)
    end

    match expected.user_cache_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_cache_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_cache_dir()? where loc=loc)
    end

    match expected.user_state_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_state_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_state_dir()? where loc=loc)
    end

    match expected.user_log_dir
    | _ExpectError =>
      h.assert_error({()? => app_dirs.user_log_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_log_dir()? where loc=loc)
    end

  fun test_home(): String =>
    ifdef osx then
      "/Users/ed"
    else
      "/home/ed"
    end


class \nodoc\ _AppDirsDefaultsTest is UnitTest
  fun name(): String => "appdirs/defaults"

  fun apply(h: TestHelper) ? =>
    let env_vars = [
      as String: "HOME=" + _AppDirsTestUtil.test_home()
    ]
    let app_dirs = AppDirs(env_vars, "appdirs")
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = "/Users/ed",
                user_data_dir' = "/Users/ed/Library/Application Support/appdirs",
                site_data_dirs' = ["/Library/Application Support/appdirs"],
                user_config_dir' = "/Users/ed/Library/Preferences/appdirs",
                site_config_dirs' = ["/Library/Preferences/appdirs"],
                user_cache_dir' = "/Users/ed/Library/Caches/appdirs",
                user_state_dir' = "/Users/ed/Library/Application Support/appdirs",
                user_log_dir' = "/Users/ed/Library/Logs/appdirs")
      elseif windows then
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        // TODO: only tested on windows 10
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs")
      else
        _ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?

class \nodoc\ _AppDirsVersionTest is UnitTest
  fun name(): String => "appdirs/version"
  fun apply(h: TestHelper) ? =>
    let env_vars = [
      as String: "HOME=" + _AppDirsTestUtil.test_home()
    ]
    let app_dirs = AppDirs(env_vars, "appdirs" where app_version="0.4")
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = "/Users/ed",
                user_data_dir' = "/Users/ed/Library/Application Support/appdirs/0.4",
                site_data_dirs' = ["/Library/Application Support/appdirs/0.4"],
                user_config_dir' = "/Users/ed/Library/Preferences/appdirs/0.4",
                site_config_dirs' = ["/Library/Preferences/appdirs/0.4"],
                user_cache_dir' = "/Users/ed/Library/Caches/appdirs/0.4",
                user_state_dir' = "/Users/ed/Library/Application Support/appdirs/0.4",
                user_log_dir' = "/Users/ed/Library/Logs/appdirs/0.4")
      elseif windows then
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                site_data_dirs' = ["C:\\ProgramData\\appdirs\\0.4"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                site_config_dirs' = ["C:\\ProgramData\\appdirs\\0.4"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache\\0.4",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4")
      else
        _ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs/0.4",
                site_data_dirs' = ["/usr/local/share/appdirs/0.4"; "/usr/share/appdirs/0.4"],
                user_config_dir' = "/home/ed/.config/appdirs/0.4",
                site_config_dirs' = ["/etc/xdg/appdirs/0.4"],
                user_cache_dir' = "/home/ed/.cache/appdirs/0.4",
                user_state_dir' = "/home/ed/.local/state/appdirs/0.4",
                user_log_dir' = "/home/ed/.cache/appdirs/0.4/log")
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?

class \nodoc\_AppDirsNoHomeTest is UnitTest
  fun name(): String => "appdirs/no_home"

  fun apply(h: TestHelper) ? =>
    let env_vars: Array[String] val = []
    let app_dirs = AppDirs(env_vars, "appdirs")
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = _ExpectError,
                user_data_dir' = _ExpectError,
                site_data_dirs' = ["/Library/Application Support/appdirs"],
                user_config_dir' = _ExpectError,
                site_config_dirs' = ["/Library/Preferences/appdirs"],
                user_cache_dir' = _ExpectError,
                user_state_dir' = _ExpectError,
                user_log_dir' = _ExpectError)
      elseif windows then
        // no impact for windows (afaik)
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs")
      else
        _ExpectedAppDirs(
          where home_dir' = _ExpectError,
                user_data_dir' = _ExpectError,
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = _ExpectError,
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = _ExpectError,
                user_state_dir' = _ExpectError,
                user_log_dir' = _ExpectError)
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?

class \nodoc\ _AppDirsAppAuthorTest is UnitTest
  fun name(): String => "appdirs/app_author"

  fun apply(h: TestHelper) ? =>
    let env_vars = [
      as String: "HOME=" + _AppDirsTestUtil.test_home()
    ]
    let app_dirs = AppDirs(env_vars, "appdirs", "Matthias Wahl")
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = "/Users/ed",
                user_data_dir' = "/Users/ed/Library/Application Support/appdirs",
                site_data_dirs' = ["/Library/Application Support/appdirs"],
                user_config_dir' = "/Users/ed/Library/Preferences/appdirs",
                site_config_dirs' = ["/Library/Preferences/appdirs"],
                user_cache_dir' = "/Users/ed/Library/Caches/appdirs",
                user_state_dir' = "/Users/ed/Library/Application Support/appdirs",
                user_log_dir' = "/Users/ed/Library/Logs/appdirs")
      elseif windows then
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\Matthias Wahl\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\Matthias Wahl\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs")
      else
        _ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?


class \nodoc\ _AppDirsWindowsRoamingTest is UnitTest
  fun name(): String => "appdirs/roaming"

  fun apply(h: TestHelper) ? =>
    let env_vars = [
      as String: "HOME=" + _AppDirsTestUtil.test_home()
    ]
    let app_dirs = AppDirs(env_vars, "appdirs" where roaming = true)
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = "/Users/ed",
                user_data_dir' = "/Users/ed/Library/Application Support/appdirs",
                site_data_dirs' = ["/Library/Application Support/appdirs"],
                user_config_dir' = "/Users/ed/Library/Preferences/appdirs",
                site_config_dirs' = ["/Library/Preferences/appdirs"],
                user_cache_dir' = "/Users/ed/Library/Caches/appdirs",
                user_state_dir' = "/Users/ed/Library/Application Support/appdirs",
                user_log_dir' = "/Users/ed/Library/Logs/appdirs")
      elseif windows then
        // this is valid for windows 7 and newer (tested with windows 10)
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs")
      else
        _ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?


class \nodoc\ _AppDirsUnixXDGVarsTest is UnitTest
  fun name(): String => "appdirs/xdg_vars"

  fun apply(h: TestHelper) ? =>
    let env_vars = [
      "HOME=" + _AppDirsTestUtil.test_home()
      "XDG_DATA_HOME=~/.my_own/data"
      "XDG_DATA_DIRS=/etc/bla/:/blubb"
      "XDG_CONFIG_HOME=/home/ed/.my_config"
      "XDG_CONFIG_DIRS=/config/a b c"
      "XDG_CACHE_HOME=~/.kache"
      "XDG_STATE_HOME=~/~/~/.state"
    ]
    let app_dirs = AppDirs(env_vars, "appdirs")
    let expected =
      ifdef osx then
        _ExpectedAppDirs(
          where home_dir' = "/Users/ed",
                user_data_dir' = "/Users/ed/Library/Application Support/appdirs",
                site_data_dirs' = ["/Library/Application Support/appdirs"],
                user_config_dir' = "/Users/ed/Library/Preferences/appdirs",
                site_config_dirs' = ["/Library/Preferences/appdirs"],
                user_cache_dir' = "/Users/ed/Library/Caches/appdirs",
                user_state_dir' = "/Users/ed/Library/Application Support/appdirs",
                user_log_dir' = "/Users/ed/Library/Logs/appdirs")
      elseif windows then
        // no impact on windows AFAIK
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        _ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs")
      else
        _ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.my_own/data/appdirs",
                site_data_dirs' = ["/etc/bla/appdirs"; "/blubb/appdirs"],
                user_config_dir' = "/home/ed/.my_config/appdirs",
                site_config_dirs' = ["/config/a b c/appdirs"],
                user_cache_dir' = "/home/ed/.kache/appdirs",
                user_state_dir' = "/home/ed/home/ed/home/ed/.state/appdirs",
                user_log_dir' = "/home/ed/.kache/appdirs/log")
      end
    _AppDirsTestUtil.test(app_dirs, expected, h)?

class \nodoc\ _AppDirsOsxAsUnixTest is UnitTest
  fun name(): String => "appdirs/osx_as_unix"
  fun apply(h: TestHelper) ? =>
    let env_vars = [
      "HOME=" + _AppDirsTestUtil.test_home()
      "XDG_DATA_HOME=~/.my_own/data"
      "XDG_DATA_DIRS=/etc/bla/:/blubb"
      "XDG_CONFIG_HOME=/Users/ed/.my_config"
      "XDG_CONFIG_DIRS=/config/a b c"
      "XDG_CACHE_HOME=~/.kache"
      "XDG_STATE_HOME=~/~/~/.state"
    ]

    let app_dirs = AppDirs(env_vars, "appdirs" where osx_as_unix = true)
    ifdef osx then
      let expected = _ExpectedAppDirs(
        where home_dir' = _AppDirsTestUtil.test_home(),
              user_data_dir' = "/Users/ed/.my_own/data/appdirs",
              site_data_dirs' = ["/etc/bla/appdirs"; "/blubb/appdirs"],
              user_config_dir' = "/Users/ed/.my_config/appdirs",
              site_config_dirs' = ["/config/a b c/appdirs"],
              user_cache_dir' = "/Users/ed/.kache/appdirs",
              user_state_dir' = "/Users/ed/Users/ed/Users/ed/.state/appdirs",
              user_log_dir' = "/Users/ed/.kache/appdirs/log")
      _AppDirsTestUtil.test(app_dirs, expected, h)?
    end


