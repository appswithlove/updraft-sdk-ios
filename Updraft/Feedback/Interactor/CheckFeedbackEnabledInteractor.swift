//
//  CheckFeedbackEnabledInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol CheckFeedbackEnabledInteractorInput {
	/// Check if feedback is enabled
	func checkIfEnabled()
}

protocol CheckFeedbackEnabledInteractorOutput: class {
	/// Tells the delegate if feedback is enabled
	///
	/// - Parameters:
	///   - sender: The sender where the event occurs.
	///   - isEnabled: A Boolean value indicating if feedback is enabled.
	func checkFeedbackEnabled(_ sender: CheckFeedbackEnabledInteractor, isEnabled: Bool)
}

class CheckFeedbackEnabledInteractor {
	weak var output: CheckFeedbackEnabledInteractorOutput?
	
	private var settings: Settings
	private let feedbackEnabledRequest: FeedbackEnabledRequest
	
	init(
		settings: Settings = Settings(),
		feedbackEnabledRequest: FeedbackEnabledRequest = FeedbackEnabledRequest()) {
		
		self.settings = settings
		self.feedbackEnabledRequest = feedbackEnabledRequest
	}
}

extension CheckFeedbackEnabledInteractor: CheckFeedbackEnabledInteractorInput {
	func checkIfEnabled() {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey
		]
		
		feedbackEnabledRequest.load(with: .isEnabled(params: parameters)) { [weak self] (result) in
			guard let strongSelf = self, strongSelf.output != nil else { return }
			switch result {
			case .success(let model):
				Logger.log("Feedback is enabled: \(model.isFeedbackEnabled)", level: .info)
				strongSelf.output?.checkFeedbackEnabled(strongSelf, isEnabled: model.isFeedbackEnabled)
			case .error(let error):
				Logger.log("Checking if feedback is enabled failed: \(error.localizedDescription)", level: .error)
			}
		}
	}
}
