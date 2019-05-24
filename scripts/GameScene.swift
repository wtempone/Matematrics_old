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
@available(iOS 8.0, *)
class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var currentLevel:myStructs.myLevel = myStructs.myLevel ()
    
    var panels:Panel = Panel(frame: CGRect())
    var tutorial:Tutorial = Tutorial(frame: CGRect())
    var levelShow: LevelShow = LevelShow(frame: CGRect())
    var loading: Loading = Loading(frame: CGRect())
    // images
    var imageBonusImage = UIImage(named: "BonusImage")!
    var imageStar = UIImage(named: "star2")!
    var blurview:UIView = UIView()
    // Initializers do Jogo
    let statistics = Statistics()
    // nomes para identificar tipos que em iteraáao
    let blockCategoryName = "block"
    let bottomCategoryName = "bottom"
    let topCategoryName = "top"
    var currentStep: Int = 0
    
    // musica de fundo
    let backgroundMusicPlayer = AVAudioPlayer()
    
    // categoryBitMasks para fisicos
    let blockCategory:UInt32 = 0x1 << 0              // 000000001
    let bottomCategory:UInt32 = 0x1 << 1            // 000000010
    let topCategory:UInt32 = 0x1 << 2            // 000000010
    
    // controles para blocos do jogo
    var blocks:[Block] = []
    var mainBlockPos:[CGFloat] = []
    var newBlockPosX:Int = 0
    var container:CGRect = CGRect()
    var areaBlocks:CGRect = CGRect()
    var mySpacing:CGFloat = 0
    var blocksWidth:CGFloat = 0
    var fingerIsOnBlock = false
    var previousBlock = Int()
    var started = false
    // nodes manipulaveis
    var bottom:SKNode = SKNode()
    var top:SKShapeNode = SKShapeNode()
    var sdisplayLbl:SKLabelNode = SKLabelNode()
    var displayLbl :SKLabelNode = SKLabelNode()
    var pontosImage = SKSpriteNode(imageNamed: "Pontos")
    var backgroundImage = SKSpriteNode(imageNamed: "bgLevel1")
    var bonusBase  = SKSpriteNode(imageNamed: "BonusBase")
    var bonusProgressBase = SKSpriteNode(imageNamed: "BonusProgressBase")
    var bonusImage  = SKSpriteNode(imageNamed: "BonusImage")
    var bonusProgress  = SKSpriteNode(imageNamed: "BonusProgress")
    
    var bonusLbl = SKLabelNode(fontNamed: "Skranji Bold")
    
    var igualBtn:myButtomVerify = myButtomVerify(imageNamed: "0Blk")
    var moreBtn:myButtomMore = myButtomMore(imageNamed: "MoreBtn")
    var pauseBtn = myButtomPause(imageNamed: "PauseBtn")
    var menuBtn = myButtomSettings(imageNamed: "SettingsBtn", direction: myDirection.down) //= myButtomMenu(imageNamed: "ReloadBtn")
    var apagarBtn = myButtomErase(imageNamed: "ApagarBtn")
    let displayImage = SKSpriteNode(imageNamed: "Display")
    let tittleImage = SKSpriteNode(imageNamed: "Titulo")
    let playBtn = myButtomPlay(imageNamed: "PlayButtonOrange")
    let helpBtn = myButtomHelp(imageNamed: "HelpBtn")
    let settingsBtn = myButtomSettings(imageNamed: "SettingsBtn")
    
    var tempoLbl = SKLabelNode(fontNamed: "Skranji Bold")
    var pontosLbl = SKLabelNode(fontNamed: "Skranji Bold")
    
    // controles
    var stars: Int = Int()
    var bonus: Int = Int()
    var lblDisplafontSize: CGFloat = CGFloat()
    var operation:[String] = ["",""]
    var timescore = Int()
    var timesecond = Int()
    var pontos = 0
    var lastMessage = ""
    var maxColBlocks = 0
    var lastblock:String = String()
    var lastblocktype: myStructs.myBlockType = myStructs.myBlockType.signal
    var textOperation = ""
    var progressBaseFrame = CGRect()
    var regras = false
    private var imageBonusSize = CGRect()
    private var firstStart = false
    private  var contactQueue = Array<SKPhysicsContact>()
    var showLevel: Bool = false
    var returnPause = false
    var isAddingBlock = false
    var tutorialIsActive = true
    var panelTutorial = PanelTutorial()
    override init(size: CGSize) {
        super.init(size: size)
    }
    convenience init(size: CGSize, level:myStructs.myLevel, showLevel: Bool?) {
        self.init(size: size)
        self.currentLevel = level
        self.showLevel = showLevel!
        self.view?.ignoresSiblingOrder = true
        
    }
    
    override func didMoveToView(view: SKView) {
        
        //let notificationCenter = NSNotificationCenter.defaultCenter()
        //notificationCenter.addObserver(self, selector: "pauseGame", name: UIApplicationWillResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationDidBecomeActiveNotification, object: nil)
        self.view?.ignoresSiblingOrder = true
        
        self.removeAllActions()
        self.removeAllChildren()
        self.clearMessages()
        physicsWorld.contactDelegate = self
        // obtem configurações salvas
        var settings = myStructs.mySettingsModel()
        settings =  GLOBALsettingsManager.readSettings()
        GLOBALsounds = settings.sounds
        GLOBALmusic = settings.music
        tutorialIsActive = settings.tutorial
        // Phisica
        // Gravidade
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        
        // espaco dos objetos
        self.mySpacing = GLOBALbuttonSize.width * 0.1
        
        // Background
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImage.size = self.frame.size
        backgroundImage.zPosition = 0
        
        // Display inferior - operaçao
        let displayHeigth  = GLOBALbuttonSize.height + ( 4 * mySpacing)
        let displayWidth = self.frame.width - ( 2 * mySpacing)
        //displayImage.size.width * (displayHeigth / displayImage.size.height)
        displayImage.size = CGSize(width:displayWidth, height: displayHeigth)
        displayImage.position = CGPointMake(self.frame.size.width / 2,
            self.frame.origin.y + mySpacing +  ( displayImage.frame.size.height / 2))
        displayImage.zPosition = 4
        
        // guardando posiçao do containter do jogo
        self.container = CGRect(origin: CGPoint(x: displayImage.frame.origin.x, y: displayImage.frame.origin.y + displayImage.size.height) , size: CGSize(width: displayImage.frame.size.width, height: self.frame.size.height))
        
        // Texto display
        // Guarda tamanho da fonte para redimensionamento
        self.lblDisplafontSize = (self.frame.size.width / 38) * 2.5
        // Texto display inferior - melhorar com uma fonte outline / shadow
        self.displayLbl = SKLabelNode(fontNamed: "Skranji Bold")
        displayLbl.fontSize = self.lblDisplafontSize
        displayLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        displayLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        displayLbl.position.y = displayImage.position.y - displayImage.frame.height / 2
        //displayLbl.position = CGPointMake(CGRectGetMidX(displayImage.frame)-1, CGRectGetMidY(displayImage.frame)  + 1 )
        displayLbl.text = ""
        displayLbl.zPosition = 6
        
        self.areaBlocks = CGRect(origin: CGPoint(x: displayImage.frame.origin.x , y: (displayImage.position.y + ( mySpacing * 2))) , size: CGSize(width: displayImage.frame.size.width, height: self.frame.size.height - ((displayImage.frame.height + displayImage.position.y + (mySpacing * 3 )))))
        
        // Botao Pausa
        pauseBtn.size = GLOBALbuttonSize
        pauseBtn.position = CGPointMake(self.frame.size.width - mySpacing - (pauseBtn.frame.size.width / 2),
            self.frame.size.height - mySpacing - (pauseBtn.frame.size.height / 2))
        pauseBtn.zPosition = 5
        // Botao Menu
        menuBtn.size =  GLOBALbuttonSize
        menuBtn.position = CGPointMake(self.frame.size.width - (2 * mySpacing) - (menuBtn.frame.size.width * 1.5),
            self.frame.size.height - mySpacing - (pauseBtn.frame.size.height / 2))
        menuBtn.zPosition = 20
        
        // Botao apagar - posicionado no inicio do display
        //self.apagarBtn = myButtomErase(imageNamed: "ApagarBtn")
        apagarBtn.size = GLOBALbuttonSize
        apagarBtn.position = CGPointMake(displayImage.frame.origin.x + (2 * mySpacing ) + (apagarBtn.frame.size.width / 2),
            CGRectGetMidY(displayImage.frame))
        apagarBtn.zPosition = 5
        
        // Botao Mais blocos - posicionado no final do display
        //self.moreBtn = myButtomMore(imageNamed: "MoreBtn")
        moreBtn.size = GLOBALbuttonSize
        moreBtn.position = CGPointMake(displayImage.frame.size.width - mySpacing - (apagarBtn.frame.size.width / 2),
            CGRectGetMidY(displayImage.frame))
        moreBtn.zPosition = 5
        
        // Botao Igual - posicionado no meio do display
        igualBtn = myButtomVerify(imageNamed: "IgualBtn")
        igualBtn.size = CGSize(width: (moreBtn.frame.origin.x - apagarBtn.frame.origin.x - apagarBtn.frame.size.width) - (2 * mySpacing) ,
            height: displayImage.size.height - (3 * mySpacing ))
        igualBtn.position = CGPointMake(apagarBtn.frame.origin.x + apagarBtn.frame.size.width + mySpacing + (igualBtn.frame.size.width / 2),
            CGRectGetMidY(displayImage.frame))
        igualBtn.addChild(displayLbl)
        igualBtn.zPosition = 6
        
        // Pontos - figura de fundo
        let pontosHeigth = pauseBtn.size.height
        let pontosWidth = pontosImage.size.width * (pontosHeigth / pontosImage.size.height)
        
        pontosImage.size = CGSize(width:pontosWidth, height: pontosHeigth)
        
        pontosImage.position = CGPointMake(self.frame.origin.x + mySpacing + (pontosImage.frame.size.width / 2),
            self.frame.size.height - mySpacing - (pontosImage.frame.size.height / 2))
        pontosImage.zPosition = 6
        // Texto Tempo
        self.tempoLbl = SKLabelNode(fontNamed: "Skranji Bold")
        tempoLbl.fontSize = (self.frame.size.width / 38) * 2.5
        tempoLbl.fontColor = UIColor.whiteColor()
        tempoLbl.name = "Clock"
        tempoLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tempoLbl.position = CGPointMake((self.frame.size.width / 2) - 1, self.frame.size.height - mySpacing - (pontosImage.frame.size.height * 0.7) )
        tempoLbl.zPosition = 8
        // pontos
        // Sombra - melhorar com uma fonte outline
        
        self.pontosLbl = SKLabelNode(fontNamed: "Skranji Bold")
        pontosLbl.fontSize = pontosImage.size.height * 0.45
        pontosLbl.fontColor = UIColor.whiteColor()
        pontosLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        pontosLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        pontosLbl.position = CGPointMake( (pontosImage.frame.width * 0.7) , self.frame.size.height - (pontosImage.frame.size.height * 0.65))
        self.pontosLbl.text = "\(self.pontos)"
        self.pontosLbl.zPosition = 8
        
        // Bonnus
        
        var bonusHeigth = self.pontosImage.frame.size.height * 0.8
        var bonusWidth = bonusImage.size.width * (bonusHeigth / bonusImage.size.height)
        bonusImage.name = "bonusImage"
        bonusImage.size = CGSize(width:bonusWidth, height: bonusHeigth)
        bonusImage.position = CGPointMake(self.frame.origin.x + mySpacing + (bonusImage.frame.size.width / 2),
            self.frame.size.height - (2 * mySpacing) - self.pontosImage.size.height - (bonusImage.frame.size.height / 2) )
        bonusImage.zPosition = 7
        top = SKShapeNode(rect: CGRect(x: self.frame.origin.x,
            y: self.frame.height - (self.frame.height  * 0.05) ,
            width: self.frame.width,
            height: self.frame.height * 0.01))
        
        top.fillColor = UIColor.redColor()
        top.alpha = 0.0
        top.zPosition = 1
        
        // Bonnus - Imagem de fundo
        //self.bonusBase = SKSpriteNode(imageNamed: "BonusBase")
        bonusHeigth = bonusImage.frame.size.height * 0.7
        bonusWidth = bonusBase.size.width * (bonusHeigth / bonusBase.size.height)
        bonusBase.name = "bonusBase"
        bonusBase.size = CGSize(width:bonusWidth, height: bonusHeigth)
        bonusBase.anchorPoint = CGPointMake(0,0.5)
        bonusBase.position = CGPointMake(self.frame.origin.x + mySpacing + (bonusImage.size.width/2),
            self.frame.size.height - (2 * mySpacing) - self.pontosImage.size.height - (bonusImage.frame.size.height / 2))
        bonusBase.zPosition = 3
        // Bonnus - Base do progresso
        //self.bonusProgressBase = SKSpriteNode(imageNamed: "BonusProgressBase")
        bonusHeigth = bonusImage.frame.size.height * 0.5
        bonusWidth = bonusProgressBase.size.width * (bonusHeigth / bonusProgressBase.size.height)
        
        bonusProgressBase.size = CGSize(width:bonusWidth, height: bonusHeigth)
        bonusProgressBase.anchorPoint = CGPointMake(0,0.5)
        bonusProgressBase.name = "bonusProgressBase"
        bonusProgressBase.position = CGPointMake(self.frame.origin.x + (1.5 * mySpacing) + (bonusImage.size.width),
            self.frame.size.height - (2 * mySpacing) - self.pontosImage.size.height - (bonusImage.frame.size.height / 2))
        bonusProgressBase.zPosition = 5
        // var auxiliar para controle do tamanho da barra de progresso
        progressBaseFrame = bonusProgressBase.frame
        // Bonnus - progresso
        //self.bonusProgress = SKSpriteNode(imageNamed: "BonusProgress")
        bonusProgress.size =  bonusProgressBase.size
        bonusProgress.anchorPoint = CGPointMake(0,0.5)
        bonusProgress.name = "bonusProgress"
        bonusProgress.position = CGPointMake(self.frame.origin.x + (1.5 * mySpacing) + (bonusImage.size.width),
            self.frame.size.height - (2 * mySpacing) - self.pontosImage.size.height - (bonusImage.frame.size.height / 2))
        bonusProgress.zPosition = 6
        
        self.bonusLbl =  SKLabelNode(fontNamed: "Skranji Bold")
        bonusLbl.fontSize = bonusImage.size.height * 0.5
        bonusLbl.fontColor = UIColor.whiteColor()
        bonusLbl.name = "bonusLbl"
        bonusLbl.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        bonusLbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        bonusLbl.position = CGPointMake(bonusImage.position.x , bonusImage.position.y)
        bonusLbl.zPosition = 8
        
        blurview = UIView(frame: self.frame)
        blurview.backgroundColor = UIColor.blackColor()
        blurview.layer.zPosition = 9
        blurview.alpha = 0
        view.addSubview(blurview)
        
        //adicionando view GameOver
        panels.layer.anchorPoint = CGPointMake(0.5, 1)
        panels = Panel(frame: areaBlocks)
        panels.hidden = true
        panels.game = self
        panels.layer.zPosition = 10
        view.addSubview(panels)
        //adiconando select level
        levelShow = LevelShow(frame: self.frame, parent: self)
        levelShow.hidden = true
        levelShow.layer.zPosition = 10
        self.view?.addSubview(levelShow)
        /*
        tutorial = Tutorial(frame: self.frame, menu: self)
        tutorial.hidden = true
        tutorial.layer.zPosition = 10
        
        self.view?.addSubview(tutorial)
        */
        panelTutorial = PanelTutorial(frame: self.frame)
        panelTutorial.game = self
        panelTutorial.hidden = true
        panelTutorial.layer.zPosition = 10
        
        self.view?.addSubview(panelTutorial)
        
        
        self.firstStart = true
        self.view?.paused = false
        // remonta tela do jogo
        self.tempoLbl.hidden = self.currentLevel.checkpointTimer == 0
        self.tempoLbl.fontColor = UIColor.whiteColor()
        self.addChild(backgroundImage)
        self.addChild(displayImage)
        self.addChild(apagarBtn)
        self.addChild(moreBtn)
        self.addChild(igualBtn)
        self.addChild(pauseBtn)
        self.addChild(menuBtn)
        self.menuBtn.reset()
        self.menuBtn.userInteractionEnabled = true
        self.addChild(pontosImage)
        self.addChild(tempoLbl)
        self.addChild(pontosLbl)
        bonusBase.hidden = true
        bonusProgressBase.hidden = true
        bonusImage.hidden = true
        bonusProgress.hidden = true
        bonusLbl.hidden = true
        self.addChild(top)
        self.addChild(bonusBase)
        self.addChild(bonusProgressBase)
        self.addChild(bonusImage)
        self.addChild(bonusProgress)
        self.addChild(bonusLbl)
        // linha de baixo - limite dos blocos bottom
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y + displayImage.frame.size.height, self.frame.size.width, 1)
        self.bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody?.dynamic = false
        self.addChild(bottom)
        loadBlocksGame()
        resetPositions()
        statistics.clear()
        if GLOBALmusic {
            somAVBackGround?.prepareToPlay()
            somAVBackGround?.stop()
            somAVBackGround?.currentTime = 0;
            somAVBackGround?.numberOfLoops = -1
            somAVBackGround?.play()
        }
        imageBonusSize = bonusImage.frame
        if showLevel {
            levelShow.show(currentLevel)
        } else {
            startGame()
        }
    }
    
    
    func startGame() {
        restartBlocks()
        restartClock()
    }
    func showTutorial() {
        tutorial.show()
    }
    func loadGame (level: myStructs.myLevel) {
        self.clearMessages()
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        let scene = GameScene(size: self.size, level: level, showLevel: true) //Replace GameScene with current class name
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
    
    func loadBlocksGame() {
        GLOBALblocos = []
        GLOBALlabelBlocos = []
        GLOBALimageBlocos = []
        self.blocksWidth = (self.container.width - ( 3 * CGFloat(currentLevel.numBlocks))) / CGFloat(currentLevel.numBlocks)
        
        self.maxColBlocks = Int(container.size.height  / self.blocksWidth)
        var _:Int
        // monta array de blocos que farao parte do jogo
        for blk in currentLevel.inGameBlocks.characters {
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
    func showBlurView(show: Bool) {
        if show {
            self.blurview.hidden = false
            UIView.animateWithDuration(0.4,
                animations: {
                    self.blurview.alpha = 0.5
                }
            )
        } else if !show {
            UIView.animateWithDuration(0.4,
                animations: {
                    self.blurview.alpha = 0
                }, completion: {
                    (value: Bool) in
                    self.blurview.hidden = true
                }
                
            )
        }
    }
    
    func stopClock() {
        if (self.actionForKey("updateClock") != nil) {
            self.removeActionForKey("updateClock")
            self.removeActionForKey("warningClock")
        }
    }
    
    func restartClock() {
        // inicia relogio
        let clockwait = SKAction.waitForDuration(1)
        let clockrun = SKAction.runBlock({self.updateClock()})
        pontosLbl.fontColor = UIColor.whiteColor()
        
        if currentLevel.checkpointTimer > 0 {
            stopClock()
            self.timescore = currentLevel.checkpointTimer
            self.timesecond = currentLevel.checkpointTimer - ((self.timescore/60) * 60)
            self.runAction( SKAction.repeatAction( SKAction.sequence([clockwait,clockrun]) ,count: currentLevel.checkpointTimer), withKey: "updateClock")
        } else{
            stopClock()
            self.runAction(SKAction.repeatActionForever(SKAction.sequence([clockwait,clockrun])), withKey: "updateClock")
            self.timescore = 0
            self.timesecond = 0
        }
        updateClock()
        self.started = true
    }
    
    func stopBlocks() {
        if (self.actionForKey("addBlock") != nil) {
            self.removeActionForKey("addBlock")
        }
    }
    
    func restartBlocks() {
        // inicia geracao dos blocos
        let actionwait = SKAction.waitForDuration(NSTimeInterval(currentLevel.timerBlocks/100))
        var actionrun:SKAction
        actionrun = SKAction.runBlock({
            self.addBlock()
            self.moreBtn.userInteractionEnabled = true
        })
        stopBlocks()
        if self.firstStart{
            self.firstStart = false
            self.addBlock()
        }
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])), withKey:"addBlock")
        if tutorialIsActive {
            self.runAction(
                SKAction.sequence([
                    SKAction.waitForDuration(0.5),
                    SKAction.runBlock({ () -> Void in
                        self.currentStep += 1
                        self.panelTutorial.stepTutorial(self.currentStep)
                    })
                    
                    ])
            )
        }
    }
    
    func interactionsGame(isInteract: Bool) {
        
        self.igualBtn.userInteractionEnabled = isInteract
        self.menuBtn.userInteractionEnabled = isInteract
        self.apagarBtn.userInteractionEnabled = isInteract
        self.moreBtn.userInteractionEnabled = isInteract
        self.pauseBtn.userInteractionEnabled = isInteract
        //for block in  self.blocks {
        //    block.userInteractionEnabled = isInteract
        //}
        
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func updateClock()
    {
        let stimesecond = NSString(format: "%02d", self.timesecond)
        self.tempoLbl.text = "\(self.timescore/60):\(stimesecond)"
        if currentLevel.checkpointTimer > 0 {
            self.timescore--
            self.timesecond--
            if timesecond == -1 {timesecond = 59}
        } else {
            self.timescore++
            self.timesecond++
            if timesecond == 60 {timesecond = 0}
        }
    }
    
    // pausa
    func pauseGame() {
        if self.view?.paused == true {
            returnPause = false
            
            self.view?.paused = false
            if GLOBALsounds {
                somAVBackGround?.play()
            }
            
        } else {
            self.view?.paused = true
            //pauseView.game = self
            if GLOBALsounds {
                somAVBackGround?.pause()
            }
            self.panels.show()
        }
    }
    
    // menu do jogo
    func menuGame() {
        pauseGame()
        panels.confirmReload()
        
    }
    // menu do jogo
    func endGame() {
        loading = Loading(frame: self.frame, parent: self)
        loading.layer.zPosition = 10
        self.view?.addSubview(loading)
        self.loading.alpha = 0
        
        UIView.animateWithDuration(0.4,
            animations: {
                self.loading.alpha = 1
            }, completion: {  animationFinished in
                self.loading.removeFromSuperview()
                self.removeAllChildren()
                self.removeAllActions()
                self.removeFromParent()
                let scene = MenuScene(size: self.size)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                self.view?.presentScene(scene) // .presentScene(scene, transition:reveal)
                (scene as MenuScene).showSelectLevel()
            }
        )
    }
    
    // Limpa display
    func eraseDisplay() {
        for blk in blocks {
            if blk.selected {
                blk.deselect()
            }
        }
        igualBtn.deselect()
        updateOperation("",index: 0)
        updateDisplay("")
    }
    
    
    // processa display
    func verifyDisplay(userAction: Bool) {
        
        if igualBtn.selected {
            let errorMat0 = validateOperation(self.operation[0])
            let errorMat1 = validateOperation(self.operation[1])
            if errorMat0 || errorMat1 {
                if userAction {
                    wrongAnswer()
                }
            } else {
                if parseOperation(self.operation[0]) == parseOperation(self.operation[1]) {
                    
                    if validaNumeros(currentLevel.validaMultiplo, validaConjunto: currentLevel.validaConjunto, numeroInicial: currentLevel.numeroInicial, numeroFinal: currentLevel.numeroFinal, Operacoes: [self.operation[0], self.operation[1]]) {
                        correctAnswer()
                    } else {
                        wrongAnswer()
                    }
                } else {
                    if userAction {
                        wrongAnswer()
                    }
                }
            }
        }
    }
    
    func validaNumeros(multiplo: Int, validaConjunto: Bool, numeroInicial: Int, numeroFinal: Int, Operacoes:[String]) -> Bool {
        var validaNumeros: Bool = true
        var numerosOperacao:[Int]=[]
        
        if multiplo != 0 || validaConjunto {
            for Operacao in Operacoes {
                numerosOperacao = ObtemNumerosOperacao(Operacao)
                if validaNumeros {
                    for numero in numerosOperacao {
                        if multiplo != 0 {
                            let numeroÉMultiplo = ChecaSeNumeroMultiplo(numero, multiplo: multiplo)
                            
                            if multiplo == 1 {
                                if !numeroÉMultiplo {
                                    let message = String(format: NSLocalizedString("Validation1", comment: ""), numero)
                                    showMessage(message, position: CGPoint(x:  self.frame.width / 2, y: self.frame.height * 0.30), chances: enumChances.Bad,type: enumTypeMensage.Erro, fontSize: 0.05 )
                                    validaNumeros = false
                                    break
                                }
                            } else  {
                                if !numeroÉMultiplo {
                                    if multiplo == 2 {
                                        let message = String(format: NSLocalizedString("Validation2", comment: ""), numero)
                                        showMessage(message , position: CGPoint(x:  self.frame.width / 2, y: self.frame.height * 0.30), chances: enumChances.Bad,type: enumTypeMensage.Erro , fontSize: 0.05)
                                    } else {
                                        let message = String(format: NSLocalizedString("Validation3", comment: ""), numero, multiplo)
                                        showMessage(message, position: CGPoint(x:  self.frame.width / 2, y: self.frame.height * 0.30), chances: enumChances.Bad,type: enumTypeMensage.Erro , fontSize: 0.05)
                                        
                                    }
                                    validaNumeros = false
                                    break
                                }
                                
                            }
                            
                        }
                        if validaConjunto {
                            if !(numero >= numeroInicial && numero <= numeroFinal) {
                                let message = String(format: NSLocalizedString("Validation4", comment: ""), numero)
                                showMessage(message, position: CGPoint(x:  self.frame.width / 2, y: self.frame.height * 0.30), chances: enumChances.Bad,type: enumTypeMensage.Erro , fontSize: 0.05)
                                showMessage(currentLevel.messagemValidacaoConjunto, position: CGPoint(x:  self.frame.width / 2, y: self.frame.height * 0.25), chances: enumChances.Bad,type: enumTypeMensage.Erro , fontSize: 0.03)
                                validaNumeros = false
                                break
                            }
                        }
                    }
                    
                }
            }
        }
        return validaNumeros
    }
    
    // resosta correta
    func correctAnswer() {
        if self.tutorialIsActive {
            if self.currentStep == 5 {
                self.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(0.1),
                        SKAction.runBlock({ () -> Void in
                            self.currentStep += 1
                            self.panelTutorial.stepTutorial(self.currentStep)
                        })
                        ])
                )
                
            }
        }
        
        // tocar som do acerto
        let `try` = Try()
        `try`.result = enumAnswer.Correct
        `try`.answerString = displayLbl.text!
        `try`.bonus = bonus
        var actionsBlocks:[SKAction] = []
        var answerPontos = 0
        textOperation = operation[0] + operation[1]
        // anima placar de pontos
        let actionPontosWiggleOut = SKAction.runBlock({
            self.pontosLbl.runAction(wiggleOut)
            self.pontosImage.runAction(wiggleOut)
            let sparkEmmiter = SKEmitterNode(fileNamed: "pontos.sks")
            sparkEmmiter!.position = self.pontosLbl.position
            sparkEmmiter?.zPosition = self.pontosLbl.zPosition + 1
            self.addChild(sparkEmmiter!)
        })
        actionsBlocks.append(actionPontosWiggleOut)
        // anima e elimina todos os blocos selecionados
        for blk in blocks {
            if blk.selected {
                answerPontos++
                //var actionwait = SKAction.waitForDuration(0.1)
                let actionrun = SKAction.runBlock(
                    {
                        let sparkEmmiter = SKEmitterNode(fileNamed: "stars.sks")
                        sparkEmmiter!.position = blk.position
                        sparkEmmiter!.zPosition = blk.zPosition + 1
                        self.addChild(sparkEmmiter!)
                        
                        blk.kill()
                        self.pontos++
                        self.pontosLbl.text =  "\(self.pontos)"
                    }
                )
                actionsBlocks.append(actionrun)
            }
        }
        `try`.numBlocks = answerPontos
        
        _ = SKAction.runBlock({
            self.pontosLbl.runAction(wiggleIn)
            self.pontosImage.runAction(wiggleIn)
        })
        //actionsBlocks.append(wiggle)
        if  GLOBALsounds {
            actionsBlocks.append(somAcertou)
        }
        _ = SKAction.group(actionsBlocks)
        
        showMessage("+\(answerPontos)", position: igualBtn.position, chances: nil )
        
        // Verifica se mudou o bonus
        let bonusQuestion = SKAction.runBlock({
            if self.currentLevel.checkpointBonus > 0 {
                if self.statistics.sequenceToBonus > 0 {
                    //            let check = self.statistics.sequenceCorrect / checkpointBonus
                    if  (self.statistics.sequenceToBonus == self.currentLevel.checkpointBonus) {
                        self.bonus++
                        //self.statistics.sequenceToBonus = 0
                        self.showMessage("\(self.bonus)×",
                            position: CGPoint(
                                x: self.backgroundImage.position.x,
                                y: (self.frame.height / 2) - 200
                            ),
                            chances: enumChances.Great, type: enumTypeMensage.Bonus )
                        self.showBonus(self.bonus, end: false)
                    }
                }
            }
        })
        
        // Multiplica blocos pelo multiplicador se tiver bonus ativo
        var MultiplyBlocks:[SKAction] = []
        let bonusMutiply = SKAction.runBlock({
            if self.currentLevel.checkpointBonus > 0 {
                if !self.bonusImage.hidden {
                    let multiplBonus = (self.bonus * answerPontos) - answerPontos
                    self.showMessage("\(self.bonus)×",
                        position: CGPoint(x: self.igualBtn.position.x, y: self.igualBtn.position.y - 50) ,
                        chances: enumChances.Good )
                    if multiplBonus > 0 {
                        self.pontosLbl.runAction(wiggleOut)
                        self.pontosImage.runAction(wiggleOut)
                        let sparkEmmiter = SKEmitterNode(fileNamed: "pontos.sks")
                        sparkEmmiter!.position = self.pontosLbl.position
                        self.addChild(sparkEmmiter!)
                        
                        for _ in 1...multiplBonus {
                            answerPontos++
                            //var actionwait = SKAction.waitForDuration(0.1)
                            let actionrun = SKAction.runBlock(
                                {
                                    answerPontos++
                                    self.pontos++
                                    self.pontosLbl.text = "\(self.pontos)"
                                }
                            )
                            MultiplyBlocks.append(actionrun)
                        }
                        self.runAction(SKAction.sequence(MultiplyBlocks))
                    }
                }
            }
        })
        
        // verifica se ganhou o jogo
        let actionQuestion = SKAction.runBlock(
            {
                if self.currentLevel.checkpointTimer > 0 {
                    
                    if (self.stars == 0 && self.pontos >= self.currentLevel.checkpointLevel) ||
                        (self.stars == 1 && self.pontos >= self.currentLevel.checkpointLevel2) ||
                        (self.stars == 2 && self.pontos >= self.currentLevel.checkpointLevel3)
                    {
                        self.pontosLbl.text = "\(self.pontos)"
                        
                        self.showMessage("",
                            position: CGPoint(
                                x: self.backgroundImage.position.x,
                                y: (self.frame.height / 2)
                            ),
                            chances: enumChances.Great, type: enumTypeMensage.Star, numStar: self.stars )
                        //self.gameWin()
                        self.stars += 1
                    }
                }
                `try`.totalBlocks = answerPontos
                self.updateStatistics(enumAnswer.Correct ,count: answerPontos, `try`: `try`)
                
            }
        )
        let actionerase = SKAction.runBlock(
            {
                var blks:[Block] = []
                for blk in self.blocks {
                    if !blk.selected {
                        blks.append(blk)
                    }
                }
                self.blocks = blks
            }
        )
        
        // executa ações programadas em sequencia
        self.runAction(SKAction.sequence(Array(arrayLiteral: actionsBlocks,bonusQuestion,bonusMutiply,actionQuestion,actionerase) as! [SKAction]))
        
        updateOperation("",index: 0)
        igualBtn.deselect()
    }
    
    func updateBonus(bonus: Int) {
        // anima barra de bunus a cada acerto usando operador
        // caso a imagem do bonus estiver ativa, não executa
        if !bonusImage.hidden {
            return
        }
        let lengthProgressBar = CGFloat(statistics.sequenceToBonus) / CGFloat(self.currentLevel.checkpointBonus + 1)
        if bonusProgressBase.hidden {
            let inicio = SKAction.sequence([
                // anima Icone
                SKAction.group([
                    SKAction.runAction(SKAction.hide(),onChildWithName: "bonusBase"),
                    SKAction.runAction(SKAction.hide(),onChildWithName: "bonusProgressBase"),
                    SKAction.runAction(SKAction.hide(),onChildWithName: "bonusProgress"),
                    ]),
                // anima base
                SKAction.waitForDuration(0.2),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0),onChildWithName: "bonusBase"),
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0),onChildWithName: "bonusProgressBase"),
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0),onChildWithName: "bonusProgress"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "bonusBase"),
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "bonusProgressBase"),
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "bonusProgress"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleXTo(1.2, duration: 0.3),onChildWithName: "bonusBase"),
                    SKAction.runAction(SKAction.scaleXTo(1.2, duration: 0.3),onChildWithName: "bonusProgressBase"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.3),onChildWithName: "bonusBase"),
                    SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.3),onChildWithName: "bonusProgressBase"),
                    ]),
                SKAction.runAction(SKAction.scaleXTo(lengthProgressBar, duration: 0.3),onChildWithName: "bonusProgress"),
                SKAction.waitForDuration(0.1),
                ])
            self.runAction(inicio, withKey: "Inicio")
        } else {
            
            //
            let update = SKAction.sequence([
                // anima base
                SKAction.waitForDuration(0.2),
                SKAction.runAction(SKAction.scaleXTo(lengthProgressBar, duration: 0.3),onChildWithName: "bonusProgress")
                ])
            
            self.runAction(update, withKey: "Update")
        }
        
    }
    
    func showBonus(bonus: Int, end: Bool) {
        
        if (self.actionForKey("bunusShow") != nil) {
            self.bonusBase.removeAllActions()
            self.bonusImage.removeAllActions()
            self.bonusLbl.removeAllActions()
            self.bonusProgressBase.removeAllActions()
            self.bonusProgress.removeAllActions()
        }
	       
        // animações do Bonus
        var inicio = SKAction()
        let updateLabels = SKAction.runBlock({
            self.bonusLbl.text = "\(bonus)×"
        })
        
        if !bonusImage.hidden {
            // atualiza icone bunus
            // mostra Icone bonus
            inicio = SKAction.sequence([
                SKAction.group([
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "sbonusLbl"),
                    ]),
                updateLabels,   // atualiza valor do bunus
                SKAction.group([
                    SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.3),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.3),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.3),onChildWithName: "sbonusLbl"),
                    ]),
                // anima base
                SKAction.waitForDuration(0.2),
                SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.5),onChildWithName: "bonusProgress"),
                SKAction.waitForDuration(0.1)
                ])
        } else {
            // mostra Icone bonus
            inicio = SKAction.sequence([
                SKAction.group([
                    SKAction.waitForDuration(0.3),
                    SKAction.runAction(SKAction.hide(),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.hide(),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.hide(),onChildWithName: "sbonusLbl"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleTo(0, duration: 0),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.scaleTo(0, duration: 0),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.scaleTo(0, duration: 0),onChildWithName: "sbonusLbl"),
                    ]),
                updateLabels,   // atualiza valor do bunus
                SKAction.group([
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.unhide(),onChildWithName: "sbonusLbl"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "sbonusLbl"),
                    ]),
                SKAction.group([
                    SKAction.runAction(SKAction.scaleTo(1.0, duration: 0.3),onChildWithName: "bonusImage"),
                    SKAction.runAction(SKAction.scaleTo(1.0, duration: 0.3),onChildWithName: "bonusLbl"),
                    SKAction.runAction(SKAction.scaleTo(1.0, duration: 0.3),onChildWithName: "sbonusLbl"),
                    ]),
                // anima base
                SKAction.waitForDuration(0.2),
                SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0.5),onChildWithName: "bonusProgress"),
                SKAction.waitForDuration(0.1)
                ])
        }
        let downSize = SKAction.sequence([
            SKAction.runAction(SKAction.scaleXTo(1.0, duration: 0),onChildWithName: "bonusProgress"),
            SKAction.runAction(SKAction.scaleXTo(0, duration: 10), onChildWithName: "bonusProgress")
            ])
        
        //	SKAction.runAction(SKAction.scaleXTo(0, duration: 10), onChildWithName: "bonusProgress")
        
        let final = SKAction.sequence([
            SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "bonusProgress"),
            SKAction.runAction(SKAction.scaleXTo(1.2, duration: 0.3),onChildWithName: "bonusProgressBase"),
            SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "bonusProgressBase"),
            SKAction.runAction(SKAction.scaleXTo(1.2, duration: 0.3),onChildWithName: "bonusBase"),
            SKAction.runAction(SKAction.scaleXTo(0, duration: 0.3),onChildWithName: "bonusBase"),
            SKAction.waitForDuration(0.1),
            SKAction.group([
                SKAction.runAction(SKAction.hide(),onChildWithName: "bonusProgress"),
                SKAction.runAction(SKAction.hide(),onChildWithName: "bonusProgressBase"),
                SKAction.runAction(SKAction.hide(),onChildWithName: "bonusBase"),
                ]),
            // anima Icone
            SKAction.group([
                SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "bonusImage"),
                SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "bonusLbl"),
                SKAction.runAction(SKAction.scaleTo(1.2, duration: 0.3),onChildWithName: "sbonusLbl"),
                ]),
            SKAction.group([
                SKAction.runAction(SKAction.scaleTo(0.0, duration: 0.3),onChildWithName: "bonusImage"),
                SKAction.runAction(SKAction.scaleTo(0.0, duration: 0.3),onChildWithName: "bonusLbl"),
                SKAction.runAction(SKAction.scaleTo(0.0, duration: 0.3),onChildWithName: "sbonusLbl"),
                ]),
            SKAction.runBlock({
                self.statistics.sequenceToBonus = 0
                self.bonus = 1
            }),
            SKAction.group([
                SKAction.runAction(SKAction.hide(),onChildWithName: "bonusImage"),
                SKAction.runAction(SKAction.hide(),onChildWithName: "bonusLbl"),
                SKAction.runAction(SKAction.hide(),onChildWithName: "sbonusLbl")
                ])
            ])
        
        if end {
            self.runAction(final, withKey: "hideBonus")
        } else {
            self.runAction(
                SKAction.sequence([
                    inicio,
                    SKAction.waitForDuration(1),
                    downSize,
                    SKAction.waitForDuration(10),
                    final
                    ])
                , withKey: "bunusShow")
        }
    }
    
    func bonusHidden(hide: Bool) {
        self.bonusBase.hidden = hide
        self.bonusProgressBase.hidden = hide
        self.bonusImage.hidden = hide
        self.bonusProgress.hidden = hide
        self.bonusLbl.hidden = hide
    }
    
    
    // resosta errrada
    func wrongAnswer() {
        if self.tutorialIsActive {
            if self.currentStep == 5 {
                self.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(0.1),
                        SKAction.runBlock({ () -> Void in
                            self.currentStep = 99
                            self.panelTutorial.stepTutorial(self.currentStep)
                        })
                        ])
                )
                
            }
        }
        let `try` = Try()
        `try`.result = enumAnswer.Wrong
        `try`.answerString = displayLbl.text!
        // tocar som do erro
        if GLOBALsounds {
            self.runAction(somErrou)
        }
        showBonus(0, end: true)
        eraseDisplay()
        updateStatistics(enumAnswer.Wrong ,count: 0, `try`: `try`)
        updateDisplay("")
        updateOperation("",index: 0)
        igualBtn.deselect()
    }
    
    // atualiza statisticas
    func updateStatistics(action: enumAnswer, count: Int, `try`: Try? = Try()) {
        var vmessage = ""
        self.statistics.answers++
        
        switch action {
        case enumAnswer.Correct:
            self.statistics.answersCorrect++
            self.statistics.sequenceWrong = 0
            if self.statistics.previousAnswer == enumAnswer.Correct {
                self.statistics.sequenceCorrect++
                let operators = "+-*/"
                var isOperator = false
                for byteOp in operators.characters {
                    if (self.textOperation.rangeOfString(String(byteOp)) != nil) {
                        isOperator = true
                        self.textOperation = ""
                        break
                    }
                }
                if isOperator {
                    self.statistics.sequenceToBonus++
                    self.updateBonus(self.bonus)
                    
                }
                if self.statistics.sequenceCorrect == 2 {
                    if lastMessage != "Again Correct" {
                        lastMessage = "Again Correct"
                        vmessage = NSLocalizedString("Again Correct", comment: "")
                        showMessage(vmessage, position: CGPointMake(backgroundImage.position.x, self.frame.height * 0.4 ), chances: enumChances.Good )
                        `try`!.best = true
                    }
                }
            }
            if self.statistics.maxBlocksAnswer < count {
                self.statistics.maxBlocksAnswer = count
                if lastMessage != "Best Play" {
                    lastMessage = "Best Play"
                    vmessage = NSLocalizedString("Best Play", comment: "")
                    showMessage(vmessage, position: CGPointMake(backgroundImage.position.x, self.frame.height * 0.3 ),chances: enumChances.Great )
                }
            }
            self.statistics.previousAnswer = enumAnswer.Correct
            self.statistics.trys.append(`try`!)
        case enumAnswer.Wrong:
            self.statistics.answersWrong++
            self.statistics.sequenceCorrect = 0
            self.statistics.sequenceToBonus = 0
            if self.statistics.previousAnswer == enumAnswer.Wrong {
                self.statistics.sequenceWrong++
                if self.statistics.sequenceWrong == 2 {
                    if lastMessage != "Again Wrong" {
                        lastMessage = "Again Wrong"
                        vmessage = NSLocalizedString("Again Wrong", comment: "")
                        showMessage(vmessage, position: CGPointMake(backgroundImage.position.x, self.frame.height * 0.2 ),chances: enumChances.Reguar )
                    }
                }
            }
            self.statistics.previousAnswer = enumAnswer.Wrong
            self.statistics.trys.append(`try`!)
            
        case enumAnswer.None:
            break
            
        }
    }
    
    func TopGameOver() {
        for block in blocks {
            if CGRectIntersectsRect(self.top.frame, block.frame) {
                block.inflame(true)
            } else {
                block.inflame(false)
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if self.started == false {
            return
        }
        
        processContactsForUpdate(currentTime)
        
        TopGameOver()
        
        if self.currentLevel.checkpointTimer > 0 {
            if timescore == 0 {
                if self.pontos >= self.currentLevel.checkpointLevel {
                    self.pontosLbl.text = "\(self.pontos)"
                    self.gameWin()
                    
                } else {
                    self.gameOver()
                }
            } else {
                if timescore <= 10 {
                    if !(self.actionForKey("warningClock") != nil) {
                        self.tempoLbl.fontColor = UIColor.yellowColor()
                        self.runAction(
                            SKAction.group([
                                SKAction.runAction(SKAction.repeatActionForever(wiggle), onChildWithName:"Clock"),
                                SKAction.runAction(SKAction.repeatActionForever(wiggle), onChildWithName:"sClock")
                                ])
                            , withKey:"warningClock")
                    }
                }
                let chancesTime = Float(Float(timescore) / Float(self.currentLevel.checkpointTimer))
                let chancesPontos = Float(Float(pontos) / Float(self.currentLevel.checkpointLevel))
                if chancesPontos < chancesTime {
                    //println("timescore:\(self.timescore) checkpointtimer:\(self.checkpointTimer)chances:\(chances)")
                    //println("<---------------------------->")
                    if chancesTime < 0.25 {
                        self.statistics.chances = enumChances.Bad
                    } else if chancesTime < 0.5 {
                        self.statistics.chances = enumChances.Reguar
                    } else if chancesTime < 0.75 {
                        self.statistics.chances = enumChances.Good
                    } else {
                        self.statistics.chances = enumChances.Great
                    }
                }
            }
        }
        verifyDisplay(false)
        
        notifications()
        /*
        println("answers:\(self.statistics.answers)")
        println("answersCorrect:\(self.statistics.answersCorrect)")
        println("answersWrong:\(self.statistics.answersWrong)")
        println("maxBlocksAnswer:\(self.statistics.maxBlocksAnswer)")
        println("previousAnswer:\(self.statistics.previousAnswer)")
        println("sequenceCorrect:\(self.statistics.sequenceCorrect)")
        println("sequenceWrong:\(self.statistics.sequenceWrong)")
        
        */
    }
    
    func notifications() {
        var vmessage:String = ""
        //println("previous: \(self.statistics.previousChances) chance: \(self.statistics.chances)")
        if self.statistics.previousChances != self.statistics.chances {
            if self.statistics.previousChances != enumChances.None {
                
                if self.statistics.chances == enumChances.Bad {
                    vmessage = NSLocalizedString("Chances Bad", comment: "Chances estao ruins")
                } else if self.statistics.chances == enumChances.Reguar {
                    vmessage = NSLocalizedString("Chances Regular", comment: "Chances estao normais")
                } else if self.statistics.chances == enumChances.Good {
                    vmessage = NSLocalizedString("Chances Good", comment: "Chances estao boas")
                } else if self.statistics.chances == enumChances.Great {
                    vmessage = NSLocalizedString("Chances Great", comment: "Chances estao normais")
                }
                showMessage(vmessage, position: backgroundImage.position, chances: self.statistics.chances)
            }
        }
        
    }
    // testa converte expressao em valor
    func parseOperation(oper: String) -> Double {
        
        if oper == "" { return Double() }
        let expr = NSExpression(format: oper)
        if let result = expr.expressionValueWithObject(nil, context: nil) as? NSNumber {
            let x = result.doubleValue
            return x
        } else {
            return Double()
        }
    }
    func validateOperation(oper: String) -> Bool {
        
        var errorMat = false
        SwiftTryCatch.`try`({ () -> Void in
            let expr1 = NSExpression(format: oper)
            _ = expr1.expressionValueWithObject(nil, context: nil) as? NSNumber
            }, `catch`: { (error) -> Void in
                errorMat = true
            }, finally: { () -> Void in
        })
        return errorMat
    }
    
    // atualiza display de baixo
    func updateDisplay (text:String) {
        self.displayLbl.runAction(wiggle, withKey: "wiggle")
        self.sdisplayLbl.runAction(wiggle, withKey: "wiggle")
        if text == "" {
            self.displayLbl.text = ""
            self.sdisplayLbl.text = ""
            self.displayLbl.fontSize = self.lblDisplafontSize
            self.sdisplayLbl.fontSize = self.lblDisplafontSize
        } else {
            self.displayLbl.text = self.displayLbl.text! + text
            self.sdisplayLbl.text = self.sdisplayLbl.text! + text
            
            if self.displayLbl.frame.size.width > (self.igualBtn.frame.size.width - (2 * mySpacing))  {
                self.displayLbl.fontSize = self.displayLbl.fontSize * ((self.igualBtn.frame.size.width - (2 * mySpacing))/self.displayLbl.frame.size.width )
                self.sdisplayLbl.fontSize = self.displayLbl.fontSize * ((self.igualBtn.frame.size.width - (2 * mySpacing))/self.displayLbl.frame.size.width )
            }
        }
    }
    
    // atualiza operaáoes
    func updateOperation (text:String, index:Int) {
        if text == "" {
            self.operation[0] = ""
            self.operation[1] = ""
        } else {
            self.operation[index] = self.operation[index] + text
        }
    }
    
    // cria mais blocos no cenario por solicitacao do usuario
    func moreBlocks() {
        if !self.paused {
            if self.started {
                addBlock()
                
            }
        }
    }
    func RandomInt(min min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    // Adiciona novos Blocos
    func addBlock() {
        //
        if isAddingBlock {return}
        isAddingBlock = true
        let repeats = self.currentLevel.blocksLine ? self.currentLevel.numBlocks - 1 : 0
        for _ in 0...repeats {
            var block = Block()
            while lastblock == block.value || (lastblocktype == block.type && lastblocktype == myStructs.myBlockType.signal) {
                block = Block()
                
            }
            lastblock = block.value
            lastblocktype = block.type
            block.name = blockCategoryName
            var posBlockX = CGFloat()
            if self.currentLevel.random {
                if self.currentLevel.posicional {
                    let range = UInt32(0)..<UInt32(self.currentLevel.numBlocks-1)
                    var randomBlock = Int()
                    //while (randomBlock == previousBlock) {
                    randomBlock = abs(RandomInt(min: 0,max: self.currentLevel.numBlocks-1))
                    //}
                    print ("random:\(randomBlock)")
                    self.newBlockPosX = randomBlock
                    previousBlock = randomBlock
                    posBlockX = mainBlockPos[randomBlock] + (self.blocksWidth/2)
                } else {
                    let range = UInt32(self.blocksWidth / 2)..<UInt32(self.frame.width - (self.blocksWidth / 2))
                    var randomBlock = CGFloat()
                    randomBlock = CGFloat(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
                    posBlockX = randomBlock
                }
                
            } else {
                //print("self.newBlockPosX:\(self.newBlockPosX)  self.blocksWidth:\(self.blocksWidth)")
                posBlockX = mainBlockPos[Int(self.newBlockPosX)] + (self.blocksWidth/2)
            }
            block.size = CGSize(width: self.blocksWidth, height: self.blocksWidth)
            let posBlockY = self.frame.size.height + (self.blocksWidth *  2)
            self.newBlockPosX += 1
            //
            // verifica se quantidade de blocos da coluna chegou ao limite - validação precisa ser melhorada, utilizar elementos da fisica para detectar se algum bloco criado colide com algum fora da área de selecao de blocos
            //
            if self.newBlockPosX == currentLevel.numBlocks {
                self.newBlockPosX = 0
            }
            block.column = self.newBlockPosX
            block.position = CGPointMake(posBlockX, posBlockY)
            //print("blocPos:\(block.position )")
            
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody?.dynamic = true
            if currentLevel.dynamic {
                block.physicsBody?.allowsRotation = true
                block.physicsBody? .restitution = 0
                block.physicsBody?.angularDamping = 1
                block.physicsBody?.linearDamping = 1
                block.physicsBody?.friction = 0.1
                block.physicsBody?.density = 1
                block.physicsBody?.mass   = 1
                block.physicsBody?.resting = false
            } else {
                block.physicsBody?.allowsRotation = false
                block.physicsBody? .restitution = 0
                block.physicsBody?.angularDamping = 0
                block.physicsBody?.linearDamping = 0
                block.physicsBody?.friction = 0
                block.physicsBody?.mass   = 1
                block.physicsBody?.resting = false
            }
            block.zPosition = 2
            
            block.physicsBody?.categoryBitMask = blockCategory
            
            block.physicsBody?.contactTestBitMask = bottomCategory | blockCategory
            if self.started {
                block.active = true
            } else {
                block.active = false
            }
            blocks.append(block)
            self.addChild(blocks[blocks.count - 1])
        }
        isAddingBlock = false
    }
    
    // game over
    func gameOver() {
        if GLOBALsounds {
            somAVBackGround?.stop()
        }
        started = false
        stopClock()
        stopBlocks()
        if GLOBALsounds {
            self.runAction(somPerdeu)
        }
        showBonus(0, end: true)
        self.started = false
        self.panels.show(enumTypePanel.Over)
        
    }
    
    
    func gameWin() {
        if GLOBALsounds {
            somAVBackGround?.stop()
        }
        
        started = false
        stopClock()
        stopBlocks()
        if GLOBALsounds {
            self.runAction(somGanhou)
        }
        showBonus(0, end: true)
        self.panels.show(enumTypePanel.Win)
        
    }
    
    
    func clearMessages() {
        // limpa possiveis me
        
        for view in self.view!.subviews {
            if view.isKindOfClass(UILabel) || view.isKindOfClass(UIImageView) {
                view.removeFromSuperview()
            }
        }
    }
    
    func resetPositions () {
        mainBlockPos = []
        var countX = self.displayImage.frame.origin.x
        for i in 0...Int(self.currentLevel.numBlocks) {
            if self.currentLevel.borders {
                // Adicionar linhas de separaçao com fisica
                let vertRect = CGRectMake(countX+1, container.origin.y, 0.1, container.size.height)
                let vertLine = SKShapeNode(rect: vertRect)
                vertLine.alpha = 0.05
                vertLine.zPosition = -1
                vertLine.physicsBody = SKPhysicsBody(edgeLoopFromRect: vertRect)
                vertLine.physicsBody?.dynamic = false
                //vertLine.physicsBody?.friction = 0
                //vertLine.physicsBody?.restitution = 0
                self.addChild(vertLine)
                if !self.currentLevel.guides && (i > 0 && i < Int(self.currentLevel.numBlocks)) {
                    vertLine.removeFromParent()
                }
            }
            // Armazena posições
            countX += 2
            if (i <= Int(self.currentLevel.numBlocks)) {
                mainBlockPos.append(countX)
                //                println(countX)
                countX += self.blocksWidth
            }
        }
        // count down
        self.blocks = []
        self.bonus=1
        self.pontos = 0
        self.statistics.clear()
        self.pontosLbl.text = "\(self.pontos)"
        self.updateDisplay("")
        self.updateOperation("", index: 0)
        self.igualBtn.deselect()
        self.newBlockPosX = 0
        
    }
    
    func countDown(count: Int) {
        
        let text = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.width ,
            height: self.frame.height * 0.2)
        )
        text.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 )
        text.layer.shadowOffset = (CGSize(width: 2, height: 2))
        text.layer.shadowOpacity = 1
        text.layer.shadowRadius = 1
        text.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor
        text.textAlignment = NSTextAlignment.Center
        text.alpha = 0
        self.view!.addSubview(text)
        
        if let font =  UIFont(name: "Skranji-Bold", size: self.frame.width * 0.2) {
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
            //let checkpoint =  chepoinsts [indStar]
            let helpText = "\(count)"
            let myMutableString = NSMutableAttributedString(
                string: helpText,
                attributes: textFontAttributes)
            
            text.attributedText = myMutableString
            text.textAlignment = NSTextAlignment.Center
            
        }
        self.tempoLbl.hidden = false
        
        self.restartClock()
        self.restartBlocks()
    }
    
    
    func showMessage(message:String, position: CGPoint, chances: enumChances?, type: enumTypeMensage? = enumTypeMensage.Text, numStar: Int? = 0,fontSize: CGFloat? = 0) {
        var ColorText = UIColor()
        var ColorOutline = UIColor()
        
        let labelNormalColor = UIColor(red: 0x44/255, green: 0x22/255, blue: 0x04/255, alpha: 1.0)
        
        let labelGreatColor = UIColor(red: 37/255, green: 195/255, blue: 253/255, alpha: 1)
        let labelGoodColor = UIColor(red: 67/255, green: 144/255, blue: 67/255, alpha: 1)
        let labelRegularColor = UIColor(red: 232/255, green: 138/255, blue: 18/255, alpha: 1)
        let labelBadColor = UIColor(red: 127/255, green: 38/255, blue: 38/255, alpha: 1.0)
        
        let labelBonusColor = UIColor(red: 67/255, green: 144/255, blue: 67/255, alpha: 1)
        
        var text = UITextView()
        
        let viimage = UIImageView(frame: CGRect(
            x: (self.frame.width - (self.frame.width * 0.15)) / 2,
            y: self.frame.height - position.y,
            width: self.frame.width * 0.15 ,
            height:  self.frame.width * 0.15)
        )
        
        if type == enumTypeMensage.Erro {
            
            ColorText = UIColor.yellowColor()
            ColorOutline = labelBadColor
            
            text = UITextView(frame: CGRect(
                x: 0,
                y: self.frame.height - position.y,
                width: self.frame.width ,
                height:  self.frame.width * 0.10)
            )
            
            
            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.width * fontSize!) {
                let shadow : NSShadow = NSShadow()
                
                shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
                let textFontAttributes = [
                    NSFontAttributeName : font,
                    // Note: SKColor.whiteColor().CGColor breaks this
                    NSForegroundColorAttributeName: ColorText,
                    NSStrokeColorAttributeName: ColorOutline,
                    // Note: Use negative value here if you want foreground color to show
                    NSStrokeWidthAttributeName: -5
                ]
                //let checkpoint =  chepoinsts [indStar]
                let helpText = message
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                
                text.attributedText = myMutableString
                text.textAlignment = NSTextAlignment.Center
                text.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                //text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
                //text.numberOfLines = 2
            }
            
        }  else if type == enumTypeMensage.Text {
            if chances == nil {
                ColorText = UIColor.whiteColor()
                ColorOutline = labelNormalColor
            } else if chances == enumChances.Bad {
                ColorText = UIColor.whiteColor()
                ColorOutline = labelBadColor
            } else if chances == enumChances.Reguar {
                ColorText = UIColor.whiteColor()
                ColorOutline = labelRegularColor
            } else if chances == enumChances.Good {
                ColorText = UIColor.whiteColor()
                ColorOutline = labelGoodColor
            } else if chances == enumChances.Great {
                ColorText = UIColor.whiteColor()
                ColorOutline = labelGreatColor
            }
            
            text = UITextView(frame: CGRect(
                x: 0,
                y: self.frame.height - position.y,
                width: self.frame.width ,
                height:  self.frame.width * 0.15)
            )
            
            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.width * 0.08) {
                let shadow : NSShadow = NSShadow()
                
                shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
                let textFontAttributes = [
                    NSFontAttributeName : font,
                    // Note: SKColor.whiteColor().CGColor breaks this
                    NSForegroundColorAttributeName: ColorText,
                    NSStrokeColorAttributeName: ColorOutline,
                    // Note: Use negative value here if you want foreground color to show
                    NSStrokeWidthAttributeName: -5
                ]
                //let checkpoint =  chepoinsts [indStar]
                let helpText = message
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                
                text.attributedText = myMutableString
                text.textAlignment = NSTextAlignment.Center
                text.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                
                //text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
                //text.numberOfLines = 2
            }
            
        } else if type == enumTypeMensage.Bonus ||  type == enumTypeMensage.Star  {
            ColorText = UIColor.whiteColor()
            ColorOutline = labelBonusColor
            text = UITextView(frame: CGRect(
                x: 0,
                y: 0,
                width: self.frame.width * 0.15 ,
                height:  self.frame.width * 0.15)
            )
            if let font =  UIFont(name: "Skranji-Bold", size: self.frame.width * 0.08) {
                let shadow : NSShadow = NSShadow()
                
                shadow.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1)
                let textFontAttributes = [
                    NSFontAttributeName : font,
                    // Note: SKColor.whiteColor().CGColor breaks this
                    NSForegroundColorAttributeName: ColorText,
                    NSStrokeColorAttributeName: ColorOutline,
                    // Note: Use negative value here if you want foreground color to show
                    NSStrokeWidthAttributeName: -5
                ]
                //let checkpoint =  chepoinsts [indStar]
                let helpText = message
                let myMutableString = NSMutableAttributedString(
                    string: helpText,
                    attributes: textFontAttributes)
                
                text.attributedText = myMutableString
                text.textAlignment = NSTextAlignment.Center
                text.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
                
                //text.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
                //text.numberOfLines = 2
            }
            viimage.image = type == enumTypeMensage.Bonus ? imageBonusImage : imageStar
        }
        
        text.layer.shadowOffset = (CGSize(width: 2, height: 2))
        text.layer.shadowOpacity = 1
        text.layer.shadowRadius = 1
        text.layer.shadowColor = ColorOutline.CGColor
        text.textAlignment = NSTextAlignment.Center
        text.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        
        let transformAnim            = CAKeyframeAnimation(keyPath:"transform")
        // sequencia de animacoes
        transformAnim.values         = [
            
            NSValue(CATransform3D: CATransform3DMakeRotation(10 * CGFloat(M_PI/180), 0, 0, -5)),
            
            NSValue(CATransform3D: CATransform3DConcat(
                CATransform3DMakeScale(1.5, 1.5, 1),
                CATransform3DMakeRotation(8 * CGFloat(M_PI/180), 0, 0, 1))
            ),
            
            NSValue(CATransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
            
            NSValue(CATransform3D: CATransform3DConcat(
                CATransform3DMakeScale(1.5, 1.5, 1),
                CATransform3DMakeRotation(-6 * CGFloat(M_PI/180), 0, 0, 1)
                )),
            
            NSValue(CATransform3D: CATransform3DConcat(
                CATransform3DMakeScale(1.5, 1.5, 1),
                CATransform3DMakeRotation(-6 * CGFloat(M_PI/180), 0, 0, 1)
                ))
            
        ]
        var animated:AnyObject
        transformAnim.keyTimes       = [0, 0.349, 0.618, 1]
        transformAnim.duration       = type  == enumTypeMensage.Erro ? 2.5 : 1.5
        if type == enumTypeMensage.Bonus ||  type == enumTypeMensage.Star  {
            text.alpha = 1
            viimage.addSubview(text)
            viimage.autoresizesSubviews = true
            animated = viimage
        } else {
            animated = text
        }
        
        animated.layer.opacity = 0
        animated.layer.zPosition = 2
        self.view!.addSubview(animated as! UIView)
        animated.layer.addAnimation(transformAnim, forKey: "transform")
        
        
        if type  == enumTypeMensage.Text || type  == enumTypeMensage.Erro {
            UIView.animateWithDuration(type  == enumTypeMensage.Erro ? 2.5 : 1.5,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut ,
                animations: {
                    //text.frame = CGRectMake(position.x, position.y - 200 , text.frame.width, text.frame.height)
                    animated.layer.frame.origin.y = animated.layer.frame.origin.y - 200
                    animated.layer.opacity = 1
                    
                },
                completion: { animationFinished in
                    animated.removeFromSuperview()
            })
        } else if type == enumTypeMensage.Bonus {
            UIView.animateWithDuration(1.5,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut ,
                animations: {
                    //text.frame = CGRectMake(position.x, position.y - 200 , text.frame.width, text.frame.height)
                    animated.layer.frame.origin.y = animated.layer.frame.origin.y - 200
                    animated.layer.opacity = 1
                },
                completion: { animationFinished in
                    animated.removeFromSuperview()
            })
        } else if type == enumTypeMensage.Star {
            UIView.animateWithDuration(1.5,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut ,
                animations: {
                    //text.frame = CGRectMake(position.x, position.y - 200 , text.frame.width, text.frame.height)
                    animated.layer.frame.origin.y = animated.layer.frame.origin.y - 200
                    animated.layer.opacity = 1
                },
                completion: { animationFinished in
                    UIView.animateWithDuration(0.5,
                        delay: 0.0,
                        usingSpringWithDamping: 0.5,
                        initialSpringVelocity: 0.0,
                        options: UIViewAnimationOptions.CurveEaseInOut ,
                        animations: {
                            animated.layer.frame.origin.y = self.frame.height -  ( self.imageBonusSize.origin.y + self.imageBonusSize.height )
                            animated.layer.frame.origin.x = self.frame.width - ( (  self.imageBonusSize.width * CGFloat( numStar! + 1 ) ) +  ( (  self.imageBonusSize.width * 0.2 ) * CGFloat( numStar! + 1 ) )  )
                            animated.layer.frame.size = self.imageBonusSize.size
                            
                        },
                        completion: nil)
            })
        }
    }
    
    func clearAllBlocks() {
        if self.blocks.count == 0 {
            return
        }
        for blk in blocks {
            blk.kill()
        }
        self.blocks = []
        
    }
    
    func ObtemNumerosOperacao(Operacao:String) -> [Int] {
        var numeros:[Int] = []
        var numero: String = ""
        for char in Operacao.characters {
            if (String("+-=*/").rangeOfString(String(char)) != nil) {
                numeros.append(Int(numero)!)
                numero = ""
                
            } else {
                numero = (numero as String) + String(char)
            }
        }
        if numero != "" {
            numeros.append(Int(numero)!)
        }
        return numeros
    }
    
    func ChecaSeNumeroMultiplo(numero:Int, multiplo: Int ) -> Bool {
        if multiplo == 1{
            return numero % 2 != 0
        } else {
            return numero % multiplo == 0
        }
    }
    
    func handleContact(contact: SKPhysicsContact) {
        // Verifica se nodes já foram tratados e remove da validacao
        if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
            return
        }
        
        if (contact.bodyA.node?.name == nil || contact.bodyA.node?.name == nil) {
            return
        }
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if ((nodeNames as NSArray).containsObject(blockCategoryName) && (nodeNames as NSArray).containsObject(blockCategoryName)) {
            // Bloco toca outro bloco
            if (contact.bodyA.node! as! Block).inflamed && !(contact.bodyB.node! as! Block).inflamed  {
                if started {
                    self.gameOver()
                }
                if GLOBALsounds {
                    self.runAction(SKAction.playSoundFileNamed("queda.mp3", waitForCompletion: false))
                }
            }
            
            if !(contact.bodyA.node! as! Block).firstContact {(contact.bodyA.node! as! Block).firstContact = true}
            if !(contact.bodyB.node! as! Block).firstContact {(contact.bodyB.node! as! Block).firstContact = true}
        }
    }
    
    func processContactsForUpdate(currentTime: CFTimeInterval) {
        
        for contact in self.contactQueue {
            self.handleContact(contact)
            
            if let index = (self.contactQueue as NSArray).indexOfObject(contact) as Int? {
                self.contactQueue.removeAtIndex(index)
            }
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        if contact as SKPhysicsContact? != nil {
            self.contactQueue.append(contact)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectBlock(touches,withEvent: event)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectBlock(touches,withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if tutorialIsActive {
            if !panelTutorial.hidden {
                if currentStep < 3 {
                    self.runAction(
                        SKAction.sequence([
                            SKAction.waitForDuration(0.1),
                            SKAction.runBlock({ () -> Void in
                                self.currentStep += 1
                                self.panelTutorial.stepTutorial(self.currentStep)
                            })
                            ])
                    )
                } else {
                    if currentStep == 99 {
                        currentStep = 2
                    } else {
                        self.panelTutorial.hide(0)
                    }
                }
                self.paused = false
                return
            } else {
                if (currentStep >= 6 && currentStep < 9) {
                    self.runAction(
                        SKAction.sequence([
                            SKAction.waitForDuration(0.1),
                            SKAction.runBlock({ () -> Void in
                                self.currentStep += 1
                                self.panelTutorial.stepTutorial(self.currentStep)
                            })
                            ])
                    )
                }
                
            }
        }
    }
    func selectBlock(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !started || (tutorialIsActive && currentStep < 3) {
            return
        }
        let touch = touches.first!
        let viewTouchLocation = touch.locationInView(self.view)
        let sceneTouchPoint = self.convertPointFromView(viewTouchLocation)
        let touchedNode = self.nodeAtPoint(sceneTouchPoint)
        
        if (touchedNode.name == blockCategoryName) {
            if !(touchedNode  as! Block).selected {
                (touchedNode  as! Block).select()
                if tutorialIsActive {
                    if currentStep == 3 {
                        self.runAction(
                            SKAction.sequence([
                                SKAction.waitForDuration(0.1),
                                SKAction.runBlock({ () -> Void in
                                    self.currentStep += 1
                                    self.panelTutorial.stepTutorial(self.currentStep)
                                })
                                ])
                        )
                        
                    }
                }
            }
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
