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
class CheckUpdateInteractor: AppUtility {

	weak var output: CheckUpdateInteractorOutput?
	
	private var settings: Settings
	private let checkUpdateRequest: CheckUpdateRequest
	private let getUpdateUrlRequest: UpdateUrlRequest
	
	init(
		settings: Settings = Settings(),
		checkUpdateRequest: CheckUpdateRequest = CheckUpdateRequest(),
		getUpdateUrlRequest: UpdateUrlRequest = UpdateUrlRequest()) {
		
		self.settings = settings
		self.checkUpdateRequest = checkUpdateRequest
		self.getUpdateUrlRequest = getUpdateUrlRequest
	}

	func getUpdateUrl() {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey]
		
		getUpdateUrlRequest.load(with: .getUpdateUrl(params: parameters)) { [weak self] (result) in
			guard let strongSelf = self, let output = strongSelf.output else { return }
			switch result {
			case .success(let model):
				if let url = URL(string: model.updateUrl) {
					Logger.log("New version can be downloaded at: \(url)", level: .info)
					output.checkUpdateInteractor(strongSelf, newUpdateAvailableAt: url)
				}
			case .error(let error):
				Logger.log("Failed to get update url: :\(error.localizedDescription)", level: .error)
			}
		}
	}
}

// MARK: - CheckUpdateInteractorInput

extension CheckUpdateInteractor: CheckUpdateInteractorInput {
	
	func checkUpdate() {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey,
			"version": buildVersion
			]
		
		checkUpdateRequest.load(with: .checkUpdate(params: parameters)) { [weak self] (result) in
			guard let strongSelf = self, strongSelf.output != nil else { return }
			switch result {
			case .success(let model) where !model.isNewVersionAvailable:
				Logger.log("No new version available, your version: \(model.onDeviceVersion), Updraft version: \(model.updraftVersion ?? "NONE")", level: .info)
			case .success(let model) where model.isNewVersionAvailable:
				Logger.log("New Version available: \(model.updraftVersion ?? "")", level: .info)
				strongSelf.getUpdateUrl()
			case .error(let error):
				Logger.log("Checking update failed: \(error.localizedDescription)", level: .error)
			case .success:
				break
			}
		}
	}
}
