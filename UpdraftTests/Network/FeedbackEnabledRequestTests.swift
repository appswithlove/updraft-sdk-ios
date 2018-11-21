//
//  FeedbackEnabledRequestTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class FeedbackEnabledRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testSuccessFeedbackEnabled() {
		//Given
		let sessionSpy = NetworkSessionSpy()
		
		let jsonString =
		"""
		{
		"is_feedback_enabled": true
		}
		"""
		
		sessionSpy.data = jsonString.data(using: .utf8)!
		sessionSpy.response = HTTPURLResponse(url: URL(fileURLWithPath: "url"), statusCode: 200, httpVersion: nil, headerFields: nil)
		sessionSpy.error = nil
		
		let sut = FeedbackEnabledRequest(session: sessionSpy)
		
		//When
		sut.load(with: .isEnabled(params: nil)) { (result) in
			switch result {
			case .success(let model):
				XCTAssertEqual(true, model.isFeedbackEnabled)
			default:
				XCTAssertTrue(false, "error")
			}
		}
	}
}
