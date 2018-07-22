//
//  SendFeedbackModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Success response model
struct SendFeedbackModel: Decodable {
	let imagePath: String
	let timestamp: String
	let tag: String
	let description: String
	let email: String
	let buildVersion: String
	let systemVersion: String
	let deviceName: String
	let deviceUudid: String
	let navigationStack: String
	
	enum CodingKeys: String, CodingKey {
		case imagePath = "image"
		case timestamp = "timestamp"
		case tag = "tag"
		case description = "description"
		case email = "email"
		case buildVersion = "build_version"
		case systemVersion = "system_version"
		case deviceName = "device_name"
		case deviceUudid = "device_uudid"
		case navigationStack = "navigation_stack"
	}
}
