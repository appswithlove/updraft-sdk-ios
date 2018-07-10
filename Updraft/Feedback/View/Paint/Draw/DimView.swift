//
//  DimView.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

class DimView: UIView {
	
	private let label = UILabel()
	private let dimmedView = UIView()
	
	// MARK: - Public Interface
	
	var title: String? {
		didSet {
			label.text = title
		}
	}
	
	func hide() {
		guard alpha != 0.0 else { return }
		UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0, options: [], animations: {
			self.alpha = 0.0
		}, completion: nil)
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
	
	// MARK: - Private Implementation
	
	private func setup() {
		isUserInteractionEnabled = false
		setupLabel()
		setupDimmedView()
		bringSubview(toFront: label)
	}
	
	private func setupLabel() {
		label.textColor = .macaroniAndCheese
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .italicBig
		addSubview(label)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
	}
	
	private func setupDimmedView() {
		dimmedView.backgroundColor = UIColor(red: 56/255.0, green: 56/255.0, blue: 60/255.0, alpha: 0.7)
		addSubview(dimmedView)
		dimmedView.stickToView(self)
	}
}
