//
//  URLSessionProtocol.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol NetworkSession {
	func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
	
	func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
		let task = dataTask(with: urlRequest) { (data, response, error) in
			completionHandler(data, response, error)
		}
		task.resume()
	}
}
