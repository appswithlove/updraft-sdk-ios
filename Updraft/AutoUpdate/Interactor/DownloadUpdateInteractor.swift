//
//  DownloadUpdateInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol DownloadUpdateInteractorInput {
	
	/// Redirect the user to the given URL to download the new version of the app.
	///
	/// - Parameter url: The URL to download the new version.
	func redirectUserForDownload(to url: URL)
}

protocol DownloadUpdateInteractorOutput: AnyObject {
	
	/// Tells the delegate whether a specified URL was opened successfully.
	///
	/// - Parameters:
	///   - sender: The sender where the event is occuring.
	///   - url: The URL
	///   - didOpen: A Boolean indicating wheter the URL was openened successfully
	func downloadUpdateInteractor(_ sender: DownloadUpdateInteractor, url: URL, didOpen: Bool)
}

/// Handle the redirection of the user to the app update download page.
class DownloadUpdateInteractor {

	weak var output: DownloadUpdateInteractorOutput?

	/// Opens Safari with the provided URL
	///
	/// - Parameter url: The URL to be opened
	func openUrl(_ url: URL) {
        UIApplication.shared.open(url, options: [:]) { (success) in
			self.output?.downloadUpdateInteractor(self, url: url, didOpen: success)
		}
	}
}

// MARK: - DownloadUpdateInteractorInput

extension DownloadUpdateInteractor: DownloadUpdateInteractorInput {
	func redirectUserForDownload(to url: URL) {
		self.openUrl(url)
	}
}
