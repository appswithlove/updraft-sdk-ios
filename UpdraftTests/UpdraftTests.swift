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
	
	func testInit() {
		
		//Given
		let apiSessionManager = ApiSessionManager()
		let autoUpdateManager = AutoUpdateManager()
		let feedbackManager = FeedbackManager()
		let settings = Settings()
		
		//When
		let updraft = Updraft(autoUpdateManager: autoUpdateManager, apiSessionManager: apiSessionManager, feedbackManager: feedbackManager, settings: settings)
		
		//Then
		XCTAssertTrue(apiSessionManager === updraft.apiSessionManager)
		XCTAssertTrue(autoUpdateManager === updraft.autoUpdateManager)
		XCTAssertTrue(feedbackManager === updraft.feedbackManager)
		XCTAssertTrue(settings === updraft.settings)
	}
	
	func testKeysOnStartUpdraft() {
		
		//Given
		let appKey = "1234567890"
		let sdkKey = "0987654321"
		let isAppStoreRelease = false
		let updraft = Updraft()
		
		//When
		updraft.start(sdkKey: sdkKey, appKey: appKey, isAppStoreRelease: isAppStoreRelease)
		
		//Then
		XCTAssertEqual(appKey, updraft.settings.appKey)
		XCTAssertEqual(sdkKey, updraft.settings.sdkKey)
		XCTAssertEqual(isAppStoreRelease, updraft.settings.isAppStoreRelease)
	}
	
	func testStartFeedbackManagerOnUpdraftStartWhenNotAppStoreRelease() {
		
		//Given
		let spy = FeedbackManagerSpy()
		let updraft = Updraft(autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: spy, settings: Settings())
		let isAppStoreRelease = false
		
		//When
		updraft.start(sdkKey: "", appKey: "", isAppStoreRelease: isAppStoreRelease)
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}
	
	func testStartFeedbackManagerOnUpdraftStartWhenAppStoreRelease() {
		
		//Given
		let spy = FeedbackManagerSpy()
		let updraft = Updraft(autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: spy, settings: Settings())
		let isAppStoreRelease = true
		
		//When
		updraft.start(sdkKey: "", appKey: "", isAppStoreRelease: isAppStoreRelease)
		
		//Then
		XCTAssertFalse(spy.startWasCalled)
	}
	
	func testStartAutoUpdateManagerOnUpdraftStartWhenNotAppStoreRelease() {
		
		//Given
		let spy = AutoUpdateManagerSpy()
		let updraft = Updraft(autoUpdateManager: spy, apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		let isAppStoreRelease = false
		
		//When
		updraft.start(sdkKey: "", appKey: "", isAppStoreRelease: isAppStoreRelease)
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}
	
	func testStartAutoUpdateManagerOnUpdraftStartWhenAppStoreRelease() {
		
		//Given
		let spy = AutoUpdateManagerSpy()
		let updraft = Updraft(autoUpdateManager: spy, apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		let isAppStoreRelease = true
		
		//When
		updraft.start(sdkKey: "", appKey: "", isAppStoreRelease: isAppStoreRelease)
		
		//Then
		XCTAssertFalse(spy.startWasCalled)
	}
}
