#
# Be sure to run `pod lib lint LocalizeNIB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LocalizeNIB'
  s.version          = '1.1'
  s.summary          = 'Simple localization of your storyboards and XIB files.'
  s.homepage         = 'https://github.com/strvcom/localizenib-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jindra Dolezy' => 'jindra.dolezy@strv.com' }
  s.source           = { :git => 'https://github.com/strvcom/localizenib-ios.git', :tag => '1.1' }

  s.ios.deployment_target = '9.0'

  s.source_files = 'LocalizeNIB/**/*'
  s.frameworks = 'UIKit'
end
