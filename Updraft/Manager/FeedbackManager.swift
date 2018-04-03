//
//  FeedbackManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Handle the user generated feedback process.
final class FeedbackManager {
	
	let takeScreenshotInteractor: TakeScreenshotInteractor
	let triggerFeedbackInteractor: TriggerFeedbackInteractor
	
	// MARK: Implementation
	
	func start() {
		//Start triggerFeedback
	}

	// - Interactor to detect and take screenshots
		// Detect shake and when user takes a screenshot
	// - Interactor to display a message to the user that he can shake device to take a screenshot
		// Reuse displayAlertInteractor
	// - Interactor to display a feedback
	// - Interactor to send a feedback
	
	// - Interactor to get information about the device, navigation stack etc ?
	// - What should happen if a user takes a screenshot or shake his device while he is on the view to comment/annotate a feedback
}
