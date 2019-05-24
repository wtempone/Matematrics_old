
import SpriteKit

class Description:SKSpriteNode {
    // settings guides
    enum Zone {
        case Left, Center, Right
    }

    
    var leftGuide:CGFloat = CGFloat()
    var rightGuide:CGFloat = CGFloat()
    var gap:CGFloat = CGFloat()
    var atualPosition:CGFloat =  CGFloat(0)
    var mask = SKCropNode()
    var masklayer = SKSpriteNode()
    var pages:[SKSpriteNode] = []
    var document = SKSpriteNode()
    var indexPage:Int = 0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let  image = SKTexture(imageNamed: "Comojogar" )
        super.init(texture: image, color: UIColor.clearColor(), size: size)
        self.userInteractionEnabled = true

    }
    
    
    convenience init(aSize: CGSize, aPosition: CGPoint, text:[myStructs.myDesctiptionItem]) {
        self.init(texture:nil, color: UIColor.clearColor(), size: aSize)
        self.position = aPosition
        
        let positionx = CGFloat(0)
        mask = SKCropNode()
        mask.position = CGPoint(x: 0, y: self.position.y * 0.53)
        masklayer = SKSpriteNode(texture: SKTexture(imageNamed: "0Blk") , color: UIColor.clearColor(), size: CGSize(width: self.frame.width * 0.9, height: self.frame.height * 0.73) )
        masklayer.position = CGPoint(x: masklayer.position.x , y: masklayer.position.y - (masklayer.frame.height / 2))
        mask.maskNode = masklayer
    
        var nextY = CGFloat(0)
        var nextX = CGFloat(0)
        
        // setting guides

        leftGuide =  CGFloat(0)
        
        rightGuide = masklayer.frame.width
        
        gap = (masklayer.frame.width / 2 - leftGuide) / 2
        
        var page = SKSpriteNode()
        page.position = CGPoint(x: 0, y: 0)
        for t in text{
            
            if t.type ==  myStructs.myDesctiptioType.text {
                let label = SKLabelNode()
                label.fontName = "ComicsCarToon"
                label.fontSize = self.frame.height * 0.04
                label.fontColor = SKColor.brownColor()
                label.text = t.text
                label.position  = CGPoint(x: positionx, y: nextY - (label.frame.height))
                page.addChild(label)
                nextY -= label.frame.height
            }else{
                let label = SKSpriteNode(imageNamed: t.text)
                let heig = masklayer.frame.height + nextY
                let wid = label.frame.width * (heig/label.frame.height)
                label.size = CGSize(width:wid
                    , height:heig
                )
                label.position  = CGPoint(x: positionx, y: nextY - (label.frame.height/2))
                page.addChild(label)
                nextY -= label.frame.height
            }
            //println("nextY:\(nextY) masklayer.frame.height:\(-masklayer.frame.height)")
            if nextY <= -masklayer.frame.height {
                pages.append(page)
                document.addChild(page)
                page = SKSpriteNode()
                nextX += masklayer.frame.width
                page.position.x = nextX
                nextY = CGFloat(0)
            }
        }
        mask.addChild(document)
        self.addChild(mask)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Movements
    func calculateScaleForX(x:CGFloat) -> CGFloat {
        let minScale = CGFloat(0.5)
        
        if x <= leftGuide || x >= rightGuide {
            return minScale
        }
        
        if x < size.width/2 {
            let a = 1.0 / (size.width - 2 * leftGuide)
            let b = 0.5 - a * leftGuide
            
            return (a * x + b)
        }
        
        let a = 1.0 / (frame.size.width - 2 * rightGuide)
        let b = 0.5 - a * rightGuide
        
        return (a * x + b)
    }
    func movePlayerToX(player: SKSpriteNode, x: CGFloat, duration: NSTimeInterval) {
        let moveAction = SKAction.moveToX(x, duration: duration)
        //let scaleAction = SKAction.scaleTo(calculateScaleForX(x), duration: duration)
        
        player.runAction(SKAction.group([moveAction]))
    }
    
    func movePlayerByX(player: SKSpriteNode, x: CGFloat) {
        let duration = 0.01
        
            player.runAction(SKAction.moveByX(x, y: 0, duration: duration))
           /*
            if CGRectGetMidX(player.frame) < leftGuide {
                player.position = CGPointMake(leftGuide, player.position.y)
            } else if CGRectGetMidX(player.frame) > rightGuide {
                player.position = CGPointMake(rightGuide, player.position.y)
            }*/
    }
    
    // Touch interactions
    
     /*override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("passa")
    }*/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil {
            let newPosition = touches.first!.locationInNode(self)
            let oldPosition = touches.first!.previousLocationInNode(self)
            let xTranslation = newPosition.x - oldPosition.x
            //println("passa")
            movePlayerByX(document, x: xTranslation)
        }
        super.touchesBegan(touches , withEvent:event)
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first != nil {
            let duration = 0.25
            
            if document.position.x  < (atualPosition - (masklayer.frame.size.width / 2)) {
                if indexPage < pages.count - 1 && indexPage >= 0 {indexPage += 1}
                //println("left")
            } else {
                if document.position.x  > atualPosition + (masklayer.frame.size.width / 2)  {
                    //println("right")
                    if indexPage <= pages.count - 1 && indexPage > 0 {indexPage -= 1}
                } else {
                    //println("center")
                }
            }
            
            //println("indexpage:\(indexPage) pages.count: \(pages.count)" )
            
            atualPosition =  -CGFloat(indexPage) * masklayer.frame.size.width
            movePlayerToX(document, x: atualPosition, duration: duration)
        }
        super.touchesBegan(touches , withEvent:event)
    }
}