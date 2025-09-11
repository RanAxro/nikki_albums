# How to fork this project

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
      * ffi: ^2.1.3
      * bitsdojo_window: ^0.1.6
      * path_provider: ^2.1.5
      * file_picker: ^10.3.2
      * flutter_inappwebview: ^6.1.5
      * http: ^1.5.0
  3. Add assets:
      * \- assets/icon/
      * \- assets/logo/
  4. Place the following code at the beginning of the "\windows\runner\main.cpp" file.
     ```C++
     #include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
     auto bdw = bitsdojo_window_configure(BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP);
  5. Make sure you have installed NuGet. If not, please open PowerShell or Windows Terminal as an administrator and execute  
     ```bash
     winget install Microsoft.NuGet
  6. Execute
     ```bash
     flutter pub get
