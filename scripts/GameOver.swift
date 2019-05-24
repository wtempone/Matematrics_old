//
//  Pause.swift
//  Matematrics
//
//  Created by William Tempone on 27/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import UIKit
import SpriteKit
class GameOverMenu: UIView {
    var viewEndGame:EndGameMenu!

    var game: SKScene = SKScene()
    var originYPos: CGFloat = CGFloat()
    var buttonSize: CGFloat = CGFloat()
    let buttonPlay = UIButton()
    let buttonReload = UIButton()
    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience  init(frame: CGRect, game: SKScene) {
        self.init(frame: frame)
        self.game = game
    }
    
    override func didMoveToSuperview() {
        
        buttonSize = self.frame.width * 0.15
        
        
        let myframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "Panel")
        backgound.image = image
        self.addSubview(backgound)
        let ribonImage = UIImage(named: "RibonGameOver")
        let ribon = UIImageView(image: ribonImage)
        let ribbonWidth = self.frame.size.width * 0.6
        let ribbonHeigth = ribon.frame.size.height * (ribbonWidth / ribon.frame.size.width)
        
        ribon.frame = CGRect(x: ((self.frame.width / 2) - (ribbonWidth / 2)), y: -(ribbonHeigth / 3) ,
            width: ribbonWidth, height: ribbonHeigth)
        self.addSubview(ribon)
        
        //messagee
        label = UILabel(frame: CGRect(x: 0, y: ribon.frame.height * 0.3, width: self.frame.width - (buttonSize * 0.5), height: self.frame.height - (buttonSize * 1.25)))
        
        
        label.layer.shadowOffset = (CGSize(width: 2, height: 2))
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 1
        label.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        //botao play
        buttonPlay.frame = CGRect(
            x: (self.frame.width / 2) + (buttonSize * 0.25) ,
            y: backgound.frame.height  - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize
        )
        buttonPlay.setImage(UIImage(named: "MenuBtn"), forState: UIControlState.Normal)
        buttonPlay.addTarget(self, action: "confirmEndGame", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPlay.imageView?.frame = buttonPlay.frame
        buttonPlay.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonPlay.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.addSubview(buttonPlay)
        
        //botao play
        buttonReload.setImage(UIImage(named: "ReloadBtn"), forState: UIControlState.Normal)
        buttonReload.addTarget(self, action: "reload", forControlEvents: UIControlEvents.TouchUpInside)
        buttonReload.frame = CGRect(
            x: ((self.frame.width / 2) - (buttonSize * 1.25)),
            y: backgound.frame.height  - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize)
        buttonReload.imageView?.frame = buttonReload.frame
        buttonReload.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonReload.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.addSubview(buttonReload)
        let sizeReloadMenu = CGRect(
            x: (self.frame.width * 0.1) ,
            y: (self.frame.height * 0.25),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.4
        )
        viewEndGame = EndGameMenu(frame: sizeReloadMenu)
        viewEndGame.menu = self
        viewEndGame.hidden = true
        self.addSubview(viewEndGame)

        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height + ( buttonSize / 2 ))

        originYPos = self.frame.origin.y
        
    }
    
    func confirmEndGame() {
        viewEndGame.show()
    }
    func reload() {
        hideView(self)
        interactionsGame(true)
        (game as! GameScene).reloadGame()
    }
    func hide() {
        interactionsGame(true)
        hideView(self)
    }
    func show() {
        interactionsGame(false)
        showView(self)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interactionsGame(isInteract: Bool) {
        
        (game as! GameScene).igualBtn.userInteractionEnabled = isInteract
        (game as! GameScene).menuBtn.userInteractionEnabled = isInteract
        (game as! GameScene).apagarBtn.userInteractionEnabled = isInteract
        (game as! GameScene).moreBtn.userInteractionEnabled = isInteract
        (game as! GameScene).pauseBtn.userInteractionEnabled = isInteract
        for block in (game as! GameScene).blocks {
            block.userInteractionEnabled = isInteract
        }
        
    }
    
    func showView(dropDownView: UIView) {
        (game as! GameScene).showBlurView(true)
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

            let helpText = "Nivel: \((game as! GameScene).level)  \n \n Blocos: \((game as! GameScene).pontos)  \n Tempo restante: \((game as! GameScene).tempoLbl.text) \n  \n Jogadas: \((game as! GameScene).statistics.answers)  \n Acertos: \((game as! GameScene).statistics.answersCorrect)  \n Erros: \((game as! GameScene).statistics.answersWrong) \n N• de Blocos da melhor jogada: \((game as! GameScene).statistics.maxBlocksAnswer) \n \n Meta: conseguir \((game as! GameScene).checkpointLevel) blocos \n em \((game as! GameScene).timeSring()) "
            
            var myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByCharWrapping
            label.attributedText = myMutableString
        }
        dropDownView.hidden = false
        let startYposition = originYPos
        dropDownView.frame.origin.y = self.originYPos - (self.originYPos + dropDownView.frame.height)
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.frame.origin.y = startYposition
                dropDownView.superview?.layoutIfNeeded()
            }
        )
        self.bringSubviewToFront(viewEndGame)

        
    }
    
    func hideView(dropDownView: UIView) {
        (game as! GameScene).showBlurView(false)

        let startYposition = dropDownView.frame.origin.y + dropDownView.frame.height
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