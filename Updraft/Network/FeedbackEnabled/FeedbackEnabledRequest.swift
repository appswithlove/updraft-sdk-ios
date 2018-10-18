//
//  FeedbackEnabledRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class FeedbackEnabledRequest: NetworkRequest {
	typealias Model = FeedbackEnabledModel
	var currentTask: URLSessionDataTask?
	
	var session: NetworkSession
	
	init(session: NetworkSession = URLSession.shared) {
		self.session = session
	}
	
	func load(with resource: FeedbackEnabledResource, completion: @escaping (NetworkResult<Model>) -> Void) {
		load(resource.urlRequest!, withCompletion: completion)
	}
}
