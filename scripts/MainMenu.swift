//
//  GameScene.swift
//  Breakout
//
//  Created by Training on 28/11/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import SpriteKit
import AVFoundation
// Animaçoões e sons
class MainMenu: SKScene, SKPhysicsContactDelegate {
    var pauseView:PauseMenu = PauseMenu(frame: CGRect())
    var game: GameScene = GameScene(size: CGSize())
    // Initializers do Jogo
    let numBlocks:CGFloat = 5	//Quantidade de blocos por linha
    let checkpointVelocity = 0	//Quantidade de acertos para incremento de velocidade
    let checkpointBonus = 0     //Quantidade de acertos para incremento de Bonus
    let checkpointLevel = 0	//Quantidade de blocos do nivel
    let checkpointTimer = 0	//Tempo do jogo
    var timerBlocks	= 0.1		//Tempo inicial para geraáao dos blocos
    let random = false			//Posiáoes de Blocos Randomicas
    let inGameBlocks = "0123456789/*-+"  // valores dos blocos que farao parte do jogo
    let borders = true
    let guides = true
    var bonus = 0
    //    let inGameBlocks = "123-+"  // valores dos blocos que farao parte do jogo
    //   let inGameBlocks = "9"  // valores dos blocos que farao parte do jogo
    let statistics = Statistics()
    // nomes para identificar tipos que em iteraáao
    let blockCategoryName = "block"
    let bottomCategoryName = "bottom"
    let buttonCategoryName = "button"
    
    // musica de fundo
    var backgroundMusicPlayer = AVAudioPlayer()
    
    // categoryBitMasks para fisicos
    let blockCategory:UInt32 = 0x1 << 0              // 000000001
    let bottomCategory:UInt32 = 0x1 << 1            // 000000010
    
    // controles para blocos do jogo
    var blocks:[Block] = []
    var mainBlockPos:[CGFloat] = []
    var newBlockPosX:CGFloat = 0
    var container:CGRect = CGRect()
    var mySpacing:CGFloat = 0
    var blocksWidth:CGFloat = 0
    var fingerIsOnBlock = false
    var previousBlock = Int()
    // nodes manipulaveis
    var bottom:SKNode = SKNode()
    var sdisplayLbl:SKLabelNode = SKLabelNode()
    var backgroundImage:SKSpriteNode = SKSpriteNode()
    var bonusLbl = SKLabelNode(fontNamed: "Skranji Bold")
    var sbonusLbl = SKLabelNode(fontNamed: "Skranji Bold")
    
    
    var igualBtn:myButtomVerify = myButtomVerify(imageNamed: "0Blk")
    var moreBtn:myButtomMore = myButtomMore(imageNamed: "MoreBtn")
    var tempoLbl = SKLabelNode(fontNamed: "Skranji Bold")
    var stempoLbl = SKLabelNode(fontNamed: "Skranji Bold")
    var pontosLbl = SKLabelNode(fontNamed: "Skranji Bold")
    
    // controles
    var lblDisplafontSize: CGFloat = CGFloat()
    var operation:[String] = ["",""]
    var timescore = Int()
    var timesecond = Int()
    var pontos = 0
    var lastMessage = ""
    var levelSelect: LevelSelect = LevelSelect(frame: CGRect())
    override init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.contactDelegate = self

        /*let bgMusicURL = NSBundle.mainBundle().URLForResource("bg2", withExtension: "mp3")
        
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        */
        
        // espaco dos objetos
        self.mySpacing = self.frame.size.width * 0.02
        
