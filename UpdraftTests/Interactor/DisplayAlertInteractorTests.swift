//
//  DisplayAlertInteractorTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 21.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class DisplayAlertInteractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
	
	func testShowAlert() {
		// Given
		let sut = DisplayAlertInteractorSpy()
		let title = "My Title"
		let message = "My Message"
		let okButtonTitle = "Ok Button"
		let hasCancelButton = true
		
		// When
		sut.displayAlert(with: message, title: title, okButtonTitle: okButtonTitle, cancelButton: hasCancelButton)
		
		// Then
		XCTAssertTrue(sut.wasShowAlertCalled)
		XCTAssertEqual(title, sut.shownAlert?.title)
		XCTAssertEqual(okButtonTitle, sut.shownAlert?.actions.last?.title)
		XCTAssertEqual(message, sut.shownAlert?.message)
	}
}
