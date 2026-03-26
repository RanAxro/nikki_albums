# How to run this project

***

## preparation
  1. assets
      * Flutter 3.32.8 • channel stable
      * Framework • revision edada7c56e • 2025-07-25 14:08:03 +0000
      * Engine • revision ef0cd00091 • 2025-07-24 12:23:50 -0700
      * Dart 3.8.1
      * DevTools 2.45.1
      * VisualStudio2022+win10sdk、win11sdk
  
  2. New Flutter Project
      * Project name: nikki_albums
	  * Platforms: Androids(Useless now!)、Windows
	
## import
  1. Place "assets" and "lib" in the root directory of the project.
  2. Add dependencies:
      * easy_localization: ^3.0.8
      * multi_split_view: ^3.6.1
      * path: ^1.9.1
      * path_provider: ^2.1.5
      * file_picker: ^10.3.7
      * watcher: ^1.1.4
      * super_clipboard: ^0.9.1
      * desktop_drop: ^0.7.0
      * url_launcher: ^6.3.2
      * archive: ^4.0.7
      * crypto: ^3.0.7
      * encrypt: ^5.0.3
      * dio: ^5.9.0
      * shelf: ^1.4.2
      * shelf_static: ^1.1.3
      * qr_flutter: ^4.1.0
      * network_info_plus: ^7.0.0
      * connectivity_plus: ^7.0.0

        # Windows
        bitsdojo_window: ^0.1.6
        ffi: ^2.1.3
        win32: ^5.15.0
        win32_registry: ^2.1.0
        windows_single_instance: ^1.1.0
  3. Add assets:
      * \- assets/lang/
      * \- assets/logo/
      * \- assets/icon/
      * \- assets/icon/album/
      * \- assets/icon/big/
      * \- assets/map/
      * \- bin/

  4. Add shaders:
      * \- assets/shaders/image_fragment.frag

  5. Place the following code at the beginning of the "\windows\runner\main.cpp" file.
     ```C++
     #include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
     auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);
  6. Make sure you have installed NuGet. If not, please open PowerShell or Windows Terminal as an administrator and execute  
     ```bash
     winget install Microsoft.NuGet
  7. Execute
     ```bash
     flutter pub get
