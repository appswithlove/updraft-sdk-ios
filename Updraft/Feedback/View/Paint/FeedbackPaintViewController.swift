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
	
	private lazy var brushPickerViewController: BrushPickerViewController = {
		let bpvc = BrushPickerViewController()
		bpvc.delegate = self
		return bpvc
	}()
	
	private let drawViewController: DrawViewController
	
	weak var delegate: FeedbackPaintViewControllerDelegate?
	
	// MARK: - Interface
	
	private(set) var image: UIImage {
		get {
			return drawViewController.editedImage
		}
		set {
			drawViewController.backgroundImage = image
		}
	}
	
	// MARK: - Init
	
	init(image: UIImage) {
		drawViewController = DrawViewController(backgroundImage: image)
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
	
	// MARK: - Actions
	
	@IBAction func showNext(_ sender: UIButton) {
		delegate?.paintViewControllerNextWasTapped(sender: self)
	}
	
	// MARK: - Setup
	
	private func setup() {
		view.backgroundColor = .spaceBlack
		nextButton.title = "next"
		[drawingContainer, brushContainer].forEach {
			$0?.backgroundColor = .clear
		}
		add(brushPickerViewController, to: brushContainer)
		brushPickerViewController.view.stickToView(brushContainer)
		add(drawViewController, to: drawingContainer)
		drawViewController.view.stickToView(drawingContainer)
		
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
