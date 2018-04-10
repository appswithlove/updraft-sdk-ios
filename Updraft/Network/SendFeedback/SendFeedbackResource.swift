//
//  SendFeedbackResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum SendFeedbackResource {
	case send(params: [String: Any])
}

extension SendFeedbackResource: ApiResource {
	var path: String {
		return "INSERT_PATH_HERE"
	}
	
	var method: NetworkMethod {
		return .post
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .send(let params):
			return params
		}
	}
}
