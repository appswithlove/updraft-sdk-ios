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
	var detectShakeWasCalled = false
	var observeUserDidTakeScreenshotWasCalled = false
	
	override func start() {
		super.start()
		startWasCalled = true
	}
	
	override func detectShake() {
		super.detectShake()
		detectShakeWasCalled = true
	}
	
	override func observeUserDidTakeScreenshot() {
		super.observeUserDidTakeScreenshot()
		observeUserDidTakeScreenshotWasCalled = true
	}
}
