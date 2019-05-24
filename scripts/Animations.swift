import UIKit
class Animations {
    var deltaTimer = Float()
    func resetDelta() {
        deltaTimer = Float(0)
    }
    func viewCurlUp(view:UIView,animationTime:Float)
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(animationTime))
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp, forView: view, cache: false)
        
        UIView.commitAnimations()
    }
    
    func viewCurlDown(view:UIView,animationTime:Float)
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(animationTime))
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlDown, forView: view, cache: false)
        
        UIView.commitAnimations()
    }
    
    func viewFlipFromLeft(view:UIView,animationTime:Float)
    {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(animationTime))
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: view, cache: false)
        
        UIView.commitAnimations()
    }
    
    func viewMoveInFromTop(view:UIView,animationTime:Float)
    {
        let animation:CATransition = CATransition()
        animation.duration = CFTimeInterval(animationTime)
        animation.type = "moveIn"
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        animation.subtype = "fromBottom"
        animation.fillMode = "forwards"
        view.layer.addAnimation(animation, forKey: nil)
        
    }
    
    func animationRotationEffect(view:UIView,animationTime:Float)
    {
        UIView.animateWithDuration(NSTimeInterval(animationTime), animations: { () -> Void in
            
            let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform")
            animation.toValue = NSValue(CATransform3D:CATransform3DMakeRotation(CGFloat(M_PI), 1, 1, 1))
            
            animation.duration = CFTimeInterval(animationTime)
            animation.cumulative = true
            animation.repeatCount  = 2
            
            view.layer.addAnimation(animation, forKey: nil)
        })
    }
    
    func animationScaleEffect(view:UIView,animationTime:Float)
    {
        deltaTimer += animationTime

        UIView.animateWithDuration(0.0, delay: NSTimeInterval(0), options: [], animations: {
            
            view.transform = CGAffineTransformMakeScale(0.001, 0.001)
            
            },completion:nil
        )
        UIView.animateWithDuration(NSTimeInterval(animationTime), delay: NSTimeInterval(self.deltaTimer), usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: [], animations: {
            view.transform = CGAffineTransformMakeScale(1, 1)
            }
            , completion: nil)
        
    }
}