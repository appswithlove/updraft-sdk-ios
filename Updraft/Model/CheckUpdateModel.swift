//
//  CheckUpdateModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 15.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct CheckUpdateModel: Decodable {
	
	var lastBuildDate: String
	var releaseNotes: String
	var updraftVersion: String
	var onDeviceVersion: String
	var isNewVersionAvailable: Bool
	
	enum CodingKeys: String, CodingKey {
		case lastBuildDate = "create_at"
		case releaseNotes = "whats_new"
		case updraftVersion = "version"
		case onDeviceVersion = "your_version"
		case isNewVersionAvailable = "is_new_version"
	}
}
