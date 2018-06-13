//
//  ShowUserHowToGiveFeedbackInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class ShowUserHowToGiveFeedbackInteractorSpy: ShowUserHowToGiveFeedbackInteractor {
	
	var wasUserShown = false
	var showWasCalled = false
	
	override var wasShown: Bool {
		get {
			return wasUserShown
		}
		set {
			wasUserShown = newValue
		}
	}
	
	override func show(in seconds: Double) {
		showWasCalled = true
	}
}
