//
//  ZoomTransition.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 08/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol ZoomTransitionGestureTarget {
    @objc optional func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer)
    @objc optional func handleEdgePan(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer)
}

class ZoomTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate, ZoomTransitionGestureTarget {
    
    var sourceView : UIView!
    var operation : UINavigationController.Operation!
    var transitionDuration : CGFloat!
    var parent : UINavigationController!
    var isInteractive : Bool!
    var startScale : CGFloat!
    var shouldCompleteTransition : Bool!
    
    init(nc : UINavigationController) {
        self.parent = nc;
        self.transitionDuration = 0.4
        super.init()
        nc.delegate = self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(self.transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let inView = transitionContext.containerView
        
        let masterView : UIView = self.operation == UINavigationController.Operation.push ? fromVC!.view : toVC!.view
        let detailView : UIView = self.operation == UINavigationController.Operation.push ? toVC!.view : fromVC!.view
        
        if self.operation == UINavigationController.Operation.push {
            detailView.frame = transitionContext.finalFrame(for: toVC!)
        } else {
            masterView.frame = transitionContext.finalFrame(for: toVC!)
        }
        inView.addSubview(toVC!.view)
        
        var detailContentOffset = CGPoint(x: 0.0, y: 0.0)
        if detailView is UIScrollView {
            detailContentOffset = (detailView as! UIScrollView).contentOffset
        }
        
        var masterContentOffset = CGPoint(x: 0.0, y: 0.0)
        if masterView is UIScrollView {
            masterContentOffset = (masterView as! UIScrollView).contentOffset
        }
        
        UIGraphicsBeginImageContextWithOptions(detailView.bounds.size, detailView.isOpaque, 0);
        var ctx = UIGraphicsGetCurrentContext();
        ctx?.translateBy(x: 0, y: -detailContentOffset.y);
        detailView.layer.render(in: ctx!)
        let detailSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(masterView.bounds.size, masterView.isOpaque, 0);
        ctx = UIGraphicsGetCurrentContext();
        ctx?.translateBy(x: 0, y: -masterContentOffset.y);
        masterView.layer.render(in: ctx!)
        let masterSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        let sourceRect = masterView.convert(self.sourceView.bounds, from:self.sourceView)
        let splitPoint = sourceRect.origin.y + sourceRect.size.height - masterContentOffset.y;
        let scale = UIScreen.main.scale
        
        let masterImgRef = masterSnapshot?.cgImage;
        let topImgRef = masterImgRef?.cropping(to: CGRect(x: 0, y: 0, width: (masterSnapshot?.size.width)! * scale, height: splitPoint * scale));
        let topImage = UIImage(cgImage: topImgRef!, scale: scale, orientation: UIImage.Orientation.up)
        
        var masterBottomView = UIImageView()
        
        if let bottomImgRef = masterImgRef?.cropping(to: CGRect(x: 0, y: splitPoint * scale,  width: (masterSnapshot?.size.width)! * scale, height: ((masterSnapshot?.size.height)! - splitPoint) * scale)) {
            
            let bottomImage = UIImage(cgImage:bottomImgRef, scale:scale, orientation:UIImage.Orientation.up)
            masterBottomView = UIImageView(image:bottomImage)
        }
        
        let masterTopView = UIImageView(image:topImage)
        
        var bottomFrame = masterBottomView.frame
        bottomFrame.origin.y = splitPoint + 64
        masterBottomView.frame = bottomFrame
        //
        var topFr = masterTopView.frame
        topFr.origin.y = 64
        masterTopView.frame = topFr
        //
        var masterTopEndFrame = masterTopView.frame
        var masterBottomEndFrame = masterBottomView.frame
        
        if self.operation == UINavigationController.Operation.push {
            masterTopEndFrame.origin.y = -(masterTopEndFrame.size.height - sourceRect.size.height)
            masterBottomEndFrame.origin.y += masterBottomEndFrame.size.height
        } else {
            var masterTopStartFrame = masterTopView.frame
            masterTopStartFrame.origin.y = -(masterTopStartFrame.size.height - sourceRect.size.height)
            masterTopView.frame = masterTopStartFrame
            
            var masterBottomStartFrame = masterBottomView.frame
            masterBottomStartFrame.origin.y += masterBottomStartFrame.size.height
            masterBottomView.frame = masterBottomStartFrame
        }
        let initialAlpha = ((self.operation == UINavigationController.Operation.push) ? 0.0 : 1.0) as CGFloat
        let finalAlpha = ((self.operation == UINavigationController.Operation.push) ? 1.0 : 0.0) as CGFloat
        
        let masterTopFadeView = UIView(frame:masterTopView.frame)
        masterTopFadeView.backgroundColor = UIColor.white
        masterTopFadeView.alpha = initialAlpha
        
        let masterBottomFadeView = UIView(frame:masterBottomView.frame)
        masterBottomFadeView.backgroundColor = UIColor.white
        masterBottomFadeView.alpha = initialAlpha
        
        let detailSmokeScreenView = UIImageView(image:detailSnapshot)
        detailSmokeScreenView.contentMode = UIView.ContentMode.top;
        
        //
        var dssFrame = detailSmokeScreenView.frame
        dssFrame.origin.y = 64
        detailSmokeScreenView.frame = dssFrame
        //
        
        if self.operation == UINavigationController.Operation.push {
            //detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.0, 0.1))
        }
        
        let backgroundView = UIView(frame:inView.frame)
        backgroundView.backgroundColor = UIColor.white
        
        inView.addSubview(backgroundView)
        inView.addSubview(detailSmokeScreenView)
        inView.addSubview(masterTopView)
        inView.addSubview(masterTopFadeView)
        inView.addSubview(masterBottomView)
        inView.addSubview(masterBottomFadeView)
        
        //let totalDuration =
        
        UIView.animateKeyframes(withDuration: Double(self.transitionDuration),
                                delay: 0,
                                options: UIView.KeyframeAnimationOptions(),
                                animations: {
                                    masterTopView.frame = masterTopEndFrame;
                                    masterTopFadeView.frame = masterTopEndFrame;
                                    masterBottomView.frame = masterBottomEndFrame;
                                    masterBottomFadeView.frame = masterBottomEndFrame;
                                    
                                    if self.operation == UINavigationController.Operation.push {
                                        detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity);
                                    } else {
                                        //detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.0, 0.1))
                                    }
                                    
                                    let fadeStartTime = ((self.operation == UINavigationController.Operation.push) ? 0.5 : 0.0) as Double
                                    
                                    UIView.addKeyframe(withRelativeStartTime: fadeStartTime,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        masterTopFadeView.alpha = finalAlpha
                                                        masterBottomFadeView.alpha = finalAlpha
                                    })
        },
                                completion: {(finished : Bool) in
                                    backgroundView.removeFromSuperview()
                                    detailSmokeScreenView.removeFromSuperview()
                                    masterTopView.removeFromSuperview()
                                    masterTopFadeView.removeFromSuperview()
                                    masterBottomView.removeFromSuperview()
                                    masterBottomFadeView.removeFromSuperview()
                                    
                                    if transitionContext.transitionWasCancelled {
                                        toVC!.view.removeFromSuperview()
                                        transitionContext.completeTransition(false)
                                    } else {
                                        fromVC!.view.removeFromSuperview()
                                        transitionContext.completeTransition(true)
                                    }
        })
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.operation = operation
        
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        
        if (self.isInteractive != nil) {
            return self
        }
        
