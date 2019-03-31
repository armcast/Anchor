//
//  ViewController.swift
//  Anchor
//
//  Created by Armando Castaneda Elguero on 03/30/2019.
//  Copyright (c) 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit
import Anchor

class ViewController: UIViewController {
    let contentScrollView = MockContentScrollView()
    let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("Open Anchor", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        button.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = UIStackView(arrangedSubviews: [button])
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension ViewController {
    @objc func handleButtonPress() {
        let anchorView = AnchorView(title: "Lorem Ipsum", contentView: contentScrollView)
        anchorView.open()
    }
}

