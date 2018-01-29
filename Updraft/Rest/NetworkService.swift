//
//  NetworkService.swift
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

protocol ApiResource {
	associatedtype Model where Model: Decodable
	var endPoint: String { get }
	
	func makeModel(data: Data) throws -> [Model]
}

extension ApiResource {
	var url: URL {
		let baseUrl = "https://api.stackexchange.com/2.2"
		let url = baseUrl + endPoint
		return URL(string: url)!
	}
	
	func makeModel(data: Data) throws -> [Model] {
		let decoder = JSONDecoder()
		
		do {
			let models = try decoder.decode([Model].self, from: data)
			return models
		} catch let error {
			throw error
		}
	}
}

struct AutoUpdateModel: Decodable {
	let updateUrl: String
}

struct AutoUpdateResource: ApiResource {
	
	typealias Model = AutoUpdateModel
	
	let endPoint = "/checkUpdate"
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

class ApiRequest<Resource: ApiResource> {
	let resource: Resource
	
	init(resource: Resource) {
		self.resource = resource
	}
}

extension ApiRequest: NetworkRequest {
	typealias Model = [Resource.Model]
	
	func load(withCompletion completion: @escaping (NetworkResult<ApiRequest<Resource>.Model>) -> Void) {
		self.load(resource.url, withCompletion: completion)
	}

	func decode(_ data: Data) throws -> ApiRequest<Resource>.Model {
		do {
			let models = try resource.makeModel(data: data)
			return models
		} catch {
			throw error
		}
	}
}

protocol AutoUpdateNetworkServiceInterface {
	func checkUpdate(completion: @escaping (NetworkResult<AutoUpdateModel>) -> Void)
}

class AutoUpdateNetworkService: AutoUpdateNetworkServiceInterface {
	
	var request: AnyObject?
	
	func checkUpdate(completion: @escaping (NetworkResult<AutoUpdateModel>) -> Void) {
		let autoUpdateResource = AutoUpdateResource()
		let autoUpdateRequest = ApiRequest(resource: autoUpdateResource)
		self.request = autoUpdateRequest
		
		autoUpdateRequest.load { (result) in
			switch result {
			case .success(let models):
				if let model = models.first {
					completion(NetworkResult.success(model))
				} else {
					completion(NetworkResult.error(NetworkError.unknown))
				}
			case .error(let error):
				completion(NetworkResult.error(error))
			}
		}
	}
}
