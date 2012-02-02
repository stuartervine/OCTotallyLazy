#!/bin/sh

CURRENT_USER=`whoami`
CURRENT_PATH=`pwd`
CERTS_PATH=$CURRENT_PATH/configuration/provisioning

function cleanTargets() {
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Application Support/iPhone Simulator
    rm -rf build
    xcodebuild -target Funcky -sdk iphoneos -configuration Release clean;
    xcodebuild -target FunckyTests -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk/ -configuration Debug clean;
}

function runTests() {
    xcodebuild -verbose -target FunckyTests -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk/ -configuration Debug build
    OUT=$?
    if [ $OUT -ne 0 ]
    then
        echo "Build FAILED : $OUT";
        exit 1
    fi
}

function buildRelease() {
    xcodebuild -target Funcky -sdk iphoneos -configuration Release build
    OUT=$?
    if [ $OUT -ne 0 ]
    then
        echo "Build FAILED : $OUT";
        exit 1
    fi
    mkdir -p build/package/Funcky.framework
    cp -R build/Release-iphoneos/Funcky.framework/Versions/Current/ build/package/Funcky.framework
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
