//
//  FeedbackPresenter.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 09.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol FeedbackPresenterInput {
	/// Present the feedback overlay with given image
	///
	/// - Parameter image: Image to be displayed
	func present(with image: UIImage)
}

enum FeedbackState {
	case edit(UIImage?) // screenshot
	case sending(Float) // progress
	case error(String) // error message
	case success
}

/// Handle the presentation of the feedback view
class FeedbackPresenter: AppUtility {
	
	let sendFeedbackInteractor: SendFeedbackInteractorInput

	var feedbackViewController: FeedbackViewController? {
		didSet {
			feedbackViewController?.delegate = self
		}
	}
	
	init(sendFeedbackInteractor: SendFeedbackInteractor = SendFeedbackInteractor()) {
		self.sendFeedbackInteractor = sendFeedbackInteractor
		sendFeedbackInteractor.output = self
	}
}

// MARK: -  FeedbackPresenterInput

extension FeedbackPresenter: FeedbackPresenterInput {
	@objc func present(with image: UIImage) {
		
		if let fbvc = feedbackViewController {
			guard !fbvc.isBeingDismissed && !fbvc.isBeingPresented && fbvc.viewIfLoaded?.window == nil else {return}
			feedbackViewController = nil
		}
		self.feedbackViewController = FeedbackViewController(state: .edit(image))
		self.topMostController?.present(feedbackViewController!, animated: true, completion: nil)
	}
}

// MARK: - FeedbackViewControllerDelegate

extension FeedbackPresenter: FeedbackViewControllerDelegate {
	@objc func feedbackViewControllerCancelWasTapped(_ sender: FeedbackViewController) {
		sender.dismiss(animated: true, completion: nil)
	}
	
	@objc func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController) {
		//TODO: Send... with image , text etc.
		sendFeedbackInteractor.sendFeedback()
	}
}

// MARK: - SendFeedbackInteractorOuput

extension FeedbackPresenter: SendFeedbackInteractorOuput {
	func sendFeedbackInteractorSending(_ sender: SendFeedbackInteractor, progress: CGFloat) {
		
	}
	
	func sendFeedbackInteractorDidSend(_ sender: SendFeedbackInteractor) {
		
	}
	
	func sendFeedbackInteractorDidFail(_ sender: SendFeedbackInteractor, error: Error) {
		
	}
}