        return nil
    }
    
    func handlePinch(_ gr : UIPinchGestureRecognizer) {
        let scale = gr.scale as CGFloat
        
        switch gr.state {
        case UIGestureRecognizer.State.began:
            self.isInteractive = true
            self.startScale = scale
            self.parent.popViewController(animated: true)
        case UIGestureRecognizer.State.changed:
            let percent = (1.0 - scale / self.startScale) as CGFloat
            self.shouldCompleteTransition = (percent > 0.25);
            self .update((percent <= 0.0) ? 0.0 : percent)
        case UIGestureRecognizer.State.cancelled:
            if !self.shouldCompleteTransition || gr.state == UIGestureRecognizer.State.cancelled {
                self.cancel()
            } else {
                self.finish()
                self.isInteractive = false
            }
        default: break
        }
    }
    
    func handleEdgePan(_ gr : UIScreenEdgePanGestureRecognizer) {
        let point = gr.translation(in: gr.view!)
        
        switch gr.state {
        case UIGestureRecognizer.State.began:
            self.isInteractive = true
            self.parent.popViewController(animated: true)
        case UIGestureRecognizer.State.changed:
            let percent = (point.x / gr.view!.frame.size.width) as CGFloat
            self.shouldCompleteTransition = (percent > 0.25)
            self.update((percent <= 0.0) ? 0.0 : percent)
        case UIGestureRecognizer.State.cancelled:
            if !self.shouldCompleteTransition || gr.state == UIGestureRecognizer.State.cancelled {
                self.cancel()
            } else {
                self.finish()
                self.isInteractive = false
            }
        default: break
        }
    }
}
