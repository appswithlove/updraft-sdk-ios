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
		let loadFontsInteractor = LoadFontsInteractor()
		let apiSessionManager = ApiSessionManager()
		let autoUpdateManager = AutoUpdateManager()
		let feedbackManager = FeedbackManager()
		let settings = Settings()
		
		//When
		let updraft = Updraft(loadFontsInteractor: loadFontsInteractor, autoUpdateManager: autoUpdateManager, apiSessionManager: apiSessionManager, feedbackManager: feedbackManager, settings: settings)
		
		//Then
		XCTAssertTrue(loadFontsInteractor === updraft.loadFontsInteractor)
		XCTAssertTrue(apiSessionManager === updraft.apiSessionManager)
		XCTAssertTrue(autoUpdateManager === updraft.autoUpdateManager)
		XCTAssertTrue(feedbackManager === updraft.feedbackManager)
		XCTAssertTrue(settings === updraft.settings)
	}
	
	func testKeysOnStartUpdraft() {
		
		//Given
		let appKey = "1234567890"
		let sdkKey = "0987654321"
		let updraft = Updraft()
		
		//When
		updraft.start(sdkKey: sdkKey, appKey: appKey)
		
		//Then
		XCTAssertEqual(appKey, updraft.settings.appKey)
		XCTAssertEqual(sdkKey, updraft.settings.sdkKey)
	}
	
	func testStartFeedbackManagerOnUpdraftStart() {
		
		//Given
		let spy = FeedbackManagerSpy()
		let updraft = Updraft(loadFontsInteractor: LoadFontsInteractor(), autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: spy, settings: Settings())
		
		//When
		updraft.start(sdkKey: "", appKey: "")
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}
	
	func testStartAutoUpdateManagerOnUpdraftStart() {
		
		//Given
		let spy = AutoUpdateManagerSpy()
		let updraft = Updraft(loadFontsInteractor: LoadFontsInteractor(), autoUpdateManager: spy, apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		
		//When
		updraft.start(sdkKey: "", appKey: "")
		
		//Then
		XCTAssertTrue(spy.startWasCalled)
	}

	func testLoadFontsOnUpdraftStart() {
		
		//Given
		let spy = LoadFontsInteractorSpy()
		let updraft = Updraft(loadFontsInteractor: spy, autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		
		//When
		updraft.start(sdkKey: "", appKey: "")
		
		//Then
		XCTAssertTrue(spy.loadAllWasCalled)
	}
	
	func testWarningLogLevelOnInit() {
		
		//Given
		let defaultLogLevel = LogLevel.warning
		
		//When
		let updraft = Updraft(loadFontsInteractor: LoadFontsInteractor(), autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		
		//Then
		XCTAssert(Logger.logLevel == defaultLogLevel)

	}
	
	func testSetLogLevel() {
		
		//Given
		let errorLevel = LogLevel.error
		let updraft = Updraft(loadFontsInteractor: LoadFontsInteractor(), autoUpdateManager: AutoUpdateManager(), apiSessionManager: ApiSessionManager(), feedbackManager: FeedbackManager(), settings: Settings())
		
		//When
		updraft.logLevel = errorLevel
		
		//Then
		XCTAssert(Logger.logLevel == errorLevel)
		
	}
}
