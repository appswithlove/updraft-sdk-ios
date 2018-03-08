//
//  UpdateUrlRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 08.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class UpdateUrlRequest: NetworkRequest {
	typealias Model = UpdateUrlModel
	
	var session: NetworkSession
	
	init(session: URLSession = .shared) {
		self.session = session
	}
	
	func load(with resource: UpdateUrlResource, completion: @escaping (NetworkResult<Model>) -> Void) {
		load(resource.urlRequest!, withCompletion: completion)
	}
}
