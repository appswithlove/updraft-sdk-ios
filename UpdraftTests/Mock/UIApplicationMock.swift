//
//  UIApplicationMock.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

struct MockUIApplication: URLOpener {
	
	var canOpen: Bool
	
	func canOpenURL(_ url: URL) -> Bool {
		return canOpen
	}
	
	func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Void)?) {
		if canOpen {
			completion?(true)
		}
	}
}
