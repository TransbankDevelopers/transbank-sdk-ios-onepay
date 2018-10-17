#!/bin/sh

set -e

xcodebuild clean

xcodebuild -target "OnePaySDK" -configuration Release -arch arm64 -arch armv7 -arch armv7s only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "OnePaySDK" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"

cp -R build/Release-iphoneos/OnePaySDK.framework .

lipo -create -output "OnePaySDK.framework/OnePaySDK" build/Release-iphoneos/OnePaySDK.framework/OnePaySDK build/Release-iphonesimulator/OnePaySDK.framework/OnePaySDK

cp build/Release-iphonesimulator/OnePaySDK.framework/Modules/module.modulemap OnePaySDK.framework/Modules/module.modulemap

zip -r9 "sdk-ios-onepay-$TRAVIS_TAG.zip" OnePaySDK.framework
