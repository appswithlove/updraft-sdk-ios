//
//  DownloadUpdateInteractorTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class DownloadUpdateInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testCanOpenUrl() {
		// Given
		let canOpen = true
		let outputSpy = DownloadUpdateInteractorOutputSpy()
		let applicationSpy = UIApplicationSpy(canOpen: canOpen)
		let sut = DownloadUpdateInteractor(application: applicationSpy)
		sut.output = outputSpy
		let url = URL(string: "www.apple.ch")!
		
		// When
		sut.openUrl(url)
		
		// Then
		XCTAssertEqual(outputSpy.didOpen, canOpen)
		XCTAssertTrue(outputSpy.urlDidOpenWasCalled, "urlDidOpen was not called")
	}
}
