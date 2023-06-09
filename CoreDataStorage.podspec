#
# Be sure to run `pod lib lint CoreDataStorage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoreDataStorage'
  s.version          = '1.0.2'
  s.summary          = 'CoreData with Combine'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

    s.swift_version = '5.0'
    s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Jeonhui/CoreDataStorage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeonhui' => 'dlwjsgml02@naver.com' }
  s.source           = { :git => 'https://github.com/Jeonhui/CoreDataStorage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/CoreDataStorage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CoreDataStorage' => ['Sources/CoreDataStorage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreData', 'Combine'
  # s.dependency 'AFNetworking', '~> 2.3'
end
