# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'GitHubDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitHubDemo
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'Moya/RxSwift', '14.0.0'
  pod 'Kingfisher', '6.0.0'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
 end
end
