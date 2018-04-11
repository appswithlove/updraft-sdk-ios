//
//  FeedbackViewController.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 09.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegate: class {
	func feedbackViewControllerCancelWasTapped(_ sender: FeedbackViewController)
	func feedbackViewControllerSendWasTapped(_ sender: FeedbackViewController)
}

class FeedbackViewController: UIViewController, AppUtility {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	
	weak var delegate: FeedbackViewControllerDelegate?
	
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
	
	@IBAction func cancel(_ sender: Any) {
		delegate?.feedbackViewControllerCancelWasTapped(self)
	}
	@IBAction func send(_ sender: Any) {
		delegate?.feedbackViewControllerSendWasTapped(self)
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
		imageView?.contentMode = .scaleAspectFit
		scrollView.alwaysBounceVertical = true
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
	}
	
	@objc func endEditing() {
		view.endEditing(true)
	}
	
	func update() {
		switch self.state {
		case .edit(let image):
			self.imageView?.image = image
		default:
			break
		}
	}
}
