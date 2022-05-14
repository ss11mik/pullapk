# get APK from Android device by ADB
# author: ss11mik
# 2022
#
# usage: ./pullapk.sh cz.package.name

adb devices
matching_pkgs=$(adb shell pm list packages | grep $1)
if [ $((`echo $matching_pkgs | wc -l `)) -eq "0" ]; then
   echo "No matching package found"
   exit 1
fi
echo "matches:"
#echo $matching_pkgs
adb shell pm list packages | grep $1
echo ""

# the apk is in one of thece locations.
# TODO find the exact path and do not guess
adb shell cp /data/app/$1/base.apk /sdcard/$1.apk 2> /dev/null
adb shell cp /data/app/$1-1/base.apk /sdcard/$1.apk 2> /dev/null
adb shell cp /data/app/$1-2/base.apk /sdcard/$1.apk 2> /dev/null

adb pull /sdcard/$1.apk 2> /dev/null
if [ $? -eq 0 ]; then
    adb shell rm /sdcard/$1.apk
    echo "Success:"
    ls -l $1.apk
else
    echo "No matching package found"
    exit 2
fi
