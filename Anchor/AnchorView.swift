//
//  AnchorView.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit
public class AnchorView: UIView {
    public var parentView: UIView?
    public var contentView = UIScrollView()
    public init(contentView: UIScrollView, parentView: UIView? = nil) {
        super.init(frame: .zero)
        
        self.contentView = contentView
        self.parentView = parentView ?? UIApplication.shared.keyWindow
        
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        addGestureRecognizer(outsideTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        contentView.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AnchorView {
    @objc func handleOutsideTap() {
extension AnchorView {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    }
}
