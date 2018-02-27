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
	
	func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
		completionHandler(data, error)
	}
	
	func loadData(from urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
		completionHandler(data, error)
	}
}