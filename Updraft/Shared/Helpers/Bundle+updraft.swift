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
		//TODO: how to detect if integrated using SPM or not (cocoapods, carthage), i.e. if Bundle.module or Updraft.self needs to be used ?
		// currently using a separate branch...
//		return Bundle(for: Updraft.self)
		return .module
	}
}
