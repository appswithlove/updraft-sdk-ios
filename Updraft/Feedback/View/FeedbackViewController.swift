//
//  FeedbackViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegate: AnyObject {
	func feedbackViewControllerDismissWasTapped(_ sender: FeedbackViewController)
	func feedbackViewControllerCancelledSending(_ sender: FeedbackViewController)
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel)
}

class FeedbackViewController: UIViewController {

	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	weak var delegate: FeedbackViewControllerDelegate?
	
	private var email: String?
	private var image: UIImage
	
	var feedbackSendViewController: FeedbackSendViewControllerInterface?
	
	lazy var feedbackPaintViewController: FeedbackPaintViewController = {
		let fpvc = FeedbackPaintViewController(image: image)
		fpvc.delegate = self
		return fpvc
	}()
	
	lazy var feedbackDescriptionViewController: FeedbackDescriptionViewController = {
		let fdvc = FeedbackDescriptionViewController(email: email, tags: FeedbackViewModel.Tag.all())
		fdvc.delegate = self
		return fdvc
	}()
	
	lazy var navigationViewController: UINavigationController = {
		let nvc = UINavigationController(rootViewController: feedbackPaintViewController)
		nvc.isNavigationBarHidden = true
		return nvc
	}()
	
	func updateProgress(_ progress: Float) {
		feedbackSendViewController?.progress = progress
	}
	
	func displayError(_ message: String) {
		feedbackSendViewController?.showError(message)
	}
	
	private func feedbackViewModel() -> FeedbackViewModel {
		let image = feedbackPaintViewController.image
		let email = feedbackDescriptionViewController.email
		let message = feedbackDescriptionViewController.text
		let tag = feedbackDescriptionViewController.selectedTag ?? FeedbackViewModel.Tag.feedback
		return FeedbackViewModel(image: image, email: email, description: message, tag: tag)
	}
	
	// MARK: - Init
	
	init(email: String?, image: UIImage) {
		self.email = email
		self.image = image
		super.init(nibName: nil, bundle: Bundle.updraft)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupConstraints()
		setupNavigationController()
    }
	
	// MARK: - Setup
	
	private func setupUI() {
		view.backgroundColor = .spaceBlack
		containerView.backgroundColor = .clear
		let updraftLogo = UIImage(named: "logoUpdraftWhiteSmall", in: Bundle.updraft, compatibleWith: nil)
		logoImageView.image = updraftLogo
		logoImageView.contentMode = .scaleAspectFit
		titleLabel.text = "updraft_feedback_title".localized
		titleLabel.textColor = .white
		titleLabel.font = UIFont.regularMedium
		let closeImage = UIImage(named: "iconButtonClose", in: Bundle.updraft, compatibleWith: nil)
		closeButton.setImage(closeImage, for: .normal)
		closeButton.setTitle("", for: .normal)
	}
	
	private func setupConstraints() {
		// layoutGuide currently not supported in .xib files see https://forums.developer.apple.com/thread/87329
		topConstraint.isActive = false
		_ = titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
	}
	
	// MARK: - Navigation
	
	private func setupNavigationController() {
		add(navigationViewController, to: containerView)
		navigationViewController.view.stickToView(containerView)
	}
	
	private func showDescriptionViewController() {
		navigationViewController.show(feedbackDescriptionViewController, sender: self)
	}
	
	private func showSendViewController() {
		feedbackSendViewController = nil
		let fbsvc = FeedbackSendViewController()
		fbsvc.delegate = self
		navigationViewController.show(fbsvc, sender: self)
		feedbackSendViewController = fbsvc
	}
	
	private func pop() {
		navigationViewController.popViewController(animated: true)
	}
	
	// MARK: - Actions
	
	@IBAction func dismiss(_ sender: UIButton) {
		delegate?.feedbackViewControllerDismissWasTapped(self)
	}
}

// MARK: - FeedbackPainViewControllerDelegate

extension FeedbackViewController: FeedbackPaintViewControllerDelegate {
	func paintViewControllerNextWasTapped(sender _: FeedbackPaintViewController) {
		showDescriptionViewController()
	}
}

// MARK: - FeedbackDescriptionViewControllerDelegate

extension FeedbackViewController: FeedbackDescriptionViewControllerDelegate {
	func descriptionViewControllerSendWasTapped(_ sender: FeedbackDescriptionViewController) {
		showSendViewController()
		delegate?.feedbackViewControllerSendWasTapped(self, model: feedbackViewModel())
	}
	
	func descriptionViewControllerPreviousWasTapped(_ sender: FeedbackDescriptionViewController) {
		pop()
	}
}

// MARK: - FeedbackSendViewControllerDelegate

extension FeedbackViewController: FeedbackSendViewControllerDelegate {
	func feedbackSendViewControllerPreviousWasTapped(_ sender: FeedbackSendViewController) {
		pop()
		delegate?.feedbackViewControllerCancelledSending(self)
	}
}
