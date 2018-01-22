//
//  AutoUpdateManagerTests.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 22.01.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
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
	
	func testInitialization() {
		//Given
		let appKey = "123456789"
		
		//When
		let autoUpdateManager = AutoUpdateManager(appKey: appKey)
		
		//Then
		XCTAssertEqual(autoUpdateManager.appKey, appKey)
		XCTAssertNotEqual(autoUpdateManager.appKey, "")
	}
	
	func testSubscribesToDidBecomeActiveNotificationOnInit() {
		//Spy
		class AutoUpdateManagerSpy: AutoUpdateManager {
			var subscribeToAppDidBecomeActiveWasCalled = false
			
			override func subscribeToAppDidBecomeActive() {
				subscribeToAppDidBecomeActiveWasCalled = true
			}
		}
		
		//Given
		
		//When
		let manager = AutoUpdateManagerSpy(appKey: "")
		
		//Then
		XCTAssertTrue(manager.subscribeToAppDidBecomeActiveWasCalled, "subscribe method called")
	}
	
	func testObserveDidBecomeActiveNotification() {
		//Given
		let manager = AutoUpdateManager(appKey: "")
		
		//When
		manager.subscribeToAppDidBecomeActive()
		
		//Then
		XCTAssertNotNil(manager.didBecomeActiveObserver)
	}
	
	func testCheckAutoUpdateIsCalledWhenDidBecomeActiveNotificationIsReceived() {
		//Spy
		class AutoUpdateManagerSpy: AutoUpdateManager {
			var checkAutoUpdateWasCalled = false
			
			override func checkAutoUpdate() {
				checkAutoUpdateWasCalled = true
			}
		}
		
		//Given
		let manager = AutoUpdateManagerSpy(appKey: "")
		manager.subscribeToAppDidBecomeActive()
		let didBecomeActiveNotificationName = Notification.Name.UIApplicationDidBecomeActive
		
		//When
		NotificationCenter.default.post(name: didBecomeActiveNotificationName, object: nil)
		
		//Then
		XCTAssertTrue(manager.checkAutoUpdateWasCalled, "checkAutoUpdate method called")
	}
}
