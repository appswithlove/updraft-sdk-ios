//
//  FeedbackPresenterSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class FeedbackPresenterSpy: FeedbackPresenter {
	
	var presentWasCalled: Bool = false
	var sendWasTappedWasCalled: Bool = false
	var cancelWasTappedWasCalled: Bool = false
	var imageToPresent: UIImage?
	var feedbackModel: FeedbackViewModel?
	
	override func present(with image: UIImage, context: FeedbackContextModel) {
		presentWasCalled = true
		imageToPresent = image
	}
	
	override func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel) {
		sendWasTappedWasCalled = true
		feedbackModel = model
	}
	
	override func feedbackViewControllerCancelledSending(_ sender: FeedbackViewController) {
		cancelWasTappedWasCalled = true
	}
}
