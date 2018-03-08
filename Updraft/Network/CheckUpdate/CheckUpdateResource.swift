//
//  CheckUpdateModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum CheckUpdateResource {
	case checkUpdate(params: [String: Any]?)
}

extension CheckUpdateResource: ApiResource {
	
	var path: String {
		return "/check_last_version/"
	}
	
	var method: NetworkMethod {
		return .post
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .checkUpdate(let params):
			return params
		}
	}
}
