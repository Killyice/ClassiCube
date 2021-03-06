#!/bin/bash

# These build instructions are for ubuntu. Other linux distributions may have saner behaviour.
# The build script relies on the following assumptions:
# - You have already cloned ClassiCube from github
# - The root folder is ~/client/ (i.e. folder layout is ~/client/.git/, ~/client/src/, etc)
# First you need to install these packages: gcc, i686-w64-mingw32-gcc and x86_64-w64-mingw32-gcc
# 
# You then need to install these packages: libx11-dev, libgl1-mesa-dev, libopenal-dev, libcurl4-gnutls-dev/libcurl4-openssl-dev
# - if 32 bit, then install the 64 bit variants of all these packages (e.g. libx11-dev:amd64)
# - if 64 bit, then install the 32 bit variants of all these packages (e.g. libx11-dev:i386)
#
# However! You may find that installing the alternate bit variant of libgl1-mesa-dev uninstalls your current package
# To fix this, first reinstall the normal libgl1-mesa-dev package
# The alternate bit .so files should have been left behind in the mesa folder, so adding a symlink should make it compile again
# - for 32 bit: ln -sf /usr/lib/x86_64-linux-gnu/mesa/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
# - for 64 bit: ln -sf /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
#
# You should now be able to compile both 32 and 64 bit variants of the client for linux
# However! The default libcurl package will produce an executable that won't run on Arch (due to defining CURL_OPENSSL_3)
# As such, you may want to uninstall libcurl package, manually compile curl's source code for both 32 and 64 bit, 
# then add the .so files to /usr/lib/i386-linux-gnu and /usr/lib/i386-linux-gnu/
cd ~/client/src/
echo $PWD

# -----------------------------
c_build_win32() {
  cp ~/client/misc/CCicon_32.res ~/client/misc/src/CCicon_32.res
  rm cc-w32-d3d.exe cc-w32-ogl.exe

  i686-w64-mingw32-gcc *.c -O1 -s -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -o cc-w32-d3d.exe CCicon_32.res -mwindows -lws2_32 -lwininet -lwinmm -limagehlp -lcrypt32 -ld3d9 -w
  i686-w64-mingw32-gcc *.c -O1 -s -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -o cc-w32-ogl.exe CCicon_32.res -DCC_BUILD_MANUAL -DCC_BUILD_WIN -DCC_BUILD_WINGUI -DCC_BUILD_WGL -DCC_BUILD_WINMM -DCC_BUILD_WININET -mwindows -lws2_32 -lwininet -lwinmm -limagehlp -lcrypt32 -lopengl32 -w
}

c_build_win64() {
  cp ~/client/misc/CCicon_64.res ~/client/misc/src/CCicon_64.res
  rm cc-w64-d3d.exe cc-w64-ogl.exe
  
  x86_64-w64-mingw32-gcc *.c -O1 -s -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -o cc-w64-d3d.exe CCicon_64.res -mwindows -lws2_32 -lwininet -lwinmm -limagehlp -lcrypt32 -ld3d9 -w
  x86_64-w64-mingw32-gcc *.c -O1 -s -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -o cc-w64-ogl.exe CCicon_64.res -DCC_BUILD_MANUAL -DCC_BUILD_WIN -DCC_BUILD_WINGUI -DCC_BUILD_WGL -DCC_BUILD_WINMM -DCC_BUILD_WININET -mwindows -lws2_32 -lwininet -lwinmm -limagehlp -lcrypt32 -lopengl32 -w
}

c_build_nix32() {
  rm cc-nix32
  gcc *.c -O1 -fvisibility=hidden -s -rdynamic -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -m32 -o cc-nix32 -lX11 -lpthread -lGL -lm -lcurl -lopenal -ldl -w
}

c_build_nix64() {
  rm cc-nix64
  gcc *.c -O1 -fvisibility=hidden -s -rdynamic -fno-stack-protector -DCC_COMMIT_SHA=\"$LATEST\" -m64 -o cc-nix64 -lX11 -lpthread -lGL -lm -lcurl -lopenal -ldl -w
}

# -----------------------------
git pull https://github.com/UnknownShadow200/ClassiCube.git
git fetch --all
git reset --hard origin/master
LATEST=`git rev-parse --short HEAD`

c_build_win32
c_build_win64
c_build_nix32
c_build_nix64
