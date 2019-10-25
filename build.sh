#!/bin/bash

NDK=~/Android/android-ndk-r13b
API=21
ORIGINAL_PATH=$PATH

rm -rf build/ffmpeg
mkdir -p build/ffmpeg
cd ffmpeg

LDFLAGS=""

# Google now requires 64-bit builds of all native libraries. 
for version in armv7a armv8a x86 x86_64; do

	DEST=../build/ffmpeg
	FLAGS="--enable-shared"
	FLAGS="$FLAGS --disable-symver"
	FLAGS="$FLAGS --enable-small"
	FLAGS="$FLAGS --enable-pic"
	FLAGS="$FLAGS --disable-dxva2"
	FLAGS="$FLAGS --disable-avdevice"
	FLAGS="$FLAGS --disable-swscale"
	FLAGS="$FLAGS --disable-avfilter"
	FLAGS="$FLAGS --disable-network"
	FLAGS="$FLAGS --disable-ffmpeg"
	FLAGS="$FLAGS --disable-ffplay"
	FLAGS="$FLAGS --disable-ffprobe"
	FLAGS="$FLAGS --disable-everything"
	FLAGS="$FLAGS --enable-decoder=mp2"
	FLAGS="$FLAGS --enable-decoder=mp3float"
	FLAGS="$FLAGS --enable-decoder=alac"
	FLAGS="$FLAGS --enable-decoder=pcm_s16be"
	FLAGS="$FLAGS --enable-decoder=pcm_s16le"
	FLAGS="$FLAGS --enable-decoder=pcm_u16be"
	FLAGS="$FLAGS --enable-decoder=pcm_u16le"
	FLAGS="$FLAGS --enable-decoder=pcm_alaw"
	FLAGS="$FLAGS --enable-decoder=pcm_mulaw"
	FLAGS="$FLAGS --enable-decoder=pcm_s16le_planar"
	FLAGS="$FLAGS --enable-decoder=adpcm_ms"
	FLAGS="$FLAGS --enable-decoder=adpcm_g726"
	FLAGS="$FLAGS --enable-decoder=gsm"
	FLAGS="$FLAGS --enable-decoder=gsm_ms"
	FLAGS="$FLAGS --enable-decoder=tta"
	FLAGS="$FLAGS --enable-decoder=wmapro"
	FLAGS="$FLAGS --enable-decoder=wmav1"
	FLAGS="$FLAGS --enable-decoder=wmav2"
	FLAGS="$FLAGS --enable-decoder=ape"
	FLAGS="$FLAGS --enable-parser=mpegaudio"
	FLAGS="$FLAGS --enable-protocol=file"
	FLAGS="$FLAGS --enable-protocol=pipe"
	FLAGS="$FLAGS --enable-demuxer=mp3"
	FLAGS="$FLAGS --enable-demuxer=mov"
	FLAGS="$FLAGS --enable-demuxer=asf"
	FLAGS="$FLAGS --enable-demuxer=pcm_s16be"
	FLAGS="$FLAGS --enable-demuxer=pcm_s16le"
	FLAGS="$FLAGS --enable-demuxer=pcm_u16be"
	FLAGS="$FLAGS --enable-demuxer=pcm_u16le"
	FLAGS="$FLAGS --enable-demuxer=pcm_alaw"
	FLAGS="$FLAGS --enable-demuxer=pcm_mulaw"
	FLAGS="$FLAGS --enable-demuxer=tta"
	FLAGS="$FLAGS --enable-demuxer=wav"
	FLAGS="$FLAGS --enable-demuxer=aiff"
	FLAGS="$FLAGS --enable-demuxer=ape"
	FLAGS="$FLAGS --enable-decoder=aac"
	FLAGS="$FLAGS --enable-parser=aac"
	FLAGS="$FLAGS --enable-demuxer=aac"
	FLAGS="$FLAGS --enable-decoder=vorbis"
	FLAGS="$FLAGS --enable-demuxer=ogg"
	FLAGS="$FLAGS --enable-decoder=flac"
	FLAGS="$FLAGS --enable-parser=flac"
	FLAGS="$FLAGS --enable-demuxer=flac"
	FLAGS="$FLAGS --enable-demuxer=dsf"
	FLAGS="$FLAGS --enable-decoder=dsd_lsbf"
	FLAGS="$FLAGS --enable-decoder=dsd_lsbf_planar"
	FLAGS="$FLAGS --enable-decoder=dsd_msbf"
	FLAGS="$FLAGS --enable-decoder=dsd_msbf_planar"

	case "$version" in
		armv7a)
			ARCH="arm"
			CROSS_PREFIX="arm-linux-androideabi-"
			TOOLCHAIN="arm-linux-androideabi-4.9"
			EXTRA_CFLAGS="-march=armv7-a"
			EXTRA_LDFLAGS=""
			XFLAGS=""
			ABI="armeabi-v7a"
			;;
		armv8a)
			ARCH="arm64"
			CROSS_PREFIX="aarch64-linux-android-"
			TOOLCHAIN="aarch64-linux-android-4.9"
			EXTRA_CFLAGS="-march=armv8-a"
			EXTRA_LDFLAGS=""
			XFLAGS=""
			ABI="arm64-v8a"
			;;
		x86)
			ARCH="x86"
			CROSS_PREFIX="i686-linux-android-"
			TOOLCHAIN="x86-4.9"
			EXTRA_CFLAGS=""
			EXTRA_LDFLAGS=""
			XFLAGS="--disable-asm"
			ABI="x86"
			;;
		x86_64)
			ARCH="x86_64"
			CROSS_PREFIX="x86_64-linux-android-"
			TOOLCHAIN="x86_64-4.9"
			EXTRA_CFLAGS=""
			EXTRA_LDFLAGS=""
			XFLAGS="--disable-asm"
			ABI="x86_64"
			;;
	esac

	SYSROOT=$NDK/platforms/android-$API/arch-$ARCH
	export PATH=$NDK/toolchains/$TOOLCHAIN/prebuilt/linux-x86_64/bin:$ORIGINAL_PATH
	echo $PATH

	DEST="$DEST/$ABI"

    FLAGS="$FLAGS --cc=${CROSS_PREFIX}gcc"
	FLAGS="$FLAGS --target-os=android"
	FLAGS="$FLAGS --sysroot=$SYSROOT"
	FLAGS="$FLAGS --arch=$ARCH"
	FLAGS="$FLAGS --enable-cross-compile"
	FLAGS="$FLAGS --cross-prefix=$CROSS_PREFIX"
	FLAGS="$FLAGS --prefix=$DEST"

	mkdir -p $DEST
	echo $FLAGS $XFLAGS --extra-cflags="\"$EXTRA_CFLAGS\"" --extra-ldflags="\"$LDFLAGS$EXTRA_LDFLAGS\"" > $DEST/info.txt
	./configure $FLAGS $XFLAGS --extra-cflags="\"$EXTRA_CFLAGS\"" --extra-ldflags="\"$LDFLAGS$EXTRA_LDFLAGS\"" | tee $DEST/configuration.txt
	[ $PIPESTATUS == 0 ] || exit 1
	make clean
	make -j4 || exit 1
	make install || exit 1

done

