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
class LevelShow: UIView {
    var currentLevel:myStructs.myLevel = myStructs.myLevel ()
    var originYPos: CGFloat = CGFloat()
    var buttonSize: CGFloat = CGFloat()
    var backgound = UIImageView()
    let xbuttonPlay = UIButton()
    let xbuttonMenu = UIButton()
    var fase = UILabel()
    var regrasTitle = UILabel()
    var regrasBody = UITextView()
    var title = UILabel()
    var body = UITextView()
    var audioPlayer:AVAudioPlayer?
    var audioPlayer2:AVAudioPlayer?
    var parent:SKScene = SKScene()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience  init(frame: CGRect, parent: SKScene) {
        self.init(frame: frame)
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("botao",
                ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Erro ao tocar ")
        }
        let url2 = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("inicioNivel2",
                ofType: "mp3")!)
        
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOfURL: url2)
        } catch {
            print("Erro ao tocar ")
        }
        
        self.parent = parent
    }
    
    override func didMoveToSuperview() {
        buttonSize = GLOBALbuttonSize.height
        
        originYPos = self.frame.origin.y

        let myframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height )
        backgound = UIImageView(frame: myframe)
        let image = UIImage(named: "backgroundLevel")
        backgound.image = image
        self.addSubview(backgound)
        // acoes posicionadas abaixo
        
        
        //botao reload
        xbuttonMenu.setImage(UIImage(named: "MenuBtn"), forState: UIControlState.Normal)
        xbuttonMenu.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        xbuttonMenu.frame = CGRect(
            x: ((self.frame.width / 2) - (buttonSize * 1.25)),
            y: self.frame.height - (buttonSize * 1.25) ,
            width: buttonSize,
            height: buttonSize)
        xbuttonMenu.imageView?.frame = xbuttonMenu.frame
        xbuttonMenu.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        xbuttonMenu.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
//        xbuttonMenu.hidden = true
        self.addSubview(xbuttonMenu)
        
        //botao play
        xbuttonPlay.frame = CGRect(
            x: (self.frame.width / 2) + (buttonSize * 0.25) ,
            y: self.frame.height - (buttonSize * 1.25) ,
            width: buttonSize,
            height: buttonSize
        )
        xbuttonPlay.setImage(UIImage(named: "playButtonGreen"), forState: UIControlState.Normal)
        xbuttonPlay.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
        xbuttonPlay.imageView?.frame = xbuttonPlay.frame
        xbuttonPlay.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        xbuttonPlay.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
