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
	let displayAlertInteractor: DisplayAlertInteractorInput
	let feedbackPresenter: FeedbackPresenterInput
	
	struct Constants {
		struct HowToGiveFeedback {
			static let showDelay = 5.0
			static let message = "Shake device or take a screenshot to give a feedback"
			static let title = "Give Feedback"
			
			struct UserDefaults {
				static let wasUserShownHowKey = "Updraft.WasUserShownHowToGiveFeedback"
			}
		}
	}
	
	var userWasShownHowToGiveFeedback: Bool {
		get {
			return UserDefaults.standard.bool(forKey: Constants.HowToGiveFeedback.UserDefaults.wasUserShownHowKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Constants.HowToGiveFeedback.UserDefaults.wasUserShownHowKey)
		}
	}
	
	init(
		takeScreenshotInteractor: TakeScreenshotInteractor = TakeScreenshotInteractor(),
		triggerFeedbackInteractor: TriggerFeedbackInteractor = TriggerFeedbackInteractor(),
		displayAlertInteractor: DisplayAlertInteractor = DisplayAlertInteractor(),
		feedbackPresenter: FeedbackPresenter = FeedbackPresenter()) {
		
		self.takeScreenshotInteractor = takeScreenshotInteractor
		self.triggerFeedbackInteractor = triggerFeedbackInteractor
		self.feedbackPresenter = feedbackPresenter
		self.displayAlertInteractor = displayAlertInteractor
		takeScreenshotInteractor.output = self
		triggerFeedbackInteractor.output = self
		displayAlertInteractor.output = self
	}
	
	// MARK: Implementation
	
	func start() {
		triggerFeedbackInteractor.start()
		if !userWasShownHowToGiveFeedback {
			showHowToGiveFeedback(in: Constants.HowToGiveFeedback.showDelay, title: Constants.HowToGiveFeedback.title, message: Constants.HowToGiveFeedback.message)
		}
	}
	
	func showHowToGiveFeedback(in seconds: Double, title: String, message: String) {
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
			self.displayAlertInteractor.displayAlert(with: message, title: title)
		}
	}
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

// MARK: - DisplayAlertInteractorOutput

extension FeedbackManager: DisplayAlertInteractorOuput {
	func displayAlertInteractorUserDidAcknowledgeAlert(_ sender: DisplayAlertInteractor) {
		userWasShownHowToGiveFeedback = true
	}
}
