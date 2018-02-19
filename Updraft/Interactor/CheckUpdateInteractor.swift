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
	private var apiSessionManager: ApiSessionManager
	private var checkUpdateRequest: ApiRequest<CheckUpdateResource>?
	private var updateRequest: ApiRequest<UpdateResource>?
	
	init(
		apiSessionManager: ApiSessionManager = ApiSessionManager() ,
		settings: Settings = Settings()) {
		
		self.apiSessionManager = apiSessionManager
		self.settings = settings
	}
	
	func buildCheckRequest(settings: Settings, session: NetworkSession) -> ApiRequest<CheckUpdateResource> {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey,
			"version": buildVersion]
		let checkUpdateResource = CheckUpdateResource(parameters: parameters)
		let checkUpdateRequest = ApiRequest(resource: checkUpdateResource, session: apiSessionManager.session)
		return checkUpdateRequest
	}
	
	func buildUploadRequest(settings: Settings, session: NetworkSession) -> ApiRequest<UpdateResource> {
		let parameters = [
			"sdk_key": settings.sdkKey,
			"app_key": settings.appKey]
		let updateResource = UpdateResource(parameters: parameters)
		let updateRequest = ApiRequest(resource: updateResource, session: apiSessionManager.session)
		return updateRequest
	}
	
	fileprivate func getUpdateUrl() {
		updateRequest = buildUploadRequest(settings: self.settings, session: self.apiSessionManager.session)
		
		updateRequest?.load(withCompletion: { [weak self] (result) in
			guard let strongSelf = self, let output = strongSelf.output else { return }
			switch result {
			case .success(let model):
				if let url = URL(string: model.updateUrl) {
					output.checkUpdateInteractor(strongSelf, newUpdateAvailableAt: url)
				}
			case .error(let error):
				print("Getting Update url error: :\(error.localizedDescription)")
			}
		})
	}
}

// MARK: - CheckUpdateInteractorInput

extension CheckUpdateInteractor: CheckUpdateInteractorInput {
	
	func checkUpdate() {
		checkUpdateRequest = buildCheckRequest(settings: self.settings, session: self.apiSessionManager.session)
		
		checkUpdateRequest?.load(withCompletion: { [weak self] (result) in
			guard let strongSelf = self, strongSelf.output != nil else { return }
			switch result {
			case .success(let model) where model.isNewVersionAvailable:
				strongSelf.getUpdateUrl()
			case .error(let error):
				print("Checking Update error: \(error.localizedDescription)")
			case .success:
				break
			}
		})
	}
}
