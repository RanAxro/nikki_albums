#!/bin/bash
set -e

FFMPEG_VERSION="7.0.1"

# Check if already compiled
if [ -f "ffmpeg_bin/ffmpeg.exe" ]; then
    echo "FFmpeg executable already exists in ffmpeg_bin/ffmpeg.exe, skipping compilation."
    exit 0
fi

echo "Installing cross-compilation dependencies..."
sudo apt-get update
sudo apt-get install -y gcc-mingw-w64 yasm make pkg-config wget

echo "Downloading FFmpeg source..."
wget -q "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2"
tar xjvf "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
cd "ffmpeg-${FFMPEG_VERSION}"

echo "Configuring FFmpeg for Windows x64..."
./configure \
  --arch=x86_64 \
  --target-os=mingw32 \
  --cross-prefix=x86_64-w64-mingw32- \
  --disable-everything \
  --disable-doc \
  --disable-programs \
  --disable-network \
  --enable-ffmpeg \
  --enable-protocol=file \
  --enable-demuxer=mov,mp4,m4a,3gp,3g2,mj2,hevc,h264,image2,gif \
  --enable-muxer=mp4,mov,gif,image2 \
  --enable-parser=hevc,h264,aac,mpegaudio,opus \
  --enable-decoder=hevc,h264,aac,mp3,opus \
  --enable-encoder=gif \
  --enable-filter=scale,split,palettegen,paletteuse,fps \
  --enable-bsf=hevc_mp4toannexb,h264_mp4toannexb,aac_adtstoasc \
  --extra-ldflags="-static" \
  --pkg-config="pkg-config --static"

echo "Compiling FFmpeg..."
make -j$(nproc)

echo "Compilation finished. Moving binary to output directory..."
cd ..
mkdir -p ffmpeg_bin
cp "ffmpeg-${FFMPEG_VERSION}/ffmpeg_g.exe" ffmpeg_bin/ffmpeg.exe
x86_64-w64-mingw32-strip ffmpeg_bin/ffmpeg.exe

echo "Cleaning up source..."
rm -rf "ffmpeg-${FFMPEG_VERSION}"
rm "ffmpeg-${FFMPEG_VERSION}.tar.bz2"
