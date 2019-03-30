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
    private var contentViewIsAtTop: Bool {
        return contentView.contentOffset.y <= 0
    }
    private var maxHeight: CGFloat {
        return AnchorPosition.maximized.rawValue * (parentView?.frame.height ?? 0)
    }
    
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
        
        contentView.layer.cornerRadius = 8
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

extension AnchorView {
    public func open() {
        animateTo(.minimized)
    }
    
    public func close() {
        animateTo(.closed) {
            self.heightContraint.isActive = false
            self.removeFromSuperview()
        }
    }
}

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
    
    private func animateToClosestAnchorPoint(for height: CGFloat) {
        let distToMin = abs(AnchorPosition.minimized.rawValue * (parentView?.frame.height ?? 0) - height)
        let distToMax = abs(AnchorPosition.maximized.rawValue * (parentView?.frame.height ?? 0) - height)
        let distToClose = abs(AnchorPosition.closed.rawValue * (parentView?.frame.height ?? 0) - height)
        
        if distToMin < distToMax && distToMin < distToClose {
            animateTo(.minimized)
        } else if distToMax < distToMin && distToMax < distToClose {
            animateTo(.maximized)
        } else if distToClose < distToMax && distToClose < distToMin {
            if anchorPosition == .maximized {
                animateTo(.minimized)
            } else {
                close()
            }
        }
    }
}

extension AnchorView {
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentView)
        let newHeight = heightContraint.constant - translation.y
        
        switch recognizer.state {
        case .began:
            contentView.isScrollEnabled = anchorPosition != .minimized
        case .changed:
            // Swiping Up
            if translation.y < 0 && anchorPosition == .minimized && newHeight <= maxHeight {
                heightContraint.constant = newHeight
            }
            
            // Swiping Down
            if translation.y > 0 && contentViewIsAtTop {
                heightContraint.constant = newHeight
            }
            
            recognizer.setTranslation(.zero, in: contentView)
            
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: contentView)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            let velocityModifier = velocity.y * slideMultiplier * 0.1
            
            animateToClosestAnchorPoint(for: newHeight - velocityModifier)
            
            contentView.isScrollEnabled = anchorPosition != .minimized
        default:
            break
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
        case minimized = 0.40, maximized = 0.90, closed = 0
    }
}

extension AnchorView {
    @objc func handleOutsideTap() {
        close()
    }
}
