//
//  Pause.swift
//  Matematrics
//
//  Created by William Tempone on 27/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
@available(iOS 8.0, *)
class PanelTutorial: UIView  {
    var game:SKScene = SKScene()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func didMoveToSuperview() {
        
       // let buttonSize = GLOBALbuttonSize.height
        
    }
      func hide(step : Int) {
        (game as! GameScene).interactionsGame(true)

        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        for view in self.subviews {
                view.removeFromSuperview()
        }
        if step > 0 {
            stepTutorial (step)
        }
        hideView(self)

    }
    
    func alignTextVerticalInTextView(textView :UITextView) {
        
        let size = textView.sizeThatFits(CGSizeMake(CGRectGetWidth(textView.bounds), CGFloat(MAXFLOAT)))
        
        var topoffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2.0
        topoffset = topoffset < 0.0 ? 0.0 : topoffset
        
        textView.contentOffset = CGPointMake(0, -topoffset)
    }
    
    func show(myFrame: CGRect, myText: String) {
        showView(self)
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        for view in self.subviews {
            if view.isKindOfClass(UIImageView) || view.isKindOfClass(UITextView) {
                view.removeFromSuperview()
            }
        }
        //var RibonimageView = UIImageView(frame: CGRect(x: myFrame.origin.x, y: myFrame.origin.y , width: myFrame.width, height: myFrame.height))
        let RibonimageView = UIImageView(image: UIImage(named: "RibbonHelp"))
        let ribbonWidth = myFrame.width * 0.5
        let ribbonHeigth = RibonimageView.frame.size.height * (ribbonWidth / RibonimageView.frame.size.width)
        RibonimageView.frame = CGRect(x: myFrame.origin.x + (myFrame.width / 2) - (ribbonWidth / 2), y: myFrame.origin.y - (ribbonHeigth / 2) ,
            width: ribbonWidth, height: ribbonHeigth)
        RibonimageView.layer.zPosition = 2
        self.addSubview(RibonimageView)
        let imageView = UIImageView(frame: CGRect(x: myFrame.origin.x, y: myFrame.origin.y , width: myFrame.width, height: myFrame.height))
        imageView.image = UIImage(named: "warning")!
        self.addSubview(imageView)
        let textTutorial = UITextView(frame: CGRect(x: myFrame.origin.x + myFrame.width * 0.1, y: myFrame.origin.y , width: myFrame.width * 0.8, height: myFrame.height))
        textTutorial.backgroundColor = UIColor(hue: 1, saturation: 1, brightness: 1, alpha: 0)
        textTutorial.userInteractionEnabled = false
        textTutorial.textColor = UIColor(red: 166/255, green: 114/255, blue: 54/255, alpha: 1)
        textTutorial.font = UIFont(name: "Comics", size:GLOBALbuttonSize.height * 0.35)
        textTutorial.textAlignment = NSTextAlignment.Center
        textTutorial.text = myText
        textTutorial.removeFromSuperview()
        alignTextVerticalInTextView(textTutorial)
        self.addSubview(textTutorial)
        self.layer.zPosition = 30
    
    }
    
    func stepTutorial(step: Int) {
        print("self.frame.width: \(self.frame.width)")
        switch step {
        case 1:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.3 ),
            myText: NSLocalizedString("HelpText\(step)", comment: ""))
             break
        case 2:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.5 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 3:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.6, width: self.frame.width * 0.8, height: self.frame.width * 0.3 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 4:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.6, width: self.frame.width * 0.8, height: self.frame.width * 0.3 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 5:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.6, width: self.frame.width * 0.8, height: self.frame.width * 0.3 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 6:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.5 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 7:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.35 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 8:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.55 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
        case 9:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.3, width: self.frame.width * 0.8, height: self.frame.width * 0.5 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            let settings = GLOBALsettingsManager.readSettings()
            settings.tutorial = false
            GLOBALsettingsManager.saveSettings(settings)
            break
        case 99:
            show(CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.5, width: self.frame.width * 0.8, height: self.frame.width * 0.3 ),
                myText: NSLocalizedString("HelpText\(step)", comment: ""))
            break
         default:
            break
        }
        (game as! GameScene).interactionsGame(false)
        (game as! GameScene).paused = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(dropDownView: UIView) {
        dropDownView.hidden = false
        dropDownView.alpha = 0
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.alpha = 1
                dropDownView.superview?.layoutIfNeeded()
            }
        )
        
    }
    
    func hideView(dropDownView: UIView) {
        
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.alpha = 0
                dropDownView.superview?.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                dropDownView.hidden = true
            }
        )
    }
    
}