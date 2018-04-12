//
//  FeedbackManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Handle the user generated feedback process.
class FeedbackManager: AppUtility {
	
	let takeScreenshotInteractor: TakeScreenshotInteractorInput
	let triggerFeedbackInteractor: TriggerFeedbackInteractorInput
	let showUserHowToGiveFeedbackInteractor: ShowUserHowToGiveFeedbackInteractorInput
	let feedbackPresenter: FeedbackPresenterInput
	
	struct Constants {
		static let showFeedbackDelay = 5.0
	}
	
	init(
		takeScreenshotInteractor: TakeScreenshotInteractor = TakeScreenshotInteractor(),
		triggerFeedbackInteractor: TriggerFeedbackInteractor = TriggerFeedbackInteractor(),
		showUserHowToGiveFeedbackInteractor: ShowUserHowToGiveFeedbackInteractor = ShowUserHowToGiveFeedbackInteractor(),
		feedbackPresenter: FeedbackPresenter = FeedbackPresenter()) {
		
		self.takeScreenshotInteractor = takeScreenshotInteractor
		self.triggerFeedbackInteractor = triggerFeedbackInteractor
		self.feedbackPresenter = feedbackPresenter
		self.showUserHowToGiveFeedbackInteractor = showUserHowToGiveFeedbackInteractor
		takeScreenshotInteractor.output = self
		triggerFeedbackInteractor.output = self
	}
	
	// MARK: Implementation
	
	func start() {
		triggerFeedbackInteractor.start()
		showUserHowToGiveFeedbackInteractor.showIfNeeded(in: Constants.showFeedbackDelay)
	}
}

// MARK: - TakeScreenshotInteractorOutput

extension FeedbackManager: TakeScreenshotInteractorOutput {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage) {
		let feedbackContext = FeedbackContextModel(navigationStack: controllersStack, systemVersion: systemVersion, modelName: modelName, deviceUuid: deviceUuid)
		feedbackPresenter.present(with: image, context: feedbackContext)
	}
}

// MARK: - TriggerFeedbackInteractorOutput

extension FeedbackManager: TriggerFeedbackInteractorOutput {
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, userDidTriggerFeedbackWith type: TriggerFeedbackInteractor.TriggerType) {
		takeScreenshotInteractor.takeScreenshot()
	}
}
