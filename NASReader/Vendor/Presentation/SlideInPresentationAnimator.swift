//
//  SlideInPresentationAnimator.swift
//  NASReader
//
//  Created by oneko.c on 2022/8/2.
//

import UIKit

final class SlideInPresentationAnimator: NSObject {
    let direction: PresentationDirection
    
    let isPresentation: Bool
    
    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissdFrame = presentedFrame
        switch direction {
        case .left:
            dismissdFrame.origin.x = -presentedFrame.width
        case .right:
            dismissdFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissdFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissdFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        let initialFrame = isPresentation ? dismissdFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissdFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration) {
            controller.view.frame = finalFrame
        } completion: { finished in
            if !self.isPresentation {
                controller.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished)
        }

    }
}
