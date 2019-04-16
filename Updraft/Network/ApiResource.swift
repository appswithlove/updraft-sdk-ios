//
//  ApiResource.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol ApiResource {
	
	/// Relative path of the endpoint for the call (eg. `/check_last_version/`).
	var path: String { get }
	
	///HTTP method that should be used to perform the call.
	var method: NetworkMethod { get }
	
	///Parameters to send along the call.
	var parameters: [String: Any]? { get }
	
	/// Parameters and data for multiform data request.
	var multiFormParameters: ([String: String]?, Data)? { get }
}

extension ApiResource {
	
	var base: String {
		return Updraft.shared.baseUrl ?? "https://getupdraft.com/" // Staging: https://u2.mqd.me/api Prod: https://getupdraft.com/api
	}
	
	var basePath: String {
		return "/api"
	}
	
	var urlComponents: URLComponents {
		var components = URLComponents(string: base)!
		components.path = basePath + path
		return components
	}
	
	var urlRequest: URLRequest? {

		var request = URLRequest(url: urlComponents.url!)
		request.httpMethod = method.rawValue
		
		if let params = self.multiFormParameters, method == .post {
			let boundary = generateBoundaryString()
			request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
			request.httpBody = createBodyWithParameters(parameters: params.0, filePathKey: "image", imageDataKey: params.1, boundary: boundary)
		} else {
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("application/json", forHTTPHeaderField: "Accept")
			if let params = self.parameters {
				let data = try? JSONSerialization.data(withJSONObject: params, options: [])
				request.httpBody = data
			}
		}
		return request
	}
	
	var parameters: [String: Any]? {
		return nil
	}
	
	var multiFormParameters: ([String: String]?, Data)? {
		return nil
	}
	
	// MARK: - Convenience
	
	/// Create boundary string for multipart/form-data request
	///
	/// - returns:	The boundary string that consists of "Boundary-" followed by a UUID string.
	
	private func generateBoundaryString() -> String {
		return "Boundary-\(UUID().uuidString)"
	}
	
	/// Create body of the `multipart/form-data` request. Default mimetype is `image/jpg`.
	///
	/// - Parameters:
	///   - parameters: The optional dictionary containing keys and values to be passed to web service
	///   - filePathKey: The field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
	///   - imageDataKey: The image data
	///   - mimeType: The imageData mimetype
	///   - boundary: The `multipart/form-data` boundary
	/// - Returns: The `Data` of the body of the request
	private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String, imageDataKey: Data, mimetype: String = "image/jpg", boundary: String) -> Data {
		
		var body = Data()
		
		if let params = parameters {
			for(key, value) in params {
				body.append("--\(boundary)\r\n")
				body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.append("\(value)\r\n")
			}
		}
		
		let filename = "feedback.jpg"
		
		body.append("--\(boundary)\r\n")
		body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
		body.append("Content Type: \(mimetype)\r\n\r\n")
		body.append(imageDataKey)
		body.append("\r\n")
		
		body.append("--\(boundary)--\r\n")
		
		return body
	}
}

private extension Data {
	
	/// Append string to Data
	///
	/// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
	///   - string: The string to be added to the `Data`.
	mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
		if let data = string.data(using: encoding) {
			append(data)
		}
	}
}
