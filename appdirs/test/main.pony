use "ponytest"
use ".."
use "cli"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(AppDirsDefaultsTest)
    test(AppDirsVersionTest)
    test(AppDirsNoHomeTest)
    test(AppDirsAppAuthorTest)
    test(AppDirsWindowsRoamingTest)
    test(AppDirsUnixXDGVarsTest)

primitive ExpectError

type ErrorOr[T] is ( T | ExpectError )

class ExpectedAppDirs
  let home_dir: ErrorOr[String]
  let user_data_dir: ErrorOr[String]
  let site_data_dirs: ErrorOr[Array[String] val]
  let user_config_dir: ErrorOr[String]
  let site_config_dirs: ErrorOr[Array[String] val]
  let user_cache_dir: ErrorOr[String]
  let user_state_dir: ErrorOr[String]
  let user_log_dir: ErrorOr[String]

  new create(
    home_dir': ErrorOr[String],
    user_data_dir': ErrorOr[String],
    site_data_dirs': ErrorOr[Array[String] val],
    user_config_dir': ErrorOr[String],
    site_config_dirs': ErrorOr[Array[String] val],
    user_cache_dir': ErrorOr[String],
    user_state_dir': ErrorOr[String],
    user_log_dir': ErrorOr[String]) =>
    home_dir = home_dir'
    user_data_dir = user_data_dir'
    site_data_dirs = site_data_dirs'
    user_config_dir = user_config_dir'
    site_config_dirs = site_config_dirs'
    user_cache_dir = user_cache_dir'
    user_state_dir = user_state_dir'
    user_log_dir = user_log_dir'



primitive AppDirsTestUtil
  fun test(app_dirs: AppDirs, expected: ExpectedAppDirs, h: TestHelper, loc: SourceLoc = __loc) ? =>
    match expected.home_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_home_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_home_dir()? where loc=loc)
    end
    match expected.user_data_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_data_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_data_dir()? where loc=loc)
    end
    match expected.site_data_dirs
    | ExpectError =>
      h.assert_error({()? => app_dirs.site_data_dirs()? } where loc=loc)
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_data_dirs()? where loc=loc)
    end

    match expected.user_config_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_config_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_config_dir()? where loc=loc)
    end
    match expected.site_config_dirs
    | ExpectError =>
      h.assert_error({()? => app_dirs.site_config_dirs()? } where loc=loc)
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_config_dirs()? where loc=loc)
    end

    match expected.user_cache_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_cache_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_cache_dir()? where loc=loc)
    end

    match expected.user_state_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_state_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_state_dir()? where loc=loc)
    end

    match expected.user_log_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_log_dir()? } where loc=loc)
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_log_dir()? where loc=loc)
    end


class AppDirsDefaultsTest is UnitTest
  fun name(): String => "appdirs/defaults"

  fun apply(h: TestHelper) ? =>
    let env_vars = ["HOME=/home/ed"]
    let app_dirs = AppDirs(env_vars, "appdirs")
    let expected =
      ifdef osx then
        // TODO
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      elseif windows then
        let user_name = EnvVars(h.env.vars)("USERNAME")? // hack for getting the username
        // TODO: only tested on windows 10
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?

