//
//  Print.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 20.02.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

//Print only in DEBUG
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
	#if DEBUG
		Swift.print(items[0], separator: separator, terminator: terminator)
	#endif
}
