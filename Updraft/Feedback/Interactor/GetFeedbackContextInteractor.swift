//
//  GetFeedbackContextInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol GetFeedbackContextInteractorInput {
	func getContext()
}

class GetFeedbackContextInteractor {
	
}

extension GetFeedbackContextInteractor: GetFeedbackContextInteractorInput {
	func getContext() {
		//TODO: Retrieve
		// 1. iOS Version - implement in appUtility ?
		let systemVersion = UIDevice.current.systemVersion // => appUtility
		// 2. iphone Model - implement in appUtility ?
		let model = UIDevice.current.model // => appUtility
		// 3. navigationStack - must be taken when screenshot is made , implement in appUtility ?
		
		// 4. device Id - implement in appUtility ?
		let uuid = UIDevice.current.identifierForVendor // => appUtility
		
		//Make a FeedbackContextModel ? with context info, comments, tags, screenshot, email
	}
}
