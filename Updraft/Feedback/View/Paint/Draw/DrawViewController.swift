//
//  DrawViewController.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 17.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
	
	@IBOutlet weak var dimView: DimView!
	@IBOutlet weak var drawView: DrawView!
	@IBOutlet weak var drawViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var drawViewWidthConstraint: NSLayoutConstraint!
	
	// MARK: Init
	
	init(backgroundImage: UIImage) {
		self.backgroundImage = backgroundImage
		super.init(nibName: nil, bundle: Bundle.updraft)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		dimView.title = "feedback.draw-explanation".localized
		drawView.backgroundImage = backgroundImage
		drawView.onTouchBegan = { [weak self] in
			self?.dimView.hide()
		}
		addDropOfShadow(to: drawView)
		drawView.backgroundImage = backgroundImage
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		update()
	}
	
	// MARK: Public Interface
	
	var backgroundImage: UIImage {
		didSet {
			update()
		}
	}
	
	var editedImage: UIImage {
		return drawView.mergedImage
	}
	
	var brush: Brush = .brush(UIColor.black.cgColor) {
		didSet {
			drawView.drawBrush = brush
		}
	}
	
	func reset() {
		drawView.clearDrawing()
	}
	
	// MARK: Private Implementation
	
	private func addDropOfShadow(to view: UIView) {
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 1.0
		view.layer.shadowRadius = 4.0
		view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
	}
	
	private var backgroundImageSizeRatio: CGFloat {
		let width = backgroundImage.size.width
		let height = backgroundImage.size.height
		if width > 0, height > 0 {
			return width / height
		} else {
			return 1.0
		}
	}
	
	private func update() {
		drawView?.backgroundImage = backgroundImage
		resizeDrawViewToFitBackgroundImage()
	}
	
	private func resizeDrawViewToFitBackgroundImage() {
		if backgroundImageSizeRatio > 1 { // landscape
			let height = min(view.bounds.width / backgroundImageSizeRatio, view.bounds.height)
			drawViewHeightConstraint.constant = height
			drawViewWidthConstraint.constant = height * backgroundImageSizeRatio
		} else {
			let width = min(view.bounds.height * backgroundImageSizeRatio, view.bounds.width)
			drawViewWidthConstraint.constant = width
			drawViewHeightConstraint.constant = width / backgroundImageSizeRatio
		}
		view.layoutIfNeeded()
	}
}
