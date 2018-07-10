//
//  FeedbackViewController.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 09.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegateLEGACY: class {
	func feedbackViewControllerCancelWasTapped(_ sender: FeedbackViewControllerLEGACY)
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController, model: FeedbackViewModel)
}

class FeedbackViewControllerLEGACY: UIViewController, AppUtility {
	
	@IBOutlet weak var drawContainerView: UIView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var messageTextView: UITextView!
	@IBOutlet weak var feedbackTypeControl: UISegmentedControl!
	
	weak var delegate: FeedbackViewControllerDelegate?
	
	var drawViewController: DrawViewController?
	
	var state: FeedbackState {
		didSet {
			update()
		}
	}
	
	// MARK: Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
		update()
    }
	
	// MARK: Init
	
	init(state: FeedbackState) {
		self.state = state
		super.init(nibName: nil, bundle: Bundle(for: FeedbackViewController.self))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Actions
	
	@IBAction func reset(_ sender: UIButton) {
		drawViewController?.reset()
	}
	@IBAction func cancel(_ sender: Any) {
		delegate?.feedbackViewControllerCancelWasTapped(self)
	}
	@IBAction func send(_ sender: Any) {
		let feedbackModel = getFeedbackViewModel()
		delegate?.feedbackViewControllerSendWasTapped(self, model: feedbackModel)
	}
	
	// MARK: Keyboard
	
	@objc func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		let keyboardHeight = keyboardViewEndFrame.height
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
			scrollView.contentInset = UIEdgeInsets.zero
			scrollView.setContentOffset(CGPoint.zero, animated: true)
		} else {
			scrollView.contentInset.bottom = keyboardHeight
			scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
		}
		scrollView.scrollIndicatorInsets = scrollView.contentInset
	}
	
	// MARK: Implementation
	
	func setup() {
		scrollView?.isScrollEnabled = false
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
		
		drawViewController = DrawViewController()
		addChildViewController(drawViewController!)
		drawContainerView.addSubview(drawViewController!.view)
		drawViewController!.view.stickToView(drawContainerView)
		drawViewController!.didMove(toParentViewController: self)
	}
	
	func getFeedbackViewModel() -> FeedbackViewModel {
		let image = drawViewController?.editedImage ?? UIImage()
		let email = emailTextField?.text ?? ""
		let message = messageTextView?.text ?? ""
		let selectedTagTitle = feedbackTypeControl?.titleForSegment(at: feedbackTypeControl.selectedSegmentIndex) ?? ""
		let tag = FeedbackViewModel.Tag(rawValue: selectedTagTitle) ?? .feedback
		
		return FeedbackViewModel(image: image, email: email, message: message, tag: tag)
	}
	
	@objc func endEditing() {
		view.endEditing(true)
	}
	
	func update() {
		switch self.state {
		case .edit(let image, let email):
			self.drawViewController?.backgroundImage = image
			self.emailTextField?.text = email
		default:
			break
		}
	}
}
