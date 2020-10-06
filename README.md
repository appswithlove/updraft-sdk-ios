![Updraft: Mobile App Distribution](updraft.png)
[![Build Status](https://github.com/appswithlove/updraft-sdk-ios/workflows/Updraft%20CI/badge.svg?branch=master)](https://github.com/appswithlove/updraft-sdk-ios/actions)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/appswithlove/updraft-sdk-ios/master/LICENSE)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UpdraftSDK.svg)](https://img.shields.io/cocoapods/v/UpdraftSDK.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Twitter](https://img.shields.io/badge/twitter-@GetUpdraft-blue.svg?style=flat)](https://twitter.com/GetUpdraft)


# Updraft SDK 

Updraft SDK for iOS

Updraft is a super easy app delivery tool that allows you to simply and quickly distribute your app. It's super useful during beta-testing or if you want to deliver an app without going through the app store review processes. Your users get a link and are guided through the installation process with in a comprehensive web-app. Updraft works with Android and iOS apps and easily integrates with your IDE.
The SDK adds additional features to apps that are delivered with Updraft: Auto-update for your distributed apps and most importantly the collection of user feedback.

Updraft is built by App Agencies [Apps with love](https://appswithlove.com/) and [Moqod](https://moqod.com/). Learn more at [getupdraft.com](https://getupdraft.com/) or follow the latest news on [twitter](https://twitter.com/GetUpdraft).

## Requirements

- iOS 10.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### Swift Package Manager (SPM) Support
- iOS 12.0+
A first version is available on branch `swift-package-manager`

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
- <b>sdkKey</b>: Your sdk key obtained on [Updraft](https://getupdraft.com)
- <b>appKey</b>: You app key obtained on [Updraft](https://getupdraft.com)

## AutoUpdate
Auto Update functionality can be enabled/disabled on [getupdraft.com](https://getupdraft.com/) in your app edit menu.

AutoUpdate work by comparing the build number of the app installed on the user's device and the app uploaded on GetUpdraft.

A prompt is displayed to the user if his installed version is lower than the version on Updraft.
Thus, the build number must be incremented for each new build release to trigger the auto-update process.

Micro version comparison is supported, for example version 1.2.3.2018080**4** is greater than version 1.2.3.2018080**3**

## Feedback

Feedback functionality can be enabled/disabled on [getupdraft.com](https://getupdraft.com/) in your app edit menu.

A prompt is shown to the user to inform him of the change of state of the feedback functionality.

If enabled, the user is explained how he can give feedback.
User can take a screenshot to give a feedback.

## Advanced setup

### Logging

To check if data is send properly to Updraft and also see some additional SDK log data in the console, you can set different log levels.

To change the log level, add the following line before starting the SDK:

#### Swift
```Swift
Updraft.shared.logLevel = .info
```
	
#### Objective-C
```Objective-C
[Updraft shared].logLevel = LogLevelInfo;
```

Default level: <b>warning</b> => Only warnings and errors will be printed.


### Base URL 

If you have your own instance of Updraft, set this property to the base URL of your instance, before starting the SDK.

#### Swift
```Swift
Updraft.shared.baseUrl = "https://your_base_url/"
```

#### Objective-C
```Objective-C
[Updraft shared].baseUrl = @"https://your_base_url/";
```

Default <b>https://getupdraft.com/</b>
