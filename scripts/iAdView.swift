import UIKit
import iAd
import SpriteKit

class iAdView: UIView, ADInterstitialAdDelegate {
    
    var interAd = ADInterstitialAd()
    var interAdView: UIView = UIView()
    var closeButton = UIButton()
    var nextScene = SKScene()
    var parent = SKScene()
    convenience init (parent: SKScene,nextScene: SKScene) {
        self.init()
        self.parent = parent
        self.nextScene = nextScene
    }
    
    override func didMoveToSuperview() {
        // Do any additional setup after loading the view, typically from a nib.
        
        closeButton = UIButton(frame: CGRectMake(10, 10, 40, 40))
        closeButton.layer.cornerRadius = 10
        closeButton.setTitle("x", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchDown)
        
    }
    
    func close(sender: UIButton) {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
    }
    
    @IBAction func showAd(sender: UIButton) {
        loadAd()
    }
    
    func loadAd() {
        print("load ad")
        interAd = ADInterstitialAd()
        interAd.delegate = self
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        print("ad did load")
        
        interAdView = UIView()
        interAdView.frame = self.bounds
        self.addSubview(interAdView)
        
        interAd.presentInView(interAdView)
        UIViewController.prepareInterstitialAds()
        closeButton.userInteractionEnabled = true
        interAdView.addSubview(closeButton)
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        parent.view?.presentScene(nextScene)
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print("failed to receive")
        print(error.localizedDescription)
        
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        
    }
    
}
