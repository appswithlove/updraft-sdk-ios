//
//  TriggerFeedbackInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 04.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class TriggerFeedbackInteractorSpy: TriggerFeedbackInteractor {
	var startWasCalled = false
	var stopWasCalled = false
	var observeUserDidTakeScreenshotWasCalled = false
	
	override func start() {
		super.start()
		startWasCalled = true
	}
	
	override func stop() {
		super.stop()
		stopWasCalled = true
	}
	
	override func observeUserDidTakeScreenshot() {
		super.observeUserDidTakeScreenshot()
		observeUserDidTakeScreenshotWasCalled = true
	}
}
