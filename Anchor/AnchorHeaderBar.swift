//
//  AnchorHeaderBar.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit

class AnchorHeaderBar: UIView {
    public weak var delegate: AnchorHeaderBarDelegate?
    public var titleFontSize: CGFloat = 24
    public var closeViewSize: CGFloat = 26
    public var padding: CGFloat = 12
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    private var closeView: UIButton = {
        let button = UIButton()
        
        let bundle = Bundle(for: AnchorHeaderBar.self)
        let image = UIImage(named: "close-x-icon", in: bundle, compatibleWith: nil)
        
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(handleClosePress), for: .touchUpInside)
        
        return button
    }()
    
    private var dividerLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private var container = UIView()
    
    convenience init(title: String) {
        self.init(frame: .zero)
        
        titleLabel.text = title
        
        clipsToBounds = true
        
        sv(
            container.sv(
                titleLabel,
                closeView
            ),
            dividerLine
        )
        layout(
            padding,
            |-padding-container-padding-|,
            padding,
            |dividerLine| ~ 1
        )
        
        // Set up Container
        container.layout(
            |titleLabel-closeView|
        )
        
        self.Top == titleLabel.Top - (padding + 1)
        self.Bottom == titleLabel.Bottom + (padding + 1)
        dividerLine.Top == titleLabel.Bottom + padding
        
        closeView.height(closeViewSize).heightEqualsWidth()
    }
}

extension AnchorHeaderBar {
    @objc func handleClosePress() {
        delegate?.didPressClose()
    }
}

protocol AnchorHeaderBarDelegate: class {
    func didPressClose()
}

extension AnchorHeaderBarDelegate {
    func didPressClose() {}
}
