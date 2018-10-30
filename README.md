# Updraft SDK

![Updraft: Mobile App Distribution](updraft.png)

Updraft SDK for iOS

## Requirements

- iOS 10.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

### CocoaPods

Get [CocoaPods](http://cocoapods.org) and specify UpdraftSDK in your Podfile:

```bash
pod 'UpdraftSDK'
```

Then, run:

```bash
pod install
```

### Carthage
Get [Carthage](https://github.com/Carthage/Carthage) and specify Updraft in your Cartfile:

```bash
github 'appswithlove/updraft-sdk-ios'
```

Then, run:

```bash
carthage update
```

In your application targets “General” tab under the “Linked Frameworks and Libraries” section, drag and drop Updraft.framework from the Carthage/Build/iOS directory that carthage update produced.


## Setup

### Swift

1. Import Updraft module in AppDelegate:

 	```Swift
	import Updraft
	```
	If using Cocoapods:
	
	```Swift
	import UpdraftSDK
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
	If using Cocoapods:
	
	```Objective-C
	@import UpdraftSDK;
	```
	
2. Start the SDK with your "SDK Key" and "App Key":

	```Objective-C
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

			[[Updraft shared] startWithSdkKey:@"YOUR_SDK_KEY" appKey:@"YOUR_APP_KEY" isAppStoreRelease: false];

			return YES;
		}
	```
	
#### Parameters
- <b>sdkKey</b>: Your sdk key obtained on [Updraft](https://getupdraft.com)
- <b>appKey</b>: You app key obtained on [Updraft](https://getupdraft.com)

## AutoUpdate

AutoUpdate work by comparing the build number of the app installed on the user's device and the app uploaded on GetUpdraft.

A prompt is displayed to the user if his installed version is lower than the version on Updraft.
Thus, the build number must be incremented for each new build release to trigger the auto-update process.

Micro version comparison is supported, for example version 1.2.3.2018080**4** is greater than version 1.2.3.2018080**3**

## Feedback

A prompt is displayed to the user after first launch to explain him how he can give feedback. Displayed only once.

User can take a screenshot to give a feedback.

## Advanced setup:  Logging

To check if data is send properly to Updraft and also see some additional SDK log data in the console, you can set different log levels.

To change the log level, add the following line before starting the SDK:

### Swift
```Swift
Updraft.shared.logLevel = .info
```
	
### Objective-C
```Objective-C
[Updraft shared].logLevel = LogLevelInfo;
```

Default level: <b>warning</b> => Only warnings and errors will be printed.
