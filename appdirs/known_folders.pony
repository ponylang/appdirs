use "lib:shell32" if windows
use "lib:ole32" if windows
use "debug"

use @SHGetKnownFolderPath[U32](rfid: Pointer[U8] tag, flags: U32,
  token: Pointer[U32], path: Pointer[Pointer[U16]]) if windows
use @WideCharToMultiByte[I32](code_page: U32, flags: U32, char_str: Pointer[U16],
  char_str_size: I32, multi_byte_str: Pointer[U8] tag, multi_byte_str_size: I32,
  default_char: Pointer[U8], used_default_char: Pointer[U8]) if windows
use @CoTaskMemFree[None](pv: Pointer[U16] tag) if windows

primitive KnownFolderIds
  """
  Known folder ids as described in:
  https://docs.microsoft.com/en-ca/windows/desktop/shell/knownfolderid
  functions return the little endian byte values of the folderid GUIDs
  """
    fun profile(): Array[U8] val =>
        """
        The user's profile folder. A typical path is C:\Users\username.
        Applications should not create files or folders at this level;
        they should put their data under the locations referred to by CSIDL_APPDATA or CSIDL_LOCAL_APPDATA.
        However, if you are creating a new Known Folder the profile root referred to by CSIDL_PROFILE is appropriate.

        FOLDERID_Profile
        5E6C858F-0E22-4760-9AFE-EA3317B67173
        """
        [as U8: 0x8f; 0x85; 0x6c; 0x5e; 0x22; 0x0e; 0x60; 0x47; 0x9A; 0xFE; 0xEA; 0x33; 0x17; 0xB6; 0x71; 0x73]

    fun app_data_roaming(): Array[U8] val =>
        """
        The file system directory that serves as a common repository for application-specific data.
        A typical path is C:\Documents and Settings\username\Application Data.

        KNOWNFOLDERID: FOLDERID_RoamingAppData
        GUID: 3EB685DB-65F9-4CF6-A03A-E3EF65729F3D
        """
        [as U8: 0xdb; 0x85; 0xb6; 0x3e; 0xf9; 0x65; 0xf6; 0x4c; 0xa0; 0x3a; 0xe3; 0xef; 0x65; 0x72; 0x9f; 0x3d]

    fun app_data_local(): Array[U8] val =>
        """
        The file system directory that serves as a data repository for local (nonroaming) applications.
        A typical path is C:\Documents and Settings\username\Local Settings\Application Data.

        FOLDERID_LocalAppData
        F1B32785-6FBA-4FCF-9D55-7B8E7F157091
        """
        [as U8: 0x85; 0x27; 0xb3; 0xf1; 0xba; 0x6f; 0xcf; 0x4f; 0x9d; 0x55; 0x7b; 0x8e; 0x7f; 0x15; 0x70; 0x91]

    fun program_data(): Array[U8] val =>
        """
        The file system directory that contains application data for all users.
        A typical path is C:\Documents and Settings\All Users\Application Data.
        This folder is used for application data that is not user specific.
        For example, an application can store a spell-check dictionary,
        a database of clip art, or a log file in the CSIDL_COMMON_APPDATA folder.
        This information will not roam and is available to anyone using the computer.

        FOLDERID_ProgramData
        62AB5D82-FDC1-4DC3-A9DD-070D1D495D97
        """
        [as U8: 0x82; 0x5d; 0xab; 0x62; 0xc1; 0xfd; 0xc3; 0x4d; 0xa9; 0xdd; 0x07; 0x0d; 0x1d; 0x49; 0x5d; 0x97]

primitive KnownFolders
  """
  Utility for getting some known folders on windows.

  https://docs.microsoft.com/en-ca/windows/desktop/shell/known-folders
  """
  fun apply(folderid: Array[U8] val): String iso^ ? =>
    ifdef not windows then
      compile_error "known folders only supported on windows"
    else
      // get UTF-16 wide-char path from windows API
      var path_pointer: Pointer[U16] = Pointer[U16]
      let result: U32 =
        @SHGetKnownFolderPath(
          folderid.cpointer(), // REFKNOWNFOLDERID
          U32(0), // retrieval flags -- no flags
          Pointer[U32], // some strange handle, pass NULL
          addressof path_pointer
        )
      if result != 0 then
          Debug("Error getting known folder path: " + result.string())
          error
      end

      // extract path from path_pointer
      let bytes_necessary: I32 = @WideCharToMultiByte(
          WindowsCodePages.utf8(),
          U32(0),
          path_pointer,
          I32(-1), // length of path pointer, -1 for null terminated
          Pointer[U8].create(),
          I32(0), // indicating we want the required bytes back
          Pointer[U8].create(), // NULL
          Pointer[U8].create()  // NULL
      )
      let utf8_path: Array[U8] iso = recover Array[U8](bytes_necessary.usize()) end
      utf8_path.undefined(bytes_necessary.usize())
      let convert_result: I32 = @WideCharToMultiByte(
          WindowsCodePages.utf8(),
          U32(0),
          path_pointer,
          I32(-1), // length of path pointer, -1 for null terminated
          utf8_path.cpointer(),
          utf8_path.size().i32(),
          Pointer[U8].create(), // NULL
          Pointer[U8].create()  // NULL
      )
      if convert_result == 0 then
          Debug("error converting from wchar to utf8.")
          error
      end
      @CoTaskMemFree(path_pointer)

      try utf8_path.pop()? end // remove 0 terminator
      String.from_iso_array(consume utf8_path)
    end
