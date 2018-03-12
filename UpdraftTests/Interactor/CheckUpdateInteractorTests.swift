//
//  AutoUpdateInteractorTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class CheckUpdateInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testNewUpdateUrl() {
		//Given
		let interactor = CheckUpdateInteractor()
		let spy = CheckUpdateInteractorOutputSpy()
		interactor.output = spy
		
		let stubUrl = URL(string: "www.apple.ch")!
	
		//When
		interactor.output?.checkUpdateInteractor(interactor, newUpdateAvailableAt: stubUrl)
		
		//Then
		XCTAssertTrue(spy.checkUpdateInteractorWasCalled)
	}
}
