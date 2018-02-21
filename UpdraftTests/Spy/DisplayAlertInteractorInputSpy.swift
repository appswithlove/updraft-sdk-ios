//
//  DisplayAlertInteractorInputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 21.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class DisplayAlertInteractorInputSpy: DisplayAlertInteractorInput {
	var displayAlertWasCalled = false
	
	func displayAlert(with message: String, title: String) {
		displayAlertWasCalled = true
	}
}
