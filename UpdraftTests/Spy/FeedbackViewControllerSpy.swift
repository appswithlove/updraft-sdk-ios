//
//  FeedbackViewControllerSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class FeedbackViewControllerSpy: FeedbackViewController {
	
	var updateWasCalled = false
	var setupWasCalled = false
	
	override func update() {
		updateWasCalled = true
		setupWasCalled = true
	}
}
