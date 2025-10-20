//
//  UIApplication+KeyWindow.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import UIKit

extension UIApplication {
    var getKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState != .unattached }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        var rootViewController = UIApplication.shared.getKeyWindow?.rootViewController
        
        while rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        
        return rootViewController
    }
}
