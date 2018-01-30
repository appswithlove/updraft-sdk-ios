//
//  CheckUpdateInteractorOutputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class CheckUpdateInteractorOutputSpy: CheckUpdateInteractorOutput {
	
	var checkUpdateInteractorWasCalled = false
	
	func checkUpdateInteractor(_ sender: CheckUpdateInteractor, newUpdateAvailableAt url: URL) {
		checkUpdateInteractorWasCalled  = true
	}
}
