//
//  ScreenRecorder.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import UIKit

extension UIWindow {
    static var didSendEventSwizzle = false
    
    static func swizzleSendEvent() {
        guard !didSendEventSwizzle else { return }
        didSendEventSwizzle = true
        
        guard let originalMethod = class_getInstanceMethod(UIWindow.self, #selector(sendEvent(_:))),
              let swizzledMethod = class_getInstanceMethod(UIWindow.self, #selector(swizzled_sendEvent(_:))) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc func swizzled_sendEvent(_ event: UIEvent) {
        if let touches = event.allTouches {
            for touch in touches {
                let touchId = "\(ObjectIdentifier(touch))"
                ScreenRecorder.shared.addTouch(id: touchId,
                                               center: touch.location(in: self),
                                               phase: {
                    switch touch.phase {
                    case .began: return .began
                    case .moved: return .moved
                    case .ended, .cancelled: return .ended
                    default: return .other
                    }
                }())
            }
        }
        
        swizzled_sendEvent(event)
    }
}
