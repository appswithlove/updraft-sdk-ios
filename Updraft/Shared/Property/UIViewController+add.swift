//
//  UIViewController+add.swift
//  testNavigation
//
//  Created by Raphael Neuenschwander on 27.06.18.
//  Copyright © 2018 Raphael Neuenschwander. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	/// Add a child controller to the specified view
	///
	/// - Parameters:
	///   - child: The controller to add
	///   - view: The view in which the controller will be added
	func add(_ child: UIViewController, to view: UIView) {
		addChildViewController(child)
		view.addSubview(child.view)
		child.didMove(toParentViewController: self)
	}
	
	/// Remove from parent UIViewController
	func remove() {
		guard parent != nil else {
			return
		}
		
		willMove(toParentViewController: nil)
		removeFromParentViewController()
		view.removeFromSuperview()
	}
}
