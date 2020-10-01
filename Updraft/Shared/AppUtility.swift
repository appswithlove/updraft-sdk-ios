//
//  Utility.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
import UIKit

protocol AppUtility {
	var buildVersion: String {get}
	var topMostController: UIViewController? {get}
	var controllersStack: String {get}
	var systemVersion: String {get}
	var deviceUuid: String? {get}
	var modelName: String {get}
}

extension AppUtility {
	
	///Returns the build version
	var buildVersion: String {
		let dictionary = Bundle.main.infoDictionary
		guard let buildVersion = dictionary?["CFBundleVersion"] as? String else {
			return "No Build Version found"
		}
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
	
	///Returns the current controllers stack
	var controllersStack: String {
		var controllers = [String]()
		
		var pointedViewController = UIApplication.shared.keyWindow?.rootViewController
		
		while pointedViewController?.presentedViewController != nil {
			controllers += getShownControllers(for: pointedViewController)
			switch pointedViewController?.presentedViewController {
			case let navagationController as UINavigationController:
				pointedViewController = navagationController.viewControllers.last
			case let tabBarController as UITabBarController:
				pointedViewController = tabBarController.selectedViewController
			default:
				pointedViewController = pointedViewController?.presentedViewController
			}
		}
		
		if pointedViewController?.presentedViewController == nil {
			controllers += getShownControllers(for: pointedViewController)
		}

		return controllers.joined(separator: ", ")
	}
	
	private func getShownControllers(for viewController: UIViewController?) -> [String] {
		var controllers = [UIViewController?]()
		
		var shownController = viewController
		
		while shownController is UITabBarController || shownController is UINavigationController {
			controllers.append(shownController)
			switch shownController {
			case let navigationController as UINavigationController:
				if navigationController.children.count > 1 {
					navigationController.viewControllers.dropLast().forEach({controllers.append($0)})
				}
				shownController = navigationController.viewControllers.last
			case let tabBarController as UITabBarController:
				shownController = tabBarController.selectedViewController
			default:
				break
			}
		}
		
		if !(shownController is UITabBarController) && !(shownController is UINavigationController) {
			controllers.append(shownController)
		}
		return controllers.compactMap({$0}).map({String(describing: type(of: $0))})
	}
	
	/// Returns the system version of the device
	var systemVersion: String {
		return UIDevice.current.systemVersion
	}
	
	/// Returns the unique identifier for vendor
	var deviceUuid: String? {
		return UIDevice.current.identifierForVendor?.uuidString
	}
	
	/// Returns the model name , eg. iPhone X, iPad Pro 9.7 Inch
	var modelName: String {
		return UIDevice.current.modelName
	}
}
