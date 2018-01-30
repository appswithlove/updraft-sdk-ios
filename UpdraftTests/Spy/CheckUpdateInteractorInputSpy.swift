//
//  CheckUpdateInteractorInputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class CheckUpdateInteractorInputSpy: CheckUpdateInteractorInput {
	var checkUpdateWasCalled = false
	
	func checkUpdate() {
		checkUpdateWasCalled = true
	}
}
