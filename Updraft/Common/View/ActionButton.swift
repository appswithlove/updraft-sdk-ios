//
//  ActionButton.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 27.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
	
	// MARK: - Overrides
	
	override var isEnabled: Bool {
		didSet {
			backgroundColor = isEnabled ? .macaroniAndCheese : .greyish
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
		tintColor = .white
		backgroundColor = .macaroniAndCheese
		titleLabel?.font = .regular
		setTitleColor(.white, for: .normal)
	}
}
