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
	
	func testShakeIsDetectedWhenThresoldIsReached() {
		//Given
		let thresold: Double = 2.0
		let acceleration = CMAcceleration(x: 2.1, y: 1.5, z: 1.3)
		let triggerFeedbackInteractor = TriggerFeedbackInteractor()
		
		//When
		let isDetected = triggerFeedbackInteractor.isShakeDetected(acceleration: acceleration, thresold: thresold)
		
		//Then
		XCTAssertTrue(isDetected)
	}
	
	func testShakeIsNotDetectedWhenThresoldIsNotReached() {
		//Given
		let thresold: Double = 2.0
		let acceleration = CMAcceleration(x: 0.1, y: 1.5, z: 1.3)
		let triggerFeedbackInteractor = TriggerFeedbackInteractor()
		
		//When
		let isDetected = triggerFeedbackInteractor.isShakeDetected(acceleration: acceleration, thresold: thresold)
		
		//Then
		XCTAssertFalse(isDetected)
	}
	
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
