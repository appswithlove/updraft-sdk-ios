//
//  FeedbackEnabledModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct FeedbackEnabledModel: Decodable {
	
	var isFeedbackEnabled: Bool
	
	enum CodingKeys: String, CodingKey {
		case isFeedbackEnabled = "is_feedback_enabled"
	}
}
