//
//  UpdateUrlResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum UpdateUrlResource {
	case getUpdateUrl(params: [String: Any]?)
}

extension UpdateUrlResource: ApiResource {
	
	var path: String {
		return "/get_last_version/"
	}
	
	var method: NetworkMethod {
		return .post
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .getUpdateUrl(let params):
			return params
		}
	}
}
