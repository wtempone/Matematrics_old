//
//  GameScene.swift
//  Breakout
//
//  Created by Training on 28/11/14.
//  Copyright (c) 2014 Training. All rights reserved.

//

import SpriteKit
import AVFoundation
import UIKit
import iAd
@available(iOS 8.0, *)
class MenuScene: SKScene,SKPhysicsContactDelegate, ADBannerViewDelegate {
    var tutorial:Tutorial = Tutorial(frame: CGRect())
    var levelSelect: LevelSelect = LevelSelect(frame: CGRect())
    var levelShow: LevelShow = LevelShow(frame: CGRect())
    var animations = Animations()
    var blurview:UIView = UIView()
    var mainBlockPos:[CGFloat] = []

    // Initializers do Jogo
    var numBlocks = 6	//Quantidade de blocos por linha
    var timerBlocks	= 1.0			//Tempo inicial para geraáao dos blocos
    var random = false			//Posiáoes de Blocos Randomicas
    var inGameBlocks = "0123456789/*-+"  // valores dos blocos que farao parte do jogo
    var borders = true
    var guides = false
    
    // musica de fundo
    let backgroundMusicPlayer = AVAudioPlayer()
    
    // controles para blocos do jogo
    var blocks:[Block] = []
    var newBlockPosX:Int = 0
    var blocksWidth:CGFloat = 0
    var previousBlock = Int()
    // nodes manipulaveis
    var bottom:SKNode = SKNode()
    var backgroundImage = SKSpriteNode(imageNamed: "BackGround")

    let tittleImage = SKSpriteNode(imageNamed: "Titulo")
    let playBtn = myButtomPlay(imageNamed: "PlayButtonOrange")
    let helpBtn = myButtomHelp(imageNamed: "HelpBtn")
    let settingsBtn = myButtomSettings(imageNamed: "SettingsBtn")
    
    // controles
    var maxColBlocks = 0
    var lastblock:String = String()
    var lastblocktype: myStructs.myBlockType = myStructs.myBlockType.signal
    
    private var firstStart = false
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        self.view?.ignoresSiblingOrder = true
        self.blocksWidth = (self.frame.width - ( 3 * CGFloat(self.numBlocks))) / CGFloat(self.numBlocks)
        
        loadBlocksGame()

        physicsWorld.contactDelegate = self
        // obtem configurações salvas
        var settings = myStructs.mySettingsModel()
        settings =  GLOBALsettingsManager.readSettings()
        GLOBALsounds = settings.sounds
        GLOBALmusic = settings.music
        
        // Background
        // self.backgroundImage = SKSpriteNode(imageNamed: "BackGround")
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImage.size = self.frame.size
        backgroundImage.zPosition = 15
        
        blurview = UIView(frame: self.frame)
        blurview.backgroundColor = UIColor.blackColor()
        blurview.alpha = 0.5
        blurview.alpha = 0
        view.addSubview(blurview)
        
        
        levelSelect = LevelSelect(frame: self.frame, menu: self)
        levelSelect.hidden = true
        self.view?.addSubview(levelSelect)
        //adiconando select level
        levelShow = LevelShow(frame: self.frame, parent: self)
        levelShow.hidden = true
        self.view?.addSubview(levelShow)
        //adicionando tutorial view
        tutorial = Tutorial(frame: self.frame, menu: self)
        tutorial.hidden = true
        self.view?.addSubview(tutorial)
        
        // tittleImage = SKSpriteNode(imageNamed: "Titulo")
        let tittleWidth = self.size.width * 0.7
        let tittleHeigth = tittleImage.size.height * (tittleWidth / tittleImage.size.width)
        tittleImage.size = CGSize(width:tittleWidth, height: tittleHeigth)
        tittleImage.position = CGPointMake(self.frame.size.width / 2,
            self.frame.size.height * 0.65)
        tittleImage.alpha = 0
        tittleImage.zPosition = 20
        
        playBtn.size = CGSize(width: self.frame.size.width * 0.2,
            height: self.frame.size.width * 0.2)
        playBtn.position = CGPointMake(self.frame.size.width / 2 , self.frame.size.height / 4 )
        playBtn.alpha = 0
        playBtn.zPosition = 20
        
