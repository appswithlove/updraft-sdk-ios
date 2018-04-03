//
//  TriggerFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
import CoreMotion

protocol TriggerFeedbackInteractorInput {
	func start()
}

protocol TriggerFeedbackInteractorOutput {
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, didTriggerFeedbackWith type: TriggerFeedbackInteractor.Type)
}

final class TriggerFeedbackInteractor {
	
	private (set) var screenshotObserver: NSObjectProtocol?
	
	func start() {
		//TODO: Test that this is called when FeedbackManager is started
	}
	
	func observeUserDidTakeScreenshot() {
		//TODO: Test that this is called on START
		// - Observe when the user takes a screenshot
	}
	
	func detectShake() {
		//TODO: Test that this is called on START
		// - Observe when the user shakes screen, use coremotion =>
	}
	
	/// Types of user actions which triggers a feedback
	///
	/// - shake: User shaked his device
	/// - userDidTakeScreenshot: User took a screenshot manually
	enum `Type` {
		case shake
		case manualScreenshot
	}
}
