//
//  ApiManager.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

class ApiSessionManager {
	let session: URLSession
	
	init(
		session: URLSession = URLSession.shared) {
		self.session = session
	}
}
