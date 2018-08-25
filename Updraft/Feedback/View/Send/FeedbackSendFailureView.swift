//
//  FeedbackSendFailureView.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 20.08.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

class FeedbackSendFailureView: UIView {

	@IBOutlet var title: UILabel!
	@IBOutlet var subtitle: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		title.font = .italicBig
		title.text = "updraft_feedback_send_failure_title".localized
		subtitle.font = .italicSmall
		subtitle.text = ""
		
		[title, subtitle].forEach {
			$0?.textColor = .macaroniAndCheese
			$0?.numberOfLines = 0
			$0?.textAlignment = .center
		}
		backgroundColor = .clear
	}
}
