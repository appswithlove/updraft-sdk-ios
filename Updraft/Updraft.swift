//
//  Updraft.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

final public class Updraft: NSObject {
	
	private(set) var settings: Settings
	private(set) var apiSessionManager: ApiSessionManager
	private(set) var autoUpdateManager: AutoUpdateManager
	private(set) var feedbackManager: FeedbackManager
	private(set) var loadFontsInteractor: LoadFontsInteractor
	
	init(
		loadFontsInteractor: LoadFontsInteractor,
		autoUpdateManager: AutoUpdateManager,
		apiSessionManager: ApiSessionManager,
		feedbackManager: FeedbackManager,
		settings: Settings) {
		
		self.settings = settings
		self.apiSessionManager = apiSessionManager
		self.autoUpdateManager = autoUpdateManager
		self.feedbackManager = feedbackManager
		self.loadFontsInteractor = loadFontsInteractor
	}
	
	convenience override init() {
		let settings = Settings()
		let apiManager = ApiSessionManager()
		
		let checkUpdateRequest = CheckUpdateRequest(session: apiManager.session)
		let getUpdateUrlRequest = UpdateUrlRequest(session: apiManager.session)
		let sendFeedbackRequest = SendFeedbackRequest()
		let sendFeedbackInteractor = SendFeedbackInteractor(settings: settings, sendFeedbackRequest: sendFeedbackRequest)
		let feedbackPresenter = FeedbackPresenter(sendFeedbackInteractor: sendFeedbackInteractor)
		let checkUpdateInteractor = CheckUpdateInteractor(settings: settings, checkUpdateRequest: checkUpdateRequest, getUpdateUrlRequest: getUpdateUrlRequest)
		let loadFontsInteractor = LoadFontsInteractor()
		
		let feedbackManager = FeedbackManager(feedbackPresenter: feedbackPresenter)
		let autoUpdateManager = AutoUpdateManager(checkUpdateInteractor: checkUpdateInteractor, settings: settings)
		self.init(loadFontsInteractor: loadFontsInteractor, autoUpdateManager: autoUpdateManager, apiSessionManager: apiManager, feedbackManager: feedbackManager, settings: settings)
	}
	
	private static let sharedInstance = Updraft()
	
	/// Returns the shared Updraft instance.
	@objc open class var shared: Updraft {
		return sharedInstance
	}
	
	/// Starts Updraft with your sdkKey and appKey.
	/// This method should be called after the app is launched and before using Updraft services.
	///
	///
	/// - Parameter appKey: Your application key
	/// - Parameter sdkKey: Your updraft sdk key
	@objc public func start(sdkKey: String, appKey: String) {
		settings.sdkKey = sdkKey
		settings.appKey = appKey
		loadFontsInteractor.loadAll()
		autoUpdateManager.start()
		feedbackManager.start()
	}
}
