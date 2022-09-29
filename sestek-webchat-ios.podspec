Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.name = "sestek-webchat-ios"
  s.summary = "sestek-webchat-ios summary"
  s.requires_arc = true
  
  s.version = "0.0.2"
  
  s.license = { :type => "MIT", :file => "LICENSE" }
  
  s.author = { "Sestek" => "ps@sestek.com" }
  
  s.homepage = "https://github.com/sestek/sestek-webchat-ios"
  
  s.source = { :git => "https://github.com/sestek/sestek-webchat-ios.git", 
               :tag => "#{s.version}" }
  
  s.framework = "UIKit"
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5.10'
  
  s.source_files = "Source/swift-sestek-webchat/**/*.{swift}"
  
  s.resources = "Source/swift-sestek-webchat/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  s.resource_bundles = {'SestekWebchatBundle' => ['Source/swift-sestek-webchat/Resources/*.*']}
  
  s.swift_version = "5.0"
  
  end