        // Background
        self.backgroundImage = SKSpriteNode(imageNamed: "BackGround")
        backgroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        backgroundImage.size = self.frame.size
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)

        let displayImage = SKSpriteNode(imageNamed: "Titulo")
        let displayWidth = self.size.width * 0.7
        let displayHeigth = displayImage.size.height * (displayWidth / displayImage.size.width)
        displayImage.size = CGSize(width:displayWidth, height: displayHeigth)
        displayImage.position = CGPointMake(self.frame.size.width / 2,
                                self.frame.size.height * 0.65)
        displayImage.alpha = 0
            
        self.addChild(displayImage)

        
         displayImage.runAction(
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

        
        // guardando posiçao do containter do jogo
        self.container = CGRect(origin: CGPoint(x: backgroundImage.frame.origin.x, y: backgroundImage.frame.origin.y + backgroundImage.size.height) , size: CGSize(width: backgroundImage.frame.size.width, height: self.frame.size.height))
        
        //
        // botoes do jogo
        //

        // Botao apagar - posicionado no inicio do display
        let playBtn = myButtomPlay(imageNamed: "PlayButtonOrange")
        playBtn.size = CGSize(width: self.frame.size.width * 0.2,
            height: self.frame.size.width * 0.2)
        playBtn.position = CGPointMake(self.frame.size.width / 2 , self.frame.size.height / 4 )
        playBtn.alpha = 0
        self.addChild(playBtn)

        playBtn.runAction(
            SKAction.sequence([
                SKAction.scaleTo(0, duration: 0),
                SKAction.fadeAlphaTo(1, duration: 0),
                SKAction.waitForDuration(2.5),
                SKAction.scaleTo(1, duration:0.5)
                ])
        )
        
        // Phisica
        // Gravidade
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.8)
        
        // linha de baixo - limite dos blocos bottom
       let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        self.bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        bottom.physicsBody?.categoryBitMask = bottomCategory
        bottom.physicsBody?.friction = 0.3
        bottom.physicsBody?.angularDamping = 1
        

        self.blocksWidth = (self.container.width - ( 3 * self.numBlocks)) / self.numBlocks
        
        println(self.blocksWidth)
        var countX = container.origin.x
        var i:Int
        for i in 0...Int(self.numBlocks) {
            if self.borders {
                // Adicionar linhas de separaçao com fisica
                let vertRect = CGRectMake(countX+1, container.origin.y, 0.1, container.size.height)
                let vertLine = SKShapeNode(rect: vertRect)
                vertLine.alpha = 0.05
                vertLine.zPosition = -1
                vertLine.physicsBody = SKPhysicsBody(edgeLoopFromRect: vertRect)
                vertLine.physicsBody?.friction = 0
                vertLine.physicsBody?.restitution = 0
                self.addChild(vertLine)
                if !self.guides && (i > 0 && i < Int(self.numBlocks)) {
                    vertLine.removeFromParent()
                }
            }
            // Armazena posições
            countX += 2
            if (i <= Int(self.numBlocks)) {
                mainBlockPos.append(countX)
                println(countX)
                countX += self.blocksWidth
            }
            
        }
        // monta array de blocos que farao parte do jogo
        for blk in inGameBlocks {
            if blk == "+" {
                println("vai")
            }
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
        // Test Switch
        // Reload
        reloadGame()
    }
    

    override func didMoveToView(view: SKView) {
        game = GameScene(size: self.view!.frame.size) // create your new scene
        levelSelect = LevelSelect(frame: self.frame, game: self)
        levelSelect.hidden = true
        self.view?.addSubview(levelSelect)
    }

    func stopBlocks() {
        if (self.actionForKey("addBlock") != nil) {
            self.removeActionForKey("addBlock")
        }
    }
    
    func showGameScene() {
        levelSelect.show()
    }

    func restartBlocks() {
        // inicia geracao dos blocos
        var actionwait = SKAction.waitForDuration(NSTimeInterval(timerBlocks))
        var actionrun = SKAction.runBlock({self.addBlock()})
        stopBlocks()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])), withKey:"addBlock")
        
    }
    func addBlock() {
        
        //
        var block = Block()
        block.name = blockCategoryName
        var posBlockX = CGFloat()
        if self.random {
            let range = UInt32(0)..<UInt32(self.numBlocks-1)
            var randomBlock = Int()
            while (randomBlock == previousBlock) {
                randomBlock = Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex + 1))
            }
            previousBlock = randomBlock
            posBlockX = mainBlockPos[randomBlock] + (self.blocksWidth/2)
        } else {
            posBlockX = mainBlockPos[Int(self.newBlockPosX)] + (self.blocksWidth/2)
        }
        block.size = CGSize(width: self.blocksWidth, height: self.blocksWidth)
        
        var posBlockY = self.frame.size.height + self.blocksWidth
        self.newBlockPosX += 1
        if self.newBlockPosX == numBlocks {
            self.newBlockPosX = 0
        }
        block.position = CGPointMake(posBlockX, posBlockY)
        
        
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
        block.physicsBody?.friction = 0.3
        block.physicsBody?.restitution = 0.3
        block.physicsBody?.density = 0.2
        //block.physicsBody?.allowsRotation = false
        block.physicsBody?.dynamic = true
        block.zPosition = -1
        block.active = false
        block.physicsBody?.categoryBitMask = blockCategory
        
        block.physicsBody?.contactTestBitMask = bottomCategory | blockCategory
        
        blocks.append(block)
        self.addChild(block)
        
    }
    
    func reloadGame() {
        
        var teste = myStructs.myDesctiptionItem(
            type: myStructs.myDesctiptioType.text ,
            //text: NSLocalizedString("explicacao")
            text: "Tete"
        )
        var teste1 = myStructs.myDesctiptionItem(
            type: .image ,
            //text: NSLocalizedString("explicacao")
            text: "7Blk"
        )
        
        
        
       /*
        let descriptionView = Description(aSize: CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.8), aPosition: CGPoint(x: self.frame.width/2, y: self.frame.height/2),
            text:[
                teste,teste,teste1,
                teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
                ,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste,teste1
            ])

        self.addChild(descriptionView)
        */
    
        self.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock({
                        println("passa no inicio")
                        self.clearAllBlocks()
                        self.restartBlocks()
                        self.addChild(self.bottom)
                        
                    }),
                    SKAction.waitForDuration(5),
                    SKAction.runBlock({
                        self.stopBlocks()
                        self.bottom.removeFromParent()
                    }),
                    SKAction.waitForDuration(5),
                    ])
            
                )
            )
       

    }
    
    func showMessage(message:String, position: CGPoint) {
        let stext = SKLabelNode(fontNamed: "Skranji Bold")
        stext.position = position
        stext.fontColor = UIColor(red: 138, green: 88, blue: 29, alpha: 1)
        stext.fontSize = 30
        stext.text = message
        let text = SKLabelNode(fontNamed: "Skranji Bold")
        text.position = CGPointMake(position.x - 2, position.y + 2)
        text.fontColor = UIColor.whiteColor()
        text.fontSize = 30
        text.text = message
        
        self.addChild(stext)
        self.addChild(text)
        
        
        var seq:[SKAction] = []
        let fade = SKAction.scaleTo (0.0, duration: 0.0)
        let fademoveup = SKAction.moveToY(position.y + 200, duration: 2)
        let fadein = SKAction.scaleTo(1, duration: 0.5)
        let wait = SKAction.waitForDuration(1)
        let fadeout = SKAction.scaleTo (0.0, duration: 0.5)
        let seqAux = SKAction.sequence([fade,fadein,wait,fadeout])
        let groupSair = SKAction.group([seqAux,fademoveup])
        seq.append(groupSair)
        let removeText = SKAction.removeFromParent()
        seq.append(removeText)
        
        
        stext.runAction(fadeout)
        text.runAction(fadeout)
        stext.runAction(SKAction.sequence(seq))
        text.runAction(SKAction.sequence(seq))
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
