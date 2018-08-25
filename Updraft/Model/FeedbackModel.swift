//
//  FeedbackModel.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 11.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

struct FeedbackModel {
	let context: FeedbackContextModel
	let viewModel: FeedbackViewModel
}

struct FeedbackViewModel {
	let image: UIImage
	let email: String
	let description: String
	let tag: Tag
	
	enum Tag: String {
		case design
		case bug
		case feedback
		
		var localized: String {
			switch self {
			case .design:
				return "updraft_feedback_type_design".localized
			case .bug:
				return "updraft_feedback_type_bug".localized
			case .feedback:
				return "updraft_feedback_type_feedback".localized
			}
		}
		
		static func all() -> [Tag] {
			return [Tag.bug, Tag.design, Tag.feedback]
		}
	}
}

struct FeedbackContextModel {
	let buildVersion: String
	let navigationStack: String
	let systemVersion: String
	let modelName: String
	let deviceUuid: String?
}
