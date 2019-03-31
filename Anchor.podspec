#
# Be sure to run `pod lib lint Anchor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Anchor'
  s.version          = '1.0.0'
  s.summary          = 'Anchor provides gesture controlled expandable views that house scrollable content. This is similiar to the cards in Apple Maps.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       This library mimics the functionality of Apple Maps Cards. Each card is anchored to minimized maximized
                       positions that the user can swipe between. The view contains a scrollView to display content.

  s.homepage         = 'https://github.com/armcast/Anchor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Armando Castaneda Elguero' => 'armando.cas27@gmail.com' }
  s.source           = { :git => 'https://github.com/Armando Castaneda Elguero/Anchor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Anchor/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Anchor' => ['Anchor/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
