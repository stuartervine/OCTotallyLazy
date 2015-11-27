#!/bin/sh

CURRENT_USER=`whoami`
CURRENT_PATH=`pwd`
XCODE_PATH=`xcode-select -print-path`
SDK_PATH=`ls -t -d $XCODE_PATH/Platforms/iPhoneSimulator.platform/Developer/SDKs/* | head -1`
function cleanTargets() {
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Application Support/iPhone Simulator
    rm -rf build
    xctool -target OCTotallyLazy -sdk iphoneos -configuration Release clean;
    xctool -target OCTotallyLazyTests -sdk iphoneos -configuration Debug clean;
}

function runTests() {
    #xcodebuild -target OCTotallyLazy -sdk iphoneos -configuration Release build
    xctool -scheme AllTests -sdk iphonesimulator -configuration Debug test
    OUT=$?
    if [ $OUT -ne 0 ]
    then
        echo "Build FAILED : $OUT";
        exit 1
    fi
}

function buildRelease() {
    xctool -scheme OCTotallyLazy -sdk iphoneos -configuration Release build
    OUT=$?
    if [ $OUT -ne 0 ]
    then
        echo "Build FAILED : $OUT";
        exit 1
    fi
}

case "$1" in
  clean)
  cleanTargets;;

  test)
  runTests;;

  release)
  buildRelease;;
  *)
  echo "Usage: build.sh (clean|test|release) e.g. ./build.sh test";
  exit 1;;
esac

exit 0
