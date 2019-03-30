//
//  AnchorView.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit
public class AnchorView: UIView {
    lazy var heightContraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    public var parentView: UIView?
    public var contentView = UIScrollView()
    private var anchorPosition: AnchorPosition = .closed
    public var animationSpeed: Double = 0.2
    
    private func configureView() {
        guard let parentView = self.parentView else { return }
        
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        heightContraint.isActive = true
    }
    
    public init(contentView: UIScrollView, parentView: UIView? = nil) {
        super.init(frame: .zero)
        
        self.contentView = contentView
        self.parentView = parentView ?? UIApplication.shared.keyWindow
        
        configureView()
        
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        addGestureRecognizer(outsideTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        pan.delegate = self
        contentView.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    private func configureView() {
        guard let parentView = self.parentView else { return }

extension AnchorView {
    private func animateTo(_ position: AnchorPosition, completion: (() -> Void)? = nil) {
        anchorPosition = position
        
        layoutIfNeeded()
        
        let height = (parentView?.frame.height ?? 0) * position.rawValue
        self.heightContraint.constant = height
        UIView.animate(withDuration: animationSpeed, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    }
}

extension AnchorView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AnchorView {
    enum AnchorPosition: CGFloat {
        case minimized = 0.25, maximized = 0.90, closed = 0
    }
}

extension AnchorView {
    @objc func handleOutsideTap() {
extension AnchorView {
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    }
}
