Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.name = "sestek-webchat-ios"
  s.summary = "sestek-webchat-ios summary"
  s.requires_arc = true
  
  s.version = "0.0.1"
  
  s.license = { :type => "MIT", :file => "LICENSE" }
  
  s.author = { "Sestek" => "ps@sestek.com" }
  
  s.homepage = "https://github.com/sestek/sestek-webchat-ios"
  
  s.source = { :git => "https://github.com/sestek/sestek-webchat-ios.git", 
               :tag => "#{s.version}" }
  
  s.framework = "UIKit"
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5.10'
  
  s.source_files = "swift-sestek-webchat/**/*.{swift}"
  
  s.resources = "swift-sestek-webchat/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  s.resource_bundles = {'SestekWebchatBundle' => ['swift-sestek-webchat/Resources/*.*']}
  
  s.swift_version = "5.0"
  
  end
