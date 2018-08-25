//
//  FeedbackSendViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 04.07.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackSendViewControllerInterface {
	var progress: Float { get set }
	func showError(_ message: String)
}

protocol FeedbackSendViewControllerDelegate: class {
	func feedbackSendViewControllerPreviousWasTapped(_ sender: FeedbackSendViewController)
}

class FeedbackSendViewController: UIViewController, FeedbackSendViewControllerInterface {
	
	@IBOutlet var progressViewContainer: UIView! {
		didSet {
			progressViewContainer.backgroundColor = .clear
			progressViewContainer.addSubview(feedbackSendProgressView)
			feedbackSendProgressView.stickToView(progressViewContainer)
		}
	}
	@IBOutlet var failureViewContainer: UIView! {
		didSet {
			failureViewContainer.backgroundColor = .clear
			failureViewContainer.addSubview(feedbackSendFailureView)
			feedbackSendFailureView.stickToView(failureViewContainer)
		}
	}
	
	lazy var feedbackSendProgressView: FeedbackSendProgressView = {
		return Bundle.updraft.loadNibNamed("FeedbackSendProgressView", owner: self, options: nil)?.first as! FeedbackSendProgressView
		}()
	
	lazy var feedbackSendFailureView: FeedbackSendFailureView! = {
		return Bundle.updraft.loadNibNamed("FeedbackSendFailureView", owner: self, options: nil)?.first as! FeedbackSendFailureView
		}()
	
	@IBOutlet weak var previousButton: NavigationButton!
	
	weak var delegate: FeedbackSendViewControllerDelegate?
	
	var progress: Float = 0.0 {
		didSet {
			updateProgress(progress, animated: true)
		}
	}
	
	func showError(_ message: String) {
		feedbackSendFailureView.subtitle.text = message
		UIView.animate(withDuration: 0.3) {
			self.feedbackSendFailureView.alpha = 1.0
			self.feedbackSendProgressView.alpha = 0.0
		}
	}
	
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
	
	// MARK: - Setup
	
	private func setup() {
		view.backgroundColor = .spaceBlack
		previousButton.setTitle("updraft_feedback_button_previous".localized, for: .normal)
		updateProgress(0.0, animated: false)
		showProgress()
	}
	
	// MARK: - Actions
	
	@IBAction func toPreviousScreen(_ sender: Any) {
		delegate?.feedbackSendViewControllerPreviousWasTapped(self)
	}

	// MARK: - Progress
	
	private func showProgress() {
		feedbackSendFailureView.alpha = 0.0
		feedbackSendProgressView.alpha = 1.0
	}
	
	private func updateProgress(_ progress: Float, animated: Bool) {
		showProgress()
		feedbackSendProgressView.progressView?.setProgress(progress, animated: animated)
		let percentProgress = Int(progress * 100)
		feedbackSendProgressView.progressLabel?.text = "\(percentProgress)%"
		if progress == 1.0 {
			feedbackSendProgressView.title.text = "updraft_feedback_send_success".localized + "  " + "√"
			previousButton.isHidden = true
		} else {
			feedbackSendProgressView.title.text = "updraft_feedback_send_inProgress".localized
			previousButton.isHidden = false
		}
	}
}
