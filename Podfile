# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Chat On' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Chat On

pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Core'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'AlamofireImage'
pod 'Alamofire'
pod 'Firebase/Messaging'

target 'Chat On Notification Content Extension' do
    pod 'AlamofireImage'
end

target 'Chat On Watch Extension' do
    platform :watchos, '2.0'
    pod 'AlamofireImage'
end

end




post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
