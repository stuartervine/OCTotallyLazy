#!/bin/sh

CURRENT_USER=`whoami`
CURRENT_PATH=`pwd`
CERTS_PATH=$CURRENT_PATH/configuration/provisioning

function cleanTargets() {
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Application Support/iPhone Simulator
    rm -rf build
    xcodebuild -target OCTotallyLazy -sdk iphoneos -configuration Release clean;
    xcodebuild -target test-unit -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk/ -configuration Debug clean;
}

function runTests() {
    #xcodebuild -target package -sdk iphoneos -configuration Release build
    xcodebuild -verbose -target test-unit -sdk /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk/ -configuration Debug build
    OUT=$?
    if [ $OUT -ne 0 ]
    then
        echo "Build FAILED : $OUT";
        exit 1
    fi
}

function buildRelease() {
    xcodebuild -target package -sdk iphoneos -configuration Release build
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
