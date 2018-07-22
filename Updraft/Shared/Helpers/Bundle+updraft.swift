//
//  Bundle+updraft.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.07.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

extension Bundle {
	static var updraft: Bundle {
		return Bundle(for: Updraft.self)
	}
}
