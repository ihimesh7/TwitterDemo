# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DemoTwitter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DemoTwitter
  pod 'TwitterKit'
  pod 'Alamofire'
  pod 'ProgressHUD'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm7, arm64"
  end
end

end
