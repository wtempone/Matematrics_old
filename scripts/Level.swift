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
class MYLevelBtn: UIButton {
    
    var label = UILabel()
    var base = UIImageView()
    var lockImage = UIImageView()
    var fase = 1
    var level = 1
    var locked = true
    var validaParImpar = 0
    var stars = 3
    var numBlocks = 6	//Quantidade de blocos por linha
    var checkpointVelocity = 40	//Quantidade de acertos para incremento de velocidade
    var checkpointBonus = 3     //Quantidade de acertos para incremento de Bonus
    var checkpointLevel = 50 	//Quantidade de blocos do nivel
    var checkpointLevel2 = 50 	//Quantidade de blocos do nivel
    var checkpointLevel3 = 50 	//Quantidade de blocos do nivel
    var checkpointTimer = 90	//Tempo do jogo
    var timerBlocks	= 1.0			//Tempo inicial para geraáao dos blocos
    var random = false			//Posiáoes de Blocos Randomicas
    var inGameBlocks = "0123456789/*-+"  // valores dos blocos que farao parte do jogo
    var borders = false
    var guides = false
    var bonus = 1
    
    var menu = SKScene()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience  init(frame: CGRect,
        menu: SKScene,
        fase: Int,
        level: Int,
        locked: Bool) {
            self.init(frame: frame)
    
            self.menu = menu
            self.fase = fase
            self.level = level
            self.locked = locked
    }
    
    override func didMoveToSuperview() {
        // Label Level
        GLOBALanimations.resetDelta()
        GLOBALanimations.deltaTimer = 1.0

        label = UILabel(frame: CGRect(
            x: 0,
            y: self.frame.height * 0.1,
            width: self.frame.width,
            height: self.frame.height * 0.6 )
        )
        label.layer.shadowOffset = (CGSize(width: 2, height: 2))
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 1
        label.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        
        var image = UIImage()
        
        if self.locked {
            image = UIImage(named: "lockLevelBase")!
            let imageFrame = CGRect(x: -self.frame.height * 0.1,
                y: -self.frame.height * 0.1,
                width: self.frame.height * 0.35,
                height: self.frame.height * 0.45)
            lockImage = UIImageView(frame: imageFrame)
            lockImage.image = UIImage(named: "lockLevel")
            self.addSubview(lockImage)
            self.userInteractionEnabled = false
        } else {
            image = UIImage(named: "levelBase")!
            var nextx = (self.frame.width * 0.15)
            for _ in 0...2{
                let starImageName = "starInactive"
                let imageFrame = CGRect(x: nextx,
                    y: self.frame.height * 0.65,
                    width: self.frame.width * 0.20,
                    height: self.frame.width * 0.20)
                let starImage = UIImageView(frame: imageFrame)
                starImage.image = UIImage(named: starImageName)
                nextx += (self.frame.width * 0.25)
                self.addSubview(starImage)
                self.userInteractionEnabled = true
            }
            
        }
        
        var levelLoad = myStructs.myLevelModel()
        levelLoad = GLOBALlevelManager.readLevel(self.fase, level: self.level)
        if levelLoad.level != 0 {
            if levelLoad.locked == levelLoad.lockedBefore {
                if levelLoad.locked  {
                    image = UIImage(named: "lockLevelBase")!
                    let imageFrame = CGRect(x: -self.frame.height * 0.1,
                        y: -self.frame.height * 0.1,
                        width: self.frame.height * 0.35,
                        height: self.frame.height * 0.45)
                    lockImage = UIImageView(frame: imageFrame)
                    lockImage.image = UIImage(named: "lockLevel")
                    self.addSubview(lockImage)
                } else {
                    self.userInteractionEnabled = true
                    image = UIImage(named: "levelBase")!
                    var nextx = (self.frame.width * 0.15)
                    for _ in 0...2{
                        let starImageName = "starInactive"
                        let imageFrame = CGRect(x: nextx,
                            y: self.frame.height * 0.65,
                            width: self.frame.width * 0.20,
                            height: self.frame.width * 0.20)
                        let starImage = UIImageView(frame: imageFrame)
                        starImage.image = UIImage(named: starImageName)
                        nextx += (self.frame.width * 0.25)
                        self.addSubview(starImage)
                        self.userInteractionEnabled = true
                    }
                    lockImage.removeFromSuperview()
                    nextx = (self.frame.width * 0.15)
                    if levelLoad.stars == levelLoad.starsBefore {
                        if levelLoad.stars > 0 {
                            for _ in 0...levelLoad.stars - 1 {
                                let starImageName = "starActive"
                                let imageFrame = CGRect(x: nextx,
                                    y: self.frame.height * 0.65,
                                    width: self.frame.width * 0.20,
                                    height: self.frame.width * 0.20)
                                let starImage = UIImageView(frame: imageFrame)
                                starImage.image = UIImage(named: starImageName)
                                nextx += (self.frame.width * 0.25)
                                self.addSubview(starImage)
                                
                            }
                        }
                    }
                }
            }
        }
        
        self.setImage(image, forState: UIControlState.Normal)
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        if let font =  UIFont(name: "Skranji-Bold", size: self.frame.height * 0.5 ) {
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
                string: "\(self.level)",
                attributes: textFontAttributes)
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByCharWrapping
            label.attributedText = myMutableString
            
        }

        if levelLoad.level != 0 {
            if levelLoad.locked != levelLoad.lockedBefore {
                self.userInteractionEnabled = true
                
                self.lockImage.removeFromSuperview()
                self.setImage(UIImage(named: "levelBase")!, forState: UIControlState.Normal)
                GLOBALanimations.animationScaleEffect(self, animationTime: 0.3)
                
            }
            if levelLoad.stars != levelLoad.starsBefore {
                var nextx = (self.frame.width * 0.15)
                // if star>0
                for _ in 0...2{
                    let starImageName = "starActive"
                    let imageFrame = CGRect(x: nextx,
                        y: self.frame.height * 0.65,
                        width: self.frame.width * 0.20,
                        height: self.frame.width * 0.20)
                    let starImage = UIImageView(frame: imageFrame)
                    starImage.image = UIImage(named: starImageName)
                    nextx += (self.frame.width * 0.25)
                    self.addSubview(starImage)
                    GLOBALanimations.animationScaleEffect(starImage, animationTime: 0.3)
                    self.userInteractionEnabled = true
                }
                
            }
            GLOBALlevelManager.saveLevel(levelLoad)
        }
        self.addTarget(self, action: "play", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func play() {
        if GLOBALsounds {
            somAVBotao?.play()
        }
        let gameview = menu as! MenuScene
        gameview.levelSelect.hideView()
        // aqui que chama a outra cena
        gameview.loadLevel(self.fase, level: self.level)
        // backgroundMusicPlayer.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}