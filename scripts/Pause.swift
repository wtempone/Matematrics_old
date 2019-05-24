//
//  Pause.swift
//  Matematrics
//
//  Created by William Tempone on 27/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import UIKit
import SpriteKit
class PauseMenu: UIView {
    // paineis externos
    var viewReload:ReloadMenu!
    var viewEndGame:EndGameMenu!
    var chepoinsts = []
    // controles de tamanho
    var originYPos: CGFloat = CGFloat()
    var buttonSize: CGFloat = CGFloat()
    var starRect = CGRect()
    var panelRect = CGRect()
    var gapstar = CGFloat()
    var starSize = CGFloat()
    var gap = CGFloat()
    var colslength = CGFloat()
    
    // botoes
    var buttonPlay = UIButton()
    var buttonReload = UIButton()
    var buttonMenu = UIButton()
    // labels
    var title = UILabel()
    var label = UILabel()
    var acertos = UILabel()
    var erros = UILabel()
    var meta = UILabel()
    var blocksLevel = UILabel()
    var textIndex = UILabel()
    var textDisplay = UILabel()
    var textBlocks = UILabel()
    var textBonus = UILabel()
    var textTotal = UILabel()
    
    
    
    // views
    var scrollView = UIScrollView()
    var viewLine = UIView()
    var backgound = UIImageView()
    var ribon = UIImageView()
    var starImage = UIImageView()
    var viimageGold = UIImageView()
    var viimageAcertos = UIImageView()
    var viimageErros = UIImageView()
    var viimageBasePage = UIImageView()
    var viimageBonus = UIImageView()
    var viimageResult = UIImageView()
    // imagens
    
    var imageResult = UIImage()
    let imageMenuBtn = UIImage(named: "MenuBtn")
    let imageReloadBtn = UIImage(named: "ReloadBtn")
    let imagePlayBtn = UIImage(named: "PlayButton")

    let imageGoldBlock = UIImage(named: "goldBlock")!
    let imageStar = UIImage(named: "levelBase")!
    let ribonImage = UIImage(named: "RibbonPause")
    let image = UIImage(named: "Panel")
    let imageStarActive = [UIImage(named: "star1"),
        UIImage(named: "star2"),
        UIImage(named: "star3")
    ]
    let imageStarInactive = [
        UIImage(named: "star1shadow"),
        UIImage(named: "star2Shadow"),
        UIImage(named: "star3Shadow")
    ]
    let imageAcertos = UIImage(named: "acerto")
    let imageErros = UIImage(named: "erro")
    
    let imageBasePage = UIImage(named: "basePage")
    let imageBonus = UIImage(named: "BonusImage")
    
    // atributos do texto
    var shadow : NSShadow = NSShadow()
    
    var game: SKScene = SKScene()

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
        
        backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "Panel")
        backgound.image = image
        self.addSubview(backgound)
        ribon = UIImageView(image: ribonImage)
        let ribbonWidth = self.frame.size.width * 0.4
        let ribbonHeigth = ribon.frame.size.height * (ribbonWidth / ribon.frame.size.width)

        ribon.frame = CGRect(x: ((self.frame.width / 2) - (ribbonWidth / 2)), y: -(ribbonHeigth / 3) ,
            width: ribbonWidth, height: ribbonHeigth)
        self.addSubview(ribon)
        
        //messagee
            label.layer.shadowOffset = (CGSize(width: 2, height: 2))
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 1
            label.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        label.textAlignment = NSTextAlignment.Center
            self.addSubview(label)
        
        //botao reload
        buttonReload.setImage(imageReloadBtn, forState: UIControlState.Normal)
        buttonReload.addTarget(self, action: "confirmReload", forControlEvents: UIControlEvents.TouchUpInside)
        buttonReload.frame = CGRect(
            x: ((self.frame.width / 2) - (buttonSize * 1.70)),
            y: backgound.frame.height  - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize)
        buttonReload.imageView?.frame = buttonReload.frame
        buttonReload.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonReload.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.addSubview(buttonReload)
        
        //botao play
        buttonPlay.frame = CGRect(
            x: (self.frame.width / 2) - (buttonSize * 0.5) ,
            y: backgound.frame.height  - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize
        )
        buttonPlay.setImage(imagePlayBtn, forState: UIControlState.Normal)
        buttonPlay.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPlay.imageView?.frame = buttonPlay.frame
        buttonPlay.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonPlay.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill

        self.addSubview(buttonPlay)
        //botao play
        buttonMenu.frame = CGRect(
            x: (self.frame.width / 2) + (buttonSize * 0.70) ,
            y: backgound.frame.height  - (buttonSize / 2),
            width: buttonSize,
            height: buttonSize
        )
        buttonMenu.setImage(UIImage(named: "MenuBtn"), forState: UIControlState.Normal)
        buttonMenu.addTarget(self, action: "confirmEndGame", forControlEvents: UIControlEvents.TouchUpInside)
        buttonMenu.imageView?.frame = buttonMenu.frame
        buttonMenu.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.addSubview(buttonMenu)
        let sizeReloadMenu = CGRect(
            x: (self.frame.width * 0.1) ,
            y: (self.frame.height * 0.25),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.4
        )
        viewReload = ReloadMenu(frame: sizeReloadMenu)
        viewReload.menu = self
        viewReload.hidden = true
        self.addSubview(viewReload)
        viewEndGame = EndGameMenu(frame: sizeReloadMenu)
        viewEndGame.menu = self
        viewEndGame.hidden = true
        self.addSubview(viewEndGame)

        originYPos = self.frame.origin.y
        
        //messagee
        title = UILabel(frame: CGRect(x: 0, y: ribon.frame.height, width: self.frame.width , height: self.frame.height * 0.05))
        title.layer.shadowOffset = (CGSize(width: 2, height: 2))
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 1
        title.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        title.textAlignment = NSTextAlignment.Center
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        self.addSubview(title)
        
        meta.layer.shadowOffset = (CGSize(width: 2, height: 2))
        meta.layer.shadowOpacity = 1
        meta.layer.shadowRadius = 1
        meta.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        meta.textAlignment = NSTextAlignment.Center
        meta.numberOfLines = 0
        meta.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        self.addSubview(meta)
        
        blocksLevel = UILabel(frame: CGRect(x: (self.frame.width / 2) - ( title.frame.height * 3 ) ,
            y: title.frame.origin.y + (title.frame.height * 1.9) ,
            width: ( title.frame.height * 4 ) ,
            height: title.frame.height * 2 ))
        
        blocksLevel.layer.shadowOffset = (CGSize(width: 2, height: 2))
        blocksLevel.layer.shadowOpacity = 1
        blocksLevel.layer.shadowRadius = 1
        blocksLevel.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        blocksLevel.textAlignment = NSTextAlignment.Right
        blocksLevel.numberOfLines = 0
        blocksLevel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        blocksLevel.adjustsFontSizeToFitWidth = true
        
        starRect = CGRect(
            x: self.frame.width * 0.1 ,
            y: blocksLevel.frame.origin.y + ( blocksLevel.frame.height * 1.5 ),
            width: self.frame.width * 0.8, //- (buttonSize * 0.5),
            height: self.frame.height * 0.01)
        
        
        gapstar = starRect.width * 0.07
        starSize = (starRect.width - (gapstar * 4 ) ) / 3
        
        
        gap = starRect.width / 11
        
        acertos = UILabel(frame: CGRect(x: starRect.origin.x + gap * 2, y: starRect.origin.y + starRect.height, width: gap * 2 , height: gap))
        acertos.layer.shadowOffset = (CGSize(width: 2, height: 2))
        acertos.layer.shadowOpacity = 1
        acertos.layer.shadowRadius = 1
        acertos.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        acertos.textAlignment = NSTextAlignment.Center
        acertos.numberOfLines = 0
        acertos.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        
        erros = UILabel(frame: CGRect(x: acertos.frame.origin.x + acertos.frame.width + ( 2 * gap), y: starRect.origin.y + starRect.height, width: gap , height: gap))
        erros.layer.shadowOffset = (CGSize(width: 2, height: 2))
        erros.layer.shadowOpacity = 1
        erros.layer.shadowRadius = 1
        erros.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        erros.textAlignment = NSTextAlignment.Center
        erros.numberOfLines = 0
        erros.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        
        // adiciona scrow view
        viimageGold = UIImageView(frame: CGRect(x: blocksLevel.frame.origin.x + blocksLevel.frame.width,
            y: blocksLevel.frame.origin.y,
            width: blocksLevel.frame.height,
            height: blocksLevel.frame.height)
        )
        viimageGold.image = imageGoldBlock

        
        meta = UILabel(frame: CGRect(
            x: self.frame.width * 0.1 ,
            y: acertos.frame.origin.y + ( acertos.frame.height ),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.3 ))
        
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
            
            let helpText = "Meta: conseguir \((game as! GameScene).checkpointLevel) blocos em \n \((game as! GameScene).timeSring()) "
            
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)

            meta.numberOfLines = 0
            meta.lineBreakMode = NSLineBreakMode.ByCharWrapping

            meta.attributedText = myMutableString
            meta.textAlignment = NSTextAlignment.Center
            
        }
        label = UILabel(frame: CGRect(
            x: self.frame.width * 0.1 ,
            y: meta.frame.origin.y + ( meta.frame.height * 1.3 ),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.1 ))
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height + ( buttonSize / 2 ))
    }
    
    func play() {
        hide()
        (game as! GameScene).pauseGame()
        
    }
    func confirmReload() {
        viewReload.show()
    }
    func confirmEndGame() {
        viewEndGame.show()
    }
    func reload() {
        hideView(self)
        (game as! GameScene).reloadGame()
    }
    func hide() {
        interactionsGame(true)
        hideView(self)        
        (game as! GameScene).paused = false
    }
    func show() {
        
        self.layer.removeAllAnimations()
        for view in self.subviews {
            
            if !view.isKindOfClass(UIButton) && !view.isKindOfClass(ReloadMenu) && !view.isKindOfClass(EndGameMenu){
                if view.isKindOfClass(UIImageView) {
                    if !(view as! UIImageView == backgound || view as! UIImageView == ribon ) {
                        view.removeFromSuperview()
                    }
                } else if view.isKindOfClass(UILabel)  {
                    
                    if !(view as! UILabel == title) {
                        view.removeFromSuperview()
                    }
                } else {
                    view.removeFromSuperview()
                }
            }
        }
        
        (game as! GameScene).showBlurView(true)
        interactionsGame(false)
        showView(self)
        
        if let font =  UIFont(name: "Skranji-Bold", size: title.frame.height ) {
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
            
            var helpText = "Nivel: \((game as! GameScene).level)"
            
            var myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            title.attributedText = myMutableString
            
        }
        
        // bonus image
        if let font =  UIFont(name: "Skranji-Bold", size: blocksLevel.frame.height ) {
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
            
            var helpText = "\((game as! GameScene).pontos)"
            
            var myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            blocksLevel.attributedText = myMutableString
        }
        self.addSubview(blocksLevel)
        self.addSubview(viimageGold)
        
        // adiciona mesagem acertos
        if let font =  UIFont(name: "Skranji-Bold", size: acertos.frame.height) {
            
            shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
            let textFontAttributes = [
                NSFontAttributeName : font,
                // Note: SKColor.whiteColor().CGColor breaks this
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1),
                // Note: Use negative value here if you want foreground color to show
                NSStrokeWidthAttributeName: -5
            ]
            var myMutableString = NSMutableAttributedString(
                string: "\((self.game as! GameScene).statistics.answersCorrect) ",
                attributes: textFontAttributes)
            acertos.numberOfLines = 0
            acertos.lineBreakMode = NSLineBreakMode.ByCharWrapping
            acertos.attributedText = myMutableString
            acertos.textAlignment = NSTextAlignment.Right
            myMutableString = NSMutableAttributedString(
                string: "\( (self.game as! GameScene).statistics.answersWrong) ",
                attributes: textFontAttributes)
            erros.numberOfLines = 0
            erros.lineBreakMode = NSLineBreakMode.ByCharWrapping
            erros.attributedText = myMutableString
            erros.textAlignment = NSTextAlignment.Right
        }
        // adiciona figura acertos
        self.addSubview(acertos)
        self.addSubview(erros)
        viimageAcertos = UIImageView(frame: CGRect(x: acertos.frame.origin.x + acertos.frame.width,
            y: acertos.frame.origin.y,
            width: gap,
            height: gap)
        )
        viimageAcertos.image = imageAcertos
        self.addSubview(viimageAcertos)
        
        // adiciona figura erros
        viimageErros = UIImageView(frame: CGRect(x: erros.frame.origin.x + erros.frame.width,
            y: erros.frame.origin.y,
            width: gap,
            height: gap)
        )
        viimageErros.image = imageErros
        self.addSubview(viimageErros)
        
        self.addSubview(meta)
        
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
            var vmessage = ""
            if (game as! GameScene).statistics.chances == enumChances.Bad {
                vmessage = NSLocalizedString("Pause Chances Bad", comment: "Chances estao ruins")
            } else if (game as! GameScene).statistics.chances == enumChances.Reguar {
                vmessage = NSLocalizedString("Pause Chances Regular", comment: "Chances estao normais")
            } else if (game as! GameScene).statistics.chances == enumChances.Good {
                vmessage = NSLocalizedString("Pause Chances Good", comment: "Chances estao boas")
            } else if (game as! GameScene).statistics.chances == enumChances.Great {
                vmessage = NSLocalizedString("Pause Chances Great", comment: "Chances estao normais")
            }
            var myMutableString = NSMutableAttributedString(
                string: vmessage,
                attributes: textFontAttributes)
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByCharWrapping
            label.attributedText = myMutableString
            label.textAlignment = NSTextAlignment.Center
        }
        self.addSubview(label)

        self.bringSubviewToFront(viewEndGame)
        self.bringSubviewToFront(viewReload)

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