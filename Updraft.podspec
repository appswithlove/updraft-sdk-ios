#
#  Be sure to run `pod spec lint Updraft.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name              = "Updraft"
  s.version           = "0.3.1"
  s.summary           = "Mobile App Distribution"
  s.homepage          = "https://u2.getupdraft.com"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "Raphael Neuenschwander" => "raphael@appswithlove.com" }
  s.social_media_url  = "https://twitter.com/getupdraft"
  s.platform          = :ios, "10.0"
  s.swift_version     = '4.0'
  s.source            = { :git => "http://gitlab.appswithlove.net/updraft-projects/updraft-sdk-ios.git", :tag => s.version }
  s.source_files      = "Updraft/**/*.swift", "Updraft/*.swift"
  s.resource          = "Updraft/**/*.{xib,xcassets,ttf,strings}"
end
