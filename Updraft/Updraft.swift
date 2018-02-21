//
//  Updraft.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

public class Updraft {
	
	private(set) var settings: Settings
	private(set) var apiSessionManager: ApiSessionManager
	private(set) var autoUpdateManager: AutoUpdateManager
	
	init(
        autoUpdateManager: AutoUpdateManager = AutoUpdateManager(),
        apiSessionManager: ApiSessionManager = ApiSessionManager(),
        settings: Settings = Settings() ) {
		
		self.settings = settings
		self.apiSessionManager = apiSessionManager
        let checkUpdateInteractor = CheckUpdateInteractor(apiSessionManager: apiSessionManager, settings: settings)
        self.autoUpdateManager = AutoUpdateManager(checkUpdateInteractor: checkUpdateInteractor, settings: settings)
	}
	
	private static let sharedInstance = Updraft()
	
	/// Returns the shared Updraft instance.
	open class var shared: Updraft {
		return sharedInstance
	}
	
	/// Starts Updraft with your sdkKey and appKey.
	/// This method should be called after the app is launched and before using Updraft services.
	///
	/// Features such as auto update are disabled when isAppStoreRelease is set to true.
	///
	/// - Parameter appKey: Your application key
	/// - Parameter sdkKey: Your updraft sdk key
	/// - Parameter isAppStoreRelease: Boolean indicating if the app will be released on the AppStore
	public func start(sdkKey: String, appKey: String, isAppStoreRelease: Bool) {
		settings.sdkKey = sdkKey
		settings.appKey = appKey
		settings.isAppStoreRelease = isAppStoreRelease
		if isAppStoreRelease == false {
			autoUpdateManager.start()
		}
	}
}
