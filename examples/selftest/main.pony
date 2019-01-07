use "../../appdirs"

actor Main
  new create(env: Env) =>
    let app_name = "selftest"
    print(AppDirs(env.vars, app_name), "With Defaults", env.out)
    print(AppDirs(env.vars, app_name, "Matthias Wahl"), "With App-Author", env.out)
    print(AppDirs(env.vars, app_name, "Matthias Wahl", "0.1"), "With App-Author and Version", env.out)
    print(AppDirs(env.vars, app_name, None, "0.1"), "With Version", env.out)
    print(AppDirs(env.vars, app_name, "Matthias Wahl", "0.2" where roaming=true), "No Roaming", env.out)

  fun print(app_dirs: AppDirs, title: String, out: OutStream) =>
    let title_len = title.size()
    let heading = String.from_array(recover val Array[U8].init('=', title_len) end)
    out.print("")
    out.print(heading)
    out.print(title)
    out.print(heading)
    out.>write("home = ")
       .>write(try app_dirs.user_home_dir()? else "ERROR" end)
       .>write("\n")
    out.>write("user_data = ")
       .>write(try app_dirs.user_data_dir()? else "ERROR" end)
       .>write("\n")
    out.print("site_data = ")
    try
      for sd_dir in app_dirs.site_data_dirs()?.values() do
        out.print("\t" + sd_dir)
      end
    else
      out.print("\tERROR")
    end

    out.>write("user_config = ")
       .>write(try app_dirs.user_config_dir()? else "ERROR" end)
       .>write("\n")

    out.print("site_config = ")
    try
      for sc_dir in app_dirs.site_config_dirs()?.values() do
        out.print("\t" + sc_dir)
      end
    else
      out.print("\tERROR")
    end

    out.>write("user_cache = ")
       .>write(try app_dirs.user_cache_dir()? else "ERROR" end)
       .>write("\n")

    out.>write("user_state = ")
       .>write(try app_dirs.user_state_dir()? else "ERROR" end)
       .>write("\n")

    out.>write("user_log = ")
       .>write(try app_dirs.user_log_dir()? else "ERROR" end)
       .>write("\n")
    out.print("")

