//
//  IsFeedbackEnabledInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 18.10.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol IsFeedbackEnabledInteractorInput {
	
	func isEnabled()
}

protocol IsFeedbackEnabledInteractorOutput {
	func isFeedbackEnabled(isEnabled: Bool)
}

class IsFeedbackEnabledInteractor {
	
}
