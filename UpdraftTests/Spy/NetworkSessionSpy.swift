//
//  NetworkSessionSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class NetworkSessionSpy: NetworkSession {
	var data: Data?
	var error: Error?
	var response: URLResponse?
	var dataTask: URLSessionDataTask?
	
	func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		completionHandler(data, response, error)
		return dataTask ?? URLSessionDataTask()
	}
	
	func loadData(from urlRequest: URLRequest) -> URLSessionDataTask {
		return dataTask ?? URLSessionDataTask()
	}
}
