//
//  String+localized.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

extension String {
	var localized: String {
		return NSLocalizedString(self, bundle: Bundle.updraft, comment: "")
	}
}
