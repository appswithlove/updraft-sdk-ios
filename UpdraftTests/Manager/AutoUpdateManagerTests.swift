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
	
	func testOutputAreSetOnInit() {
		//Given
		let downloadUpdateInteractor = DownloadUpdateInteractor()
		let checkUpdateInteractor = CheckUpdateInteractor()
		let displayAlertInteractor = DisplayAlertInteractor()
		let settings = Settings()
		
		//When
		let manager = AutoUpdateManager(checkUpdateInteractor: checkUpdateInteractor, downloadUpdateInteractor: downloadUpdateInteractor, displayAlertInteractor: displayAlertInteractor, settings: settings)
		
		//Then
		XCTAssertTrue(downloadUpdateInteractor.output === manager)
		XCTAssertTrue(checkUpdateInteractor.output === manager)
		XCTAssertTrue(displayAlertInteractor.output === manager)
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
	
	func testInformUserIsCalledAndUrlSetWhenNewUpdateUrlAvailable() {
		//Given
		let checkUpdateInteractor = CheckUpdateInteractor()
		let spy = AutoUpdateManagerSpy(checkUpdateInteractor: checkUpdateInteractor)
		let stubUrl = URL(fileURLWithPath: "123")
		
		//When
		checkUpdateInteractor.output?.checkUpdateInteractor(checkUpdateInteractor, newUpdateAvailableAt: stubUrl)
		
		//Then
		XCTAssertEqual(spy.updateUrl, stubUrl)
		XCTAssertTrue(spy.informUserOfNewVersionAvailablewasCalled)
	}
	
	func testRedirectUserIsCalledWhenUserAcknowledgedAlert() {
		//Given
		let displayAlertInteractor = DisplayAlertInteractor()
		let manager = AutoUpdateManagerSpy(displayAlertInteractor: displayAlertInteractor)
		manager.updateUrl = URL(fileURLWithPath: "123")
		
		//When
		displayAlertInteractor.output?.displayAlertInteractorUserDidAcknowledgeAlert(displayAlertInteractor)
		
		//Then
		XCTAssertTrue(manager.redirectUserForUpdateWasCalled)
	}
	
	func testCheckUpdateIsCalledWhenDidBecomeActiveNotificationIsReceived() {
		
		//Given
		let manager = AutoUpdateManagerSpy()
		manager.subscribeToAppDidBecomeActive()
		let didBecomeActiveNotificationName = Notification.Name.UIApplicationDidBecomeActive
		
		//When
		NotificationCenter.default.post(name: didBecomeActiveNotificationName, object: nil)
		
		//Then
		XCTAssertTrue(manager.checkUpdateWasCalled, "checkUpdate not called")
	}
	
	func testCheckUpdateIsCalledWhenUpdateIsCalled() {
		//Given
		let spy = CheckUpdateInteractorInputSpy()
		let manager = AutoUpdateManager()
		manager.checkUpdateInteractor = spy
		
		//When
		manager.checkUpdate()
		
		//Then
		XCTAssertTrue(spy.checkUpdateWasCalled, "checkUpdate not called")
	}
	
	func testDisplayAlertIsCalledWhenInformUserOfNewVersionAvailableIsCalled() {
		//Given
		let spy = DisplayAlertInteractorInputSpy()
		let manager = AutoUpdateManager()
		manager.displayAlertInteractor = spy
		
		//When
		manager.informUserOfNewVersionAvailable()
		
		//Then
		XCTAssertTrue(spy.displayAlertWasCalled)
	}
	
	func testRedirectUserToUrl() {
		//Given
		let spy = DownloadUpdateInteractorInputSpy()
		let manager = AutoUpdateManager()
		manager.downloadUpdateInteractor = spy
		let dumURL = URL(string: "www.apple.ch")!
		
		//When
		manager.redirectUserForUpdate(to: dumURL)
		
		//Then
		XCTAssertTrue(spy.redirectUserForDownloadWasCalled, "Redirect user for download was not called")
	}
}
