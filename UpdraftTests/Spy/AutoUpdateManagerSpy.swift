//
//  AutoUpdateManagerSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class AutoUpdateManagerSpy: AutoUpdateManager {
	var startWasCalled = false
	var subscribeToAppDidBecomeActiveWasCalled = false
	var subscriveToAppWillResignActiveWasCalled = false
	var informUserOfNewVersionAvailablewasCalled = false
	var checkUpdateWasCalled = false
	var redirectUserForUpdateWasCalled = false

	override func start() {
		super.start()
		startWasCalled = true
	}
	
	override func subscribeToAppDidBecomeActive() {
		super.subscribeToAppDidBecomeActive()
		subscribeToAppDidBecomeActiveWasCalled = true
	}
	
	override func subscribeToAppWillResignActive() {
		super.subscribeToAppWillResignActive()
		subscriveToAppWillResignActiveWasCalled = true
	}
	
	override func checkUpdate() {
		checkUpdateWasCalled = true
	}
	
	override func informUserOfNewVersionAvailable() {
		informUserOfNewVersionAvailablewasCalled = true
	}
	
	override func redirectUserForUpdate(to url: URL) {
		redirectUserForUpdateWasCalled = true
	}
}