//        xbuttonPlay.hidden = true
        
        self.addSubview(xbuttonPlay)
        
        
        //show()
    }

    func show(level: myStructs.myLevel) {
        currentLevel = level
        GLOBALanimations.resetDelta()
        self.layer.removeAllAnimations()
        for view in self.subviews {
            if !view.isKindOfClass(UIButton) {
                if view.isKindOfClass(UIImageView) {
                    if view as! UIImageView != backgound {
                        view.removeFromSuperview()
                    }
                } else {
                    view.removeFromSuperview()
                }
            }
        }
        //messagee
        fase = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.width, //- (buttonSize * 0.5),
            height: self.frame.height * 0.05)
        )
        fase.layer.shadowOffset = (CGSize(width: 2, height: 2))
        fase.layer.shadowOpacity = 1
        fase.layer.shadowRadius = 1
        fase.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        fase.textAlignment = NSTextAlignment.Center
        self.addSubview(fase)
        title = UILabel(frame: CGRect(
            x: 0,
            y: fase.frame.height,
            width: self.frame.width, //- (buttonSize * 0.5),
            height: self.frame.height * 0.07)
        )
        title.layer.shadowOffset = (CGSize(width: 2, height: 2))
        title.layer.shadowOpacity = 1
        title.layer.shadowRadius = 1
        title.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        title.textAlignment = NSTextAlignment.Center
        self.addSubview(title)
        body = UITextView(frame: CGRect(
            x: self.frame.width * 0.05,
            y: title.frame.origin.y + title.frame.height,
            width: self.frame.width * 0.9,
            height: self.frame.height * 0.18)
        )
        body.textColor = UIColor(red: 166/255, green: 114/255, blue: 54/255, alpha: 1)
        body.backgroundColor = UIColor(red: 166/255, green: 114/255, blue: 54/255, alpha: 0)
        body.textAlignment = NSTextAlignment.Center
        body.font = UIFont(name: "Comics", size: self.frame.height * 0.020)
        body.userInteractionEnabled = false

        //body.text = NSLocalizedString("DSNIVEL-Fase:\(level.fase)-Nivel:\(level.level)", comment: "Descricao nivel")
        body.text = level.description
        self.addSubview(body)
        
        
        regrasTitle = UILabel(frame: CGRect(
            x: 0,
            y: body.frame.origin.y + body.frame.height,
            width: self.frame.width, //- (buttonSize * 0.5),
            height: self.frame.height * 0.04)
        )
        regrasTitle.layer.shadowOffset = (CGSize(width: 2, height: 2))
        regrasTitle.layer.shadowOpacity = 1
        regrasTitle.layer.shadowRadius = 1
        regrasTitle.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        regrasTitle.textAlignment = NSTextAlignment.Center
        self.addSubview(regrasTitle)

        
        regrasBody = UITextView(frame: CGRect(
            x: self.frame.width * 0.05,
            y: regrasTitle.frame.origin.y + regrasTitle.frame.height,
            width: self.frame.width * 0.9 , //- (buttonSize * 0.5),
            height: self.frame.height * 0.12)
        )
        regrasBody.textColor = UIColor(red: 166/255, green: 114/255, blue: 54/255, alpha: 1)
        regrasBody.backgroundColor = UIColor(red: 166/255, green: 114/255, blue: 54/255, alpha: 0)
        regrasBody.textAlignment = .Center
        regrasBody.font = UIFont(name: "Comics", size: self.frame.height * 0.02)
        regrasBody.userInteractionEnabled = false

        self.addSubview(regrasBody)
        
        
        let starRect = CGRect(
            x: self.frame.width * 0.1 ,
            y: regrasBody.frame.origin.y + regrasBody.frame.height ,
            width: self.frame.width * 0.8, //- (buttonSize * 0.5),
            height: self.frame.height * 0.18)
        
        let gapstar = starRect.width * 0.07
        let starSize = (starRect.width - (gapstar * 4 ) ) / 3
        var nextx = starRect.origin.x + gapstar
        var nexty = starRect.origin.y
        let imageStarActive = ["star1", "star2","star3"]
        let imageStarInactive = ["star1shadow", "star2Shadow","star3Shadow"]
        let chepoinsts = [level.checkpointLevel, level.checkpointLevel2, level.checkpointLevel3]
        let chechpointHeigth = (starRect.height * 0.4)
        for indStar in 0...2{
            let starImageName =  imageStarInactive[indStar]
            if indStar == 1 {
                nexty = starRect.origin.y - (gapstar / 2)
            } else {
                nexty = starRect.origin.y
            }
            let starImage = UIImageView(frame: CGRect(x: nextx, y: nexty, width: starSize, height: starSize))
            starImage.image = UIImage(named: starImageName)
            self.addSubview(starImage)
            
            let imageBlock = UIImage(named: "goldBlock")
            let viimageBlock = UIImageView(frame: CGRect(x:nextx + ((starSize - chechpointHeigth)  / 2 ),
                y: nexty + (starSize * 1.1),
                width: chechpointHeigth,
                height: chechpointHeigth)
            )
            viimageBlock.image = imageBlock

            let labelPoint = UILabel (frame: CGRect(origin:CGPoint(x: 0, y: 0) , size: viimageBlock.frame.size))
            if let font =  UIFont(name: "Skranji-Bold", size: chechpointHeigth * 0.3) {
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
                let checkpoint =  chepoinsts [indStar]
                let helpText = "\(checkpoint)"
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)

                labelPoint.attributedText = myMutableString
                labelPoint.textAlignment = NSTextAlignment.Center
                
            }
            viimageBlock.addSubview(labelPoint)
            nextx += (starSize + gapstar)

            self.addSubview(viimageBlock)
            
            GLOBALanimations.animationScaleEffect(viimageBlock, animationTime: 0.1)
            
        }
        
        // star actives
        let levelSavings = GLOBALlevelManager.readLevel(level.fase, level: level.level)

         nextx = starRect.origin.x + gapstar
         nexty = starRect.origin.y
        if levelSavings.level > 0 {
            if levelSavings.stars > 0 {
                for indStar in 0...levelSavings.stars - 1 {
                    let starImageName = imageStarActive[indStar]
                    
                    if indStar == 1 {
                        nexty = starRect.origin.y - (gapstar / 2)
                    } else {
                        nexty = starRect.origin.y
                    }
                    let starImage = UIImageView(frame: CGRect(x: nextx, y: nexty, width: starSize, height: starSize))
                    starImage.image = UIImage(named: starImageName)
                    self.addSubview(starImage)
                    GLOBALanimations.animationScaleEffect(starImage, animationTime: 0.3)
                    nextx += (starSize + gapstar)
                }
            }
        }
        let containerRect = CGRect(
            x: 0,
            y: starRect.origin.y + starRect.height + (gapstar * 1.2) ,
            width: self.frame.width, //- (buttonSize * 0.5),
            height: self.frame.height * 0.3)
        let gap = containerRect.width * 0.05
        
        let numbersRect = CGRect(
            x: gap ,
            y: containerRect.origin.y ,
            width: containerRect.width * 0.3 - gap ,
            height: xbuttonPlay.frame.origin.y - containerRect.origin.y)
        
        let signal = "+-/*"
        
        var countnumbers = 0
        for blk in level.inGameBlocks.characters {
            if signal.rangeOfString(String(blk)) == nil {
                countnumbers += 1
            }
        }
        var numberLines = CGFloat(countnumbers) / 3
        
        var blockSize = CGSize(width: numbersRect.width/3, height: numbersRect.width/3)
        var blockHeight = CGFloat(Int(numberLines)) * blockSize.height
        nexty = numbersRect.origin.y + blockHeight //+ blockSize.height

        var nextpos = CGPoint(x: numbersRect.origin.x, y: nexty)
        var cols = 0
        for blk in level.inGameBlocks.characters {
            for i_bkl in 0...Int(v_blocos.count - 1) {
                if String(blk) == v_blocos[i_bkl] && signal.rangeOfString(String(blk)) == nil {
                    let image = UIImage(named: v_imageBlocos[i_bkl])
                    let viimage = UIImageView(frame: CGRect(x: nextpos.x,
                        y: nextpos.y,
                        width: blockSize.width,
                        height: blockSize.height)
                    )
                    viimage.image = image
                    self.addSubview(viimage)
                    GLOBALanimations.animationScaleEffect(viimage, animationTime: 0.1)

                    nextpos.x += blockSize.width
                    cols += 1
                    if cols >= 3 {
                        nextpos.y -= blockSize.height
                        nextpos.x = numbersRect.origin.x
                        cols = 0
                    }
		
                    break
                }
            }
        }
        let centralRect = CGRect(
            x: numbersRect.width + gap ,
            y: containerRect.origin.y,
            width: containerRect.width * 0.4 - gap,
            height: containerRect.height)
        var labelNext = CGPoint()
        let operatorsRect = CGRect(
            x: centralRect.origin.x +  centralRect.width + gap ,
            y: containerRect.origin.y,
            width: (containerRect.width * 0.3) - gap,
            height: containerRect.height)
        
        var countoperator = 0
        blockSize = CGSize(width: operatorsRect.width/3, height: operatorsRect.width/3)
        for blk in level.inGameBlocks.characters {
            if signal.rangeOfString(String(blk)) != nil {
                countoperator += 1
            }
        }
        numberLines = CGFloat(countoperator) / 2
        
        blockHeight = CGFloat(Int(numberLines)) * blockSize.height
        //nexty = operatorsRect.origin.y + ((operatorsRect.height - blockHeight) / 4)
        nexty = operatorsRect.origin.y + blockHeight //+ blockSize.height
        nextpos = CGPoint(x: operatorsRect.origin.x + blockSize.width, y: nexty)
        cols = 0
        for blk in level.inGameBlocks.characters {
            for i_bkl in 0...Int(v_blocos.count - 1) {
                if String(blk) == v_blocos[i_bkl] && signal.rangeOfString(String(blk)) != nil {
                    let image = UIImage(named: v_imageBlocos[i_bkl])
                    let viimage = UIImageView(frame: CGRect(x: nextpos.x,
                        y: nextpos.y,
                        width: blockSize.width,
                        height: blockSize.height)
                    )
                    viimage.image = image
                    
                    self.addSubview(viimage)
                    GLOBALanimations.animationScaleEffect(viimage, animationTime: 0.1)
                    
                    nextpos.x += blockSize.width
                    cols += 1
                    if cols >= 2 {
                        nextpos.y -= blockSize.height
                        nextpos.x =  operatorsRect.origin.x + blockSize.width
                        cols = 0
                    }
                    break
                }
            }
        }
        
        labelNext.y = centralRect.origin.y

        if level.checkpointTimer > 0 {
            
            let labelTime = UILabel(frame: CGRect(x: 0,
                y: centralRect.origin.y,
                width: self.frame.width,
                height: self.frame.height * 0.04
                ))
            labelTime.layer.shadowOffset = (CGSize(width: 2, height: 2))
            labelTime.layer.shadowOpacity = 1
            labelTime.layer.shadowRadius = 1
            labelTime.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
            labelTime.textAlignment = NSTextAlignment.Center

            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.height * 0.04 ) {
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
                let checkpoint =  GLOBALtimeDigital(level.checkpointTimer)
                let helpText = "\(checkpoint)"
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                labelTime.numberOfLines = 0
                labelTime.lineBreakMode = NSLineBreakMode.ByCharWrapping
                labelTime.attributedText = myMutableString
                labelTime.textAlignment = NSTextAlignment.Center

            }
            self.addSubview(labelTime)
            GLOBALanimations.animationScaleEffect(labelTime, animationTime: 0.1)

            labelNext.y = labelTime.frame.origin.y + labelTime.frame.height + gap
        }
        if level.checkpointBonus > 0 {
            
            let labelBonus = UILabel(frame: CGRect(x: centralRect.origin.x,
                y: labelNext.y,
                width: centralRect.width,
                height: self.frame.height * 0.035
                ))
            labelBonus.layer.shadowOffset = (CGSize(width: 2, height: 2))
            labelBonus.layer.shadowOpacity = 1
            labelBonus.layer.shadowRadius = 1
            labelBonus.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
            labelBonus.textAlignment = NSTextAlignment.Center
            
            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.height * 0.035 ) {
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
                let helpText = String(format: NSLocalizedString("Bonus", comment: ""), level.checkpointBonus)
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                labelBonus.numberOfLines = 0
                labelBonus.lineBreakMode = NSLineBreakMode.ByCharWrapping
                labelBonus.attributedText = myMutableString
                labelBonus.textAlignment = NSTextAlignment.Right
                
            }
            self.addSubview(labelBonus)
            labelNext.y = labelBonus.frame.origin.y + labelBonus.frame.height
            let image = UIImage(named: "acerto")
            let viimage = UIImageView(frame: CGRect(x: labelBonus.frame.origin.x + labelBonus.frame.width,
                y: labelBonus.frame.origin.y,
                width: labelBonus.frame.height,
                height: labelBonus.frame.height)
            )
            viimage.image = image
            self.addSubview(viimage)
            GLOBALanimations.animationScaleEffect(labelBonus, animationTime: 0.1)
            GLOBALanimations.animationScaleEffect(viimage, animationTime: 0.1)

            labelNext.y +=  labelBonus.frame.height
        }
        
        if level.checkpointVelocity > 0 {
            
            let labelBonus = UILabel(frame: CGRect(x: centralRect.origin.x,
                y: labelNext.y,
                width: centralRect.width,
                height: self.frame.height * 0.03
                ))
            labelBonus.layer.shadowOffset = (CGSize(width: 2, height: 2))
            labelBonus.layer.shadowOpacity = 1
            labelBonus.layer.shadowRadius = 1
            labelBonus.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
            labelBonus.textAlignment = NSTextAlignment.Center
            
            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.height * 0.03 ) {
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
                
                let helpText = String(format: NSLocalizedString("Velocity", comment: ""), level.checkpointVelocity)
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                labelBonus.numberOfLines = 0
                labelBonus.lineBreakMode = NSLineBreakMode.ByCharWrapping
                labelBonus.attributedText = myMutableString
                labelBonus.textAlignment = NSTextAlignment.Right
                
            }
            self.addSubview(labelBonus)
            labelNext.y = labelBonus.frame.origin.y + labelBonus.frame.height
            let image = UIImage(named: "acerto")
            let viimage = UIImageView(frame: CGRect(x: labelBonus.frame.origin.x + labelBonus.frame.width,
                y: labelBonus.frame.origin.y,
                width: labelBonus.frame.height,
                height: labelBonus.frame.height)
            )
            viimage.image = image
            self.addSubview(viimage)
            GLOBALanimations.animationScaleEffect(labelBonus, animationTime: 0.1)
            GLOBALanimations.animationScaleEffect(viimage, animationTime: 0.1)

            
        }
        if let font =  UIFont(name: "Skranji-Bold", size: self.frame.height * 0.03 ) {
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
            var helpText = "\(level.descriptionFase)"
            var myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            fase.numberOfLines = 0
            fase.lineBreakMode = NSLineBreakMode.ByCharWrapping
            fase.attributedText = myMutableString
            //verifica se existe alguma regra no jogo
            helpText = NSLocalizedString("Rules", comment: "")
            myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            regrasTitle.numberOfLines = 0
            regrasTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
            regrasTitle.attributedText = myMutableString
            
            
            regrasBody.text = level.validaConjunto && level.messagemValidacaoConjunto != "" ? "- " + level.messagemValidacaoConjunto : ""
            
            if level.validaMultiplo > 0 {
                var message = ""
                if regrasBody.text != "" {regrasBody.text = regrasBody.text + "\n"}
                switch level.validaMultiplo {
                case 1:
                    message = NSLocalizedString("Validation5", comment: "")
                    break
                case 2:
                    message = NSLocalizedString("Validation6", comment: "")
                    break
                default:
                    message = String(format: NSLocalizedString("Validation7", comment: ""), level.validaMultiplo)
                    break
                }
                
                regrasBody.text =  regrasBody.text! + message
            }
            if regrasBody.text != "" {regrasBody.text = regrasBody.text + "\n"}
            regrasBody.text = regrasBody.text +  NSLocalizedString("Validation8", comment: "")

        }
        
        
        if let font =  UIFont(name: "Skranji-Bold", size: self.title.frame.height * 0.8) {
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
            print("Level: \(NSLocalizedString("Level", comment: ""))")
            let helpText = String.localizedStringWithFormat(NSLocalizedString("Level", comment: ""), level.level)
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            title.numberOfLines = 0
            title.lineBreakMode = NSLineBreakMode.ByCharWrapping
            title.attributedText = myMutableString
        }
         interactionsGame(false)
        showView(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func play() {
        if GLOBALsounds {
            somAVInicio?.play()        }
        hide()
        if ((self.parent as? MenuScene) != nil) {
            (self.parent as? MenuScene)!.startGame(currentLevel)
        } else {
            (self.parent as? GameScene)!.startGame()
        }

    }
    
    func hide() {
        interactionsGame(true)
        hideView(self)        
    }
    
    func back() {
        
        if GLOBALsounds {
            somAVBotao?.play()
        }
        hide()
        if ((self.parent as? MenuScene) != nil) {
            (self.parent as? MenuScene)!.showSelectLevel()
        } else {
            (self.parent as? GameScene)!.endGame()
        }
    }

    func interactionsGame(isInteract: Bool) {
        if ((parent as? GameScene) != nil) {
            (parent as! GameScene).igualBtn.userInteractionEnabled = isInteract
            (parent as! GameScene).menuBtn.userInteractionEnabled = isInteract
            (parent as! GameScene).apagarBtn.userInteractionEnabled = isInteract
            (parent as! GameScene).moreBtn.userInteractionEnabled = isInteract
            (parent as! GameScene).pauseBtn.userInteractionEnabled = isInteract
            for block in (parent as! GameScene).blocks {
                block.userInteractionEnabled = isInteract
            }
        }
        
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
        
        UIView.animateWithDuration(0.8,
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