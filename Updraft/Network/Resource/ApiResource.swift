//
//  ApiResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol ApiResource {
	associatedtype Model where Model: Decodable
	var endPoint: String { get }
	var method: NetworkMethod { get }
	var parameters: [String: AnyObject]? { get }
	
	func makeModel(data: Data) throws -> Model
}

extension ApiResource {
	
	var url: URL {
		let baseUrl = "https://u2.mqd.me/api"
		let url = baseUrl + endPoint
		return URL(string: url)!
	}
	
	var urlRequest: URLRequest? {
		guard let params = self.parameters else { return nil }
		
		let data = try? JSONSerialization.data(withJSONObject: params, options: [])
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = data
		
		return request
	}
	
	func makeModel(data: Data) throws -> Model {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		do {
			let models = try decoder.decode(Model.self, from: data)
			return models
		} catch let error {
			throw error
		}
	}
}
