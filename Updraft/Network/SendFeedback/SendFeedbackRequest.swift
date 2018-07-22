//
//  SendFeedbackRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class SendFeedbackRequest: NSObject, NetworkRequest {
	
	typealias Model = SendFeedbackModel
	
	var session: NetworkSession
	var responseData = Data()
	var progressHandler: ((Double) -> Void)?
	var completionHandler: ((NetworkResult<SendFeedbackModel>) -> Void)?
	var currentTask: URLSessionDataTask?
	
	init(session: NetworkSession = URLSession.shared) {
		self.session = session
	}
	
	convenience override init() {
		self.init(session: URLSession.shared)
		let configuration = URLSessionConfiguration.default
		session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
	}
	
	func load(with resource: SendFeedbackResource, progress: @escaping (Double) -> Void, completion: @escaping (NetworkResult<SendFeedbackModel>) -> Void) {
		responseData.removeAll()
		load(resource.urlRequest!)
		progressHandler = progress
		completionHandler = completion
	}
}

// MARK: - URLSessionDelegate, URLSessionDataDelegate

extension SendFeedbackRequest: URLSessionDelegate, URLSessionDataDelegate {
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		print("\nSession \(session) upload completed, response \(String(describing: NSString.init(data: responseData, encoding: String.Encoding.utf8.rawValue)))")
		let result = responseHandler(data: responseData, response: task.response, error: error)
		completionHandler?(result)
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		responseData.append(data)
	}
	
	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		completionHandler(.allow)
	}
	
	func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		let uploadProgress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
		print("Upload Feedback Progress: \(uploadProgress)")
		progressHandler?(uploadProgress)
	}
}
