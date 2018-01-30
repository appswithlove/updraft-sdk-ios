//
//  ApiRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class ApiRequest<Resource: ApiResource> {
	let resource: Resource
	
	init(resource: Resource) {
		self.resource = resource
	}
}

extension ApiRequest: NetworkRequest {
	typealias Model = Resource.Model
	
	func load(withCompletion completion: @escaping (NetworkResult<ApiRequest<Resource>.Model>) -> Void) {
		self.load(resource.url, withCompletion: completion)
	}
	
	func decode(_ data: Data) throws -> ApiRequest<Resource>.Model {
		do {
			let model = try resource.makeModel(data: data)
			return model
		} catch {
			throw error
		}
	}
}
