//
//  UpdraftTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import XCTest
@testable import Updraft

class UpdraftTests: XCTestCase {
	
	var updraft: Updraft!
    
    override func setUp() {
        super.setUp()
		
        // Put setup code here. This method is called before the invocation of each test method in the class.
		updraft = Updraft.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		updraft.clear()
    }
	
	func testStartUpdraft() {
		//Given
		let appKey = "123456789"
		
		//When
		updraft.start(with: appKey)
		
		//Then
		XCTAssertEqual(appKey, updraft.appKey)
		XCTAssertNotNil(updraft.autoUpdateManager)
	}
	
	func testClearConfig() {
		//Given
		let appKey = "123456789"
		updraft.start(with: appKey)
		
		//When
		updraft.clear()
		
		//Then
		XCTAssertEqual(updraft.appKey, "")
	}
}
