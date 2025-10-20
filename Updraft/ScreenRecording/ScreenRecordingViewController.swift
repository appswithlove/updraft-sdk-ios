//
//  ScreenRecordingViewController.swift
//  Updraft
//
//  Created by Yanis Plumit on 18.10.2025.
//  Copyright © 2025 Apps with love AG. All rights reserved.
//

import SwiftUI
import UIKit

protocol ScreenRecordingViewControllerDelegate: AnyObject {
    func screenRecordingViewControllerNextWasTapped(sender _: ScreenRecordingViewController)
}

// MARK: - UIKit ViewController

class ScreenRecordingViewController: UIViewController {

    var data: Data?
    weak var delegate: ScreenRecordingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let swiftUIView = ScreenRecordingView(didSelectVideoForExport: {[weak self] url in
            guard let self else { return }
            self.data = try? Data(contentsOf: url)
            self.delegate?.screenRecordingViewControllerNextWasTapped(sender: self)
        })
        
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}
