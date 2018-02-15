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
	
	func makeModel(data: Data) throws -> Model
}

extension ApiResource {
	var url: URL {
		let baseUrl = "https://api.stackexchange.com/2.2"
		let url = baseUrl + endPoint
		return URL(string: url)!
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
