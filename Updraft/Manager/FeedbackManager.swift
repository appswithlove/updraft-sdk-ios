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
	
	let takeScreenshotInteractor: TakeScreenshotInteractorInput
	let triggerFeedbackInteractor: TriggerFeedbackInteractorInput
	
	init(
		takeScreenshotInteractor: TakeScreenshotInteractor = TakeScreenshotInteractor(),
		triggerFeedbackInteractor: TriggerFeedbackInteractor = TriggerFeedbackInteractor()) {
		
		self.takeScreenshotInteractor = takeScreenshotInteractor
		self.triggerFeedbackInteractor = triggerFeedbackInteractor
		takeScreenshotInteractor.output = self
		triggerFeedbackInteractor.output = self
	}
	
	// MARK: Implementation
	
	func start() {
		//TODO: Test it is called
		triggerFeedbackInteractor.start()
	}

	// - Interactor to display a message to the user that he can shake device to take a screenshot
		// Reuse displayAlertInteractor
	// - Interactor to display a feedback
	// - Interactor to send a feedback
	
	// - Interactor to get information about the device, navigation stack etc ?
	// - What should happen if a user takes a screenshot or shake his device while he is on the view to comment/annotate a feedback
}

extension FeedbackManager: TakeScreenshotInteractorOutput {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage) {
		//TODO: Present the feedback screen , passing along the image to be displayed
		print(image)
		//FIXME: What to do if another image arrives when one is already being presented in feedbackView ? ignore it? or present it on top ?
	}
}

extension FeedbackManager: TriggerFeedbackInteractorOutput {
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, userDidTriggerFeedbackWith type: TriggerFeedbackInteractor.TriggerType) {
		//TODO: Take a screenshot
		takeScreenshotInteractor.takeScreenshot()
	}
}
