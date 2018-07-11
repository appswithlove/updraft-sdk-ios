//
//  BrushPickerViewController.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 25.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol BrushPickerViewControllerDelegate: class {
	func brushPicker(_ sender: BrushPickerViewController, didPick brush: Brush)
}

class BrushPickerViewController: UIViewController {
	
	@IBOutlet weak var blackButton: BrushButton!
	@IBOutlet weak var whiteButton: BrushButton!
	@IBOutlet weak var macaroniAndCheeseButton: BrushButton!
	@IBOutlet weak var darkPeachButton: BrushButton!
	@IBOutlet weak var eraserButton: BrushButton!
	
	private var buttons: [UIButton] {
		return [blackButton, whiteButton, macaroniAndCheeseButton, darkPeachButton, eraserButton]
	}
	
	weak var delegate: BrushPickerViewControllerDelegate?
	
	// MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: Bundle.updraft)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	@IBAction func selectColor(_ button: BrushButton) {
		select(button)
		guard let color = button.backgroundColor else {return}
		delegate?.brushPicker(self, didPick: .brush(color.cgColor))
	}
	
	@IBAction func selectEraser(_ button: BrushButton) {
		select(button)
		delegate?.brushPicker(self, didPick: .eraser)
	}
	
	private func select(_ button: UIButton) {
		buttons.forEach { $0.isSelected = false }
		button.isSelected = true
	}
	
	private func setup() {
		view.backgroundColor = .clear
		blackButton.backgroundColor = .black
		blackButton.borderColor = .white
		whiteButton.backgroundColor = .white
		macaroniAndCheeseButton.backgroundColor = .macaroniAndCheese
		darkPeachButton.backgroundColor = .darkPeach
		let eraser = UIImage(named: "iconEraser", in: Bundle(for: BrushPickerViewController.self), compatibleWith: nil)
		eraserButton.setImage(eraser, for: .normal)
	}
}
