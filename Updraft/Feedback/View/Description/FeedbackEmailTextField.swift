//
//  FeedbackEmailTextField.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 29.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class FeedbackEmailTextField: UITextField {
	
	private struct Constants {
		static let edgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
		static let placeholderAttributes: [NSAttributedStringKey: Any] = [
			NSAttributedStringKey.foregroundColor: UIColor.greyish,
			NSAttributedStringKey.font: UIFont.italic]
	}
	
	// MARK: - Overrides
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, Constants.edgeInsets)
	}

	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, Constants.edgeInsets)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, Constants.edgeInsets)
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
		font = .italic
		attributedPlaceholder = NSAttributedString(
			string: "updraft_feedback_textField_email_placeholder".localized,
			attributes: Constants.placeholderAttributes
		)
		keyboardType = .emailAddress
		keyboardAppearance = .dark
	}
}
