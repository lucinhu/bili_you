# 该脚本需要在项目根目录执行
echo 编译linux版AppImage包到build目录...
flutter build linux --release
rm -rf scripts/bili_you.AppDir/opt/
cp -r build/linux/x64/release/bundle/ scripts/bili_you.AppDir/opt/
appimagetool scripts/bili_you.AppDir build/BiliYou-x86_64.AppImage
rm -rf scripts/bili_you.AppDir/opt/
rm scripts/bili_you.AppDir/.DirIcon
