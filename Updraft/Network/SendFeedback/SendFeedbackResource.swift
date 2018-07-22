//
//  SendFeedbackResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum SendFeedbackResource {
	case send(params: [String: String], imageData: Data)
}

extension SendFeedbackResource: ApiResource {
	
	var path: String {
		return "/feedback-mobile/"
	}
	
	var method: NetworkMethod {
		return .post
	}
	
	var multiFormParameters: ([String: String]?, Data)? {
		switch self {
		case .send(let params, let imageData):
			return (params, imageData)
		}
	}
}
