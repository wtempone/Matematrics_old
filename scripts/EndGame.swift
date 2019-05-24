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
class EndGameMenu: UIView  {
    var menu:UIView = UIView()
    var originYPos: CGFloat = CGFloat()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func didMoveToSuperview() {
        
        let buttonSize = GLOBALbuttonSize.height
        
        
        let myframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - (buttonSize / 2))
        let backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "warning")
        backgound.image = image
        self.addSubview(backgound)
        //botao play
        let buttonAcept = UIButton()
        buttonAcept.enabled = true
        buttonAcept.frame = CGRect(
            x: (self.frame.width / 2) + (buttonSize * 0.25) ,
            y: self.frame.height - buttonSize ,
            width: buttonSize,
            height: buttonSize
        )
        buttonAcept.setImage(UIImage(named: "aceptButton"), forState: UIControlState.Normal)
        buttonAcept.addTarget(self, action: "acept", forControlEvents: UIControlEvents.TouchUpInside)
        buttonAcept.imageView?.frame = buttonAcept.frame
        buttonAcept.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonAcept.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.addSubview(buttonAcept)
        
        //botao play
        let buttonReject = UIButton()
        buttonReject.enabled = true
        buttonReject.setImage(UIImage(named: "rejectButton"), forState: UIControlState.Normal)
        buttonReject.addTarget(self, action: "reject", forControlEvents: UIControlEvents.TouchUpInside)
        buttonReject.frame = CGRect(
            x: ((self.frame.width / 2) - (buttonSize * 1.25)),
            y: self.frame.height - buttonSize,
            width: buttonSize,
            height: buttonSize)
        buttonReject.imageView?.frame = buttonReject.frame
        buttonReject.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonReject.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.addSubview(buttonReject)
        originYPos = self.frame.origin.y
        if let font =  UIFont(name: "Skranji-Bold", size: GLOBALbuttonSize.height * 0.45  ) {
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
            

            let myMutableString = NSMutableAttributedString(string: NSLocalizedString("AskEndGame", comment: ""), attributes: textFontAttributes)
            
            let label = UILabel(frame: myframe)
            
            
            label.attributedText = myMutableString
            label.layer.shadowOffset = (CGSize(width: 2, height: 2))
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 1
            label.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
            label.textAlignment = NSTextAlignment.Center
            
            self.addSubview(label)
        }
        
        
    }
    func reject() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        hide()
    }
    func acept() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        hide()
        if let menuGame = menu as? Panel {
            (menuGame.game as! GameScene).panels.hide()
            (menuGame.game as! GameScene).endGame()
        }
    }
    
    func hide() {
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        interactionsPause(true)
        hideView(self)
    }
    func show() {
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        interactionsPause(false)
        showView(self)
    }
    
    
    func interactionsPause(isInteract: Bool) {

        if let menuGame = menu as? Panel {
            menuGame.buttonForward.userInteractionEnabled = isInteract
            menuGame.buttonReload.userInteractionEnabled = isInteract
            menuGame.buttonMenu.userInteractionEnabled = isInteract
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(dropDownView: UIView) {
        dropDownView.hidden = false
        let startYposition = originYPos
        dropDownView.frame.origin.y = self.originYPos - (self.originYPos + dropDownView.frame.height)
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.frame.origin.y = startYposition
                dropDownView.superview?.layoutIfNeeded()
            }
        )
        
    }
    
    func hideView(dropDownView: UIView) {
        
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.frame.origin.y = self.originYPos - (self.originYPos + dropDownView.frame.height)
                dropDownView.superview?.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                dropDownView.hidden = true
            }
        )
    }
    
}