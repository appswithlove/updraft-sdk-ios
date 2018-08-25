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
	case invalidData
	case unsuccessfulResponse(Int) //Status code
	case requestFailed
	
	var localizedDescription: String {
		switch self {
		case .invalidData:
			return "Invalid Data"
		case .unsuccessfulResponse(let code):
			return "Recieved unsuccesful response with code: \(code)"
		case .requestFailed:
			return "Request failed"
		}
	}
}

/// This defines the type of HTTP method used to perform the request
///
/// - get: GET method
/// - post: POST method
enum NetworkMethod: String {
	case get = "GET"
	case post = "POST"
}

protocol NetworkRequest: class {
	///Result Model that must conform to Decodable
	associatedtype Model where Model: Decodable
	func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (NetworkResult<Model>) -> Void)
	func load(_ urlRequest: URLRequest)
	func cancelCurrentTask()
	func decode(_ data: Data) throws -> Model
	func logRequest(_ request: URLRequest)
	func logResponse(request: URLRequest?, data: Data?, response: URLResponse?, error: Error?)
	var session: NetworkSession {get}
	var currentTask: URLSessionDataTask? {get set}
}

extension NetworkRequest {
	
	func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (NetworkResult<Model>) -> Void) {
		logRequest(urlRequest)
		currentTask = session.loadData(from: urlRequest) { [weak self] (data, response, error) in
			guard let strongSelf = self else { return }
			strongSelf.logResponse(request: urlRequest, data: data, response: response, error: error)
			let result = strongSelf.responseHandler(data: data, response: response, error: error)
			
			//Dispatch result to main queue
			dispatchToMainThread {
				completion(result)
			}
		}
	}
	
	func load(_ urlRequest: URLRequest) {
		logRequest(urlRequest)
		currentTask = session.loadData(from: urlRequest)
	}
	
	func cancelCurrentTask() {
		currentTask?.cancel()
	}
	
	func responseHandler(data: Data?, response: URLResponse?, error: Error?) -> NetworkResult<Model> {
		
		guard let httpResponse = response as? HTTPURLResponse else {
			return NetworkResult.error(error ?? NetworkError.requestFailed)
		}
	
		guard  (200..<300).contains(httpResponse.statusCode) else {
			return NetworkResult.error(error ?? NetworkError.unsuccessfulResponse(httpResponse.statusCode))
		}
		
		guard let data = data else {
			let error = error ?? NetworkError.invalidData
			return NetworkResult.error(error)
		}
		
		do {
			let model = try self.decode(data)
			return NetworkResult.success(model)
		} catch let decodingError {
			return NetworkResult.error(decodingError)
		}
	}
	
	func decode(_ data: Data) throws -> Model {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(DateFormatter.updraft)
		do {
			let models = try decoder.decode(Model.self, from: data)
			return models
		} catch {
			throw error
		}
	}
	
	func logRequest(_ request: URLRequest) {
		Logger.log(
			"""
			Loading URL request:
			\(request.logMessage)
			""",
			level: .debug)
	}
	
	func logResponse(request: URLRequest?, data: Data?, response: URLResponse?, error: Error?) {
		guard let request = request else { return }
		
		let logResponse: String = {
			guard let response = response else { return "NO RESPONSE" }
			return response.debugDescription
		}()
		
		let logData: String = {
			guard let data = data else { return "NO DATA" }
			return String(data: data, encoding: .utf8) ?? "DATA NOT .utf8 STRING DECODABLE"
		}()
		
		let logError: String = {
			guard let error = error else { return "NO ERROR" }
			return error.localizedDescription
		}()
		
		Logger.log(
			"""
			Recieved Response for URL Request:
			********** REQUEST *********
			\(request.logMessage)
			********** RESPONSE *********
			response: \(logResponse)
			data: \(logData)
			error: \(logError)
			"""
			,
			level: .debug)
	}
}
