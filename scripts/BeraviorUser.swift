//
//  Block.swift
//  Matematrics
//
//  Created by William Tempone on 11/01/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import Foundation
import SpriteKit

// classe escondida para alterar sprite node
class HideRequired : SKSpriteNode {
    
}
// classe escondida para criar sprite node
class MySKSpriteNode : HideRequired {
    init(imageNamed imageName: String) {
        let color = UIColor()
        
        let texture = SKTexture(imageNamed: imageName)
        let size = texture.size()
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// classe Blocos
@available(iOS 8.0, *)
class Block : MySKSpriteNode {
    var selected = false
    var active = true
    var column = 0
    var value:String = ""
    var label:String = ""
    var type:myStructs.myBlockType = myStructs.myBlockType.number
    var inflamed = false
    var firstContact = false
    
    init() {
        
        let range = UInt32(0)..<UInt32(GLOBALblocos.count-1)
        let randomBlock = Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
        
        self.value =  GLOBALblocos[randomBlock]
        self.label =  GLOBALlabelBlocos[randomBlock]
        self.selected = false
        super.init(imageNamed: GLOBALimageBlocos[randomBlock])
        self.zPosition = 2
        //self.userInteractionEnabled = true
        let operators = "+-*/"
        if operators.rangeOfString(self.value) != nil{
            self.type = myStructs.myBlockType.signal
        } else {
            self.type = myStructs.myBlockType.number
        }
        self.name = "block"

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func select() {
        if (self.parent as! GameScene).operation[0] == "" && (self.parent as! GameScene).operation[1] == "" {
            (self.parent as! GameScene).updateDisplay("")
        }
        
        if GLOBALsounds{
            self.runAction(somSelect)
        }
        self.selected = true
        self.runAction(blockFadeOut)

        if let myParent = self.parent as? GameScene {
            //println(self.label)
            myParent.updateDisplay(self.label)
            if myParent.igualBtn.selected {
                myParent.updateOperation(self.value, index: 1)
            } else {
                myParent.updateOperation(self.value, index: 0)
            }
        }
    }
    func deselect() {
        self.selected = false
        self.runAction(blockFadeIn)
    }
    
    func inflame(flame: Bool) {
        if flame {
            if !self.hasActions() {
                self.runAction(wiggleColor, withKey: "Flame")
            }
        } else {
            self.removeActionForKey("Flame")
            if !self.selected {self.colorBlendFactor = 0}
                
        }
        inflamed = flame
    }
    
    func kill() {
        self.selected = false
        // animar corretamente
        self.runAction(blockFadeOut)
        self.removeFromParent()
    }
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil {
            if !active {
                return
            }
            if selected {
                if let myParent = self.parent as? GameScene {
                    if !myParent.fingerIsOnBlock {
                        self.runAction(somWrong, withKey: "wiggle")
                    }
                }
            } else {
                select()
            }
        }
    }*/
    
}

// Classes dos Botoes
@available(iOS 8.0, *)
class myButtomPause : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil {
            
            self.runAction(wiggle, withKey: "wiggle")
            if GLOBALsounds{
                self.runAction(somBotao, withKey: "wiggle")
            }
            
            if let myParent = self.parent as? GameScene {
                myParent.pauseGame()
            }
        }
    }
}
@available(iOS 8.0, *)
class myButtomMenu : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil {
            
            //            self.runAction(wiggle, withKey: "wiggle")
            self.runAction(wiggle, withKey: "wiggle")
            if GLOBALsounds{
                self.runAction(somBotao, withKey: "wiggle")
            }
            
            if let myParent = self.parent as? GameScene {
                myParent.menuGame()
            }
        }
    }
}
@available(iOS 8.0, *)
class myButtomErase : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(wiggle, withKey: "wiggle")
        if GLOBALsounds{
            self.runAction(somBotao, withKey: "wiggle")
        }
        if let myParent = self.parent as? GameScene {
            myParent.wrongAnswer()

            //myParent.eraseDisplay()
        }
    }
}
@available(iOS 8.0, *)
class myButtomMore : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(wiggle, withKey: "wiggle")
        if GLOBALsounds{
            self.runAction(somBotao, withKey: "wiggle")
        }
        if let myParent = self.parent as? GameScene {
            myParent.moreBlocks()
        }
    }
}

