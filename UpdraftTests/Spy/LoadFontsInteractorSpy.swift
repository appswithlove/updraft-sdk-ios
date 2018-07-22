//
//  LoadFontsInteractorSpy.swift
//  UpdraftTests
//
//  Created by Raphael Neuenschwander on 11.07.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
@testable import Updraft

class LoadFontsInteractorSpy: LoadFontsInteractor {
	var loadAllWasCalled = false
	
	override func loadAll() {
		super.loadAll()
		loadAllWasCalled = true
	}
}
