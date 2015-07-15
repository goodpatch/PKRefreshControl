#
# Be sure to run `pod lib lint PKRefreshControl.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PKRefreshControl"
  s.version          = "0.1.3"
  s.summary          = "Customizable refresh control."
  s.description      = <<-DESC
  You can replace pulling(appearing) animation, loading animation, disappearing animation.
                       DESC
  s.homepage         = "https://github.com/goodpatch/PKRefreshControl"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Seiya Shimokawa" => "seiya@goodpatch.com" }
  s.source           = { :git => "https://github.com/goodpatch/PKRefreshControl.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PKRefreshControl' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
