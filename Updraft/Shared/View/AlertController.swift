//
//  AlertController.swift
//  Updraft
//
//  Created by Maximilian Lemberg on 25.11.21.
//  Copyright © 2021 Apps with love AG. All rights reserved.
//

import Foundation
import UIKit

@available (iOS 13, *)
class AlertAction: UIButton {
    
    let title: String
    @objc let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        super.init(frame: .zero)
        self.backgroundColor = .clear
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadView() {
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        clipsToBounds = true
        setTitleColor(.black, for: .normal)
        isUserInteractionEnabled = true
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitleColor(.label, for: .normal)
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seperator)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            seperator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            seperator.heightAnchor.constraint(equalToConstant: 0.5),
            seperator.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
            action()
        }

}

@available (iOS 13, *)
class AlertController: UIView {
//frame: CGRect(x: 0, y: UIScreen.main.bounds.height-300, width: UIScreen.main.bounds.width, height: 300)
    let bottomView = UIView()
    let handleView = UIView()
    let titleView = UILabel()
    let messageView = UILabel()
    
    let title: String
    let message: String
    
    let actions: [AlertAction]
    
    init(title: String, message: String, actions: [AlertAction]) {
        self.title = title
        self.message = message
        self.actions = actions
        super.init(frame: .zero)
        self.backgroundColor = .clear
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func loadView() {
        bottomView.layer.cornerRadius = 20
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        handleView.layer.cornerRadius = 2.5
        handleView.backgroundColor = .lightGray
        handleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.text = title
        titleView.font = .boldSystemFont(ofSize: 16)
        titleView.textAlignment = .center
        titleView.textColor = .label
        messageView.text = message
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.textColor = .label
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(bottomView)
        bottomView.addSubview(stackView)
        bottomView.addSubview(handleView)
        
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(messageView)
        stackView.setCustomSpacing(24, after: messageView)
        
        actions.forEach { action in
            stackView.addArrangedSubview(action)
        }
        
        NSLayoutConstraint.activate([
                bottomView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 0),
                bottomView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                handleView.widthAnchor.constraint(equalToConstant: 40),
                handleView.heightAnchor.constraint(equalToConstant: 5),
                handleView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
                handleView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                titleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
                messageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
                stackView.widthAnchor.constraint(equalTo: bottomView.widthAnchor),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                stackView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 20)
            ])
    }
    
}
