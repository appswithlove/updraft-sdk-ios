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
	func start()
}

protocol TriggerFeedbackInteractorOutput: class {
	func triggerFeedbackInteractor(_ sender: TriggerFeedbackInteractor, userDidTriggerFeedbackWith type: TriggerFeedbackInteractor.TriggerType)
}

class TriggerFeedbackInteractor: TriggerFeedbackInteractorInput {
	
	struct Constants {
		static let shakeAccelerationThresold: Double = 1.75 // in g-force
	}
	
	private (set) var screenshotObserver: NSObjectProtocol?
	weak var output: TriggerFeedbackInteractorOutput?
	
	let queue = OperationQueue()
	
	lazy var motionManager: CMMotionManager = {
		let manager = CMMotionManager()
		manager.accelerometerUpdateInterval = 0.25
		return manager
		}()
	
	deinit {
		if let obs = screenshotObserver {
			NotificationCenter.default.removeObserver(obs)
		}
	}
	
	func start() {
		observeUserDidTakeScreenshot()
		detectShake()
	}
	
	func observeUserDidTakeScreenshot() {
		screenshotObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: nil, using: { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.output?.triggerFeedbackInteractor(strongSelf, userDidTriggerFeedbackWith: .screenshot)
		})
	}
	
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
