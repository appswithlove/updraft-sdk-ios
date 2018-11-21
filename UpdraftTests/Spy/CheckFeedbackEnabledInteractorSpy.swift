//
//  CheckFeedbackEnabledInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 21.11.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class CheckFeedbackEnabledInteractorSpy: CheckFeedbackEnabledInteractor {
	var checkIfEnabledWasCalled = false
	
	override func checkIfEnabled() {
		checkIfEnabledWasCalled = true
	}
}
