//
//  Pause.swift
//  Matematrics
//
//  Created by William Tempone on 27/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import UIKit
import SpriteKit
@available(iOS 8.0, *)
class Panel: UIView,UIScrollViewDelegate {
    var game: SKScene = SKScene()
    // paineis externos
    var viewReload:ReloadMenu!
    var viewEndGame:EndGameMenu!
    var chepoinsts = []
    // controles de tamanho
    var originYPos: CGFloat = CGFloat()
    var starRect = CGRect()
    var panelRect = CGRect()
    var gapstar = CGFloat()
    var starSize = CGFloat()
    var gap = CGFloat()
    var colslength = CGFloat()
    
    // botoes
    let buttonForward = UIButton()
    let buttonReload = UIButton()
    let buttonMenu = UIButton()
    let buttonPlay = UIButton()
    
    // labels
    var fase = UILabel()
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
    var starImageArray = [UIImageView(image: UIImage(named: "star1")),
        UIImageView(image: UIImage(named: "star2")),
        UIImageView(image: UIImage(named: "star3"))]
    var viimageGold = UIImageView()
    var viimageAcertos = UIImageView()
    var viimageErros = UIImageView()
    var viimageBasePage = UIImageView()
    var viimageBonus = UIImageView()
    var viimageResult = UIImageView()
    // imagens
    var imageResult = UIImage()
    let imagePlayBtn = UIImage(named: "PlayButton")
    let imageMenuBtn = UIImage(named: "MenuBtn")!
    let imageReloadBtn = UIImage(named: "ReloadBtn")
    let imageFowardBtn = UIImage(named: "ForwardBtn")
    let imageGoldBlock = UIImage(named: "goldBlock")!
    let imageStar = UIImage(named: "levelBase")!
    let ribonImageWin = UIImage(named: "RibonGameWin")
    let ribonImageOver = UIImage(named: "RibonGameOver")
    let ribonImagePause = UIImage(named: "RibonPause")
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
    var type : enumTypePanel = enumTypePanel.Paused
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func didMoveToSuperview() {
        
        chepoinsts = [(self.game as! GameScene).currentLevel.checkpointLevel, (self.game as! GameScene).currentLevel.checkpointLevel2, (self.game as! GameScene).currentLevel.checkpointLevel3]
        
        let myframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        backgound = UIImageView(frame: myframe)
        backgound.image = image
        self.addSubview(backgound)
        ribon = UIImageView(image: ribonImagePause)
        let ribbonWidth = self.frame.size.width * 0.6
        let ribbonHeigth = ribon.frame.size.height * (ribbonWidth / ribon.frame.size.width)
        
        ribon.frame = CGRect(x: ((self.frame.origin.x + self.frame.width) / 2) - (ribbonWidth / 2), y: -(ribbonHeigth / 3) ,
            width: ribbonWidth, height: ribbonHeigth)
        self.addSubview(ribon)
        
        //botao play
        buttonPlay.frame = CGRect(
            x: (self.frame.width / 2) - (GLOBALbuttonSize.width / 2) ,
            y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
            width: GLOBALbuttonSize.width,
            height: GLOBALbuttonSize.height
        )
        
        buttonPlay.setImage(imagePlayBtn, forState: UIControlState.Normal)
        buttonPlay.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
        buttonPlay.imageView?.frame = buttonPlay.frame
        buttonPlay.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonPlay.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.addSubview(buttonPlay)
        // botao menu
        buttonMenu.frame = CGRect(
            x: (self.frame.width / 2)  - (GLOBALbuttonSize.width * 1.70) ,
            y: self.frame.height - (GLOBALbuttonSize.height * 0.5) ,
            width: GLOBALbuttonSize.width,
            height: GLOBALbuttonSize.height
        )
        
        buttonMenu.setImage(imageMenuBtn , forState: UIControlState.Normal)
        buttonMenu.addTarget(self, action: "confirmEndGame", forControlEvents: UIControlEvents.TouchUpInside)
        buttonMenu.imageView?.frame = buttonMenu.frame
        buttonMenu.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.addSubview(buttonMenu)
        
        //botao reload
        buttonReload.setImage(imageReloadBtn , forState: UIControlState.Normal)
        buttonReload.addTarget(self, action: "confirmReload", forControlEvents: UIControlEvents.TouchUpInside)
        buttonReload.frame = CGRect(
            x: ((self.frame.width / 2) - (GLOBALbuttonSize.width * 0.5)),
            y: self.frame.height - (GLOBALbuttonSize.height * 0.5) ,
            width: GLOBALbuttonSize.width,
            height: GLOBALbuttonSize.height)
        buttonReload.imageView?.frame = buttonReload.frame
        buttonReload.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonReload.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        self.addSubview(buttonReload)
        
        //botao foward
        buttonForward.frame = CGRect(
            x: (self.frame.width / 2) + (GLOBALbuttonSize.width * 0.70) ,
            y: self.frame.height - (GLOBALbuttonSize.height * 0.5) ,
            width: GLOBALbuttonSize.width,
            height: GLOBALbuttonSize.height
        )
        buttonForward.setImage(imageFowardBtn , forState: UIControlState.Normal)
        buttonForward.addTarget(self, action: "foward", forControlEvents: UIControlEvents.TouchUpInside)
        buttonForward.imageView?.frame =  buttonForward.frame
        buttonForward.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        buttonForward.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        self.addSubview( buttonForward)
        let sizeReloadMenu = CGRect(
            x: (self.frame.width * 0.1) ,
            y: (self.frame.height * 0.25),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.4
        )
        
        viewReload = ReloadMenu(frame: sizeReloadMenu)
        viewReload.menu = self
        viewReload.hidden = true
        viewReload.layer.zPosition = 12
        self.addSubview(viewReload)
        
        viewEndGame = EndGameMenu(frame: sizeReloadMenu)
        viewEndGame.menu = self
        viewEndGame.hidden = true
        viewEndGame.layer.zPosition = 12
        self.addSubview(viewEndGame)
        
        originYPos = self.frame.origin.y
        
        //messagee
        fase = UILabel(frame: CGRect(x: 0,
            y: ribon.frame.origin.y + ribon.frame.height, width: self.frame.width , height: self.frame.height * 0.05))
        fase.layer.shadowOffset = (CGSize(width: 2, height: 2))
        fase.layer.shadowOpacity = 1
        fase.layer.shadowRadius = 1
        fase.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        fase.textAlignment = NSTextAlignment.Center
        fase.numberOfLines = 0
        fase.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        self.addSubview(fase)
        
        title = UILabel(frame: CGRect(x: 0,
            y: fase.frame.origin.y + fase.frame.height, width: self.frame.width , height: self.frame.height * 0.05))
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
            y: title.frame.origin.y + (title.frame.height * 1.5) ,
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
            width: self.frame.width * 0.8, //- (GLOBALbuttonSize * 0.5),
            height: self.frame.height * 0.14)
        
        
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
        //        scrollView.frame = scrollframe
        scrollView.frame  = CGRect(
            x: self.frame.width * 0.1 ,
            y: acertos.frame.origin.y + ( acertos.frame.height * 1.3 ),
            width: self.frame.width * 0.8,
            height: self.frame.height * 0.32 )
        
