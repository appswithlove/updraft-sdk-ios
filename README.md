# Updraft SDK

Updraft SDK for iOS

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Updraft into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
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

## Setup

1. Import Updraft module in AppDelegate

 	```Swift
	import Updraft
	```
2. Start the SDK with your "SDK Key" and "App Key":

	
	```Swift
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
			Updraft.shared.start(sdkKey: "YOUR_SDK_KEY", appKey: "YOUR_APP_KEY", isAppStoreRelease: false)
			
			return true
		}
	```
