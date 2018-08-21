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
pod 'Updraft', :git => 'http://gitlab.appswithlove.net/updraft-projects/updraft-sdk-ios.git'
end
```

Then, run the following command:

```bash
$ pod install
$ pod update
```

## Setup

### Swift

1. Import Updraft module in AppDelegate

 	```Swift
	import Updraft
	```
2. Start the SDK with your "SDK Key" and "App Key":

	```Swift
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
			Updraft.shared.start(sdkKey: "YOUR_SDK_KEY", appKey: "YOUR_APP_KEY")
			
			return true
		}
	```
	
### Objective-C

1. Import Updraft module in AppDelegate

	```Objective-C
	@import Updraft;
	```
2. Start the SDK with your "SDK Key" and "App Key":

	```Objective-C
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

			[[Updraft shared] startWithSdkKey:@"YOUR_SDK_KEY" appKey:@"YOUR_APP_KEY" isAppStoreRelease: false];

			return YES;
		}
	```
	
#### Parameters
- <b>sdkKey</b>: Your sdk key obtained on getupdraft
- <b>appKey</b>: You app key obtained on getupdraft

## AutoUpdate

AutoUpdate work by comparing the build number of the app installed on the user's device and the app uploaded on GetUpdraft.

A prompt is displayed to the user if his installed version is lower than the version on Updraft.
Thus, the build number must be incremented for each new build release to trigger the auto-update process.

Micro version comparison is supported, for example version 1.2.3.2018080**4** is greater than version 1.2.3.2018080**3**

## Feedback

A prompt is displayed to the user after first launch to explain him how he can give feedback. Displayed only once.

User can shake his device ot take a screenshot to give a feedback.
