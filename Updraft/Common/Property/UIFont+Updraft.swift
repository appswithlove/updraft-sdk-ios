//
//  UIFont+Updraft.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 04.07.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
	
	private class var creteRegular: String  { return "CreteRound-Regular" }
	private class var creteItalic: String  { return "CreteRound-Italic" }
	
	class var regularSmall: UIFont {
		return UIFont(name: creteRegular, size: 14.0)!
	}
	
	class var regular: UIFont {
		return UIFont(name: creteRegular, size: 16.0)!
	}
	
	class var regularMedium: UIFont {
		return UIFont(name: creteRegular, size: 18.0)!
	}
	
	class var italic: UIFont {
		return UIFont(name: creteItalic, size: 16.0)!
	}
	
	class var italicBig: UIFont {
		return UIFont(name: creteItalic, size: 28.0)!
	}
}
