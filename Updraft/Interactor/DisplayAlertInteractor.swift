//
//  DisplayAlertInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 20.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol DisplayAlertInteractorInput {
	
	/// Display alert to the user
	///
	/// - Parameter message: The message of the alert
	/// - Parameter title: The title of the alert
	func displayAlert(with message: String, title: String)
	
	/// Clear any currently displayed message
	func clearMessages()
}

protocol DisplayAlertInteractorOuput: class {
	func displayAlertInteractorUserDidAcknowledgeAlert(_ sender: DisplayAlertInteractor)
}

final class DisplayAlertInteractor: AppUtility {
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
	func displayAlert(with message: String, title: String) {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = 	UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.displayedAlert = nil
			strongSelf.output?.displayAlertInteractorUserDidAcknowledgeAlert(strongSelf)
		}
		alert.addAction(okAction)
		self.showAlert(alert: alert)
	}
	
	func clearMessages() {
		clear()
	}
}
