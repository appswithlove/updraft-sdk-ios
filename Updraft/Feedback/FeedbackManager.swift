//
//  FeedbackManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Handle the user generated feedback process.
class FeedbackManager {
	
	let takeScreenshotInteractor: TakeScreenshotInteractorInput
	let triggerFeedbackInteractor: TriggerFeedbackInteractorInput
	let feedbackPresenter: FeedbackPresenterInput
	
	init(
		takeScreenshotInteractor: TakeScreenshotInteractor = TakeScreenshotInteractor(),
		triggerFeedbackInteractor: TriggerFeedbackInteractor = TriggerFeedbackInteractor(),
		feedbackPresenter: FeedbackPresenter = FeedbackPresenter()) {
		
		self.takeScreenshotInteractor = takeScreenshotInteractor
		self.triggerFeedbackInteractor = triggerFeedbackInteractor
		self.feedbackPresenter = feedbackPresenter
		takeScreenshotInteractor.output = self
		triggerFeedbackInteractor.output = self
	}
	
	// MARK: Implementation
	
	func start() {
		triggerFeedbackInteractor.start()
	}
	// - Interactor to display a message to the user that he can shake device to take a screenshot
		// Reuse displayAlertInteractor
	// - Interactor to get information about the device, navigation stack etc ?
}

// MARK: - TakeScreenshotInteractorOutput

extension FeedbackManager: TakeScreenshotInteractorOutput {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage) {
		feedbackPresenter.present(with: image)
	}
}

// MARK: - TriggerFeedbackInteractorOutput

extension FeedbackManager: TriggerFeedbackInteractorOutput {
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, userDidTriggerFeedbackWith type: TriggerFeedbackInteractor.TriggerType) {
		takeScreenshotInteractor.takeScreenshot()
	}
}
