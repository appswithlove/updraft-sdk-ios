//
//  LoadFontsInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.07.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation
import UIKit

protocol LoadFontsInteractorInput {
	/// Load custom fonts
	func loadAll()
}

class LoadFontsInteractor: LoadFontsInteractorInput {
	
	private struct Constants {
		static let creteItalic = "CreteRound-Italic.ttf"
		static let creteRegular = "CreteRound-Regular.ttf"
	}
	
	func loadAll() {
		registerFontWith(filenameString: Constants.creteRegular)
		registerFontWith(filenameString: Constants.creteItalic)
	}
	
	private func registerFontWith(filenameString: String) {
		let bundle = Bundle.updraft
		guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
			Logger.log("UIFont+:  Failed to register font \(filenameString) - path for resource not found.", level: .warning)
			return
		}
		
		guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
			Logger.log("UIFont+:  Failed to register font \(filenameString) - font data could not be loaded.", level: .warning)
			return
		}
		
		guard let dataProvider = CGDataProvider(data: fontData) else {
			Logger.log("UIFont+:  Failed to register font \(filenameString) - data provider could not be loaded.", level: .warning)
			return
		}
		
		guard let fontRef = CGFont(dataProvider) else {
			Logger.log("UIFont+:  Failed to register font \(filenameString) - font could not be loaded.", level: .warning)
			return
		}
		
		var errorRef: Unmanaged<CFError>?
		if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
			Logger.log("UIFont+:  Failed to register font \(filenameString) - register graphics font failed - this font may have already been registered in the main bundle.", level: .warning)
		}
	}
}
