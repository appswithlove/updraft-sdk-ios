//
//  DisplayAlertInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 20.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol DisplayAlertInteractorInput {
	
	/// Display alert to the user
	///
	/// - Parameters:
	///   - message: The message of the alert
	///   - title: The title of the alert
	///   - okButtonTitle: Custom title for `ok` button
	///   - cancelButton: Boolean indicating if a cancel button should added to the alert
	func displayAlert(with message: String, title: String, okButtonTitle: String?, cancelButton: Bool)
	
	/// Clear any currently displayed message
	func clearMessages()
}

protocol DisplayAlertInteractorOuput: class {
	func displayAlertInteractorUserDidConfirm(_ sender: DisplayAlertInteractor)
	func displayAlertInteractorUserDidCancel(_ sender: DisplayAlertInteractor)
}

extension DisplayAlertInteractorOuput {
	func displayAlertInteractorUserDidCancel(_ sender: DisplayAlertInteractor) {}
}

class DisplayAlertInteractor: AppUtility {
	var displayedAlert: UIAlertController?
	weak var output: DisplayAlertInteractorOuput?
	
	func showAlert(alert: UIAlertController) {
		clear {
			self.topMostController?.present(alert, animated: true) { [weak self] in
				self?.displayedAlert = alert
			}
		}
	}
	
	func clear(completion: (() -> Void)? = nil) {
		if let alert = displayedAlert {
			alert.dismiss(animated: true, completion: { [weak self] in
				self?.displayedAlert = nil
				completion?()
			})
		} else {
			completion?()
		}
	}
}

// MARK: - DisplayAlertInteractorInput

extension DisplayAlertInteractor: DisplayAlertInteractorInput {
	func displayAlert(with message: String, title: String, okButtonTitle: String?, cancelButton: Bool) {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		if cancelButton {
			let cancelAction = UIAlertAction(title: "updraft_alert_button_cancel".localized, style: .default) { [weak self] (_) in
				guard let strongSelf = self else {return}
				strongSelf.displayedAlert = nil
				strongSelf.output?.displayAlertInteractorUserDidCancel(strongSelf)
			}
			alert.addAction(cancelAction)
		}
		let okAction = 	UIAlertAction(title: okButtonTitle ?? "updraft_alert_button_ok".localized, style: .default) { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.displayedAlert = nil
			strongSelf.output?.displayAlertInteractorUserDidConfirm(strongSelf)
		}
		alert.addAction(okAction)
		alert.preferredAction = okAction
		self.showAlert(alert: alert)
	}
	
	func clearMessages() {
		clear()
	}
}
