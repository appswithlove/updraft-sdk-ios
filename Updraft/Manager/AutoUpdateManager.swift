//
//  AutoUpdateManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import Foundation

class AutoUpdateManager {
	private(set) var appKey: String
	
	var didBecomeActiveObserver: NSObjectProtocol?
	
	init(appKey: String) {
		self.appKey = appKey
		self.subscribeToAppDidBecomeActive()
	}
	
	deinit {
		if let obs = didBecomeActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	func subscribeToAppDidBecomeActive() {
		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil, using: { [weak self] (notification) in
			self?.checkAutoUpdate()
		})
	}
	
	func checkAutoUpdate() {
		//TODO: Use an interactor to check with backend when a new version is available, display a popup when available and redirect user to the recieved url when he presses "Ok". Always/never forced ?
	}
}
