//
//  UserEmailInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 12.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol UserEmailInteractorInput {
	var email: String? {get set}
}

class UserEmailInteractor: UserEmailInteractorInput {
	
	struct Constants {
		static let UserDefaultsEmailKey = "Updraft.UserEmail"
	}
	
	var email: String? {
		get {
			return UserDefaults.standard.string(forKey: Constants.UserDefaultsEmailKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsEmailKey)
		}
	}
}