        viimageGold = UIImageView(frame: CGRect(x: blocksLevel.frame.origin.x + blocksLevel.frame.width,
            y: blocksLevel.frame.origin.y,
            width: blocksLevel.frame.height,
            height: blocksLevel.frame.height)
        )
        viimageGold.image = imageGoldBlock
        
        
        //copiar pra baixo
        panelRect =  CGRect(x: scrollView.frame.origin.x,
            y: scrollView.frame.origin.y,
            width: scrollView.frame.width,
            height: scrollView.frame.height / 4 )
        colslength = scrollView.frame.width / 12
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height + ( GLOBALbuttonSize.height / 2 ))
        
    }
    
    func foward() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        
        let nextFase = (self.game as! GameScene).currentLevel.level + 1 > 20 ? (self.game as! GameScene).currentLevel.fase + 1 : (self.game as! GameScene).currentLevel.fase
        
        let nextLevel = (self.game as! GameScene).currentLevel.level + 1 > 20 ? 1 : (self.game as! GameScene).currentLevel.level
            + 1
        
        let levelOriginal = GLOBALlevelManager.readLevelOriginal(nextFase, level:nextLevel)
        (self.game as! GameScene).loadGame(levelOriginal)
        
        hide()
    }
    func play() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        hide()
        (game as! GameScene).pauseGame()
        
    }
    
    func confirmReload() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        
        viewReload.show()
    }
    func confirmEndGame() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        viewEndGame.show()
    }
    func reload() {
        
        if GLOBALsounds {
            somAVBotao?.play()
        }
        hideView(self)
        let loading = Loading(frame: self.frame, parent: (game as! GameScene))
        loading.layer.zPosition = 10
        loading.alpha = 0
        (game as! GameScene).view?.addSubview(loading)
        
        UIView.animateWithDuration(0.4,
            animations: {
                loading.alpha = 1
            }, completion: {  animationFinished in
                loading.removeFromSuperview()
                (self.game as! GameScene).loadGame((self.game as! GameScene).currentLevel)
            }
        )
        
    }
    func hide() {
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        interactionsGame(true)
        hideView(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interactionsGame(isInteract: Bool) {
        
        (game as! GameScene).igualBtn.userInteractionEnabled = isInteract
        (game as! GameScene).menuBtn.userInteractionEnabled = isInteract
        (game as! GameScene).apagarBtn.userInteractionEnabled = isInteract
        (game as! GameScene).moreBtn.userInteractionEnabled = isInteract
        (game as! GameScene).pauseBtn.userInteractionEnabled = isInteract
        /*for block in  (game as! GameScene).blocks {
            block.userInteractionEnabled = isInteract
        }*/
        
    }
    
    func show (type : enumTypePanel? = enumTypePanel.Paused){
        self.type = type!
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        SetButtons(type)
        
        self.layer.removeAllAnimations()
        
        for view in self.subviews {
            
            if !view.isKindOfClass(UIButton) && !view.isKindOfClass(ReloadMenu) && !view.isKindOfClass(EndGameMenu){
                if view.isKindOfClass(UIImageView) {
                    if !(view as! UIImageView == backgound || view as! UIImageView == ribon ) {
                        view.removeFromSuperview()
                    }
                } else if view.isKindOfClass(UILabel)  {
                    
                    if !(view as! UILabel == title) && !(view as! UILabel == fase) {
                        view.removeFromSuperview()
                    }
                } else {
                    view.removeFromSuperview()
                }
            }
        }
        if type == enumTypePanel.Paused {
            ribon.image = ribonImagePause
        } else if type == enumTypePanel.Win {
            ribon.image = ribonImageWin
        } else if type == enumTypePanel.Over {
            ribon.image = ribonImageOver
        }
        if type == enumTypePanel.Paused {
            
            let ribbonWidth = self.frame.size.width * 0.35
            let ribbonHeigth = ribon.frame.size.height * (ribbonWidth / ribon.frame.size.width)
            
            ribon.frame = CGRect(x: ((self.frame.origin.x + self.frame.width) / 2) - (ribbonWidth / 2), y: -(ribbonHeigth / 3) ,
                width: ribbonWidth, height: ribbonHeigth)
        } else {
            
            let ribbonWidth = self.frame.size.width * 0.6
            let ribbonHeigth = ribon.frame.size.height * (ribbonWidth / ribon.frame.size.width)
            
            ribon.frame = CGRect(x: ((self.frame.origin.x + self.frame.width) / 2) - (ribbonWidth / 2), y: -(ribbonHeigth / 3) ,
                width: ribbonWidth, height: ribbonHeigth)
            
        }
        if let font =  UIFont(name: "Skranji-Bold", size: fase.frame.height * 0.6 ) {
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
            
            let helpText = String(format: NSLocalizedString("Fase", comment: ""), (game as! GameScene).currentLevel.descriptionFase)
            
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            
            fase.attributedText = myMutableString
            
        }
        
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
            
            let helpText = String(format: NSLocalizedString("Level", comment: ""), (game as! GameScene).currentLevel.level)
            let myMutableString = NSMutableAttributedString(
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
            
            let helpText = "\((game as! GameScene).pontos)"
            
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            blocksLevel.attributedText = myMutableString
        }
        self.addSubview(blocksLevel)
        /*if type != enumTypePanel.Paused {
        (self.game as! GameScene).animations.animationScaleEffect(blocksLevel, animationTime: 0.1)
        }*/
        self.addSubview(viimageGold)
        /*
        if type != enumTypePanel.Paused {
        (self.game as! GameScene).animations.animationScaleEffect(viimageGold, animationTime: 0.1)
        }*/
        var nextx = starRect.origin.x + gapstar
        var nexty = starRect.origin.y
        if type != enumTypePanel.Paused {
            
            for indStar in 0...2{
                if indStar == 1 {
                    nexty = starRect.origin.y - (gapstar / 2)
                } else {
                    nexty = starRect.origin.y
                }
                let starImage = UIImageView(frame: CGRect(x: nextx, y: nexty, width: starSize, height: starSize))
                starImage.image = imageStarInactive[indStar]
                self.addSubview(starImage)
                nextx += (starSize + gapstar)
                
            }
            
            // star actives
            starImage = UIImageView()
            nextx = starRect.origin.x + gapstar
            nexty = starRect.origin.y
            if (game as! GameScene).stars > 0 {
                for indStar in 0...(game as! GameScene).stars - 1 {
                    if indStar == 1 {
                        nexty = starRect.origin.y - (gapstar / 2)
                    } else {
                        nexty = starRect.origin.y
                    }
                    self.starImageArray[indStar] = UIImageView(frame: CGRect(x: nextx, y: nexty, width: starSize, height: starSize))
                    self.starImageArray[indStar].image = imageStarActive[indStar]
                    self.starImageArray[indStar].layer.zPosition = 11
                    self.addSubview(self.starImageArray[indStar])
                    //(self.game as! GameScene).animations.animationScaleEffect(starImage, animationTime: 0.3)
                    nextx += (starSize + gapstar)
                }
            }
            acertos = UILabel(frame: CGRect(x: starRect.origin.x + gap * 2, y: starRect.origin.y + starRect.height, width: gap * 2 , height: gap))
        } else {
            acertos = UILabel(frame: CGRect(x: starRect.origin.x + gap * 2, y: starRect.origin.y , width: gap * 2 , height: gap))
        }
        erros = UILabel(frame: CGRect(x: acertos.frame.origin.x + acertos.frame.width + ( 2 * gap), y: acertos.frame.origin.y, width: gap , height: gap))
        
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
        /*if type != enumTypePanel.Paused {
        (self.game as! GameScene).animations.animationScaleEffect(acertos, animationTime: 0.1)
        }*/
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
        /*if type != enumTypePanel.Paused {
        (self.game as! GameScene).animations.animationScaleEffect(viimageAcertos, animationTime: 0.1)
        (self.game as! GameScene).animations.animationScaleEffect(erros, animationTime: 0.1)
        (self.game as! GameScene).animations.animationScaleEffect(viimageErros, animationTime: 0.1)
        }*/
        viimageErros = UIImageView(frame: CGRect(x: erros.frame.origin.x + erros.frame.width,
            y: erros.frame.origin.y,
            width: gap,
            height: gap)
        )
        viimageErros.image = imageErros
        self.addSubview(viimageErros)
        if type != enumTypePanel.Paused {
            //(self.game as! GameScene).animations.animationScaleEffect(viimageErros, animationTime: 0.1)
            if (self.game as! GameScene).statistics.trys.count > 0 {
                scrollView.contentSize = CGSize(width: panelRect.width, height: panelRect.height * CGFloat((self.game as! GameScene).statistics.trys.count) )
                for ind in  0...(self.game as! GameScene).statistics.trys.count - 1 {
                    // imagem de fundo da linha
                    viewLine = UIView(frame: CGRect(x: 0, y: panelRect.height * CGFloat(ind), width: panelRect.width, height: panelRect.height))
                    viimageBasePage = UIImageView(frame: CGRect(x: 0, y:  0, width: viewLine.frame.width , height: viewLine.frame.height ))
                    viimageBasePage.image = imageBasePage
                    viewLine.addSubview(viimageBasePage)
                    // indiceresposta
                    // answer text
                    textIndex = UILabel(frame: CGRect(x: colslength / 2,
                        y: viimageBasePage.frame.height * 0.15 ,
                        width: viewLine.frame.height * 0.7,
                        height: viewLine.frame.height * 0.7 ))
                    textIndex.layer.shadowOffset = (CGSize(width: 2, height: 2))
                    textIndex.layer.shadowOpacity = 1
                    textIndex.layer.shadowRadius = 1
                    textIndex.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
                    textIndex.textAlignment = NSTextAlignment.Center
                    textIndex.numberOfLines = 0
                    textIndex.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    
                    
                    // imagem de acerto ou erro
                    imageResult = ((self.game as! GameScene).statistics.trys[ind].result == enumAnswer.Correct ? imageAcertos : imageErros)!
                    viimageResult = UIImageView(frame: CGRect(x: colslength * 2 , y:  viewLine.frame.height * 0.15 , width: viewLine.frame.height * 0.5 , height: viewLine.frame.height * 0.5))
                    viimageResult.image = imageResult
                    viewLine.addSubview(viimageResult)
                    viewLine.bringSubviewToFront(viimageResult)
                    
                    // answer base
                    let imageDisplay = UIImage(named: "BonusProgressBase")
                    let viimageDisplay = UIImageView(frame: CGRect(x: (colslength * 3) , y:  viewLine.frame.height * 0.15, width: colslength * 5, height: viewLine.frame.height * 0.7 ))
                    viimageDisplay.image = imageDisplay
                    viewLine.addSubview(viimageDisplay)
                    viewLine.bringSubviewToFront(viimageDisplay)
                    
                    // answer text
                    textDisplay = UILabel(frame: CGRect(x: colslength * 3,
                        y: viewLine.frame.height * 0.15 ,
                        width: colslength * 5 ,
                        height: viewLine.frame.height * 0.7 ))
                    textDisplay.layer.shadowOffset = (CGSize(width: 2, height: 2))
                    textDisplay.layer.shadowOpacity = 1
                    textDisplay.layer.shadowRadius = 1
                    textDisplay.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
                    textDisplay.textAlignment = NSTextAlignment.Center
                    textDisplay.numberOfLines = 0
                    textDisplay.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    
                    // Blocks
                    textBlocks = UILabel(frame: CGRect(x: colslength * 8,
                        y: viewLine.frame.height * 0.15 ,
                        width: colslength * 1.5,
                        height: viewLine.frame.height * 0.7 ))
                    textBlocks.layer.shadowOffset = (CGSize(width: 2, height: 2))
                    textBlocks.layer.shadowOpacity = 1
                    textBlocks.layer.shadowRadius = 1
                    textBlocks.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
                    textBlocks.textAlignment = NSTextAlignment.Center
                    textBlocks.numberOfLines = 0
                    textBlocks.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    // bonus image
                    viimageBonus = UIImageView(frame: CGRect(x: colslength * 9.5, y: viewLine.frame.height * 0.15 , width: viewLine.frame.height * 0.7, height: viewLine.frame.height * 0.7 ))
                    viimageBonus.image = imageBonus
                    viewLine.addSubview(viimageBonus)
                    viewLine.bringSubviewToFront(viimageBonus)
                    viimageBonus.hidden = !((game as! GameScene).statistics.trys[ind].bonus > 1)
                    
                    // bonus text
                    textBonus = UILabel(frame: CGRect(x: colslength * 9.5, y: viewLine.frame.height * 0.15 , width: viewLine.frame.height * 0.7, height: viewLine.frame.height * 0.7 ))
                    //textBonus.layer.shadowOffset = (CGSize(width: 2, height: 2))
                    //textBonus.layer.shadowOpacity = 1
                    //textBonus.layer.shadowRadius = 1
                    textBonus.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
                    textBonus.textAlignment = NSTextAlignment.Center
                    textBonus.numberOfLines = 0
                    textBonus.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    textBonus.hidden = !((game as! GameScene).statistics.trys[ind].bonus > 1)
                    // total
                    textTotal = UILabel(frame: CGRect(x: colslength * 10.5, y: viewLine.frame.height * 0.15 , width: colslength * 1.5, height: viewLine.frame.height * 0.7 ))
                    textTotal.layer.shadowOffset = (CGSize(width: 2, height: 2))
                    textTotal.layer.shadowOpacity = 1
                    textTotal.layer.shadowRadius = 1
                    textTotal.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
                    textTotal.textAlignment = NSTextAlignment.Center
                    textTotal.numberOfLines = 0
                    textTotal.lineBreakMode = NSLineBreakMode.ByCharWrapping
                    textTotal.hidden = !((game as! GameScene).statistics.trys[ind].bonus > 1)
                    // Meta
                    if let font =  UIFont(name: "Skranji-Bold", size: viewLine.frame.height / 2 ) {
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
                        
                        var helpText = "\((game as! GameScene).statistics.trys[ind].answerString)"
                        
                        var myMutableString = NSMutableAttributedString(
                            string: helpText,
                            attributes: textFontAttributes)
                        textDisplay.attributedText = myMutableString
                        
                        helpText = "\(ind + 1)"   //"\((game as! GameScene).statistics.trys[ind].numBlocks)"
                        
                        myMutableString = NSMutableAttributedString(
                            string: helpText,
                            attributes: textFontAttributes)
                        textIndex.attributedText = myMutableString
                        
                        helpText = "\((game as! GameScene).statistics.trys[ind].numBlocks)"
                        
                        myMutableString = NSMutableAttributedString(
                            string: helpText,
                            attributes: textFontAttributes)
                        textBlocks.attributedText = myMutableString
                        
                        helpText = "\((game as! GameScene).statistics.trys[ind].totalBlocks)"
                        
                        myMutableString = NSMutableAttributedString(
                            string: helpText,
                            attributes: textFontAttributes)
                        textTotal.attributedText = myMutableString
                        
                    }
                    if let font =  UIFont(name: "Skranji-Bold", size: viewLine.frame.height / 3 ) {
                        let textFontAttributes = [
                            NSFontAttributeName : font,
                            // Note: SKColor.whiteColor().CGColor breaks this
                            NSForegroundColorAttributeName: UIColor.whiteColor(),
                            // Cor verde
                            NSStrokeColorAttributeName: UIColor(red: 67/255, green: 144/255, blue: 67/255, alpha: 1),
                            
                            // Note: Use negative value here if you want foreground color to show
                            NSStrokeWidthAttributeName: -5
                        ]
                        
                        let helpText = "\((game as! GameScene).statistics.trys[ind].bonus)"
                        
                        let myMutableString = NSMutableAttributedString(
                            string: helpText,
                            attributes: textFontAttributes)
                        textBonus.attributedText = myMutableString
                    }
                    // ajusta tamanho da fonte
                    //if textDisplay.frame.size.width > (viimageDisplay.frame.size.width)  {
                    //    textDisplay.fontSize = textDisplay.fontSize * ( viimageDisplay.frame.size.width / textDisplay.frame.size.width )
                    //}
                    textDisplay.adjustsFontSizeToFitWidth = true
                    
                    
                    viewLine.addSubview(textIndex)
                    viewLine.addSubview(textDisplay)
                    viewLine.bringSubviewToFront(textDisplay)
                    viewLine.addSubview(textBlocks)
                    viewLine.addSubview(textBonus)
                    viewLine.bringSubviewToFront(textBonus)
                    viewLine.addSubview(textTotal)
                    scrollView.addSubview(viewLine)
                    scrollView.bringSubviewToFront(viewLine)
                }
            }
            scrollView.pagingEnabled = false
            scrollView.showsHorizontalScrollIndicator = true
            
            scrollView.delegate = self
            scrollView.bounces = true
            
            scrollView.layoutIfNeeded()
            self.addSubview(scrollView)
            self.bringSubviewToFront(scrollView)
            scrollView.userInteractionEnabled  = true
            
            
            //(self.game as! GameScene).animations.animationScaleEffect(scrollView, animationTime: 0.1)
        }
        var metaFontSize = CGFloat(0.0)
        var helpText = ""
        
        if type != enumTypePanel.Paused {
            (self.game as! GameScene).clearMessages()
            
            meta = UILabel(frame: CGRect(x: scrollView.frame.origin.x,
                y: scrollView.frame.origin.y + scrollView.frame.height ,
                width: scrollView.frame.width,
                height: self.scrollView.frame.height / 6 ))
            metaFontSize =  self.frame.width * 0.028
            
            helpText = String(format: NSLocalizedString("Goal", comment: ""), (game as! GameScene).currentLevel.checkpointLevel,GLOBALtimeSring((game as! GameScene).currentLevel.checkpointTimer))
            
        } else {
            meta = UILabel(frame: CGRect(x: scrollView.frame.origin.x,
                y: acertos.frame.origin.y + ( acertos.frame.height * 1.5 ) ,
                width: scrollView.frame.width,
                height: scrollView.frame.height))
            metaFontSize =  self.frame.width * 0.05
            helpText = String(format: NSLocalizedString("Goal", comment: ""), (game as! GameScene).currentLevel.checkpointLevel,GLOBALtimeSring((game as! GameScene).currentLevel.checkpointTimer))
        }
        
        if let font =  UIFont(name: "Skranji-Bold", size: metaFontSize ) {
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
            
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            meta.attributedText = myMutableString
            meta.textAlignment = NSTextAlignment.Center
            meta.numberOfLines = 0
            meta.lineBreakMode = NSLineBreakMode.ByCharWrapping
            
            
            self.addSubview(meta)
            
            if type == enumTypePanel.Win {
                // salva conquista do nivel
                var level = myStructs.myLevelModel()
                level.fase = (self.game as! GameScene).currentLevel.fase
                level.level = (self.game as! GameScene).currentLevel.level
                level.locked = false
                level.stars = (self.game as! GameScene).stars
                GLOBALlevelManager.saveLevel(level)
                // destrava proximo nivel
                level = myStructs.myLevelModel()
                level = GLOBALlevelManager.readLevel(level.fase, level: level.level + 1)
                if level.level != 0 {
                    level.locked = false
                    if level.stars < (self.game as! GameScene).stars {
                        level.stars = (self.game as! GameScene).stars
                    }
                } else {
                    level.fase = (self.game as! GameScene).currentLevel.fase
                    level.level = (self.game as! GameScene).currentLevel.level + 1
                    level.lockedBefore = true
                    level.locked = false
                    level.stars = 0
                }
                GLOBALlevelManager.saveLevel(level)
            }
            self.bringSubviewToFront(viewEndGame)
            self.bringSubviewToFront(viewReload)
            (self.game as! GameScene).statistics.clear()
        }
        if type == enumTypePanel.Over {
            if (game as! GameScene).pontos > 0 {
                var auxPontos = (game as! GameScene).pontos
                var auxStars = (game as! GameScene).stars
                //Animação para limpar pontos e estrelas
                (game as! GameScene).runAction(
                    //Inicia sequencia para subtrair pontos
                    SKAction.sequence([
                        // aguarda um segundo e meio para começar -  tempo de descer o painel
                        SKAction.waitForDuration(1.5),
                        // subrtrai 1 vez até quantidade de pntos
                        SKAction.repeatAction(
                            SKAction.sequence([
                                //delay de animação
                                SKAction.waitForDuration(0.03),
                                // atualiza pontos
                                SKAction.runBlock({
                                    auxPontos -= 1
                                    if let font =  UIFont(name: "Skranji-Bold", size: self.blocksLevel.frame.height ) {
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
                                        
                                        let helpText = "\(auxPontos)"
                                        
                                        let myMutableString = NSMutableAttributedString(
                                            string: helpText,
                                            attributes: textFontAttributes)
                                        self.blocksLevel.attributedText = myMutableString
                                    }
                                })
                                // quantidade de repetições = numero de pontos
                                ]), count: (game as! GameScene).pontos),
                        // inicia sequencia para tirar estrelas == quantidade de estrelas
                        SKAction.repeatAction(
                            SKAction.sequence([
                                // delay da animação
                                SKAction.waitForDuration(0.4),
                                SKAction.runBlock({
                                    auxStars -= 1
                                    if auxStars >= 0 {
                                        UIView.animateWithDuration(0.4, animations: {
                                            self.starImageArray[auxStars].layer.position.y = self.frame.height * 1.5
                                            self.starImageArray[auxStars].transform = CGAffineTransformRotate(self.starImageArray[auxStars].transform , (6 * 3.1415926))
                                        })
                                    }
                                })
                                ]), count: (game as! GameScene).stars),
                        ])
                )
            }
        }
        (game as! GameScene).showBlurView(true)
        interactionsGame(false)
        showView(self)
        	
    }
    
    // define visibilidade e posicao dos botoes
    func SetButtons(type : enumTypePanel? = enumTypePanel.Paused) {
        if type == enumTypePanel.Win {
            // Define botoes visiveis
            buttonMenu.hidden = false
            buttonReload.hidden = false
            buttonForward.hidden = false
            buttonPlay.hidden = true
            // posiciona botoes
            buttonMenu.frame = CGRect(
                x: (self.frame.width / 2)  - (GLOBALbuttonSize.width * 1.70) ,
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
            buttonReload.frame = CGRect(
                x: ((self.frame.width / 2) - (GLOBALbuttonSize.width * 0.5)),
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
            buttonForward.frame = CGRect(
                x: (self.frame.width / 2) + (GLOBALbuttonSize.width * 0.70) ,
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
        } else if type == enumTypePanel.Over {
            // Define botoes visiveis
            buttonMenu.hidden = false
            buttonReload.hidden = false
            buttonForward.hidden = true
            buttonPlay.hidden = true
            // posiciona botoes
            buttonMenu.frame = CGRect(
                x: (self.frame.width / 2) + (GLOBALbuttonSize.width * 0.25) ,
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height
            )
            buttonReload.frame = CGRect(
                x: ((self.frame.width / 2) - (GLOBALbuttonSize.width * 1.25)),
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
            
        } else if type == enumTypePanel.Paused {
            // Define botoes visiveis
            buttonMenu.hidden = false
            buttonReload.hidden = false
            buttonForward.hidden = true
            buttonPlay.hidden = false
            self.bringSubviewToFront(buttonPlay)
            // posiciona botoes
            buttonReload.frame = CGRect(
                x: ((self.frame.width / 2) - (GLOBALbuttonSize.width * 1.70)),
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
            buttonPlay.frame = CGRect(
                x: (self.frame.width / 2) - (GLOBALbuttonSize.width * 0.5) ,
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
            buttonMenu.frame = CGRect(
                x: (self.frame.width / 2) + (GLOBALbuttonSize.width * 0.70) ,
                y: backgound.frame.height  - (GLOBALbuttonSize.height / 2),
                width: GLOBALbuttonSize.width,
                height: GLOBALbuttonSize.height)
        }
    }
    
    
    
    func showView(dropDownView: UIView) {
        
        dropDownView.hidden = false
        let startYposition = originYPos
        dropDownView.frame.origin.y = self.originYPos - (self.originYPos + dropDownView.frame.height)
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.frame.origin.y = startYposition
            }
        )
        
    }
    
    func hideView(dropDownView: UIView) {
        
        (game as! GameScene).showBlurView(false)
        
        UIView.animateWithDuration(0.4,
            animations: {
                dropDownView.frame.origin.y = self.originYPos - (self.originYPos + dropDownView.frame.height)
            }, completion: {
                (value: Bool) in
                dropDownView.hidden = true
                
            }
        )
        
        
    }
    
}