//
//  TakeScreenshotInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol TakeScreenshotInteractorInput {
	func takeScreenshot()
}

protocol TakeScreenshotInteractorOutput: class {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage)
}

final class TakeScreenshotInteractor {
	weak var output: TakeScreenshotInteractorOutput?
}

extension TakeScreenshotInteractor: TakeScreenshotInteractorInput {
	func takeScreenshot() {
		
		var screenshotImage: UIImage?
		let layer = UIApplication.shared.keyWindow!.layer
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
		guard let context = UIGraphicsGetCurrentContext() else {return}
		layer.render(in: context)
		screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		guard let screenshot = screenshotImage else {return}
		output?.takeScreenshotInteractor(self, didTakeScreenshot: screenshot)
	}
}
