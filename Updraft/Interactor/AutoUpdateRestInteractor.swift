//
//  AutoUpdateInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol AutoUpdateRestInteractorInput {
	/// Check if a update is available.
	func checkUpdate()
}

protocol AutoUpdateRestInteractorOutput: class {
	/// Tells the delegate that a new update is available at the corresponding URL.
	///
	/// - Parameters:
	///   - sender: The sender where the event occurs.
	///   - url: The URL to update the app.
	func autoUpdateRestInteractor(_ sender: AutoUpdateRestInteractor, newUpdateAvailableAt url: URL)
}

/// Handle the logic to check if a new update is available.
class AutoUpdateRestInteractor  {
	
	private(set) var repository: AutoUpdateRepository
	weak var output: AutoUpdateRestInteractorOutput?
	
	init(repository: AutoUpdateRepository) {
		self.repository = repository
	}
}

//MARK: - AutoUpdateRestInteractorInput

extension AutoUpdateRestInteractor: AutoUpdateRestInteractorInput {
	func checkUpdate() {
		
	}
}
