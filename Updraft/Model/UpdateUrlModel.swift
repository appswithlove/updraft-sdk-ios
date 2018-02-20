//
//  UpdateUrlModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 30.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct UpdateUrlModel: Decodable {
	let updateUrl: String
	
	enum CodingKeys: String, CodingKey {
		case updateUrl = "update_url"
	}
}
