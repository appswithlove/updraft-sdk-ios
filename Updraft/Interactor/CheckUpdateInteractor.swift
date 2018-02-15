//
//  AutoUpdateInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol CheckUpdateInteractorInput {
	/// Check if a update is available.
	func checkUpdate()
}

protocol CheckUpdateInteractorOutput: class {
	/// Tells the delegate that a new update is available at the corresponding URL.
	///
	/// - Parameters:
	///   - sender: The sender where the event occurs.
	///   - url: The URL to update the app.
	func checkUpdateInteractor(_ sender: CheckUpdateInteractor, newUpdateAvailableAt url: URL)
}

/// Handle the logic to check if a new update is available.
class CheckUpdateInteractor {

	weak var output: CheckUpdateInteractorOutput?
	private var request: AnyObject?
}

// MARK: - CheckUpdateInteractorInput

extension CheckUpdateInteractor: CheckUpdateInteractorInput {
	
	func checkUpdate() {
		
		let updateResource = UpdateResource()
		let configuration = URLSessionConfiguration.ephemeral
		let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
		let updateRequest = ApiRequest(resource: updateResource, session: session)
		self.request = updateRequest
		
		updateRequest.load { [weak self] (result) in
			guard let strongSelf = self, let output = strongSelf.output else { return }
			switch result {
			case .success(let model):
				if let url = URL(string: model.updateUrl) {
					output.checkUpdateInteractor(strongSelf, newUpdateAvailableAt: url)
				}
			case .error(let error):
				print("Checking Update error: \(error.localizedDescription)")
			}
		}
	}
}
