//
//  FeedbackViewControllerTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class FeedbackViewControllerTests: XCTestCase {
	
	func testSetupAndUpdateAreCalledWhenViewDidLoad() {
		//Given
		let spy = FeedbackViewControllerSpy(state: .edit(UIImage(), email: nil))
		
		//When
		_ = spy.view //Triggers viewDidLoad
		
		//Then
		XCTAssertTrue(spy.setupWasCalled)
		XCTAssertTrue(spy.updateWasCalled)
	}
	
	func testDidCancelDelegateIsCalledWhenCancelButtonIsTapped() {
		//Given
		let spy = FeedbackPresenterSpy()
		let feedbackViewController = FeedbackViewController(state: .edit(UIImage(), email: nil))
		feedbackViewController.delegate = spy
		
		//When
		feedbackViewController.cancel(UIButton())
		
		//Then
		XCTAssertTrue(spy.cancelWasTappedWasCalled)
	}
	
	func testDidSendDelegateIsCalledWhenSendButonIsTapped() {
		//Given
		let spy = FeedbackPresenterSpy()
		let feedbackViewController = FeedbackViewController(state: .edit(UIImage(), email: nil))
		feedbackViewController.delegate = spy
		
		//When
		feedbackViewController.send(UIButton())
		
		//Then
		XCTAssertTrue(spy.sendWasTappedWasCalled)
	}
    
}
