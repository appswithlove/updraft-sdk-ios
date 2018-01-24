//
//  AutoUpdateInteractorTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class AutoUpdateRestInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testInitialization() {
		//Given
		let repository = AutoUpdateRepository()
		
		//When
		let interactor = AutoUpdateRestInteractor(repository: repository)
		
		//Then
		XCTAssertNotNil(interactor.repository)
	}
	
	func testNewUpdateUrl() {
		//Given
		let repository = AutoUpdateRepository()
		let interactor = AutoUpdateRestInteractor(repository: repository)
		let spy = AutoUpdateRestInteractorOutputSpy()
		interactor.output = spy
		
		let stubUrl = URL(string: "www.apple.ch")!
	
		//When
		interactor.output?.autoUpdateRestInteractor(interactor, newUpdateAvailableAt: stubUrl)
		
		//Then
		XCTAssertTrue(spy.autoUpdateRestInteractorWasCalled)
	}
	
}
