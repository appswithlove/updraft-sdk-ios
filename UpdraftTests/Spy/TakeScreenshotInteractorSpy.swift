//
//  TakeScreenshotInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class TakeScreenshotInteractorSpy: TakeScreenshotInteractor {
	var takeScreenshotWasCalled = false
	
	override func takeScreenshot() {
		takeScreenshotWasCalled = true
	}
}
