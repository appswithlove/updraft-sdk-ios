//
//  DownloadUpdateInteractorOutputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class DownloadUpdateInteractorOutputSpy: DownloadUpdateInteractorOutput {
	var urlDidOpenWasCalled = false
	var didOpen: Bool?
	
	func downloadUpdateInteractor(_ sender: DownloadUpdateInteractor, url: URL, didOpen: Bool) {
		urlDidOpenWasCalled = true
		self.didOpen = didOpen
	}
}
