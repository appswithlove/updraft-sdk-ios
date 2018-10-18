//
//  FeedbackEnabledResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum FeedbackEnabledResource {
	case isEnabled(params: [String: Any]?)
}

extension FeedbackEnabledResource: ApiResource {
	
	var path: String {
		return "/feedback-mobile-enabled/"
	}
	
	var method: NetworkMethod {
		return .post
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .isEnabled(let params):
			return params
		}
	}
}
