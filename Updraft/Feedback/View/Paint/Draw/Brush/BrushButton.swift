//
//  BrushButton.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 25.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

@IBDesignable class BrushButton: UIButton {
	
	private let shadowColor = UIColor.shadowBlue.cgColor
	
	var borderColor: UIColor? {
		didSet{
			applyBorderColor(borderColor)
		}
	}
	
	private var border: CAShapeLayer?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override var isSelected: Bool {
		didSet {
			isSelected ? applyShadow() : clearShadow()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = bounds.height / 2
		applyBorderColor(borderColor)
		isSelected ? applyShadow() : clearShadow()
	}
	
	private func setup() {
		adjustsImageWhenHighlighted = false
	}
	
	private func applyShadow() {
		let shadowSize : CGFloat = 7.0
		let rect = CGRect(x: -shadowSize / 2,
						  y: -shadowSize / 2,
						  width: bounds.size.width + shadowSize,
						  height: bounds.size.height + shadowSize)
		
		let shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: bounds.height / 2.0)
		layer.masksToBounds = false
		layer.shadowColor = shadowColor
		layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		layer.shadowOpacity = 1.0
		layer.shadowPath = shadowPath.cgPath
	}
	
	private func clearShadow() {
		layer.shadowOpacity = 0.0
	}
	
	private func applyBorderColor(_ color: UIColor?) {
		guard let color = color else {return}
		border?.removeFromSuperlayer()
		border = CAShapeLayer()
		border!.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
		border!.frame = bounds
		border!.strokeColor = color.cgColor
		border!.fillColor = UIColor.clear.cgColor
		border!.lineWidth = 1.0
		layer.addSublayer(border!)
	}
}