        helpBtn.size =  GLOBALbuttonSize
        helpBtn.position = CGPointMake(self.frame.origin.x + helpBtn.frame.width, self.frame.origin.y + (helpBtn.frame.height + 1) )
        helpBtn.alpha = 0
        helpBtn.zPosition = 20
        settingsBtn.size = helpBtn.size
        settingsBtn.position = CGPointMake(self.frame.size.width - settingsBtn.frame.width, self.frame.origin.y + settingsBtn.frame.height)
        settingsBtn.alpha = 0
            
        reloadSelectLevel()
        numBlocks = 5	//Quantidade de blocos por linha
        timerBlocks	= 0.1		//Tempo inicial para geraáao dos blocos
        random = false			//Posiáoes de Blocos Randomicas
        inGameBlocks = "0123456789/*-+"  // valores dos blocos que farao parte do jogo
        borders = true
        guides = true

        self.backgroundImage.texture = SKTexture(imageNamed: "bgLevel1")
        self.addChild(backgroundImage)
        self.addChild(playBtn)
        self.addChild(helpBtn)
        self.settingsBtn.reset()
        self.addChild(settingsBtn)
        self.addChild(tittleImage)
            
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        self.bottom = SKNode()
        
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody?.dynamic = false
        
        self.playBtn.userInteractionEnabled = true
        resetPositions ()

