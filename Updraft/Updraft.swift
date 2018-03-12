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
		autoUpdateManager: AutoUpdateManager,
		apiSessionManager: ApiSessionManager,
		settings: Settings) {
		
		self.settings = settings
		self.apiSessionManager = apiSessionManager
		self.autoUpdateManager = autoUpdateManager
	}
	
	convenience init() {
		let settings = Settings()
		let apiManager = ApiSessionManager()
		
		let checkUpdateRequest = CheckUpdateRequest(session: apiManager.session)
		let getUpdateUrlRequest = UpdateUrlRequest(session: apiManager.session)
		let checkUpdateInteractor = CheckUpdateInteractor(settings: settings, checkUpdateRequest: checkUpdateRequest, getUpdateUrlRequest: getUpdateUrlRequest)
		
		let autoUpdateManager = AutoUpdateManager(checkUpdateInteractor: checkUpdateInteractor, settings: settings)
		self.init(autoUpdateManager: autoUpdateManager, apiSessionManager: apiManager, settings: settings)
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
