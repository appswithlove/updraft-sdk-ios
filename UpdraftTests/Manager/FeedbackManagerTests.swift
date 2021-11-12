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
		// Given
		let takeScreenshotInteractor = TakeScreenshotInteractor()
		let triggerFeedackInteractor = TriggerFeedbackInteractor()
		let showFeedbackStatusInteractor = ShowFeedbackStatusInteractor()
		
		// When
		let manager = FeedbackManager(takeScreenshotInteractor: takeScreenshotInteractor, triggerFeedbackInteractor: triggerFeedackInteractor, showFeedbackStatusInteractor: showFeedbackStatusInteractor)
		
		// Then
		XCTAssertTrue(takeScreenshotInteractor.output === manager)
		XCTAssertTrue(triggerFeedackInteractor.output === manager)
		XCTAssertTrue(showFeedbackStatusInteractor.output === manager)
	}
	
	func testTriggerFeedbackInteractorStartIsCalledWhenFeedbackEnabled() {
		// Given
		let spy = TriggerFeedbackInteractorSpy()
		let feedbackManager = FeedbackManager(triggerFeedbackInteractor: spy)
		
		// When
		feedbackManager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: true)
		
		// Then
		XCTAssertTrue(spy.startWasCalled)
		XCTAssertTrue(spy.isActive)
	}
	
	func testTriggerFeedbackInteractorStopIsCalledWhenFeedbackDisabled() {
		// Given
		let spy = TriggerFeedbackInteractorSpy()
		let feedbackManager = FeedbackManager(triggerFeedbackInteractor: spy)
		spy.isActive = true
		
		// When
		feedbackManager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: false)
		
		// Then
		XCTAssertTrue(spy.stopWasCalled)
		XCTAssertTrue(!spy.isActive)
	}
	
	func testPresentFeedbackIsCalledWhenDidTakeScreenshotDelegateIsCalled() {
		// Given
		let spy = FeedbackPresenterSpy()
		let dumImage = UIImage()
		let takeScreenshotInteractor = TakeScreenshotInteractor()
		let manager = FeedbackManager(takeScreenshotInteractor: takeScreenshotInteractor, feedbackPresenter: spy)
		takeScreenshotInteractor.output = manager
		
		// When
		takeScreenshotInteractor.output?.takeScreenshotInteractor(takeScreenshotInteractor, didTakeScreenshot: dumImage)
		
		// Then
		XCTAssertTrue(spy.presentWasCalled)
		XCTAssertEqual(dumImage, spy.imageToPresent)
	}
	
	func testTakeScreenshotIsCalledWhenUserDidTriggerScreenshotDelegateIsCalled() {
		// Given
		let spy = TakeScreenshotInteractorSpy()
		let triggerScreenshotInteractor = TriggerFeedbackInteractor()
		let manager = FeedbackManager(takeScreenshotInteractor: spy, triggerFeedbackInteractor: triggerScreenshotInteractor)
		triggerScreenshotInteractor.output = manager
		
		// when
		triggerScreenshotInteractor.output?.triggerFeedbackInteractorUserDidTakeScreenshot(triggerScreenshotInteractor)
		
		// Then
		XCTAssertTrue(spy.takeScreenshotWasCalled)
	}
	
	func testShowEnabledStatusWhenLastShownDisabled() {
		// Given
		let spy = ShowFeedbackStatusInteractorSpy()
		let manager = FeedbackManager(showFeedbackStatusInteractor: spy)
		spy.lastShownStatus = .disabled
		
		// When
		manager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: true)
		
		// Then
		XCTAssertEqual(spy.showWasCalled, true)
		XCTAssertEqual(ShowFeedbackStatusInteractor.FeedbackStatusType.enabled, spy.showForStatus)
	}
	
	func testShowDisabledStatusWhenLastShownEnaled() {
		// Given
		let spy = ShowFeedbackStatusInteractorSpy()
		let manager = FeedbackManager(showFeedbackStatusInteractor: spy)
		spy.lastShown = .enabled
		
		// When
		manager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: false)
		
		// Then
		XCTAssertEqual(spy.showWasCalled, true)
		XCTAssertEqual(ShowFeedbackStatusInteractor.FeedbackStatusType.disabled, spy.showForStatus)
	}
	
	func testShowEnabledStatusWhenLastShownNil() {
		// Given
		let spy = ShowFeedbackStatusInteractorSpy()
		let manager = FeedbackManager(showFeedbackStatusInteractor: spy)
		spy.lastShown =  nil
		
		// When
		manager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: true)
		
		// Then
		XCTAssertEqual(spy.showWasCalled, true)
		XCTAssertEqual(ShowFeedbackStatusInteractor.FeedbackStatusType.enabled, spy.showForStatus)
	}
	
	func testDontShowDisabledStatusWhenLastShownNil() {
		// Given
		let spy = ShowFeedbackStatusInteractorSpy()
		let manager = FeedbackManager(showFeedbackStatusInteractor: spy)
		spy.lastShown =  nil
		
		// When
		manager.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: false)
		
		// Then
		XCTAssertEqual(spy.showWasCalled, false)
	}
	
	func testDontShowStatusIdentical() {
		// Given
		let spy1 = ShowFeedbackStatusInteractorSpy()
		let manager1 = FeedbackManager(showFeedbackStatusInteractor: spy1)
		spy1.lastShown = .enabled
		
		let spy2 = ShowFeedbackStatusInteractorSpy()
		let manager2 = FeedbackManager(showFeedbackStatusInteractor: spy2)
		spy2.lastShown = .disabled
		
		// When
		manager1.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: true)
		manager2.checkFeedbackEnabled(CheckFeedbackEnabledInteractor(), isEnabled: false)
		
		// Then
		XCTAssertFalse(spy1.showWasCalled)
		XCTAssertFalse(spy2.showWasCalled)
	}
	
	func testCheckIfEnabledWasCalledWhenUserDidTakeScreenshot() {
		// Given
		let spy = CheckFeedbackEnabledInteractorSpy()
		let manager = FeedbackManager(checkFeedbackEnabledInteractor: spy)
		
		// When
		manager.takeScreenshotInteractor(TakeScreenshotInteractor(), didTakeScreenshot: UIImage())
		
		// Then
		XCTAssertTrue(spy.checkIfEnabledWasCalled)
	}
	
	func testDismissWasCalledWhenUserDidConfirmAlertAndFeedbackIsVisibleAndStatusIsDisabled() {
		// Given
		let spy = FeedbackPresenterSpy()
		spy.visible = true
		let manager = FeedbackManager(feedbackPresenter: spy)
		
		// When
		manager.showFeedbackStatusInteractorUserDidConfirm(ShowFeedbackStatusInteractor(), statusType: .disabled)
		
		// Then
		XCTAssertTrue(spy.dismissWasCalled)
	}
}