        addSKActions()
    }
    
    func addSKActions () {
        
        let countLoop = (numBlocks + 1) * (Int(self.frame.height / blocksWidth) + 1)
        
        let addBottom = SKAction.runBlock({
            self.addChild(self.bottom)
            
        })
        
        let addBlocks = SKAction.repeatAction(
            SKAction.sequence([
                SKAction.runBlock({
                    self.addBlock()
                }),
                SKAction.waitForDuration(timerBlocks)
                ]),count: countLoop)
        
        let stopBlocks = SKAction.runBlock({
            self.stopBlocks()
            self.bottom.removeFromParent()
            
        })
        let clearBlocks = SKAction.runBlock({
            self.clearAllBlocks()
        })
        //self.runAction(addBlocks)
        self.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    addBottom,
                    addBlocks,
                    SKAction.waitForDuration(5),
                    stopBlocks,
                    SKAction.waitForDuration(2),
                    clearBlocks
                    ])
                
            )
        )
        
        tittleImage.runAction(
            SKAction.sequence([
                SKAction.scaleTo(0, duration: 0),
                SKAction.fadeAlphaTo(1, duration: 0),
                SKAction.waitForDuration(2),
                SKAction.scaleTo(1, duration:1),
                SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.scaleTo(1.2, duration:3),
                        SKAction.scaleTo(1.0, duration:3),
                        ])
                )
                ])
        )
        
        playBtn.runAction(
            SKAction.sequence([
                SKAction.scaleTo(0, duration: 0),
                SKAction.fadeAlphaTo(1, duration: 0),
                SKAction.waitForDuration(2.5),
                SKAction.scaleTo(1, duration:0.5)
                ])
        )
        helpBtn.runAction(
            SKAction.sequence([
                SKAction.scaleTo(0, duration: 0),
                SKAction.fadeAlphaTo(1, duration: 0),
                SKAction.waitForDuration(2.5),
                SKAction.scaleTo(1, duration:0.5)
                ])
        )
        settingsBtn.reset()
        settingsBtn.runAction(
            SKAction.sequence([
                SKAction.scaleTo(0, duration: 0),
                SKAction.fadeAlphaTo(1, duration: 0),
                SKAction.waitForDuration(2.5),
                SKAction.scaleTo(1, duration:0.5)
                ])
        )
        

    }
    
    func showSelectLevel() {
        levelSelect.show()
    }
    
    func showTutorial() {
        tutorial.show()
    }
    
    func reloadSelectLevel() {
        levelSelect.removeFromSuperview()
        //adiconando select level
        levelSelect = LevelSelect(frame: self.frame, menu: self)
        levelSelect.hidden = true
        self.view?.addSubview(levelSelect)
        levelSelect.layoutIfNeeded()
    }
    func startGame(level: myStructs.myLevel){
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        let scene = GameScene(size: self.size, level: level, showLevel: false) //Replace GameScene with current class name
        if GLOBALcountAdvertise == GLOBALmaxAdvertise {
            let transitionScene = TransitionSceneAd(nextScene: scene)
            transitionScene.prepareAd()
            self.view?.presentScene(transitionScene)
            GLOBALcountAdvertise = 0
        } else {
            self.view?.presentScene(scene)//, transition:reveal)
            GLOBALcountAdvertise += 1
        }
    }
    func loadLevel(fase: Int, level: Int) {

        if GLOBALsounds {
            self.runAction(somGameStart)
        }
        let myLevel = GLOBALlevelManager.readLevelOriginal(fase, level: level)
        levelShow.show(myLevel)

    }


    func loadBlocksGame() {
        GLOBALblocos = []
        GLOBALlabelBlocos = []
        GLOBALimageBlocos = []
        
        self.maxColBlocks = Int(self.frame.size.height  / self.blocksWidth)
        // monta array de blocos que farao parte do jogo
        for blk in inGameBlocks.characters {
            for i_bkl in 0...Int(v_blocos.count - 1) {
                if String(blk) == v_blocos[i_bkl] {
                    
                    var exist = false
                    if GLOBALblocos.count > 0 {
                        for  myind in 0...Int(GLOBALblocos.count - 1) {
                            if String(blk) == GLOBALblocos[myind] {
                                exist = true
                                break
                            }
                        }
                    }
                    if !exist {
                        GLOBALblocos.append(v_blocos[i_bkl])
                        GLOBALlabelBlocos.append(v_labelBlocos[i_bkl])
                        GLOBALimageBlocos.append(v_imageBlocos[i_bkl])
                    }
                }
            }
        }
        
    }
    
    func stopBlocks() {
        if (self.actionForKey("addBlock") != nil) {
            self.removeActionForKey("addBlock")
        }
    }
    func restartBlocks() {
        resetPositions ()
        // inicia geracao dos blocos
        let actionwait = SKAction.waitForDuration(NSTimeInterval(timerBlocks))
        var actionrun:SKAction
        actionrun = SKAction.runBlock({
            self.addBlock()
        })
        stopBlocks()
        if self.firstStart{
            self.firstStart = false
            self.addBlock()
        }
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])), withKey:"addBlock")
        
    }
    func resetPositions () {
        mainBlockPos = []
        var countX = self.frame.origin.x
        for i in 0...Int(self.numBlocks) {
            if self.borders {
                let vertRect = CGRectMake(countX+1, self.frame.origin.y, 0.1, self.size.height)
                let vertLine = SKShapeNode(rect: vertRect)
                vertLine.alpha = 0.05
                vertLine.zPosition = -1
                vertLine.physicsBody = SKPhysicsBody(edgeLoopFromRect: vertRect)
                vertLine.physicsBody?.dynamic = false

                self.addChild(vertLine)
                if !self.guides && (i > 0 && i < Int(self.numBlocks)) {
                    vertLine.removeFromParent()
                }
            }
            // Armazena posições
            countX += 2
            if (i <= Int(self.numBlocks)) {
                mainBlockPos.append(countX)
                //                println(countX)
                countX += self.blocksWidth
            }
        }
        self.newBlockPosX = 0
        
    }
    func addBlock() {
        var block = Block()
        while lastblock == block.value || (lastblocktype == block.type && lastblocktype == myStructs.myBlockType.signal) {
            block = Block()
            
        }
        lastblock = block.value
        lastblocktype = block.type
        var posBlockX = CGFloat()
        if self.random {
                let range = UInt32(0)..<UInt32(self.numBlocks-1)
                var randomBlock = Int()
                while (randomBlock == previousBlock) {
                    randomBlock = Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
                }
                self.newBlockPosX = randomBlock
                previousBlock = randomBlock
                posBlockX = mainBlockPos[randomBlock] + (self.blocksWidth/2)
            
        } else {
            posBlockX = mainBlockPos[Int(self.newBlockPosX)] + (self.blocksWidth/2)
        }
        block.size = CGSize(width: self.blocksWidth, height: self.blocksWidth)
        let posBlockY = self.frame.size.height + (self.blocksWidth *  2)
        self.newBlockPosX += 1

        var i:Int = 0
        for blk in blocks {
            if blk.column == newBlockPosX {
                i++
            }
        }

        if self.newBlockPosX == numBlocks + 1 {
            self.newBlockPosX = 0
        }
        block.column = self.newBlockPosX
        block.position = CGPointMake(posBlockX, posBlockY)
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
        //block.physicsBody?.dynamic = true
        

            block.physicsBody?.allowsRotation = false
            block.physicsBody?.restitution = 0
            block.physicsBody?.angularDamping = 0
            block.physicsBody?.resting = true
        
        block.zPosition = 18
        

        block.active = false
        blocks.append(block)
        self.addChild(block)

    }
    func clearAllBlocks() {

        for blk in blocks {
            blk.kill()
        }
        self.blocks = []
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
