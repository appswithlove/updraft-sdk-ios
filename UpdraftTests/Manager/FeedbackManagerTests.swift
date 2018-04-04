//
//  FeedbackManagerTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 04.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class FeedbackManagerTests: XCTestCase {
	
	func testOutputAreSetOnInit() {
		//Given
		let takeScreenshotInteractor = TakeScreenshotInteractor()
		let triggerFeedackInteractor = TriggerFeedbackInteractor()
		
		//When
		let manager = FeedbackManager(takeScreenshotInteractor: takeScreenshotInteractor, triggerFeedbackInteractor: triggerFeedackInteractor)
		
		//Then
		XCTAssertTrue(takeScreenshotInteractor.output === manager)
		XCTAssertTrue(triggerFeedackInteractor.output === manager)
	}
	
	func testTriggerFeedbackInteractorStartIsCalledWhenFeedbackManagerStart() {
		//Given
		let spy = TriggerFeedbackInteractorSpy()
		let feedbackManager = FeedbackManager(takeScreenshotInteractor: TakeScreenshotInteractor(), triggerFeedbackInteractor: spy)
		
		//When
		feedbackManager.start()
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}
}
