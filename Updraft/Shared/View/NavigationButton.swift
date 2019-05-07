//
//  NavigationButton.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class NavigationButton: UIButton {
	
	private let underlinedTitleAttributes: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key.font: UIFont.regular,
		NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
	]
	
	// MARK: - Public Interface
	
	var title: String = "" {
		didSet {
			setUnderlinedTitle(title)
		}
	}
	
	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	// MARK: - Setup
	
	private func setup() {
		tintColor = .macaroniAndCheese
		setUnderlinedTitle(title)
	}
	
	// MARK: - Private implementation
	
	private func setUnderlinedTitle(_ text: String) {
		let attributedString = NSAttributedString(string: text, attributes: underlinedTitleAttributes)
		setAttributedTitle(attributedString, for: .normal)
	}
}
