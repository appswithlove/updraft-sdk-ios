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
	
	class var creteRegular: String { return "CreteRound-Regular" }
	class var creteItalic: String { return "CreteRound-Italic" }
	
	class var regularSmall: UIFont {
		let size: CGFloat = 14.0
		return UIFont(name: creteRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var regular: UIFont {
		let size: CGFloat = 16.0
		return UIFont(name: creteRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var regularMedium: UIFont {
		let size: CGFloat = 18.0
		return UIFont(name: creteRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var italicSmall: UIFont {
		let size: CGFloat = 14.0
		return UIFont(name: creteRegular, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var italic: UIFont {
		let size: CGFloat = 16.0
		return UIFont(name: creteItalic, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var italicMedium: UIFont {
		let size: CGFloat = 20
		return UIFont(name: creteItalic, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
	
	class var italicBig: UIFont {
		let size: CGFloat = 28.0
		return UIFont(name: creteItalic, size: size) ?? .systemFont(ofSize: size, weight: .regular)
	}
}
