//
//  NetworkRequestSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 12.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

struct DecodableMock: Decodable {
	var identifier: Int
}

class NetworkRequestSpy: NetworkRequest {
	var currentTask: URLSessionDataTask?
	
	typealias Model = DecodableMock
	var session: NetworkSession
	
	init(session: NetworkSession = URLSession.shared) {
		self.session = session
	}
}
