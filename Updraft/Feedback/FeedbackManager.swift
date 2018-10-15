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
	
	private(set) var didBecomeActiveObserver: NSObjectProtocol?
	private(set) var willResignActiveObserver: NSObjectProtocol?
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
	
	deinit {
		if let obs = didBecomeActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
		if let obs = willResignActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	// MARK: Implementation
	
	func start() {
		Logger.log("Starting Feedback service...", level: .info)
		triggerFeedbackInteractor.start()
		if !showUserHowToGiveFeedbackInteractor.wasShown {
			showUserHowToGiveFeedbackInteractor.show(in: Constants.showFeedbackDelay)
		}
		subscribeToAppDidBecomeActive()
		subscribeToAppWillResignActive()
	}
	
	func subscribeToAppDidBecomeActive() {
		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.triggerFeedbackInteractor.start()
		})
	}
		
	func subscribeToAppWillResignActive() {
		willResignActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.triggerFeedbackInteractor.stop()
		})
	}
}

// MARK: - TakeScreenshotInteractorOutput

extension FeedbackManager: TakeScreenshotInteractorOutput {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage) {
		let feedbackContext = FeedbackContextModel(buildVersion: buildVersion, navigationStack: controllersStack, systemVersion: systemVersion, modelName: modelName, deviceUuid: deviceUuid)
		feedbackPresenter.present(with: image, context: feedbackContext)
	}
}

// MARK: - TriggerFeedbackInteractorOutput

extension FeedbackManager: TriggerFeedbackInteractorOutput {
	func triggerFeedbackInteractorUserDidTakeScreenshot(_ sender: TriggerFeedbackInteractor) {
		Logger.log("User triggered Feedback overlay", level: .info)
		takeScreenshotInteractor.takeScreenshot()
	}
}
