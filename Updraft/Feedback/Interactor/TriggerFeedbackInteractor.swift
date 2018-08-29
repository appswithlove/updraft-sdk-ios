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
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, userDidTriggerFeedbackWith type: TriggerFeedbackInteractor.TriggerType)
}

/// Handle the detection of feedback triggers
class TriggerFeedbackInteractor: TriggerFeedbackInteractorInput {
	
	struct Constants {
		static let shakeAccelerationThresold: Double = 1.75 // in g-force
	}
	
	private (set) var screenshotObserver: NSObjectProtocol?
	weak var output: TriggerFeedbackInteractorOutput?
	
	let queue = OperationQueue() // Dedicated operation queue to handle CMMotionManager updates
	
	lazy var motionManager: CMMotionManager = {
		let manager = CMMotionManager()
		manager.accelerometerUpdateInterval = 0.25
		return manager
		}()
	
	deinit {
		stop()
	}

	func start() {
		observeUserDidTakeScreenshot()
		detectShake()
	}
	
	func stop() {
		removeScreenshotObserver()
		stopDetectingShake()
	}
	
	func removeScreenshotObserver() {
		if let obs = screenshotObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	/// Observe when the user takes a screenshot, usually by pressing "Home" + "Lock" buttons
	func observeUserDidTakeScreenshot() {
		screenshotObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: nil, using: { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.output?.triggerFeedbackInteractor(strongSelf, userDidTriggerFeedbackWith: .screenshot)
		})
	}
	
	/// Detect when the user shakes his device
	func detectShake() {
		if motionManager.isAccelerometerAvailable {
			motionManager.startAccelerometerUpdates(to: queue) { [weak self] (data, _) in
				guard let data = data, let strongSelf = self else {return}
				if strongSelf.isShakeDetected(acceleration: data.acceleration, thresold: Constants.shakeAccelerationThresold) {
					OperationQueue.main.addOperation {
						strongSelf.output?.triggerFeedbackInteractor(strongSelf, userDidTriggerFeedbackWith: .shake)
					}
				}
			}
		}
	}
	
	func stopDetectingShake() {
		motionManager.stopAccelerometerUpdates()
	}
	
	/// Determines if the acceleration, given a g-force thresold, is considered a "shake"
	///
	/// - Parameters:
	///   - acceleration: Acceleration vector.
	///   - thresold: Thresold in g-force.
	/// - Returns: Boolean value indicating whether a shake is detected.
	func isShakeDetected(acceleration: CMAcceleration, thresold: Double) -> Bool {
		if abs(acceleration.x) > thresold ||
			abs(acceleration.y) > thresold ||
			abs(acceleration.z) > thresold {
			return true
		}
		return false
	}
	
	/// Types of user actions which triggers a feedback
	///
	/// - shake: User shaked his device
	/// - screenshot: User took a screenshot manually
	enum TriggerType {
		case shake
		case screenshot
	}
}
