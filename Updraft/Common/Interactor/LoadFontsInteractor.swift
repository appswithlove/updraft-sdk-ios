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
	
	func loadAll() {
		registerFontWith(filenameString: UIFont.creteItalic + ".ttf")
		registerFontWith(filenameString: UIFont.creteRegular + ".ttf")
	}
	
	private func registerFontWith(filenameString: String) {
		let bundle = Bundle.updraft
		guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
			print("UIFont+:  Failed to register font - path for resource not found.")
			return
		}
		
		guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
			print("UIFont+:  Failed to register font - font data could not be loaded.")
			return
		}
		
		guard let dataProvider = CGDataProvider(data: fontData) else {
			print("UIFont+:  Failed to register font - data provider could not be loaded.")
			return
		}
		
		guard let fontRef = CGFont(dataProvider) else {
			print("UIFont+:  Failed to register font - font could not be loaded.")
			return
		}
		
		var errorRef: Unmanaged<CFError>? = nil
		if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
			print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
		}
	}
}
