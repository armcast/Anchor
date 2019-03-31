//
//  AnchorView.swift
//  Anchor
//
//  Created by Armando Castaneda on 3/30/19.
//  Copyright © 2019 Armando Castaneda Elguero. All rights reserved.
//

import UIKit

public class AnchorView: UIView {
    lazy var heightContraint = NSLayoutConstraint(item: contentContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0)
    private var contentViewIsAtTop: Bool {
        return contentScrollView.contentOffset.y <= 0
    }
    private var startedAtTop: Bool = false
    private var maxHeight: CGFloat {
        return AnchorPosition.maximized.rawValue * (parentView?.frame.height ?? 0)
    }
    
    public var parentView: UIView?
    private var contentContainerView = AnchorContentContainerView()
    public var contentScrollView = UIScrollView()
    private var headerBar = AnchorHeaderBar(title: "Longest Videos")
    
    private var anchorPosition: AnchorPosition = .closed
    public var animationSpeed: Double = 0.4
    
    private func configureView() {
        guard let parentView = self.parentView else { return }
        
        pin([.bottom, .leading, .trailing], to: parentView)
        heightContraint.isActive = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 4
        
        contentContainerView.layer.cornerRadius = 8
        contentContainerView.clipsToBounds = true
        contentContainerView.layer.borderColor = UIColor.black.cgColor
        contentContainerView.layer.borderWidth = 0.5
        
        contentContainerView.pin(to: self)
        contentContainerView.arrangedSubviews = [headerBar, contentScrollView]
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.pin(to: contentContainerView, at: 0)
    }
    
    public init(contentView: UIScrollView, parentView: UIView? = nil) {
        super.init(frame: .zero)
        
        self.contentScrollView = contentView
        self.parentView = parentView ?? UIApplication.shared.keyWindow
        
        configureView()
        
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        parentView?.addGestureRecognizer(outsideTap)
        parentView?.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        pan.delegate = self
        contentContainerView.addGestureRecognizer(pan)
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
    private func animateTo(_ position: AnchorPosition, animationSpeed: Double? = nil, completion: (() -> Void)? = nil) {
        anchorPosition = position
        let animationSpeed: Double = animationSpeed ?? self.animationSpeed
        
        self.parentView?.layoutIfNeeded()
        
        let height = (parentView?.frame.height ?? 0) * position.rawValue
        self.heightContraint.constant = height
        
        UIView.animate(withDuration: animationSpeed, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
            self.parentView?.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    private func animateToClosestAnchorPoint(for height: CGFloat, velocityMultiplier: Double) {
        let distToMin: Double = Double(abs(AnchorPosition.minimized.rawValue * (parentView?.frame.height ?? 0) - height))
        let distToMax: Double = Double(abs(AnchorPosition.maximized.rawValue * (parentView?.frame.height ?? 0) - height))
        let distToClose: Double = Double(abs(AnchorPosition.closed.rawValue * (parentView?.frame.height ?? 0) - height))
        
        if distToMin < distToMax && distToMin < distToClose && startedAtTop {
            animateTo(.minimized, animationSpeed: velocityMultiplier / distToMin)
        } else if distToMax < distToMin && distToMax < distToClose {
            animateTo(.maximized, animationSpeed: velocityMultiplier / distToMax)
        } else if distToClose < distToMax && distToClose < distToMin && startedAtTop {
            if anchorPosition == .maximized {
                animateTo(.minimized, animationSpeed: velocityMultiplier / distToMin)
            } else {
                close()
            }
        }
    }
}

extension AnchorView {
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: contentScrollView)
        let newHeight = heightContraint.constant - translation.y
        
        switch recognizer.state {
        case .began:
            startedAtTop = contentViewIsAtTop
            
            contentScrollView.isScrollEnabled = anchorPosition != .minimized
            contentScrollView.bounces = translation.y < 0 || anchorPosition != .maximized || !contentViewIsAtTop
        case .changed:
            // Swiping Up
            if translation.y < 0 && anchorPosition == .minimized && newHeight <= maxHeight {
                heightContraint.constant = newHeight
            }
            
            // Swiping Down
            if translation.y > 0 && contentViewIsAtTop && startedAtTop {
                heightContraint.constant = newHeight
            }
            
            recognizer.setTranslation(.zero, in: contentScrollView)
            
        case .ended, .cancelled:
            let velocity = recognizer.velocity(in: contentScrollView)
            // Range is between 2200 and 8000
            let velocityY: CGFloat = {
                if velocity.y > 0 {
                    return max(2200, min(velocity.y * 2, 8000))
                }
                
                if velocity.y < 0 {
                    return min(-2200, max(velocity.y * 2, -8000))
                }
                
                return 0
            }()
            let slideMultiplier = abs(velocityY) / 200
            let velocityModifier = velocityY * slideMultiplier * 0.1
            
            let velocityMultiplier = Double(abs(velocityY))
            animateToClosestAnchorPoint(for: newHeight - velocityModifier, velocityMultiplier: velocityMultiplier)
            
            contentScrollView.isScrollEnabled = anchorPosition != .minimized
            contentScrollView.bounces = anchorPosition == .maximized
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
        case minimized = 0.40, maximized = 0.93, closed = 0
    }
}

extension AnchorView {
    @objc func handleOutsideTap() {
        close()
    }
}
