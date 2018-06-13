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
	let message: String
	let tag: Tag
	
	enum Tag: String {
		case ux
		case bug
		case feedback
	}
}

struct FeedbackContextModel {
	let navigationStack: String
	let systemVersion: String
	let modelName: String
	let deviceUuid: String?
}
