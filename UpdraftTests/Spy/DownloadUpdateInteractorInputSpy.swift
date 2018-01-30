//
//  DownloadUpdateInteractorInputSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class DownloadUpdateInteractorInputSpy: DownloadUpdateInteractorInput {
	
	var redirectUserForDownloadWasCalled = false
	
	func redirectUserForDownload(to url: URL) {
		redirectUserForDownloadWasCalled = true
	}
}
