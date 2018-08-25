//
//  URLRequest+logMessage.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 24.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

extension URLRequest {
	var logMessage: String {
		let message =
		"""
		url: \(logUrl)
		method: \(logMethod)
		headers: \(logHeaders)
		data: \(logData)
		"""
		return message
	}
	
	private var logUrl: String {
		guard let url = self.url else { return "NO URL" }
		return url.debugDescription
	}
	
	private var logMethod: String {
		guard let method = self.httpMethod else { return "NO METHOD SED" }
		return method.debugDescription
	}
	
	private var logHeaders: String {
		guard let headers = self.allHTTPHeaderFields else { return "NO HEADER" }
		return headers.debugDescription
	}
	
	private var logData: String {
		guard let data = self.httpBody else { return "NO DATA" }
		let decodedData = String(data: data, encoding: .utf8) ?? "DATA NOT .utf8 STRING DECODABLE"
		return decodedData
	}
}
