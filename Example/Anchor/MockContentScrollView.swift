//
//  MockContentScrollView.swift
//  Anchor_Example
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class MockContentScrollView: UIScrollView {
    let loremLabel: UILabel = {
        let label = UILabel()
        
        let path = Bundle.main.path(forResource: "LoremIpsum.txt", ofType: nil)!
        let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        label.text = content
            
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(loremLabel)
        loremLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        loremLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        loremLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        loremLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        loremLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        loremLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -padding * 2).isActive = true
    }
}
