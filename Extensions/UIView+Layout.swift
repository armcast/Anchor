//
//  UIView+Layout.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit

extension UIView {
    func pin(_ pins: [PinType] = PinType.all, to sv: UIView, at index: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if !sv.subviews.contains(self) {
            if let index = index {
                sv.insertSubview(self, at: index)
            } else {
                sv.addSubview(self)
            }
        }
        
        pins.forEach({ pin in
            let constraint = NSLayoutConstraint(item: self,
                                                attribute: pin.attribute(),
                                                relatedBy: .equal,
                                                toItem: sv,
                                                attribute: pin.attribute(),
                                                multiplier: 1.0,
                                                constant: 0.0)
            constraint.isActive = true
        })
    }
}

extension UIView {
    enum PinType {
        static var all: [PinType] = [.leading, .trailing, .top, .bottom]
        
        case leading, trailing, top, bottom, height, width
        
        func attribute() -> NSLayoutConstraint.Attribute {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .width:
                return .width
            case .height:
                return .height
            }
        }
    }
}
