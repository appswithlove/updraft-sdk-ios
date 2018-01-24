//
//  AutoUpdateManagerTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import XCTest
@testable import Updraft

class AutoUpdateManagerTests: XCTestCase {
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testSubscribeToAppDidBecomeActiveOnStart() {
		//Given
		let spy = AutoUpdateManagerSpy()
		
		//When
		spy.start()
		
		//Then
		XCTAssertTrue(spy.subscribeToAppDidBecomeActiveWasCalled)
	}
	
	func testObserveDidBecomeActiveNotification() {
		//Given
		let manager = AutoUpdateManager()
		
		//When
		manager.subscribeToAppDidBecomeActive()
		
		//Then
		XCTAssertNotNil(manager.didBecomeActiveObserver)
	}
	
	func testCheckAutoUpdateIsCalledWhenDidBecomeActiveNotificationIsReceived() {
		
		//Given
		let manager = AutoUpdateManagerSpy()
		manager.subscribeToAppDidBecomeActive()
		let didBecomeActiveNotificationName = Notification.Name.UIApplicationDidBecomeActive
		
		//When
		NotificationCenter.default.post(name: didBecomeActiveNotificationName, object: nil)
		
		//Then
		XCTAssertTrue(manager.checkUpdateWasCalled, "checkAutoUpdate method called")
	}
	
	func testCheckUpdateIsCalledWhenAutoUpdateIsCalled() {
		//Given
		let spy = AutoUpdateRestInteractorInputSpy()
		let manager = AutoUpdateManager()
		manager.autoUpdateRestInteractor = spy
		
		//When
		manager.checkUpdate()
		
		//Then
		XCTAssertTrue(spy.checkUpdateWasCalled, "checkUpdateWasCalled")
	}
	
	func testRedirectUserToUrl() {
		//Given
		let spy = AutoUpdateDownloadInteractorInputSpy()
		let manager = AutoUpdateManager()
		manager.autoUpdateDownloadInteractor = spy
		let dumURL = URL(string: "www.apple.ch")!
		
		//When
		manager.redirectUserForUpdate(to: dumURL)
		
		//Then
		XCTAssertTrue(spy.redirectUserForDownloadWasCalled, "Redirect user for download was called")
	}
}
