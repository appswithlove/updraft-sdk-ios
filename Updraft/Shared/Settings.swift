//
//  Settings.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Settings of the sdk
final class Settings {
	var sdkKey: String
	var appKey: String
	
	init(sdkKey: String, appKey: String) {
		self.sdkKey = sdkKey
		self.appKey = appKey
	}
	
	convenience init() {
		self.init(sdkKey: "", appKey: "")
	}
}