@available(iOS 8.0, *)
class myButtomPlay : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
        self.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(wiggle, withKey: "wiggle")
        if GLOBALsounds{
            self.runAction(somBotao, withKey: "wiggle")
        }
        self.userInteractionEnabled = false
        if let myParent = self.parent as? MenuScene {
            myParent.showSelectLevel()
        }
    }
}



@available(iOS 8.0, *)
class myButtomHelp : MySKSpriteNode {
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
        self.zPosition = 3

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(wiggle, withKey: "wiggle")
        if GLOBALsounds{
            self.runAction(somBotao, withKey: "wiggle")
        }
        self.userInteractionEnabled = false
        if let myParent = self.parent as? MenuScene {
            myParent.showTutorial()
        }
    }
}

@available(iOS 8.0, *)
class myButtomSettings : MySKSpriteNode {
    var selfImage = SKSpriteNode(imageNamed: "SettingsBtn")
    var baseSettings = SKSpriteNode(imageNamed: "BaseSetting")
    var soundIco = SKSpriteNode(imageNamed: "SoundIcon")
    var musicIco = SKSpriteNode(imageNamed: "MusicIcon")
    var infoIco = SKSpriteNode(imageNamed: "InfoIcon")
    var cancelSound = SKSpriteNode(imageNamed: "CancelIcon")
    var cancelMusic = SKSpriteNode(imageNamed: "CancelIcon")
    var cancelInfo = SKSpriteNode(imageNamed: "CancelIcon")
    var cropnode = SKCropNode()
    var created = false
    var pressed = false
    var direction: myDirection = myDirection.up
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.userInteractionEnabled = true
        //baseSettings.hidden  = true
        self.texture = nil
    }

    convenience init(imageNamed imageName: String, direction: myDirection) {
        self.init(imageNamed: imageName)
        self.userInteractionEnabled = true
        //baseSettings.hidden  = true
        self.direction = direction

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !created {
            if  direction == myDirection.up {
                
                let baseWidhtSize = GLOBALbuttonSize.width
                let baseHeigthSize = baseSettings.frame.height * (baseWidhtSize / baseSettings.frame.width)
                baseSettings.size = CGSize(width: baseWidhtSize, height: baseHeigthSize)
                baseSettings.anchorPoint = CGPoint(x: 0.5,y: 0.01)
                baseSettings.position = CGPoint(x: 0,y: 0)
                let maskNode = SKShapeNode(rect: baseSettings.frame)
                maskNode.fillColor = UIColor.whiteColor()
                maskNode.alpha = 0.001

                //self.addChild(maskNode)
                baseSettings.anchorPoint = CGPoint(x: 0.5,y: 0.09)
                baseSettings.position = CGPoint(x: 0,y: 0)
                
                cropnode.maskNode = maskNode
                
                let soundWidhtSize = GLOBALbuttonSize.width *  0.7
                let soundHeigthSize = soundIco.frame.height * (soundWidhtSize / soundIco.frame.width)
                
                soundIco.size = CGSize(width: soundWidhtSize, height: soundHeigthSize)
                soundIco.position = CGPoint(x: 0, y: baseSettings.frame.height * 0.75)
                cancelSound.size = CGSize(width: GLOBALbuttonSize.width *  0.8,height:GLOBALbuttonSize.width *  0.8)
                cancelSound.position = soundIco.position
                
                let musicHeigthSize = soundHeigthSize
                let musicWidhtSize = musicIco.frame.width * musicHeigthSize / musicIco.frame.height
                
                musicIco.size = CGSize(width: musicWidhtSize, height: musicHeigthSize)
                musicIco.position = CGPoint(x: 0, y: baseSettings.frame.height  * 0.5)
                
                cancelMusic.size = cancelSound.size
                cancelMusic.position = musicIco.position
                
                let infoHeigthSize = soundHeigthSize
                let infoWidhtSize = infoIco.frame.width * infoHeigthSize / infoIco.frame.height
                
                infoIco.size = CGSize(width: infoWidhtSize, height: infoHeigthSize)
                infoIco.position = CGPoint(x: 0, y: baseSettings.frame.height  * 0.25)

            } else {
                let baseWidhtSize = GLOBALbuttonSize.width
                let baseHeigthSize = baseSettings.frame.height * (baseWidhtSize / baseSettings.frame.width)
                baseSettings.size = CGSize(width: baseWidhtSize, height: baseHeigthSize)
                baseSettings.anchorPoint = CGPoint(x: 0.5,y: 0.99)
                baseSettings.position = CGPoint(x: 0,y: 0)
                let maskNode = SKShapeNode(rect: baseSettings.frame)
                maskNode.fillColor = UIColor.whiteColor()
                //self.addChild(maskNode)
                baseSettings.anchorPoint = CGPoint(x: 0.5,y: 0.91)
                baseSettings.position = CGPoint(x: 0,y:  -baseSettings.frame.height * 0.3)
                maskNode.alpha = 0.001

                cropnode.maskNode = maskNode
                
                let soundWidhtSize = GLOBALbuttonSize.width *  0.7
                let soundHeigthSize = soundIco.frame.height * (soundWidhtSize / soundIco.frame.width)
                
                soundIco.size = CGSize(width: soundWidhtSize, height: soundHeigthSize)
                soundIco.position = CGPoint(x: 0, y: -baseSettings.frame.height * 0.75)
                cancelSound.size = CGSize(width: GLOBALbuttonSize.width *  0.8,height:GLOBALbuttonSize.width *  0.8)
                cancelSound.position = soundIco.position
                
                let musicHeigthSize = soundHeigthSize
                let musicWidhtSize = musicIco.frame.width * musicHeigthSize / musicIco.frame.height
                
                musicIco.size = CGSize(width: musicWidhtSize, height: musicHeigthSize)
                musicIco.position = CGPoint(x: 0, y: -baseSettings.frame.height  * 0.5)
                
                cancelMusic.size = cancelSound.size
                cancelMusic.position = musicIco.position
                
                let infoHeigthSize = soundHeigthSize
                let infoWidhtSize = infoIco.frame.width * infoHeigthSize / infoIco.frame.height
                
                infoIco.size = CGSize(width: infoWidhtSize, height: infoHeigthSize)
                infoIco.position = CGPoint(x: 0, y: -baseSettings.frame.height  * 0.25)
            }

            cancelMusic.hidden = GLOBALmusic
            cancelSound.hidden = GLOBALsounds
            soundIco.zPosition = 30
            musicIco.zPosition = 30
            infoIco.zPosition = 30
            cancelMusic.zPosition = 40
            cancelSound.zPosition = 40
            baseSettings.addChild(soundIco)
            baseSettings.addChild(musicIco)
            baseSettings.addChild(infoIco)
            baseSettings.addChild(cancelMusic)
            baseSettings.addChild(cancelSound)
            baseSettings.hidden = false
            cropnode.zPosition = 20
            baseSettings.zPosition = 20
            cropnode.addChild(baseSettings)
            self.addChild(cropnode)
            created = true
            
        }
        
        cancelMusic.hidden = GLOBALmusic
        cancelSound.hidden = GLOBALsounds

        var pressSettings = false
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        if direction == myDirection.up {
            if soundIco.containsPoint(touchLocation) || cancelSound.containsPoint(touchLocation) {
                changeSounds()
                pressSettings = true
            }
            
            if musicIco.containsPoint(touchLocation) || cancelMusic.containsPoint(touchLocation){
                changeMusic()
                pressSettings = true
            }
            
            if infoIco.containsPoint(touchLocation) {
                print("Info")
                pressSettings = true
                if GLOBALsounds{
                    self.runAction(somBotao, withKey: "wiggle")
                }
            }
        } else {
            if soundIco.containsPoint(CGPoint(x: touchLocation.x, y: touchLocation.y - baseSettings.frame.height * 0.3 ) ) || cancelSound.containsPoint(CGPoint(x: touchLocation.x, y: touchLocation.y - baseSettings.frame.height * 0.3 ) ) {
                changeSounds()
                pressSettings = true
            }
            
            if musicIco.containsPoint(CGPoint(x: touchLocation.x, y: touchLocation.y - baseSettings.frame.height * 0.3 ) ) || cancelMusic.containsPoint(CGPoint(x: touchLocation.x, y: touchLocation.y - baseSettings.frame.height * 0.3 ) ){
                changeMusic()
                pressSettings = true
            }

        }
        
        //if pressSettings {return}
        
        if pressed {
            if  direction == myDirection.up {
                
                baseSettings.runAction(SKAction.moveToY(0, duration: 0))
                baseSettings.runAction(SKAction.moveToY(-baseSettings.frame.height, duration: 0.5))
            } else {
                baseSettings.runAction(SKAction.moveToY(baseSettings.frame.height * 0.3, duration: 0))
                baseSettings.runAction(SKAction.moveToY(baseSettings.frame.height, duration: 0.5))

            }
        } else {
            if  direction == myDirection.up {
                
                baseSettings.runAction(SKAction.moveToY(-baseSettings.frame.height, duration: 0))
                baseSettings.runAction(SKAction.moveToY(0, duration: 0.5))
            } else {
                baseSettings.runAction(SKAction.moveToY(baseSettings.frame.height, duration: 0))
                baseSettings.runAction(SKAction.moveToY(baseSettings.frame.height * 0.3, duration: 0.5))
                
            }
        }
        pressed = !pressed
        
        self.runAction(wiggle, withKey: "wiggle")
        if GLOBALsounds{
            self.runAction(somBotao)
        }
    }
    
    func reset() {
        self.removeChildrenInArray([selfImage])
        self.selfImage.size = self.size
        self.selfImage.position = CGPoint(x: 0,y: 0)
        self.addChild(selfImage)
        selfImage.zPosition = 50
        pressed = false
        if self.direction == myDirection.up {
            self.baseSettings.runAction(SKAction.moveToY(-baseSettings.frame.height, duration: 0))
        } else {
            self.baseSettings.runAction(SKAction.moveToY(baseSettings.frame.height, duration: 0))
        }
        
    }
    func changeSounds() {
        print("Soud")
        cancelSound.hidden = !cancelSound.hidden
        GLOBALsounds = cancelSound.hidden
        let settings = GLOBALsettingsManager.readSettings()
        settings.sounds = GLOBALsounds
        GLOBALsettingsManager.saveSettings(settings)
        if GLOBALsounds{
            self.runAction(somBotao)
        }
    }
    
    func changeMusic() {
        print("Soud")
        cancelMusic.hidden = !cancelMusic.hidden
        GLOBALmusic = cancelMusic.hidden
        let settings = GLOBALsettingsManager.readSettings()
        settings.music = GLOBALmusic
        GLOBALsettingsManager.saveSettings(settings)
        if GLOBALmusic {
            self.runAction(somBotao)
            if ((self.parent as? MenuScene) == nil) {
                somAVBackGround?.play()
            }
            
        } else {
            if ((self.parent as? MenuScene) == nil) {
                somAVBackGround?.stop()
            }
        }
    }
}

