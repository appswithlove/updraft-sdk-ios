//
//  SendFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol SendFeedbackInteractorInput {
	func sendFeedback(_ feedback: FeedbackModel)
	/// Cancel any ongoing upload request
	func cancel()
}

protocol SendFeedbackInteractorOuput: AnyObject {
	func sendFeedbackInteractorSending(_ sender: SendFeedbackInteractor, progress: Double)
	func sendFeedbackInteractorDidSend(_ sender: SendFeedbackInteractor)
	func sendFeedbackInteractorDidFail(_ sender: SendFeedbackInteractor, error: Error)
	func sendFeedbackInteractorDidCancel(_ sender: SendFeedbackInteractor)
}

class SendFeedbackInteractor: NSObject {

	private let sendFeedbackRequest: SendFeedbackRequest
	private var settings: Settings
	weak var output: SendFeedbackInteractorOuput?
	
	init(
		settings: Settings = Settings(),
		sendFeedbackRequest: SendFeedbackRequest = SendFeedbackRequest()) {
		
		self.sendFeedbackRequest = sendFeedbackRequest
		self.settings = settings
	}
	
	private func createParametersFrom(_ model: FeedbackModel) -> [String: String] {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey,
			"tag": model.viewModel.tag.rawValue,
			"description": model.viewModel.description,
			"email": model.viewModel.email,
			"build_version": model.context.buildVersion,
			"system_version": model.context.systemVersion,
			"device_name": model.context.modelName,
			"device_uudid": model.context.deviceUuid ?? "",
			"navigation_stack": model.context.navigationStack
		]
		return parameters
	}
	
	private func interpretError(_ error: Error) {
		if (error as NSError).code == NSURLErrorCancelled {
			Logger.log("Feedback sending was cancelled: \(error.localizedDescription)", level: .info)
			output?.sendFeedbackInteractorDidCancel(self)
		} else {
			Logger.log("Failed to send feedback, reason: \(error.localizedDescription)", level: .error)
			output?.sendFeedbackInteractorDidFail(self, error: error)
		}
	}
}

extension SendFeedbackInteractor: SendFeedbackInteractorInput {
	func sendFeedback(_ feedback: FeedbackModel) {
		let sendingData = feedback.viewModel.sendingData
		let parameters = createParametersFrom(feedback)
		
		sendFeedbackRequest.load(with: .send(params: parameters, imageData: sendingData), progress: { [weak self] progress in
			guard let strongSelf = self else { return }
			strongSelf.output?.sendFeedbackInteractorSending(strongSelf, progress: progress)
		}, completion: { [weak self] result in
			guard let strongSelf = self else { return }
			switch result {
			case .success:
				Logger.log("Feedack sent with success!", level: .info)
				strongSelf.output?.sendFeedbackInteractorDidSend(strongSelf)
			case .error(let error):
				strongSelf.interpretError(error)
			}
		})
	}
	
	func cancel() {
		sendFeedbackRequest.cancelCurrentTask()
	}
}
