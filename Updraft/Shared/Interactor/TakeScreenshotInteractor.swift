//
//  TakeScreenshotInteractor.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 03.04.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import UIKit

protocol TakeScreenshotInteractorInput {
	/// Take a screenshot of the screen as it is currently visible to the user
	func takeScreenshot()
}

protocol TakeScreenshotInteractorOutput: AnyObject {
	func takeScreenshotInteractor(_ sender: TakeScreenshotInteractor, didTakeScreenshot image: UIImage)
}

/// Object, which purpose is to take screenshots
class TakeScreenshotInteractor {
	weak var output: TakeScreenshotInteractorOutput?
}

// MARK: - TakeScreenshotInteractorInput

extension TakeScreenshotInteractor: TakeScreenshotInteractorInput {
	
	@objc func takeScreenshot() {
        var screenshotImage: UIImage?
        
        let scale = UIScreen.main.scale

        guard let window = UIApplication.shared.keyWindow else { return }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, scale)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let screenshot = screenshotImage else {return}
        
        output?.takeScreenshotInteractor(self, didTakeScreenshot: screenshot)	}
}
