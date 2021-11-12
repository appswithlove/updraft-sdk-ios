//
//  UpdateUrlRequestTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class UpdateUrlRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testSuccessGetUpdateUrl() {
		// Given
		let sessionSpy = NetworkSessionSpy()
		
		let jsonString =
		"""
		{
		"update_url": "www.updraft.com"
		}
		"""
		
		sessionSpy.data = jsonString.data(using: .utf8)!
		sessionSpy.response = HTTPURLResponse(url: URL(fileURLWithPath: "url"), statusCode: 200, httpVersion: nil, headerFields: nil)
		sessionSpy.error = nil
		
		let sut = UpdateUrlRequest(session: sessionSpy)
		
		// When
		sut.load(with: .getUpdateUrl(params: nil)) { (result) in
			switch result {
			case .success(let model):
				// Then
				XCTAssertEqual("www.updraft.com", model.updateUrl)
			default:
				XCTAssertTrue(false, "error")
			}
		}
	}
    
}
