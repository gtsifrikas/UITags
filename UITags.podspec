#
# Be sure to run `pod lib lint UITags.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "UITags"
s.version          = "0.1.5"
s.summary          = "Tags used for category based filtering of for multiple selection"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description      = "UITags can be used if you have a list a you want to filter the based on some cateogies, or if you want the user to choose some of the options. It is very customizable"


s.homepage         = "https://github.com/gtsif21/UITags"
# s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "George Tsifrikas" => "gtsifrikas@gmail.com", "Fernando Valle" => "fernandovalle.developer@gmail.com",  }
s.source           = { :git => "https://github.com/gtsif21/UITags.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/gtsifrikas'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Pod/Classes/**/*'

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit'
s.dependency 'UICollectionViewLeftAlignedLayout'
end
