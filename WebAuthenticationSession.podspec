Pod::Spec.new do |s|
  s.name             = 'WebAuthenticationSession'
  s.version          = '1.0'
  s.summary          = 'A drop in replacement for SFAuthenticationSession and ASWebAuthenticationSession.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Apple has deprecated SFAuthenticationSession in iOS 12 in favor of ASWebAuthenticationSession.
Since the API is practically identical, this library makes it easier to support both classes when targeting iOS 11.
                       DESC

  s.homepage         = 'https://github.com/JonathanDowning/WebAuthenticationSession'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JonathanDowning' => 'jd@jonathandowning.uk' }
  s.source           = { :git => 'https://github.com/JonathanDowning/WebAuthenticationSession.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.1'
  s.source_files = 'WebAuthenticationSession/Classes/**/*'
end
