//
//  DisplayAlertInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 21.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class DisplayAlertInteractorSpy: DisplayAlertInteractor {
	var wasShowAlertCalled = false
	var shownAlert: UIAlertController?
	
	override func showAlert(alert: UIAlertController) {
		wasShowAlertCalled = true
		shownAlert = alert
	}
}
