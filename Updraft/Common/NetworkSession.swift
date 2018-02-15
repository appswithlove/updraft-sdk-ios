//
//  URLSessionProtocol.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol NetworkSession {
	func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
	func loadData(from url: URL,
				  completionHandler: @escaping (Data?, Error?) -> Void) {
		let task = dataTask(with: url) { (data, _, error) in
			completionHandler(data, error)
		}
		
		task.resume()
	}
}
