//
//  FeedbackSendProgressView.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 20.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

class FeedbackSendProgressView: UIView {

	@IBOutlet var title: UILabel!
	@IBOutlet var progressView: UIProgressView!
	@IBOutlet var progressLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		title.font = .italicMedium
		title.textColor = .macaroniAndCheese
		title.text = "feedback.send.success".localized + "  " + "√"
		title.numberOfLines = 0
		title.textAlignment = .center
		progressView.progressTintColor = .macaroniAndCheese
		progressView.trackTintColor = .clear
		progressView.layer.borderWidth = 1
		progressView.layer.borderColor = UIColor.macaroniAndCheese.cgColor
		progressLabel.font = .regularSmall
		progressLabel.textColor = .macaroniAndCheese
		progressLabel.textAlignment = .center
		backgroundColor = .clear
	}
}
