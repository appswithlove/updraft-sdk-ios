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
	
	func testPresentFeedbackIsCalledWhenDidTakeScreenshotDelegateIsCalled() {
		//Given
		let spy = FeedbackPresenterSpy()
		let dumImage = UIImage()
		let takeScreenshotInteractor = TakeScreenshotInteractor()
		let manager = FeedbackManager(takeScreenshotInteractor: takeScreenshotInteractor, feedbackPresenter: spy)
		takeScreenshotInteractor.output = manager
		
		//When
		takeScreenshotInteractor.output?.takeScreenshotInteractor(takeScreenshotInteractor, didTakeScreenshot: dumImage)
		
		//Then
		XCTAssertTrue(spy.presentWasCalled)
		XCTAssertEqual(dumImage, spy.imageToPresent)
	}
	
	func testTakeScreenshotIsCalledWhenUserDidTriggerScreenshotDelegateIsCalled() {
		//Given
		let spy = TakeScreenshotInteractorSpy()
		let triggerScreenshotInteractor = TriggerFeedbackInteractor()
		let manager = FeedbackManager(takeScreenshotInteractor: spy, triggerFeedbackInteractor: triggerScreenshotInteractor)
		triggerScreenshotInteractor.output = manager
		
		//when
		triggerScreenshotInteractor.output?.triggerFeedbackInteractor(triggerScreenshotInteractor, userDidTriggerFeedbackWith: .screenshot)
		
		//Then
		XCTAssertTrue(spy.takeScreenshotWasCalled)
	}
}
