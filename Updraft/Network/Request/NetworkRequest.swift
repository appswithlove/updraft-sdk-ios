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
}

enum NetworkMethod: String {
	case get = "GET"
	case post = "POST"
}

protocol NetworkRequest: class {
	associatedtype Model
	func load(withCompletion completion: @escaping (NetworkResult<Model>) -> Void)
	func decode(_ data: Data) throws -> Model
	var session: NetworkSession {get}
}

extension NetworkRequest {
	func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (NetworkResult<Model>) -> Void) {
		session.loadData(from: urlRequest) { [weak self] (data, error) in
			guard let strongSelf = self else { return }
			completion(strongSelf.responseHandler(data: data, error: error))
		}
	}
	
	func load(_ url: URL, withCompletion completion: @escaping (NetworkResult<Model>) -> Void) {
		session.loadData(from: url) { [weak self] (data, error) in
			guard let strongSelf = self else { return }
			completion((strongSelf.responseHandler(data: data, error: error)))
		}
	}
	
	fileprivate func responseHandler(data: Data?, error: Error?) -> NetworkResult<Model> {
		guard let data = data else {
			let error = error ?? NetworkError.unknown
			return NetworkResult.error(error)
		}
		
		do {
			let model = try self.decode(data)
			return NetworkResult.success(model)
		} catch let decodingError {
			return NetworkResult.error(decodingError)
		}
	}
}
