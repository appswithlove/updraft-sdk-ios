//
//  UpdraftTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class UpdraftTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testAppKeyOnStartUpdraft() {
		//Given
		let appKey = "123456789"
		let updraft = Updraft()
		
		//When
		updraft.start(with: appKey)
		
		//Then
		XCTAssertEqual(appKey, updraft.appKey)
		XCTAssertNotEqual("", updraft.appKey)
	}
	
	func testStartAutoUpdateManagerOnUpdraftStart() {
		
		//Given
		let spy = AutoUpdateManagerSpy()
		let updraft = Updraft(autoUpdateManager: spy)
		
		//When
		updraft.start(with: "")
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}
	
	func testClearConfig() {
		//Given
		let appKey = "123456789"
		let updraft = Updraft()
		updraft.start(with: appKey)
		
		//When
		updraft.clear()
		
		//Then
		XCTAssertEqual(updraft.appKey, "")
		XCTAssertNotEqual(updraft.appKey, appKey)
	}
}
