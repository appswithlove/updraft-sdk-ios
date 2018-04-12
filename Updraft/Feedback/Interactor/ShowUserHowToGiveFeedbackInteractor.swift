//
//  ShowUserHowToGiveFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 12.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol ShowUserHowToGiveFeedbackInteractorInput {
	func showIfNeeded(in seconds: Double)
}

class ShowUserHowToGiveFeedbackInteractor {
	struct Constants {
			static let message = "Shake device or take a screenshot to give a feedback"
			static let title = "Give Feedback"
			struct UserDefaults {
				static let wasUserShownHowKey = "Updraft.WasUserShownHowToGiveFeedback"
			}
	}
	
	var wasShown: Bool {
		get {
			return UserDefaults.standard.bool(forKey: Constants.UserDefaults.wasUserShownHowKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.wasUserShownHowKey)
		}
	}
	
	let displayAlertInteractor: DisplayAlertInteractor
	
	init(displayAlertInteractor: DisplayAlertInteractor = DisplayAlertInteractor()) {
		self.displayAlertInteractor = displayAlertInteractor
		displayAlertInteractor.output = self
	}
}

// MARK: - ShowUserHowToGiveFeedbackInteractorInput

extension ShowUserHowToGiveFeedbackInteractor: ShowUserHowToGiveFeedbackInteractorInput {
	func showIfNeeded(in seconds: Double) {
		if !wasShown {
			DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
				self.displayAlertInteractor.displayAlert(with: Constants.message, title: Constants.title)
			}
		}
	}
}

// MARK: - DisplayAlertInteractorOutput

extension ShowUserHowToGiveFeedbackInteractor: DisplayAlertInteractorOuput {
	func displayAlertInteractorUserDidAcknowledgeAlert(_ sender: DisplayAlertInteractor) {
		wasShown = true
	}
}
