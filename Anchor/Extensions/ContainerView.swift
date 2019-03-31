//
//  ContainerView.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit

extension AnchorContentContainerView {
    public enum Distribution: Int {
        case fill, fillEqually, fillProportionally, equalSpacing, equalCentering, center
        
        func value() -> UIStackView.Distribution {
            switch self {
            case .fill:
                return UIStackView.Distribution.fill
            case .fillEqually:
                return UIStackView.Distribution.fillEqually
            case .fillProportionally:
                return UIStackView.Distribution.fillProportionally
            case .equalSpacing:
                return UIStackView.Distribution.equalSpacing
            case .equalCentering:
                return UIStackView.Distribution.equalCentering
            default:
                return .fill
            }
        }
    }
}

open class AnchorContentContainerView: UIView {
    let stack = UIStackView()
    let helperStack = UIStackView()
    
    public var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stack.axis = axis
        }
    }
    public var distribution: Distribution = .fill {
        didSet {
            stack.distribution = distribution.value()
            
            if distribution == .center {
                helperStack.axis = stack.axis == .vertical ? .horizontal : .vertical
                helperStack.alignment = .center
                
                stack.removeFromSuperview()
                stack.alignment = .center
                
                helperStack.addArrangedSubview(stack)
                helperStack.pin(to: self)
            }
        }
    }
    public var alignment: UIStackView.Alignment = .fill {
        didSet {
            stack.alignment = alignment
        }
    }
    public var spacing: CGFloat = 0 {
        didSet {
            stack.spacing = spacing
        }
    }
    public var padding: UIEdgeInsets = .zero {
        didSet {
            stack.layoutMargins = padding
            stack.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    public var arrangedSubviews = [UIView]() {
        didSet {
            guard arrangedSubviews != oldValue else { return }
            
            // TODO: Make this more efficient.
            stack.subviews.forEach({ $0.removeFromSuperview() })
            arrangedSubviews.forEach({ stack.addArrangedSubview($0) })
        }
    }
    
    open func configure() {
        stack.pin(to: self)
        
        axis = .vertical
    }
    
    public init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
