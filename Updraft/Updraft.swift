//
//  Updraft.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

public class Updraft {
	
	init(autoUpdateManager: AutoUpdateManager) {
		self.autoUpdateManager = autoUpdateManager
	}
	
	convenience init() {
		self.init(autoUpdateManager: AutoUpdateManager())
	}
	
	private static let sharedInstance = Updraft()
	
	private(set) var appKey = ""
	private(set) var autoUpdateManager: AutoUpdateManager
	
	/// Returns the shared Updraft instance.
	open class var shared: Updraft {
		return sharedInstance
	}
	
	/// Clears Updraft configs
	public func clear() {
		appKey = ""
	}
	
	/// Starts Updraft with your appKey.
	/// This method should be called after the app is launched and before using Updraft services.
	///
	/// - Parameter appKey: Your application key
	public func start(with appKey: String) {
		self.appKey = appKey
		autoUpdateManager.start()
	}
}
