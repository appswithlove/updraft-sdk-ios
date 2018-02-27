
- [Installation](#installation)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
pod 'Updraft', :git => 'https://git.appswithlove.net/awl_ios/updraft-sdk_ios.git'
end
```

Then, run the following command:

```bash
$ pod install
```
