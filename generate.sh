
# Usage:
# sh generate.sh com.zhz.ProjectTemplate
echo ">>>>>>>> 开始生成 <<<<<<<<"

if [ -n $1 ]; then
    echo $1
fi

# 替换名字
echo `pwd`
echo `which ruby`
ruby changeinfo.rb --name=$1

# 编译新的project
echo `which xcodebuild`
cd ./ProjectTemplate/
echo `pwd`

xcodebuild clean
xcodebuild build -project ProjectTemplate.xcodeproj \
                -scheme ProjectTemplate \
                -sdk iphoneos15.0 \
                -derivedDataPath ./build \
                -allowProvisioningUpdates \
                -allowProvisioningDeviceRegistration \
                -arch arm64e \
                # -configuration Release
                # CODE_SIGN_IDENTITY=Apple Distribution: Shanghai Yitan Network Technology Company Limited (RPHGJA2XNE)
                # IPHONEOS_DEPLOYMENT_TARGET=10.0
# -allowProvisioningUpdates
# 允许xcodebuild与Apple Developer网站进行通信。
# 对于自动签名的目标，xcodebuild将创建并更新配置文件，应用程序ID和证书。
# 对于手动签名的目标，xcodebuild将下载缺失或更新的供应配置文件， 需要在Xcode的帐户首选项窗格中添加开发者帐户。

# -allowProvisioningDeviceRegistration
# 如有必要，允许xcodebuild在Apple Developer网站上注册您的目标设备。需要-allowProvisioningUpdates。

# 找到 embedded.mobileprovision
echo ">>> mobileprovision path: "
mobileprovisionpath=`pwd`/build/Build/Products/Debug-iphoneos/ProjectTemplate.app/embedded.mobileprovision
echo $apppath
cp $mobileprovisionpath `pwd`

# 生成描述文件
security cms -D -i $mobileprovisionpath >> embedded.plist
/usr/libexec/PlistBuddy -x -c "print :Entitlements" embedded.plist > Entitlements.plist

echo ">>>>>>>> 已完成 <<<<<<<<"



