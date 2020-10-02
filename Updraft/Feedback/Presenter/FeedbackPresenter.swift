//
//  FeedbackPresenter.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 09.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol FeedbackPresenterInput {
	/// Present the feedback overlay with given image
	///
	/// - Parameters:
	///   - image: Image to be displayed
	///   - context: The context of the feedback
	func present(with image: UIImage, context: FeedbackContextModel)
	var isVisible: Bool {get}
	func dismiss()
}

enum FeedbackState {
	case edit(UIImage, email: String?)
	case sending(Float) // progress
	case error(String) // error message
	case success
}

/// Handle the presentation of the feedback view
class FeedbackPresenter: FeedbackPresenterInput, AppUtility, FeedbackViewControllerDelegate {
	
	private let notification = UINotificationFeedbackGenerator()
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
	
	var isVisible: Bool {
		return feedbackViewController?.viewIfLoaded?.window != nil
	}
	
	func dismiss() {
		feedbackViewController?.dismiss(animated: true, completion: nil)
	}
	
	func present(with image: UIImage, context: FeedbackContextModel) {
		
		if let fbvc = feedbackViewController {
			guard !fbvc.isBeingDismissed && !fbvc.isBeingPresented && fbvc.viewIfLoaded?.window == nil else {return}
			feedbackViewController = nil
		}
		let email = userEmailInteractor.email
		self.feedbackViewController = FeedbackViewController(email: email, image: image)
        feedbackViewController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        feedbackViewController?.modalPresentationStyle = UIModalPresentationStyle.custom
		self.context = context
		self.topMostController?.present(feedbackViewController!, animated: true, completion: nil)
	}
	
	// MARK: - FeedbackViewControllerDelegate
	
	func feedbackViewControllerCancelledSending(_ sender: FeedbackViewController) {
		sendFeedbackInteractor.cancel()
	}
	
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel) {
		userEmailInteractor.email = model.email
		let feedbackModel = FeedbackModel(context: context, viewModel: model)
		sendFeedbackInteractor.sendFeedback(feedbackModel)
	}
	
	func feedbackViewControllerDismissWasTapped(_ sender: FeedbackViewController) {
		sendFeedbackInteractor.cancel()
		sender.dismiss(animated: true, completion: nil)
	}
}

// MARK: - SendFeedbackInteractorOuput

extension FeedbackPresenter: SendFeedbackInteractorOuput {
	
	func sendFeedbackInteractorSending(_ sender: SendFeedbackInteractor, progress: Double) {
		feedbackViewController?.updateProgress(Float(progress))
	}
	
	func sendFeedbackInteractorDidSend(_ sender: SendFeedbackInteractor) {
		feedbackViewController?.updateProgress(Float(1.0))
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			self.notification.notificationOccurred(.success)
			self.feedbackViewController?.dismiss(animated: true, completion: nil)
		}
	}
	
	func sendFeedbackInteractorDidFail(_ sender: SendFeedbackInteractor, error: Error) {
		self.notification.notificationOccurred(.error)
		feedbackViewController?.displayError("updraft_feedback_send_failure_subtitle".localized)
	}
	
	func sendFeedbackInteractorDidCancel(_ sender: SendFeedbackInteractor) {
		feedbackViewController?.updateProgress(Float(0.0))
	}
}
