//
//  FeedbackDescriptionTextView.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 29.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class FeedbackDescriptionTextView: UIView {
	
	var text: String {
		return textView.text
	}
	
	private let textView = UITextView()
	private let placeholderTextView = UITextView()
	
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
		
		[textView, placeholderTextView].forEach {
			$0.backgroundColor = .clear
			$0.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
			$0.font = .italic
		}
		placeholderTextView.text = "Describe the issue...\nBrevity is the source of wit"
		placeholderTextView.textColor = .greyish
		placeholderTextView.isUserInteractionEnabled = false
		
		addSubview(placeholderTextView)
		placeholderTextView.stickToView(self)
		
		textView.delegate = self
		textView.textColor = .spaceBlack
		textView.keyboardAppearance = .dark
		
		addSubview(textView)
		textView.stickToView(self)
	}
}

// MARK: - UITextViewDelegate

extension FeedbackDescriptionTextView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		placeholderTextView.alpha = textView.text.isEmpty ? 1.0 : 0.0
	}
}
