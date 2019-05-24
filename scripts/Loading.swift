//
//  Pause.swift
//  Matematrics
//
//  Created by William Tempone on 27/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//
import UIKit
import SpriteKit
import AVFoundation
@available(iOS 8.0, *)
class Loading: UIView {
    var backgound = UIImageView()
    var title = UILabel()
    var parent:SKScene = SKScene()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience  init(frame: CGRect, parent: SKScene) {
        self.init(frame: frame)
        self.parent = parent
    }
    
    override func didMoveToSuperview() {
        let myframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height )
        backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "backgroundLevel")
        backgound.image = image
        self.addSubview(backgound)
        title = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.width, //- (buttonSize * 0.5),
            height: self.frame.height)
        )
        title.layer.shadowOffset = (CGSize(width: 2, height: 2))
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 1
        title.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        title.textAlignment = NSTextAlignment.Center
        title.layer.zPosition = 110
        
        
        if let font =  UIFont(name: "Skranji-Bold", size: self.frame.width * 0.05 ) {
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
            let helpText = NSLocalizedString("Loading", comment: "")
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            title.numberOfLines = 0
            title.lineBreakMode = NSLineBreakMode.ByCharWrapping
            title.attributedText = myMutableString
        }
        self.addSubview(title)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}