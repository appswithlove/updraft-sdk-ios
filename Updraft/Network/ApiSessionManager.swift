//
//  ApiManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

final class ApiSessionManager {
	let session: URLSession
	
	init(session: URLSession) {
		self.session = session
	}
	
	convenience init() {
		let configuration = URLSessionConfiguration.default
		let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
		self.init(session: session)
	}
}
