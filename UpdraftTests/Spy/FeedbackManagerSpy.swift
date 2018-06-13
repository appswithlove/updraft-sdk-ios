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
	
	override func start() {
		super.start()
		startWasCalled = true
	}
}
