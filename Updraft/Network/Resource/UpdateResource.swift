//
//  UpdateResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct UpdateResource: ApiResource {
	typealias Model = UpdateModel
	
	let endPoint = "/checkUpdate"
}
