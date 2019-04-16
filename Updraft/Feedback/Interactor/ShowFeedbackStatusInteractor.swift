//
//  ShowFeedbackStatusInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 12.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol ShowFeedbackStatusInteractorInput {
	/// Last status shown to the user
	var lastShown: ShowFeedbackStatusInteractor.FeedbackStatusType? {get set}
	
	/// Show status to the user
	func show(for status: ShowFeedbackStatusInteractor.FeedbackStatusType, in seconds: TimeInterval)
}

protocol ShowFeedbackStatusInteractorOutput: class {
	func showFeedbackStatusInteractorUserDidConfirm(_ sender: ShowFeedbackStatusInteractor, statusType: ShowFeedbackStatusInteractor.FeedbackStatusType?)
}

class ShowFeedbackStatusInteractor: ShowFeedbackStatusInteractorInput {
	weak var output: ShowFeedbackStatusInteractorOutput?
	
	enum FeedbackStatusType: Int {
		case enabled = 1
		case disabled
		
		var title: String {
			switch self {
			case .enabled:
				return "updraft_feedback_alert_howToGiveFeedback_title".localized
			case .disabled:
				return "updraft_feedback_alert_feedbackDisabled_title".localized
			}
		}
		
		var message: String {
			switch self {
			case .enabled:
				return "updraft_feedback_alert_howToGiveFeedback_message".localized
			case .disabled:
				return "updraft_feedback_alert_feedbackDisabled_message".localized
			}
		}
	}
	
	struct Constants {
			struct UserDefaults {
				static let showUserFeedbackStatus = "Updraft.ShowUserFeedbackStatus"
			}
	}
	
	var lastShown: FeedbackStatusType? {
		get {
			let value = UserDefaults.standard.integer(forKey: Constants.UserDefaults.showUserFeedbackStatus)
			return FeedbackStatusType.init(rawValue: value)
		}
		set {
			UserDefaults.standard.set(newValue?.rawValue, forKey: Constants.UserDefaults.showUserFeedbackStatus)
		}
	}
	
	private var showingStatus: FeedbackStatusType?
	private var timer: Timer?
	
	let displayAlertInteractor: DisplayAlertInteractor
	
	init(displayAlertInteractor: DisplayAlertInteractor = DisplayAlertInteractor()) {
		self.displayAlertInteractor = displayAlertInteractor
		displayAlertInteractor.output = self
	}
	
// MARK: - ShowFeedbackStatusInteractorInput
	
	func show(for status: FeedbackStatusType, in seconds: TimeInterval) {
		timer?.invalidate()
		timer = nil
		timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { (_) in
			self.showingStatus = status
			self.displayAlertInteractor.displayAlert(with: status.message, title: status.title, okButtonTitle: nil, cancelButton: false)
		})
	}
}

// MARK: - DisplayAlertInteractorOutput

extension ShowFeedbackStatusInteractor: DisplayAlertInteractorOuput {
	func displayAlertInteractorUserDidConfirm(_ sender: DisplayAlertInteractor) {
		lastShown = showingStatus
		output?.showFeedbackStatusInteractorUserDidConfirm(self, statusType: showingStatus)
	}
}
