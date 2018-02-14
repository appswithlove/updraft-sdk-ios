//
//  UpdateModelTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 14.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class UpdateModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testInit() {
		//Given
		let updateUrl = "www.update.com"
		
		//When
		let sut = UpdateModel(updateUrl: updateUrl)
		
		//Then
		XCTAssertEqual(sut.updateUrl, updateUrl)
	}
}
