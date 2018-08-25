//
//  FeedbackPresenterTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class FeedbackPresenterTests: XCTestCase {
	
	func testOutputAreSetOnInit() {
		//Given
		let sendFeedbackInteractor = SendFeedbackInteractor()
		
		//When
		let presenter = FeedbackPresenter(sendFeedbackInteractor: sendFeedbackInteractor)
		
		//Then
		XCTAssertTrue(sendFeedbackInteractor.output === presenter)
	}
	
	func testFeedbackViewControllerIsInitiliazedWhenPresentItCalled() {
		//Given
		let feedbackPresenter = FeedbackPresenter()
		feedbackPresenter.feedbackViewController = nil
		
		//When
		feedbackPresenter.present(with: UIImage(), context: FeedbackContextModel(buildVersion: "", navigationStack: "", systemVersion: "", modelName: "", deviceUuid: ""))
		
		//Then
		XCTAssertTrue(feedbackPresenter.feedbackViewController != nil)
		XCTAssertTrue(feedbackPresenter.feedbackViewController?.delegate === feedbackPresenter)
	}
}
