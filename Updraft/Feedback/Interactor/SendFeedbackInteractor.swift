//
//  SendFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol SendFeedbackInteractorInput {
	func sendFeedback()
}

protocol SendFeedbackInteractorOuput: class {
	func sendFeedbackInteractorSending(_ sender: SendFeedbackInteractor, progress: CGFloat)
	func sendFeedbackInteractorDidSend(_ sender: SendFeedbackInteractor)
	func sendFeedbackInteractorDidFail(_ sender: SendFeedbackInteractor, error: Error)
}

class SendFeedbackInteractor {

	private let sendFeedbackRequest: SendFeedbackRequest
	weak var output: SendFeedbackInteractorOuput?
	
	init(sendFeedbackRequest: SendFeedbackRequest = SendFeedbackRequest()) {
		self.sendFeedbackRequest = sendFeedbackRequest
	}
}

extension SendFeedbackInteractor: SendFeedbackInteractorInput {
	func sendFeedback() {
		//TODO: sendFeedbackRequest.load(with: .send(params: ), completion: <#T##(NetworkResult<SendFeedbackModel>) -> Void#>)
	}
}
