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
	/// Start listening to feedback triggers
	func start()
	
	/// Stop listening to feedback triggers
	func stop()
}

protocol TriggerFeedbackInteractorOutput: class {
	func triggerFeedbackInteractorUserDidTakeScreenshot(_ sender: TriggerFeedbackInteractor)
}

/// Handle the detection of feedback triggers
class TriggerFeedbackInteractor: TriggerFeedbackInteractorInput {
	
	private (set) var screenshotObserver: NSObjectProtocol?
	weak var output: TriggerFeedbackInteractorOutput?
	
	deinit {
		stop()
	}

	func start() {
		observeUserDidTakeScreenshot()
	}
	
	func stop() {
		removeScreenshotObserver()
	}
	
	func removeScreenshotObserver() {
		if let obs = screenshotObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	/// Observe when the user takes a screenshot, usually by pressing "Home" + "Lock" buttons
	func observeUserDidTakeScreenshot() {
		removeScreenshotObserver()
		screenshotObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: nil, using: { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.output?.triggerFeedbackInteractorUserDidTakeScreenshot(strongSelf)
		})
	}
}
