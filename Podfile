platform :ios, '11.0'

source 'https://gitlab.wind-digital.com/cocoapods/Specs.git'
source 'https://cdn.cocoapods.org/'

use_frameworks!

def common_pods
  pod 'TinyConstraints'
  pod 'DropDown', '2.3.13'
  pod 'BetterSegmentedControl', '~> 2.0'
  pod 'Charts',  :path => './Charts'
end

target 'Graphic Components' do
  common_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        #config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        if Gem::Version.new('11.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
  end
end
