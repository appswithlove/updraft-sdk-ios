//
//  DispatchToMainThread.swift
//  Updraft
//
//  Created by Raphael Neuenschwander on 12.03.18.
//  Copyright © 2018 Apps with love AG. All rights reserved.
//

import Foundation

/// Global function to dispatching to main thread, only when needed
///
/// - Parameter closure: The block to be performed on the main thread
func dispatchToMainThread(using closure: @escaping () -> Void) {
	// If we are already on the main thread, execute the closure directly
	if Thread.isMainThread {
		closure()
	} else {
		DispatchQueue.main.async(execute: closure)
	}
}
