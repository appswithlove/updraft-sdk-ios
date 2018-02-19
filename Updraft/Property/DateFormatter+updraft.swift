//
//  DateFormatter+up.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 19.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

extension DateFormatter {
	static var updraft: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
		return formatter
	}
}
