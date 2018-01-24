//
//  URLOpener.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 24.01.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

protocol URLOpener {
	func canOpenURL(_ url: URL) -> Bool
	func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Swift.Void)?)
}

extension UIApplication: URLOpener {}
