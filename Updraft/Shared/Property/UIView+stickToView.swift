//
//  StickToView.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 17.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Convenience
extension UIView {
	func stickToView(_ view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
		self.translatesAutoresizingMaskIntoConstraints = false
		self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
		self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailing).isActive = true
		self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom).isActive = true
		self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive=true
	}
}
