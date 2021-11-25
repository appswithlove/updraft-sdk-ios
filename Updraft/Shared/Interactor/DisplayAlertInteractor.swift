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

protocol DisplayAlertInteractorOuput: AnyObject {
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
        if #available (iOS 11, *) {
            configureBottomSheet(with: message, title: title, okButtonTitle: okButtonTitle, cancelButton: cancelButton)
        } else {
            configureAlert(with: message, title: title, okButtonTitle: okButtonTitle, cancelButton: cancelButton)
        }
	}
    
    @available (iOS 11, *)
    private func configureBottomSheet(with message: String, title: String, okButtonTitle: String?, cancelButton: Bool) {
        guard let rootViewWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first,
                let rootViewController = rootViewWindow.rootViewController else {
            return
        }
        
        let vc = UIViewController()
        let okButtonTitle = okButtonTitle ?? "updraft_alert_button_ok".localized
        let cancelButtonTitle = "Cancel"
        
        let okAction = AlertAction(title: okButtonTitle) {
            self.displayedAlert = nil
            self.output?.displayAlertInteractorUserDidConfirm(self)
        }
        
        var actions: [AlertAction] = [okAction]
        if cancelButton {
            let cancelAction = AlertAction(title: cancelButtonTitle) {
                vc.dismiss(animated: true, completion: nil)
                self.output?.displayAlertInteractorUserDidCancel(self)
            }
            actions.append(cancelAction)
        }

        let alertView = AlertController(title: title, message: message, actions: actions)
        
        vc.view = alertView
        rootViewController.present(vc, animated: true)
    }
    
    // For use with iOS 11 and prior
    private func configureAlert(with message: String, title: String, okButtonTitle: String?, cancelButton: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if cancelButton {
            let cancelAction = UIAlertAction(title: "updraft_alert_button_cancel".localized, style: .default) { [weak self] (_) in
                guard let strongSelf = self else {return}
                strongSelf.displayedAlert = nil
                strongSelf.output?.displayAlertInteractorUserDidCancel(strongSelf)
            }
            alert.addAction(cancelAction)
        }
        let okAction =     UIAlertAction(title: okButtonTitle ?? "updraft_alert_button_ok".localized, style: .default) { [weak self] (_) in
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
