//
//  FeedbackManagerSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 04.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class FeedbackManagerSpy: FeedbackManager {
	var startWasCalled = false
	var showHowToGiveFeedbackWasCalled = false
	var wasUserShown = false
	
	override func start() {
		super.start()
		startWasCalled = true
	}
	
	override func showHowToGiveFeedback(in seconds: Double, title: String, message: String) {
		showHowToGiveFeedbackWasCalled = true
	}
	
	override var userWasShownHowToGiveFeedback: Bool {
		get {
			return wasUserShown
		}
		set {
			wasUserShown = newValue
		}
	}
}
