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
	/// - Parameters:
	///   - image: Image to be displayed
	///   - context: The context of the feedback
	func present(with image: UIImage, context: FeedbackContextModel)
}

enum FeedbackState {
	case edit(UIImage, email: String?)
	case sending(Float) // progress
	case error(String) // error message
	case success
}

/// Handle the presentation of the feedback view
class FeedbackPresenter: FeedbackPresenterInput, AppUtility, FeedbackViewControllerDelegate {
	
	let sendFeedbackInteractor: SendFeedbackInteractorInput
	var userEmailInteractor: UserEmailInteractorInput
	
	var context: FeedbackContextModel!

	var feedbackViewController: FeedbackViewController? {
		didSet {
			feedbackViewController?.delegate = self
		}
	}
	
	init(
		sendFeedbackInteractor: SendFeedbackInteractor = SendFeedbackInteractor(),
		userEmailInteractor: UserEmailInteractor = UserEmailInteractor()
		) {
		self.sendFeedbackInteractor = sendFeedbackInteractor
		self.userEmailInteractor = userEmailInteractor
		sendFeedbackInteractor.output = self
	}
	
	// MARK: FeedbackPresenterInput
	
	func present(with image: UIImage, context: FeedbackContextModel) {
		
		if let fbvc = feedbackViewController {
			guard !fbvc.isBeingDismissed && !fbvc.isBeingPresented && fbvc.viewIfLoaded?.window == nil else {return}
			feedbackViewController = nil
		}
		let email = userEmailInteractor.email
		self.feedbackViewController = FeedbackViewController(state: .edit(image, email: email))
		self.context = context
		self.topMostController?.present(feedbackViewController!, animated: true, completion: nil)
	}
	
	// MARK: - FeedbackViewControllerDelegate
	
	func feedbackViewControllerCancelWasTapped(_ sender: FeedbackViewController) {
		//TODO: Cancel upload request
	}
	
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel) {
		userEmailInteractor.email = model.email
		let feedbackModel = FeedbackModel(context: context, viewModel: model)
		//TODO: Send... with image , text etc.
		//sendFeedbackInteractor.sendFeedback()
		sender.dismiss(animated: true, completion: nil)
	}
	
	func feedbackViewControllerDismissWasTapped(_ sender: FeedbackViewController) {
		//TODO: Cancel any ongoing upload
		sender.dismiss(animated: true, completion: nil)
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
