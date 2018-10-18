//
//  NetworkRequestTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class NetworkRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuccessfulResponse() {
		//Given
		
		let sessionSpy = NetworkSessionSpy()
		
		let jsonString =
		"""
		{
		"identifier": 1
		}
		"""
		
		let stubURL = URL(fileURLWithPath: "url")
		
		sessionSpy.data = jsonString.data(using: .utf8)!
		sessionSpy.error = nil
		sessionSpy.response = HTTPURLResponse.init(url: stubURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		
		let sut = NetworkRequestSpy(session: sessionSpy)
		
		//When
		sut.load(URLRequest(url: stubURL)) { (result) in
			switch result {
			case .success(let model):
				//Then
				XCTAssertEqual(1, model.identifier)
			default:
				XCTAssertTrue(false, "Error")
			}
		}
		
    }
    
    func testInvalidResponse() {
		//Given
		
		let sessionSpy = NetworkSessionSpy()
		let stubURL = URL(fileURLWithPath: "url")
		
		sessionSpy.data = nil
		sessionSpy.error = nil
		sessionSpy.response = HTTPURLResponse.init(url: stubURL, statusCode: 400, httpVersion: nil, headerFields: nil)
		
		let sut = NetworkRequestSpy(session: sessionSpy)
		
		//When
		sut.load(URLRequest(url: stubURL)) { (result) in
			switch result {
			case .error:
				//Then
				XCTAssertTrue(true)
			default:
				XCTAssertTrue(false, "Error")
			}
		}
    }
	
	func testErrorResponse() {
		//Given
		
		let sessionSpy = NetworkSessionSpy()
		let stubURL = URL(fileURLWithPath: "url")
		
		sessionSpy.data = nil
		sessionSpy.error = NetworkError.invalidData
		sessionSpy.response = HTTPURLResponse.init(url: stubURL, statusCode: 200, httpVersion: nil, headerFields: nil)
		
		let sut = NetworkRequestSpy(session: sessionSpy)
		
		//When
		sut.load(URLRequest(url: stubURL)) { (result) in
			if case .error(let error as NetworkError) = result {
				if case .invalidData = error {
					//Then
					XCTAssertTrue(true)
				} else {
					XCTAssertTrue(false, "Error")
				}
			} else {
				XCTAssertTrue(false, "Error")
			}
		}
	}
}
