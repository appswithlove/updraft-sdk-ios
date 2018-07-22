//
//  SendFeedbackInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol SendFeedbackInteractorInput {
	func sendFeedback(_ feedback: FeedbackModel)
	/// Cancel any ongoing upload request
	func cancel()
}

protocol SendFeedbackInteractorOuput: class {
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
	
	private func jpegRepresentationFrom(_ image: UIImage) -> Data {
		return UIImageJPEGRepresentation(image, 1.0) ?? Data()
	}
	
	private func interpretError(_ error: Error) {
		if (error as NSError).code == NSURLErrorCancelled {
			output?.sendFeedbackInteractorDidCancel(self)
		} else {
			output?.sendFeedbackInteractorDidFail(self, error: error)
		}
	}
}

extension SendFeedbackInteractor: SendFeedbackInteractorInput {
	func sendFeedback(_ feedback: FeedbackModel) {
		let imageData = jpegRepresentationFrom(feedback.viewModel.image)
		let parameters = createParametersFrom(feedback)
		
		sendFeedbackRequest.load(with: .send(params: parameters, imageData: imageData), progress: { [weak self] progress in
			guard let strongSelf = self else { return }
			strongSelf.output?.sendFeedbackInteractorSending(strongSelf, progress: progress)
		}, completion: { [weak self] result in
			guard let strongSelf = self else { return }
			switch result {
			case .success(let feedbackModel):
				print(feedbackModel)
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
