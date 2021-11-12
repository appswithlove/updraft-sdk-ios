//
//  CheckUpdateRequestTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class CheckUpdateRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessCheckUpdateModel() {
		// Given
		let sessionSpy = NetworkSessionSpy()
		
		let jsonString =
		"""
		{
		"create_at": "2018-03-07T13:41:04.699669Z",
		"whats_new": "Bugfixes",
		"version": "1.5",
		"your_version": "1.4",
		"is_new_version": true,
		"is_autoupdate_enabled": true
		}
		"""
		
		sessionSpy.data = jsonString.data(using: .utf8)!
		sessionSpy.response = HTTPURLResponse(url: URL(fileURLWithPath: "url"), statusCode: 200, httpVersion: nil, headerFields: nil)
		sessionSpy.error = nil
		
		let sut = CheckUpdateRequest(session: sessionSpy)
		
		// When
		sut.load(with: .checkUpdate(params: nil)) { (result) in
			switch result {
			case .success(let model):
				// Then
				XCTAssertEqual("2018-03-07T13:41:04.699669Z", model.lastBuildDate)
				XCTAssertEqual("Bugfixes", model.releaseNotes)
				XCTAssertEqual("1.5", model.updraftVersion)
				XCTAssertEqual("1.4", model.onDeviceVersion)
				XCTAssertEqual(true, model.isNewVersionAvailable)
				XCTAssertEqual(true, model.isAutoUpdateEnabled)
			default:
				XCTAssertTrue(false, "error")
			}
		}
    }
}
