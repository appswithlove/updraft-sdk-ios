//
//  AutoUpdateRestInteractorOutputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class AutoUpdateRestInteractorOutputSpy: AutoUpdateRestInteractorOutput {
	
	var autoUpdateRestInteractorWasCalled = false
	
	func autoUpdateRestInteractor(_ sender: AutoUpdateRestInteractor, newUpdateAvailableAt url: URL) {
		autoUpdateRestInteractorWasCalled  = true
	}
}
