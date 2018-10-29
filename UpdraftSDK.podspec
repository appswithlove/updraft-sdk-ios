Pod::Spec.new do |s|
  s.name              = "UpdraftSDK"
  s.version           = "0.3.4"
  s.summary           = "Mobile App Distribution"
  s.homepage          = "https://getupdraft.com"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "Raphael Neuenschwander" => "raphael@appswithlove.com" }
  s.social_media_url  = "https://twitter.com/getupdraft"
  s.platform          = :ios, "10.0"
  s.swift_version     = '4.0'
  s.source            = { :git => "git@github.com:appswithlove/updraft-sdk-ios.git", :tag => s.version }
  s.source_files      = "Updraft/**/*.swift", "Updraft/*.swift"
  s.resource          = "Updraft/**/*.{xib,xcassets,ttf,strings}"
end
