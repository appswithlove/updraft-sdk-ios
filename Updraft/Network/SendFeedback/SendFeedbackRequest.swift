//
//  SendFeedbackRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class SendFeedbackRequest: NetworkRequest {
	typealias Model = SendFeedbackModel
	
	var session: NetworkSession
	
	init(session: NetworkSession = URLSession.shared) {
		self.session = session
	}
	
	func load(with resource: SendFeedbackResource, completion: @escaping (NetworkResult<SendFeedbackModel>) -> Void) {
		load(resource.urlRequest!, withCompletion: completion)
	}
}
