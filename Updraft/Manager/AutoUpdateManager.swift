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
	var checkUpdateInteractor: CheckUpdateInteractorInput
	var downloadUpdateInteractor: DownloadUpdateInteractorInput
	
	// MARK: Lifecycle
	
	init(checkUpdateInteractor: CheckUpdateInteractor, downloadUpdateInteractor: DownloadUpdateInteractor) {
		self.checkUpdateInteractor = checkUpdateInteractor
		self.downloadUpdateInteractor = downloadUpdateInteractor
		checkUpdateInteractor.output = self
		downloadUpdateInteractor.output = self
	}
	
	convenience init() {
		let checkUpdateInteractor = CheckUpdateInteractor()
		let updateDownloadInteractor = DownloadUpdateInteractor()
		self.init(checkUpdateInteractor: checkUpdateInteractor, downloadUpdateInteractor: updateDownloadInteractor)
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
		checkUpdateInteractor.checkUpdate()
	}
	
	func redirectUserForUpdate(to url: URL) {
		downloadUpdateInteractor.redirectUserForDownload(to: url)
	}
}

// MARK: - CheckUpdateInteractorOutput

extension AutoUpdateManager: CheckUpdateInteractorOutput {
	func checkUpdateInteractor(_ sender: CheckUpdateInteractor, newUpdateAvailableAt url: URL) {
		redirectUserForUpdate(to: url)
	}
}

// MARK: - DownloadUpdateInteractorOutput

extension AutoUpdateManager: DownloadUpdateInteractorOutput {
	func downloadUpdateInteractor(_ sender: DownloadUpdateInteractor, url: URL, didOpen: Bool) {
		
	}
}
