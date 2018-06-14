//
//  ApiResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol ApiResource {
	
	/// Relative path of the endpoint for the call (eg. `/check_last_version/`).
	var path: String { get }
	
	///HTTP method that should be used to perform the call.
	var method: NetworkMethod { get }
	
	///Parameters to send along the call.
	var parameters: [String: Any]? { get }
}

extension ApiResource {
	
	var base: String {
		return "https://getupdraft.com/api"
	}
	
	var basePath: String {
		return "/api"
	}
	
	var urlComponents: URLComponents {
		var components = URLComponents(string: base)!
		components.path = basePath + path
		return components
	}
	
	var urlRequest: URLRequest? {

		var request = URLRequest(url: urlComponents.url!)
		request.httpMethod = method.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		if let params = self.parameters {
			let data = try? JSONSerialization.data(withJSONObject: params, options: [])
			request.httpBody = data
		}
		
		return request
	}
}
