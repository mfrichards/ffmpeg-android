## Building FFmpeg 4.2.1 for MyTunes Music Player Pro

These instructions explain how to build FFmpeg for use on an Android device with MyTunes
Music Player Pro. Note that these instructions are for Linux only. You should be able to
build it on Windows using Cygwin, however, I only do Android development on Linux, so do
not ask about Windows.

1) To build FFmpeg you need the the Android SDK and the Android NDK installed on your
   system. I use version 13b of the NDK (android-ndk-r13b), because that is the last
   version to fully support the gcc compiler. You may be able to use more recent NDK
   versions, but I had trouble building FFmpeg with clang, so I stick with gcc.

2) Modify the "build.sh" script to point to the correct directories on your system for the
   Android NDK tools.

3) Execute "build.sh". This should do everyting to configure and build FFmpeg with the
   components needed by MyTunes Pro. The resulting libraries will be placed under the
   "build" subdirectory.

4) Execute "clean-build.sh". This removes intermediate libraries and produces the final
   shared libraries that will be installed on the device. The libraries will be placed in
   "build/ffmpeg/<architecture>/lib".

To install the new FFmpeg shared libraries on your Android device, the device must be
rooted and you must have access to the file system via the adb tool. Copy the new shared
libraries (libavcodec.so, libavformat.so, libavutil.so, and libswresample.so) to
"/data/data/com.whitestar.mytunespro3/lib" and restart MyTunes. The app will now be
using the new libraries.


Note: These build scripts used originally created from samples found in the "bambuser"
project. For more information, see:

http://bambuser.com/opensource


## License

FFmpeg is licensed under the GNU Lesser General Public License version 2.1.

