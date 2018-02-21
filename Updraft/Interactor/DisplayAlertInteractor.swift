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
}

protocol DisplayAlertInteractorOuput: class {
	func displayAlertInteractorUserDidAcknowledgeAlert(_ sender: DisplayAlertInteractor)
}

class DisplayAlertInteractor: AppUtility {
	var isDisplayingAlert = false
	weak var output: DisplayAlertInteractorOuput?
	
	func showAlert(alert: UIAlertController) {
		topMostController?.present(alert, animated: true) { [weak self] in
			self?.isDisplayingAlert = true
		}
	}
}

extension DisplayAlertInteractor: DisplayAlertInteractorInput {
	func displayAlert(with message: String, title: String) {
		guard !isDisplayingAlert else {return}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = 	UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
			guard let strongSelf = self else {return}
			strongSelf.isDisplayingAlert = false
			strongSelf.output?.displayAlertInteractorUserDidAcknowledgeAlert(strongSelf)
		}
		alert.addAction(okAction)
		self.showAlert(alert: alert)
	}
}
