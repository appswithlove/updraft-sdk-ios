//
//  LoadFontsInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 10.07.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

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
			print("UIFont+:  Failed to register font \(filenameString) - path for resource not found.")
			return
		}
		
		guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
			print("UIFont+:  Failed to register font \(filenameString) - font data could not be loaded.")
			return
		}
		
		guard let dataProvider = CGDataProvider(data: fontData) else {
			print("UIFont+:  Failed to register font \(filenameString) - data provider could not be loaded.")
			return
		}
		
		guard let fontRef = CGFont(dataProvider) else {
			print("UIFont+:  Failed to register font \(filenameString) - font could not be loaded.")
			return
		}
		
		var errorRef: Unmanaged<CFError>? = nil
		if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
			print("UIFont+:  Failed to register font \(filenameString) - register graphics font failed - this font may have already been registered in the main bundle.")
		}
	}
}
