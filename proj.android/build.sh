cd ./main
./build_native.sh
cd ../
gradle installDebug
adb shell am start -n prime.bacoo.gamee/prime.bacoo.gamee.Gamee
adb logcat | grep cocos2d-x