class AppDirsVersionTest is UnitTest
  fun name(): String => "appdirs/version"
  fun apply(h: TestHelper) ? =>
    let env_vars = ["HOME=/home/ed"]
    let app_dirs = AppDirs(env_vars, "appdirs" where app_version="0.4")
    let expected =
      ifdef osx then
        // TODO
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      elseif windows then
        // TODO
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                site_data_dirs' = ["C:\\ProgramData\\appdirs\\0.4"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                site_config_dirs' = ["C:\\ProgramData\\appdirs\\0.4"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\0.4\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs/0.4",
                site_data_dirs' = ["/usr/local/share/appdirs/0.4"; "/usr/share/appdirs/0.4"],
                user_config_dir' = "/home/ed/.config/appdirs/0.4",
                site_config_dirs' = ["/etc/xdg/appdirs/0.4"],
                user_cache_dir' = "/home/ed/.cache/appdirs/0.4",
                user_state_dir' = "/home/ed/.local/state/appdirs/0.4",
                user_log_dir' = "/home/ed/.cache/appdirs/0.4/log")
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?

class AppDirsNoHomeTest is UnitTest
  fun name(): String => "appdirs/no_home"

  fun apply(h: TestHelper) ? =>
    let env_vars: Array[String] val = []
    let app_dirs = AppDirs(env_vars, "appdirs")
    let expected =
      ifdef osx then
        ExpectedAppDirs(
          where home_dir' = ExpectError,
                user_data_dir' = ExpectError,
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = ExpectError,
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = ExpectError,
                user_state_dir' = ExpectError,
                user_log_dir' = ExpectError)
      elseif windows then
        // no impact for windows (afaik)
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = ExpectError,
                user_data_dir' = ExpectError,
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = ExpectError,
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = ExpectError,
                user_state_dir' = ExpectError,
                user_log_dir' = ExpectError)
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?

class AppDirsAppAuthorTest is UnitTest
  fun name(): String => "appdirs/app_author"

  fun apply(h: TestHelper) ? =>
    let env_vars = ["HOME=/home/ed"]
    let app_dirs = AppDirs(env_vars, "appdirs", "Matthias Wahl")
    let expected =
      ifdef osx then
        // TODO
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      elseif windows then
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\Matthias Wahl\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\Matthias Wahl\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\Matthias Wahl\\appdirs\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?


class AppDirsWindowsRoamingTest is UnitTest
  fun name(): String => "appdirs/roaming"

  fun apply(h: TestHelper) ? =>
    let env_vars = ["HOME=/home/ed"]
    let app_dirs = AppDirs(env_vars, "appdirs" where roaming = true)
    let expected =
      ifdef osx then
        // TODO
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      elseif windows then
        // this is valid for windows 7 and newer (tested with windows 10)
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roamin\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Roaming\\appdirs\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?


class AppDirsUnixXDGVarsTest is UnitTest
  fun name(): String => "appdirs/xdg_vars"

  fun apply(h: TestHelper) ? =>
    let env_vars = [
      "HOME=/home/ed"
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
        // TODO
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.local/share/appdirs",
                site_data_dirs' = ["/usr/local/share/appdirs"; "/usr/share/appdirs"],
                user_config_dir' = "/home/ed/.config/appdirs",
                site_config_dirs' = ["/etc/xdg/appdirs"],
                user_cache_dir' = "/home/ed/.cache/appdirs",
                user_state_dir' = "/home/ed/.local/state/appdirs",
                user_log_dir' = "/home/ed/.cache/appdirs/log")
      elseif windows then
        // no impact on windows AFAIK
        ExpectedAppDirs(
          where home_dir' = "C:\\Users\\" + user_name,
                user_data_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_data_dirs' = ["C:\\ProgramData\\appdirs"],
                user_config_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                site_config_dirs' = ["C:\\ProgramData\\appdirs"],
                user_cache_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Cache",
                user_state_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs",
                user_log_dir' = "C:\\Users\\" + user_name + "\\AppData\\Local\\appdirs\\Logs")
      else
        ExpectedAppDirs(
          where home_dir' = "/home/ed",
                user_data_dir' = "/home/ed/.my_own/data/appdirs",
                site_data_dirs' = ["/etc/bla/appdirs"; "/blubb/appdirs"],
                user_config_dir' = "/home/ed/.my_config/appdirs",
                site_config_dirs' = ["/config/a b c/appdirs"],
                user_cache_dir' = "/home/ed/.kache/appdirs",
                user_state_dir' = "/home/ed/home/ed/home/ed/.state/appdirs",
                user_log_dir' = "/home/ed/.kache/appdirs/log")
      end
    AppDirsTestUtil.test(app_dirs, expected, h)?

