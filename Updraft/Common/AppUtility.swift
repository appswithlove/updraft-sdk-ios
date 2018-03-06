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
	var topMostController: UIViewController? {get}
}

extension AppUtility {
	
	///Returns the build version
	var buildVersion: String {
		let dictionary = Bundle.main.infoDictionary!
		let buildVersion = dictionary["CFBundleVersion"] as! String
		return buildVersion
	}
	
	///Returns the topmost presented UIViewController
	var topMostController: UIViewController? {
		var topController = UIApplication.shared.keyWindow?.rootViewController
		while topController?.presentedViewController != nil {
			topController = topController?.presentedViewController
		}
		return topController
	}
}
