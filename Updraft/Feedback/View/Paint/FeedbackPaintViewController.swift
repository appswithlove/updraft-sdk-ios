//
//  FeedbackPaintViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackPaintViewControllerDelegate: class {
	func paintViewControllerNextWasTapped(sender _: FeedbackPaintViewController)
}

class FeedbackPaintViewController: UIViewController {
	
	@IBOutlet weak var drawingContainer: UIView!
	@IBOutlet weak var brushContainer: UIView!
	@IBOutlet weak var nextButton: NavigationButton!
	
	private lazy var brushPickerViewController: BrushPickerViewController =  {
		let bpvc = BrushPickerViewController()
		bpvc.delegate = self
		return bpvc
	}() //FIXME: pass into init for testing purposes
	
	private let drawViewController = DrawViewController() //FIXME: pass into init for testing purposes
	
	weak var delegate: FeedbackPaintViewControllerDelegate?
	
	// MARK: - Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
	
	// MARK: - Actions
	
	@IBAction func showNext(_ sender: UIButton) {
		delegate?.paintViewControllerNextWasTapped(sender: self)
	}
	
	// MARK: - Setup
	
	private func setup() {
		view.backgroundColor = .spaceBlack
		nextButton.title = "next"
		[drawingContainer, brushContainer].forEach() {
			$0?.backgroundColor = .clear
		}
		add(brushPickerViewController, to: brushContainer)
		brushPickerViewController.view.stickToView(brushContainer)
		add(drawViewController, to: drawingContainer)
		drawViewController.view.stickToView(drawingContainer)
		drawViewController.backgroundImage = UIImage.init(named: "screenshot")
		
		//Set default color
		brushPickerViewController.macaroniAndCheeseButton.isSelected = true
		drawViewController.brush = Brush.brush(UIColor.macaroniAndCheese.cgColor)
	}
}

// MARK: - BrushPickerViewControllerDelegate

extension FeedbackPaintViewController: BrushPickerViewControllerDelegate {
	func brushPicker(_ sender: BrushPickerViewController, didPick brush: Brush) {
		drawViewController.brush = brush
	}
}
