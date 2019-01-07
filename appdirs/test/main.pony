use "ponytest"
use ".."

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
  fun test(app_dirs: AppDirs, expected: ExpectedAppDirs, h: TestHelper) ? =>
    match expected.home_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_home_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_home_dir()?)
    end
    match expected.user_data_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_data_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_data_dir()?)
    end
    match expected.site_data_dirs
    | ExpectError =>
      h.assert_error({()? => app_dirs.site_data_dirs()? })
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_data_dirs()?)
    end

    match expected.user_config_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_config_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_config_dir()?)
    end
    match expected.site_config_dirs
    | ExpectError =>
      h.assert_error({()? => app_dirs.site_config_dirs()? })
    | let expect: Array[String] val =>
      h.assert_array_eq[String](expect, app_dirs.site_config_dirs()?)
    end

    match expected.user_cache_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_cache_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_cache_dir()?)
    end

    match expected.user_state_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_state_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_state_dir()?)
    end

    match expected.user_log_dir
    | ExpectError =>
      h.assert_error({()? => app_dirs.user_log_dir()? })
    | let expect: String =>
      h.assert_eq[String](expect, app_dirs.user_log_dir()?)
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
  fun apply(h: TestHelper) =>
    h.fail("not implemented") // TODO

class AppDirsNoHomeTest is UnitTest
  fun name(): String => "appdirs/no_home"

  fun apply(h: TestHelper) =>
    h.fail("not implemented") // TODO

class AppDirsAppAuthorTest is UnitTest
  fun name(): String => "appdirs/app_author"

  fun apply(h: TestHelper) =>
    h.fail("not implemented") // TODO

class AppDirsWindowsRoamingTest is UnitTest
  fun name(): String => "appdirs/roaming"

  fun apply(h: TestHelper) =>
    h.fail("not implemented") // TODO

class AppDirsUnixXDGVarsTest is UnitTest
  fun name(): String => "appdirs/xdg_vars"

  fun apply(h: TestHelper) =>
    h.fail("not implemented") // TODO

