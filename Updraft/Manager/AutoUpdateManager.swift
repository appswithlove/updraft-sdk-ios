//
//  AutoUpdateManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Handle the autoupdate process.
class AutoUpdateManager {
	
	private(set) var didBecomeActiveObserver: NSObjectProtocol?
	var autoUpdateRestInteractor: AutoUpdateRestInteractorInput
	var autoUpdateDownloadInteractor: AutoUpdateDownloadInteractorInput
	
	// MARK: Lifecycle
	
	init(autoUpdateRestInteractor: AutoUpdateRestInteractor, autoUpdateDownloadInteractor: AutoUpdateDownloadInteractor) {
		self.autoUpdateRestInteractor = autoUpdateRestInteractor
		self.autoUpdateDownloadInteractor = autoUpdateDownloadInteractor
		autoUpdateRestInteractor.output = self
		autoUpdateDownloadInteractor.output = self
	}
	
	convenience init() {
		let autoUpdateRepository = AutoUpdateNetworkService()
		let autoUpdateRestInteractor = AutoUpdateRestInteractor(repository: autoUpdateRepository)
		let autoUpdateDownloadInteractor = AutoUpdateDownloadInteractor()
		self.init(autoUpdateRestInteractor: autoUpdateRestInteractor, autoUpdateDownloadInteractor: autoUpdateDownloadInteractor)
	}
	
	deinit {
		if let obs = didBecomeActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	// MARK: Implementation
	
	func start() {
		self.subscribeToAppDidBecomeActive()
	}
	
	func subscribeToAppDidBecomeActive() {
		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.checkUpdate()
		})
	}
	
	func checkUpdate() {
		autoUpdateRestInteractor.checkUpdate()
	}
	
	func redirectUserForUpdate(to url: URL) {
		autoUpdateDownloadInteractor.redirectUserForDownload(to: url)
	}
}

// MARK: - AutoUpdateRestInteractorOutput

extension AutoUpdateManager: AutoUpdateRestInteractorOutput {
	func autoUpdateRestInteractor(_ sender: AutoUpdateRestInteractor, newUpdateAvailableAt url: URL) {
		redirectUserForUpdate(to: url)
	}
}

// MARK: - AutoUpdateDownloadInteractorOutput

extension AutoUpdateManager: AutoUpdateDownloadInteractorOutput {
	func autoUpdateDownloadInteractor(_ sender: AutoUpdateDownloadInteractor, url: URL, didOpen: Bool) {
		
	}
}
