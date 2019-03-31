//
//  AnchorHeaderBar.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit

class AnchorHeaderBar: UIView {
    
    public var titleFontSize: CGFloat = 24
    public var closeViewSize: CGFloat = 16
    public var padding: CGFloat = 12
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Longest Videos"
        label.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        label.textColor = .white
        label.numberOfLines = 0
        
        return label
    }()
    private var closeView: UIImageView = {
        let view = UIImageView()
        
        let bundle = Bundle(for: AnchorHeaderBar.self)
        let image = UIImage(named: "close-x-icon", in: bundle, compatibleWith: nil)
        view.image = image
        view.tintColor = .lightGray
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private var dividerLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private var container = UIView()
    
    convenience init() {
        self.init(frame: .zero)
        
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
