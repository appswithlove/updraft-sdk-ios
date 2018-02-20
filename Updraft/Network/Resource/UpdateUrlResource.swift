//
//  UpdateUrlResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct UpdateUrlResource: ApiResource {
	typealias Model = UpdateUrlModel
	
	var parameters: [String: Any]?
	
	let endPoint = "/get_last_version/"
	let method = NetworkMethod.post
	
	init(parameters: [String: Any]? = nil) {
		self.parameters = parameters
	}
}