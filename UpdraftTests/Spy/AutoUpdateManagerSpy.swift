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
	var checkUpdateWasCalled = false
	
	override func start() {
		super.start()
		startWasCalled = true
	}
	
	override func subscribeToAppDidBecomeActive() {
		super.subscribeToAppDidBecomeActive()
		subscribeToAppDidBecomeActiveWasCalled = true
	}
	
	override func checkUpdate() {
		super.checkUpdate()
		checkUpdateWasCalled = true
	}
}
