//
//  AutoUpdateManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Handle the autoupdate process.
final class AutoUpdateManager {
	
	private(set) var didBecomeActiveObserver: NSObjectProtocol?
	private(set) var willResignActiveObserver: NSObjectProtocol?
	var updateTimer: Timer?
	var checkUpdateInteractor: CheckUpdateInteractorInput
	var downloadUpdateInteractor: DownloadUpdateInteractorInput
	var displayAlertInteractor: DisplayAlertInteractorInput
	var settings: Settings
	
	var updateUrl: URL?
	
	// MARK: Lifecycle
	
	init(
		checkUpdateInteractor: CheckUpdateInteractor = CheckUpdateInteractor(),
		downloadUpdateInteractor: DownloadUpdateInteractor = DownloadUpdateInteractor(),
		displayAlertInteractor: DisplayAlertInteractor = DisplayAlertInteractor(),
		settings: Settings = Settings()) {
		
		self.checkUpdateInteractor = checkUpdateInteractor
		self.downloadUpdateInteractor = downloadUpdateInteractor
		self.displayAlertInteractor = displayAlertInteractor
		self.settings = settings
		checkUpdateInteractor.output = self
		downloadUpdateInteractor.output = self
		displayAlertInteractor.output = self
	}
	
	deinit {
		if let obs = didBecomeActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
		if let obs = willResignActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	// MARK: Implementation
	
	func start() {
		self.subscribeToAppDidBecomeActive()
		self.subscribeToAppWillResignActive()
	}
	
	func subscribeToAppDidBecomeActive() {
		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.updateTimer?.invalidate()
			//Wait a few seconds to check update
			//to allow main app to set root view (eg. after splash screen)
			self?.updateTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (_) in
				self?.checkUpdate()
			}
		})
	}
	
	func subscribeToAppWillResignActive() {
		willResignActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.clearMessages()
		})
	}
	
	func clearMessages() {
		self.displayAlertInteractor.clearMessages()
	}
	
	func checkUpdate() {
		self.checkUpdateInteractor.checkUpdate()
	}
	
	func redirectUserForUpdate(to url: URL) {
		downloadUpdateInteractor.redirectUserForDownload(to: url)
	}
	
	func informUserOfNewVersionAvailable() {
		displayAlertInteractor.displayAlert(with: "You will be redirected to download the new version", title: "New version available")
	}
}

// MARK: - CheckUpdateInteractorOutput

extension AutoUpdateManager: CheckUpdateInteractorOutput {
	func checkUpdateInteractor(_ sender: CheckUpdateInteractor, newUpdateAvailableAt url: URL) {
		updateUrl = url
		informUserOfNewVersionAvailable()
	}
}

// MARK: - DownloadUpdateInteractorOutput

extension AutoUpdateManager: DownloadUpdateInteractorOutput {
	func downloadUpdateInteractor(_ sender: DownloadUpdateInteractor, url: URL, didOpen: Bool) {
		print("UPDRAFT: Did open url to download new version at: \(url).")
	}
}

// MARK: - DisplayAlertInteractorOutput

extension AutoUpdateManager: DisplayAlertInteractorOuput {
	func displayAlertInteractorUserDidAcknowledgeAlert(_ sender: DisplayAlertInteractor) {
		guard let url = updateUrl else {return}
		redirectUserForUpdate(to: url)
	}
}
