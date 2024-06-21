platform :ios, '18.0'
use_frameworks!

target 'MR-Mapping-iOS' do
  pod 'Starscream'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.0'
    end
  end
end