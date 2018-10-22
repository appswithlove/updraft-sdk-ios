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
	let takeScreenshotInteractor: TakeScreenshotInteractorInput
	let triggerFeedbackInteractor: TriggerFeedbackInteractorInput
	let showFeedbackStatusInteractor: ShowFeedbackStatusInteractorInput
	let checkFeedbackEnabledInteractor: CheckFeedbackEnabledInteractorInput
	let feedbackPresenter: FeedbackPresenterInput
	
	struct Constants {
		static let showFeedbackStatusDelay = 5.0
	}
	
	init(
		takeScreenshotInteractor: TakeScreenshotInteractor = TakeScreenshotInteractor(),
		triggerFeedbackInteractor: TriggerFeedbackInteractor = TriggerFeedbackInteractor(),
		showFeedbackStatusInteractor: ShowFeedbackStatusInteractor = ShowFeedbackStatusInteractor(),
		checkFeedbackEnabledInteractor: CheckFeedbackEnabledInteractor = CheckFeedbackEnabledInteractor(),
		feedbackPresenter: FeedbackPresenter = FeedbackPresenter()) {
		
		self.takeScreenshotInteractor = takeScreenshotInteractor
		self.triggerFeedbackInteractor = triggerFeedbackInteractor
		self.feedbackPresenter = feedbackPresenter
		self.showFeedbackStatusInteractor = showFeedbackStatusInteractor
		self.checkFeedbackEnabledInteractor = checkFeedbackEnabledInteractor
		takeScreenshotInteractor.output = self
		triggerFeedbackInteractor.output = self
		checkFeedbackEnabledInteractor.output = self
	}
	
	deinit {
		if let obs = didBecomeActiveObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	// MARK: Implementation
	
	func start() {
		Logger.log("Starting Feedback service...", level: .info)
		checkFeedbackEnabledInteractor.checkIfEnabled()
		subscribeToAppDidBecomeActive()
	}
	
	func subscribeToAppDidBecomeActive() {
		didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidBecomeActive, object: nil, queue: nil, using: { [weak self] (_) in
			self?.checkFeedbackEnabledInteractor.checkIfEnabled()
		})
	}
}

// MARK: - CheckFeedbackEnabledInteractorOutput

extension FeedbackManager: CheckFeedbackEnabledInteractorOutput {
	func checkFeedbackEnabled(_ sender: CheckFeedbackEnabledInteractor, isEnabled: Bool) {
		if isEnabled {
			if !triggerFeedbackInteractor.isActive { triggerFeedbackInteractor.start() }
			guard showFeedbackStatusInteractor.lastShown != .enabled else { return }
			showFeedbackStatusInteractor.show(for: .enabled, in: Constants.showFeedbackStatusDelay)
		} else {
			if triggerFeedbackInteractor.isActive { triggerFeedbackInteractor.stop() }
			guard showFeedbackStatusInteractor.lastShown == .enabled else { return }
			showFeedbackStatusInteractor.show(for: .disabled, in: Constants.showFeedbackStatusDelay)
		}
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
