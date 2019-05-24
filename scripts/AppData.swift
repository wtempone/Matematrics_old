//

import SpriteKit
import AVFoundation
// Animaçoões e sons SpriteKIT

let somSelect = SKAction.playSoundFileNamed("marcar1.mp3", waitForCompletion: false)
let somDeselect = SKAction.playSoundFileNamed("deselect.mp3", waitForCompletion: false)
let somBotao = SKAction.playSoundFileNamed("botao.mp3", waitForCompletion: false)
let somBloco = SKAction.playSoundFileNamed("marcar.mp3", waitForCompletion: false)
let somWrong = SKAction.playSoundFileNamed("wrong.mp3", waitForCompletion: false)
let somAcertou = SKAction.playSoundFileNamed("acerto1.mp3", waitForCompletion: false)	
let somErrou = SKAction.playSoundFileNamed("errou1.mp3", waitForCompletion: false)
let somGanhou = SKAction.playSoundFileNamed("ganhou.mp3", waitForCompletion: false)
let somPerdeu = SKAction.playSoundFileNamed("perdeu.mp3", waitForCompletion: false)
let somFlipPage = SKAction.playSoundFileNamed("FlipPage.mp3", waitForCompletion: false)
let somImpacto1 = SKAction.playSoundFileNamed("Impacto1.mp3", waitForCompletion: false)
let somImpacto2 = SKAction.playSoundFileNamed("Impacto2.mp3", waitForCompletion: false)
let somGameStart = SKAction.playSoundFileNamed("GameStart.mp3", waitForCompletion: false)
let wiggleColorIn = SKAction.colorizeWithColor(UIColor.redColor() , colorBlendFactor: 0.7, duration: 0.4)
let wiggleColorOut = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.0, duration: 0.4)
let wiggleColor = SKAction.repeatActionForever(SKAction.sequence([wiggleColorIn, wiggleColorOut]))
let wiggleIn = SKAction.scaleTo(1.0, duration: 0.2)
let wiggleOut = SKAction.scaleTo(1.1, duration: 0.2)
let wiggle = SKAction.sequence([wiggleIn, wiggleOut, wiggleIn])
let wiggleButtonOK = SKAction.group([somBotao,wiggle])
let wiggleButtonNOK = SKAction.group([somWrong,wiggle])

let blockFadeOut = SKAction.group([
    SKAction.fadeAlphaTo(0.5, duration: 0.2),
    SKAction.colorizeWithColor(UIColor.blueColor() , colorBlendFactor: 0.5, duration: 0.2)
])
let blockFadeIn =  SKAction.group([
    SKAction.colorizeWithColor(UIColor.blueColor() , colorBlendFactor: 0, duration: 0.2),
    SKAction.fadeAlphaTo(1, duration: 0.2)
    ])

// Constantes para geracao dos blocos
// Array para operacoes matematicas
let v_blocos = ["0","1","2","3","4","5","6","7","8","9","/","*","+","-"]
// array para montagem do display
let v_labelBlocos = ["0","1","2","3","4","5","6","7","8","9","÷","×","+","-"]
// Array de imagens para exibicao dos blocos
let v_imageBlocos = ["0Blk","1Blk","2Blk","3Blk","4Blk","5Blk","6Blk","7Blk","8Blk","9Blk","DividirBlk","MultiplicarBlk","SomarBlk","SubtrairBlk"]

// arrays dos blocos que farao parte do jogo
var GLOBALblocos:[String] = []
var GLOBALlabelBlocos:[String] = []
var GLOBALimageBlocos:[String] = []
var GLOBALsounds = true
var GLOBALmusic = true
let GLOBALlevelManager = LevelManager()
let GLOBALsettingsManager = SettingsManager()
let GLOBALanimations = Animations()
var GLOBALbuttonSize = defineButonSize()
var GLOBALmaxAdvertise:Int = 1
var GLOBALcountAdvertise:Int = 0


func defineButonSize () -> CGSize {
    switch UIScreen.mainScreen().bounds.width {
    //Ipad2, IPad air, Ipad Retina
    case 768.0:return CGSize(width: 65,height: 65)
    //iPad Pro
    case 1024.0:return CGSize(width: 80,height: 80)
    //iPhone 5s
    case 320.0: return CGSize(width: 36,height: 36)
    //Iphone 6 e 6S
    case 375.0: return CGSize(width: 45,height: 45)
    //Iphone 6 plus e 6S plus
   case 414.0: return CGSize(width: 47,height: 47)
    default: abort()
    }
}


func GLOBALtimeSring(time:Int) -> String{
    let (_,m,s) = GLOBALsecondsToHoursMinutesSeconds(time)
    let ms = (m > 1) ? "s" : ""
    let ss = (s > 1) ? "s" : ""
    let message = String(format: NSLocalizedString("DescriptionTime", comment: ""), m,ms,s,ss)

    return message
}
func GLOBALtimeDigital(time: Int) -> String{
    let (_,m,s) = GLOBALsecondsToHoursMinutesSeconds(time)
    let sec = NSString(format: "%02d", s)
    return "\(m):\(sec)"
}
func GLOBALsecondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}