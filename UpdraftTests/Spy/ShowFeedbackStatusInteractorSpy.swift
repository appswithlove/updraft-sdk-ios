//
//  ShowFeedbackStatusInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class ShowFeedbackStatusInteractorSpy: ShowFeedbackStatusInteractor {
	
	var showWasCalled = false
	private var lastShownStatus: ShowFeedbackStatusInteractor.FeedbackStatusType?
	var showForStatus: ShowFeedbackStatusInteractor.FeedbackStatusType?
	
	override var lastShown: ShowFeedbackStatusInteractor.FeedbackStatusType? {
		get {
			return lastShownStatus
		}
		set {
			lastShownStatus = newValue
		}
	}
	
	override func show(for status: ShowFeedbackStatusInteractor.FeedbackStatusType, in seconds: TimeInterval) {
		showForStatus = status
		showWasCalled = true
	}
}
