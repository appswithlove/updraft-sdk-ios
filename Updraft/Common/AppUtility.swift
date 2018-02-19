//
//  Utility.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol AppUtility {
	var buildVersion: String {get}
}

extension AppUtility {
	
	///Returns the build version
	var buildVersion: String {
		let dictionary = Bundle.main.infoDictionary!
		let buildVersion = dictionary["CFBundleVersion"] as! String
		return buildVersion
	}
}
