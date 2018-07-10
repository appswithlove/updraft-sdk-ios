//
//  FeedbackViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegate: class {
	func feedbackViewControllerDismissWasTapped(_ sender: FeedbackViewController)
	func feedbackViewControllerCancelWasTapped(_ sender: FeedbackViewController)
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel)
}

class FeedbackViewController: UIViewController {

	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var topConstraint: NSLayoutConstraint!
	
	weak var delegate: FeedbackViewControllerDelegate?
	
	lazy var feedbackPaintViewController: FeedbackPaintViewController =  {
		let fpvc = FeedbackPaintViewController()
		fpvc.delegate = self
		return fpvc
	}() //FIXME: Dependency injection
	
	lazy var feedbackDescriptionViewController: FeedbackDescriptionViewController = {
		let fdvc = FeedbackDescriptionViewController()
		fdvc.delegate = self
		return fdvc
	}() //FIXME: Dependency injection
	
	lazy var navigationViewController: UINavigationController = {
		let nvc = UINavigationController(rootViewController: feedbackPaintViewController)
		nvc.isNavigationBarHidden = true
		return nvc
	}() //FIXME: Dependency injection
	
	// MARK: - Init
	
	init(state: FeedbackState) {
		self.state = state
		super.init(nibName: nil, bundle: Bundle(for: FeedbackViewController.self))
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
		logoImageView.image = UIImage(named: "logoUpdraftSmallWhite")
		logoImageView.contentMode = .scaleAspectFit
		titleLabel.text = "Give Feedback"
		titleLabel.textColor = .white
		titleLabel.font = UIFont.regularMedium
		closeButton.setImage(UIImage(named: "buttonClose"), for: .normal)
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
		
		let feedbackSendViewController = FeedbackSendViewController()
		feedbackSendViewController.delegate = self
		navigationViewController.show(feedbackSendViewController, sender: self)
	}
	
	private func pop() {
		navigationViewController.popViewController(animated: true)
	}
	
	//MARK: - Actions
	
	@IBAction func dismiss(_ sender: UIButton) {
		delegate?.feedbackViewControllerDismissWasTapped(self)
	}
	//TODO: Custom fonts ?
	//TODO: Pass models and retrieve on send
	//TODO: Transfer Code to SDK
	//TODO: Add unit tests, doc ?
}

// MARK: - FeedbackPainViewControllerDelegate

extension FeedbackViewController: FeedbackPaintViewControllerDelegate {
	func paintViewControllerNextWasTapped(sender _: FeedbackPaintViewController) {
		//TODO: Retrieve merged image
		showDescriptionViewController()
	}
}

// MARK: - FeedbackDescriptionViewControllerDelegate

extension FeedbackViewController: FeedbackDescriptionViewControllerDelegate {
	func descriptionViewControllerSendWasTapped(_ sender: FeedbackDescriptionViewController) {
		//TODO: Start Upload
		showSendViewController()
		delegate?.feedbackViewControllerSendWasTapped(self, model: <#T##FeedbackViewModel#>)
	}
	
	func descriptionViewControllerPreviousWasTapped(_ sender: FeedbackDescriptionViewController) {
		pop()
	}
}

// MARK: - FeedbackSendViewControllerDelegate

extension FeedbackViewController: FeedbackSendViewControllerDelegate {
	func feedbackSendViewControllerCancelWasTapped(_ sender: FeedbackSendViewController) {
		pop()
		delegate?.feedbackViewControllerCancelWasTapped(self)
	}
}
