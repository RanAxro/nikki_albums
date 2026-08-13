cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

# ---------------------------------------------
# 复制 nuan5_decryption.dll 到 Flutter 构建输出目录
# ---------------------------------------------
set(NATIVE_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../rust/lib/windows")

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  "${NATIVE_LIB_DIR}/nuan5_decryption.dll"
  $<TARGET_FILE_DIR:${BINARY_NAME}>
  COMMENT "Copying nuan5_decryption.dll to output directory"
)

# ---------------------------------------------
# 复制 FFmpeg 和 ExifTool 到输出目录下的 bin 文件夹
# ---------------------------------------------
set(TOOLS_BIN_DIR "${CMAKE_CURRENT_SOURCE_DIR}/resources/bin")

# Create a small cmake script to copy files if they exist
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/copy_tools.cmake" "
if(EXISTS \"\${SRC}/ffmpeg.exe\")
  file(COPY \"\${SRC}/ffmpeg.exe\" DESTINATION \"\${DST}\")
endif()
if(EXISTS \"\${SRC}/exiftool.exe\")
  file(COPY \"\${SRC}/exiftool.exe\" DESTINATION \"\${DST}\")
endif()
if(EXISTS \"\${SRC}/exiftool_files\")
  file(COPY \"\${SRC}/exiftool_files\" DESTINATION \"\${DST}\")
endif()
")

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:${BINARY_NAME}>/bin
  COMMAND ${CMAKE_COMMAND} -DSRC="${TOOLS_BIN_DIR}" -DDST="$<TARGET_FILE_DIR:${BINARY_NAME}>/bin" -P "${CMAKE_CURRENT_BINARY_DIR}/copy_tools.cmake"
  COMMENT "Copying ffmpeg.exe and exiftool.exe to output bin directory if they exist"
)