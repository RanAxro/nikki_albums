@echo off
chcp 65001 >nul
echo Building Nikki Albums...

cargo build --release

if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo Copying to final name...
copy /Y "target\release\nikki_albums_windows_sfx.exe" "target\release\Nikki Albums.exe" >nul

echo Done: target\release\Nikki Albums.exe
pause