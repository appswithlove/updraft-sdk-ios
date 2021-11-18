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
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: Updraft.self)
        #endif
		return bundle
	}
}
