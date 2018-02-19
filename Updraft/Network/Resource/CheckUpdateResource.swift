//
//  CheckUpdateModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct CheckUpdateResource: ApiResource {
	typealias Model = CheckUpdateModel
	
	var parameters: [String: AnyObject]?
	
	let endPoint = "/check_last_version"
	let method = NetworkMethod.post
	
	init(parameters: [String: AnyObject]? = nil) {
		self.parameters = parameters
	}
}
