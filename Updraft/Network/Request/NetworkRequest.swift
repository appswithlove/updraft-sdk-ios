//
//  NetworkRequest.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

enum NetworkResult<T> {
	case success(T)
	case error(Error)
}

enum NetworkError: Error {
	case unknown
	case requestDeallocation
}

protocol NetworkRequest: class {
	associatedtype Model
	func load(withCompletion completion: @escaping (NetworkResult<Model>) -> Void)
	func decode(_ data: Data) throws -> Model
}

extension NetworkRequest {
	func load(_ url: URL, withCompletion completion: @escaping (NetworkResult<Model>) -> Void) {
		let configuration = URLSessionConfiguration.ephemeral
		let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
		let task = session.dataTask(with: url) { [weak self] (data, _, error) in
			guard let strongSelf = self else {
				completion(NetworkResult.error(NetworkError.requestDeallocation))
				return
			}
			
			guard let data = data else {
				let error = error ?? NetworkError.unknown
				completion(NetworkResult.error(error))
				return
			}
			
			do {
				let model = try strongSelf.decode(data)
				completion(NetworkResult.success(model))
				
			} catch let decodingError {
				completion(NetworkResult.error(decodingError))
			}
		}
		task.resume()
	}
}
