//
//  FeedbackDescriptionViewController.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 26.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import UIKit

protocol FeedbackDescriptionViewControllerDelegate: class {
	func descriptionViewControllerPreviousWasTapped(_ sender: FeedbackDescriptionViewController)
	func descriptionViewControllerSendWasTapped(_ sender: FeedbackDescriptionViewController)
}

class FeedbackDescriptionViewController: UIViewController {
	
	private struct Constants {
		static let pickerHeight: CGFloat = 150
		static let minBottomSpacing: CGFloat = 30
	}

	@IBOutlet var pickerTopEdgeConstraint: NSLayoutConstraint!
	@IBOutlet var pickerHeight: NSLayoutConstraint!
	@IBOutlet var sendButtonBottomConstraint: NSLayoutConstraint!
	
	@IBOutlet var pickerContainerView: UIView!
	@IBOutlet weak var descriptionView: FeedbackDescriptionTextView!
	@IBOutlet weak var emailTextField: FeedbackEmailTextField!
	@IBOutlet weak var sendButton: ActionButton!
	@IBOutlet weak var arrowButton: UIButton!
	@IBOutlet weak var feedbackView: UIView!
	@IBOutlet weak var feedbackTypeLabel: UILabel!
	@IBOutlet weak var feedbackTypePicker: UIPickerView!
	@IBOutlet weak var previousButton: NavigationButton!
	
	weak var delegate: FeedbackDescriptionViewControllerDelegate?
	
	private(set) var tags = [FeedbackViewModel.Tag?]()// Get real values
	private(set) var email: String
	
	var text: String {
		return descriptionView.text
	}
	
	private(set) var selectedTag: FeedbackViewModel.Tag? {
		didSet {
			updateSelectedTag(selectedTag)
		}
	}
	
	private var isTypeSelected = false {
		didSet {
			update(isTypeSelected: isTypeSelected, animated: true)
		}
	}
	
	// MARK: - Init
	
	init(email: String?, tags: [FeedbackViewModel.Tag]) {
		self.email = email ?? ""
		self.tags = tags
		self.tags.insert(nil, at: 0) // First item of the picker is empty
		super.init(nibName: nil, bundle: Bundle.updraft)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setup()
		update(isTypeSelected: false, animated: false)
    }
	
	// MARK: - UI
	
	private func setup() {
		pickerContainerView.clipsToBounds = true
		pickerContainerView.backgroundColor = .clear
		view.backgroundColor = .spaceBlack
		emailTextField.delegate = self
		emailTextField.text = email
		feedbackTypePicker.delegate = self
		feedbackTypePicker.dataSource = self
		feedbackTypePicker.backgroundColor = .white
		feedbackTypeLabel.font = .italic
		previousButton.title = "updraft_feedback_button_previous".localized
		sendButton.setTitle("updraft_feedback_button_sendFeedback".localized, for: .normal)
		let arrow = UIImage(named: "iconArrowDown", in: Bundle.updraft, compatibleWith: nil)
		arrowButton.setImage(arrow, for: .normal)
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
		feedbackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
		arrowButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
		
		updateSelectedTag(selectedTag)
	}
	
	private func update(isTypeSelected selected: Bool, animated: Bool) {
		func update(isTypeSelected selected: Bool) {
			self.descriptionView.alpha = selected ? 1.0 : 0.0
			self.emailTextField.alpha = selected ? 1.0 : 0.0
			self.sendButton.isEnabled = selected ? true : false
		}
		
		if animated {
			UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0, options: [], animations: {
				update(isTypeSelected: selected)
			}, completion: nil)
		} else {
			update(isTypeSelected: selected)
		}
	}
	
	func updateSelectedTag(_ tag: FeedbackViewModel.Tag?) {
		feedbackTypeLabel.text = tag?.localized ?? "updraft_feedback_picker_feedbackType_title".localized
	}
	
	// MARK: - Actions
	
	@IBAction func sendFeedback(_ sender: Any) {
		dismissKeyboard()
		delegate?.descriptionViewControllerSendWasTapped(self)
	}
	
	@objc func showPicker() {
		dismissKeyboard()
	}
	
	@IBAction func emailChanged(_ sender: UITextField) {
		email = sender.text ?? ""
	}
	
	@IBAction func showPrevious(_ sender: UIButton) {
		delegate?.descriptionViewControllerPreviousWasTapped(self)
	}
	
	// MARK: Keyboard
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		let keyboardHeight = keyboardViewEndFrame.height
		
		let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
		
		if notification.name == Notification.Name.UIKeyboardWillHide {
			sendButtonBottomConstraint.constant = Constants.minBottomSpacing
			hidePicker(hide: false)
		} else {
			let newHeight = keyboardHeight + Constants.minBottomSpacing - bottomSafeHeight()
			sendButtonBottomConstraint.constant = newHeight
			hidePicker(hide: true)
		}
		
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
	
	private func hidePicker(hide: Bool) {
		pickerTopEdgeConstraint.isActive = hide ? false : true
		pickerHeight.constant = hide ? 0.0 : Constants.pickerHeight
	}
	
	private func bottomSafeHeight() -> CGFloat {
		var bottomSafeHeight: CGFloat = 0.0
		if #available(iOS 11.0, *) {
			bottomSafeHeight = view.safeAreaInsets.bottom
		}
		return bottomSafeHeight
	}
}

// MARK: - UITextFieldDelegate

extension FeedbackDescriptionViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: - UIPickerviewDataSource

extension FeedbackDescriptionViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return tags.count
	}
}

// MARK: - UIPickerViewDelegate

extension FeedbackDescriptionViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let title = tags[row]?.localized ?? ""
		return title
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let tag = tags[row] else { return }
		if !isTypeSelected { isTypeSelected = true }
		selectedTag = tag
	}
}
