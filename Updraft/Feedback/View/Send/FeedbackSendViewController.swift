//
//  FeedbackSendViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 04.07.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackSendViewControllerDelegate: class {
	func feedbackSendViewControllerCancelWasTapped(_ sender: FeedbackSendViewController)
}

class FeedbackSendViewController: UIViewController {
	
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var progressLabel: UILabel!
	@IBOutlet weak var cancelButton: NavigationButton!
	@IBOutlet weak var titleLabel: UILabel!
	
	weak var delegate: FeedbackSendViewControllerDelegate?
	
	var progress: Float = 0.0 {
		didSet {
			updateProgress(progress, animated: true)
		}
	}
	
	@IBAction func cancel(_ sender: Any) {
		delegate?.feedbackSendViewControllerCancelWasTapped(self)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }
	
	private func setup() {
		view.backgroundColor = .spaceBlack
		titleLabel.font = .italicBig
		titleLabel.textColor = .macaroniAndCheese
		titleLabel.text = "Thank you\n for the\n feedback"
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		progressView.progressTintColor = .macaroniAndCheese
		progressView.trackTintColor = .clear
		progressView.layer.borderWidth = 1
		progressView.layer.borderColor = UIColor.macaroniAndCheese.cgColor
		progressLabel.font = .regularSmall
		progressLabel.textColor = .macaroniAndCheese
		cancelButton.title = "Cancel"
		updateProgress(0.0, animated: false)
	}
	
	private func updateProgress(_ progress: Float, animated: Bool) {
		progressView.setProgress(progress, animated: animated)
		progressLabel.text = "\(progress)%"
	}
}
