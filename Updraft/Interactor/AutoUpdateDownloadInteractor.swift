//
//  AutoUpdateDownloadInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 23.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol AutoUpdateDownloadInteractorInput {
	
	/// Redirect the user to the given URL to download the new version of the app.
	///
	/// - Parameter url: The URL to download the new version.
	func redirectUserForDownload(to url: URL)
}

protocol AutoUpdateDownloadInteractorOutput: class {
	
	/// Tells the delegate whether a specified URL was opened successfully.
	///
	/// - Parameters:
	///   - sender: The sender where the event is occuring.
	///   - url: The URL
	///   - didOpen: A Boolean indicating wheter the URL was openened successfully
	func autoUpdateDownloadInteractor(_ sender: AutoUpdateDownloadInteractor, url: URL, didOpen: Bool)
}

/// Handle the redirection of the user to the app update download page.
class AutoUpdateDownloadInteractor {
	
	private let application: URLOpener
	weak var output: AutoUpdateDownloadInteractorOutput?
	
	init(application: URLOpener = UIApplication.shared) {
		self.application = application
	}

	/// Opens Safari with the provided URL
	///
	/// - Parameter url: The URL to be opened
	func openUrl(_ url: URL) {
		guard application.canOpenURL(url) else {
			output?.autoUpdateDownloadInteractor(self, url: url, didOpen: false)
			return
		}
		application.open(url, options: [:]) { (success) in
			self.output?.autoUpdateDownloadInteractor(self, url: url, didOpen: success)
		}
	}
}

// MARK: - AutoUpdateDownloadInteractorInput

extension AutoUpdateDownloadInteractor: AutoUpdateDownloadInteractorInput {
	func redirectUserForDownload(to url: URL) {
		self.openUrl(url)
	}
}
