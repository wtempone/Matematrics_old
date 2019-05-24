import iAd
import SpriteKit
class TransitionSceneAd : SKScene, ADInterstitialAdDelegate {
    var interAd:ADInterstitialAd?
    var interAdView = UIView()
    var closeButton = UIButton()
    var nextScene = SKScene()
    var isShowed = false
    var backgound = UIImageView()
    var title = UILabel()

    convenience init (nextScene: SKScene) {
        self.init()
        self.nextScene = nextScene
    }
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(red: 248/255, green: 232/255, blue: 176/255, alpha: 1)
        
        
        let myView = UIView(frame: self.view!.bounds)
        let myframe = myView.bounds
        backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "backgroundLevel")
        backgound.image = image
        
        title = UILabel(frame: myView.bounds)
        title.layer.shadowOffset = (CGSize(width: 2, height: 2))
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 1
        title.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        title.textAlignment = NSTextAlignment.Center
        title.layer.zPosition = 110
        //title.text = "teste"
        
        if let font =  UIFont(name: "Skranji-Bold", size: myView.bounds.height * 0.03 ) {
            let shadow : NSShadow = NSShadow()
            
            shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -5
            ]
            let helpText = "Carregando..."
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            title.numberOfLines = 0
            title.lineBreakMode = NSLineBreakMode.ByCharWrapping
            title.attributedText = myMutableString
        }
        title.layoutIfNeeded()
        backgound.addSubview(title)
        //backgound.addSubview(title)
        title.layer.zPosition = 100
        backgound.bringSubviewToFront(title)
        backgound.layoutIfNeeded()
        myView.addSubview(backgound)
        self.view!.addSubview(backgound)
        self.view?.layoutIfNeeded()

        
        
        
        // Define a close button size:
        closeButton.frame = CGRectMake(20, 20, 70, 44)
        closeButton.layer.cornerRadius = 10
        // Give the close button some coloring layout:
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        // Wire up the closeAd function when the user taps the button
        closeButton.addTarget(self, action: "closeAd:", forControlEvents: UIControlEvents.TouchDown)
        // Some funkiness to get the title to display correctly every time:
        closeButton.enabled = false
        
        let message = NSLocalizedString("ButtonAd", comment: "")

        closeButton.setTitle(message, forState: UIControlState.Normal)
        closeButton.enabled = true
        closeButton.setNeedsLayout()
        self.runAction(
            SKAction.sequence([
                SKAction.waitForDuration(10),
                SKAction.runBlock({
                    if !self.isShowed {
                        self.view?.presentScene(self.nextScene)
                    }
                })
                ]))
        
    }
    // iAd
    func prepareAd() {
        print(" --- AD: Try Load ---")
        // Attempt to load a new ad:
        interAd = ADInterstitialAd()
        interAd?.delegate = self
    }
    
    // You can call this function from an external source when you actually want to display an ad:
    func showAd() -> Bool {
        if interAd != nil && interAd!.loaded {
            interAdView = UIView()
            interAdView.frame = self.view!.bounds
            self.view?.addSubview(interAdView)
            
            interAd!.presentInView(interAdView)
            UIViewController.prepareInterstitialAds()
            
            interAdView.addSubview(closeButton)
        }
        // Return true if we're showing an ad, false if an ad can't be displayed:
        return interAd?.loaded ?? false
    }
    
    // When the user clicks the close button, route to the adFinished function:
    func closeAd(sender: UIButton) {
        self.view?.presentScene(nextScene)
        adFinished()
    }
    
    // A function of common functionality to run when the user returns to your app:
    func adFinished() {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        //self.view?.presentScene(nextScene)
    }
    
    // The ad loaded successfully (we don't need to do anything for the basic implementation)
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Load Success ---")
        // Try to show an ad
        let adShown = showAd()
        
        // If no ad, just move on
        if adShown == false {
            self.view?.presentScene(nextScene)
        } else {
            isShowed = true
        }

    }
    
    // The ad unloaded (we don't need to do anything for the basic implementation)
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        print(" --- AD: Unload --- ")
    }
    
    // This is called if the user clicks into the interstitial, and then finishes interacting with the ad
    // We'll call our adFinished function since we're returning to our app:
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        print(" --- ADD: Action Finished --- ")
        adFinished()
        if isShowed {
            self.view?.presentScene(nextScene)
        }
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    // Error in the ad load, print out the error
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print(" --- AD: Error --- ")
        print(error.localizedDescription)
        adFinished()

        self.view?.presentScene(nextScene)
    }
}