@available(iOS 8.0, *)
class myButtomVerify : MySKSpriteNode {
    var selected = false
    
    override init(imageNamed imageName: String) {
        super.init(imageNamed: imageName)
        self.selected = false
        self.userInteractionEnabled = true
        self.name = "igualBtn"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.parent as! GameScene).operation[0] == "" && (self.parent as! GameScene).operation[1] == "" {
            (self.parent as! GameScene).updateDisplay("")
        }
        if selected {
            self.runAction(wiggle, withKey: "wiggle")
            if GLOBALsounds{
                self.runAction(somBotao)
            }
            if let myParent = self.parent as? GameScene {
                myParent.verifyDisplay(true)
            }
            deselect()
        } else {
            if let myParent = self.parent as? GameScene {
                if myParent.displayLbl.text != "" {
                    select()
                    myParent.updateDisplay("=")
                    if myParent.tutorialIsActive {
                        
                        if myParent.currentStep == 4 {
                            self.runAction(
                                SKAction.sequence([
                                    SKAction.waitForDuration(0.1),
                                    SKAction.runBlock({ () -> Void in
                                        myParent.currentStep += 1
                                        myParent.panelTutorial.stepTutorial(myParent.currentStep)
                                    })
                                    ])
                            )
                            
                        }
                    }
                    self.runAction(wiggle, withKey: "wiggle")
                    if GLOBALsounds{
                        self.runAction(somBotao)
                    }
                } else {
                    //println("pronto")
                    self.runAction(wiggle, withKey: "wiggle")
                    if GLOBALsounds{
                        self.runAction(somWrong)
                    }
                }
            }
        }
    }
    
    func select() {
        let texture = SKTexture(imageNamed: "OkBtn")
        self.texture = texture
        self.selected = true
    }
    
    func deselect() {
        let texture = SKTexture(imageNamed: "IgualBtn")
        self.texture = texture
        self.selected = false
    }
}
