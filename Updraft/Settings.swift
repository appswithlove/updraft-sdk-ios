//
//  Settings.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Settings of the sdk
class Settings {
	var sdkKey: String
	var appKey: String
	var isAppStoreRelease: Bool
	
	init(sdkKey: String, appKey: String, isAppStoreRelease: Bool) {
		self.sdkKey = sdkKey
		self.appKey = appKey
		self.isAppStoreRelease = isAppStoreRelease
	}
	
	convenience init() {
		self.init(sdkKey: "", appKey: "", isAppStoreRelease: false)
	}
}
