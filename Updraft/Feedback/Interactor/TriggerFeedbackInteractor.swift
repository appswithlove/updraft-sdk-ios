//
//  TriggerFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

protocol TriggerFeedbackInteractorInput {
	
	/// Boolean indicating if the trigger is active
	var isActive: Bool { get }
	
	/// Start listening to feedback triggers
	func start()
	
	/// Stop listening to feedback triggers
	func stop()
}

protocol TriggerFeedbackInteractorOutput: AnyObject {
	func triggerFeedbackInteractorUserDidTakeScreenshot(_ sender: TriggerFeedbackInteractor)
}

/// Handle the detection of feedback triggers
class TriggerFeedbackInteractor: TriggerFeedbackInteractorInput {
	
	private(set) var screenshotObserver: NSObjectProtocol?
	weak var output: TriggerFeedbackInteractorOutput?
	var isActive: Bool = false
	
	deinit {
		stop()
	}

	func start() {
		Logger.log("Starting Feedback Trigger service...", level: .info)
		observeUserDidTakeScreenshot()
	}
	
	func stop() {
		Logger.log("Stopping Feedback Trigger service...", level: .info)
		removeScreenshotObserver()
	}
	
	func removeScreenshotObserver() {
		if let obs = screenshotObserver {
			NotificationCenter.default.removeObserver(obs)
		}
		isActive = false
	}
	
	/// Observe when the user takes a screenshot
	func observeUserDidTakeScreenshot() {
		removeScreenshotObserver()
		screenshotObserver = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: nil, using: { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.output?.triggerFeedbackInteractorUserDidTakeScreenshot(strongSelf)
		})
		isActive = true
	}
}
