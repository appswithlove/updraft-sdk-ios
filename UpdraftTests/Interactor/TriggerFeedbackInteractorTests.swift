//
//  TriggerFeedbackInteractorTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 04.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
import CoreMotion
@testable import Updraft

class TriggerFeedbackInteractorTests: XCTestCase {
	
	func testObserveUserDidTakeScreenshotIsCalledOnStart() {
		//Given
		let spy = TriggerFeedbackInteractorSpy()
		
		//When
		spy.start()
		
		//Then
		XCTAssertTrue(spy.observeUserDidTakeScreenshotWasCalled, "ObserveUserDidTakeScreenshot was not called on start")
	}
	
	func testDetectShakeIsCalledOnStart() {
		//Given
		let spy = TriggerFeedbackInteractorSpy()
		
		//When
		spy.start()
		
		//Then
		XCTAssertTrue(spy.detectShakeWasCalled, "DetectShake was not called on start")
	}
	
	func testObserveUserDidTakeScreenshot() {
		
		//Given
		let spy = TriggerFeedbackInteractor()
		
		//When
		spy.observeUserDidTakeScreenshot()
		
		//Then
		XCTAssertNotNil(spy.screenshotObserver)
	}
}
