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
class LevelSelect: UIView, UIScrollViewDelegate {
    
    var originYPos: CGFloat = CGFloat()
    var buttonSize: CGFloat = CGFloat()
    var buttonsPerPage: CGFloat = CGFloat()
    var buttonsGap: CGFloat = CGFloat()
    
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var navbarView:UIView!
    let buttonLeft = UIButton()
    let buttonRight = UIButton()
    let buttonBack = UIButton()
    let buttonShop = UIButton()
    var menu: SKScene = SKScene()
    var label = UILabel()
    var audioPlayer:AVAudioPlayer?
    var levelSize: CGFloat = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let url = NSURL.fileURLWithPath(
            NSBundle.mainBundle().pathForResource("botao",
                ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Erro ao tocar ")
        }

    }
    convenience init(frame: CGRect, menu: SKScene) {
        self.init(frame: frame)
        self.menu = menu
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

    

    override func didMoveToSuperview() {

        buttonsPerPage = 4

        // set the backbround

        let backgroundframe = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        let backgound = UIImageView(frame: backgroundframe)

        let image = UIImage(named: "Backgound")

        backgound.image = image

        self.addSubview(backgound)

        // set the panel background for scroll 0.8 reduced size

        let panelframe = CGRect(x: (self.frame.width - self.frame.width * 0.9) / 2 , y: (self.frame.height - self.frame.height * 0.9) / 2, width: self.frame.width * 0.9, height: self.frame.height * 0.9)

        let panel = UIImageView(frame: panelframe)

        let panelImage = UIImage(named: "Panel")

        panel.image = panelImage

        self.addSubview(panel)

        buttonSize = GLOBALbuttonSize.height

        levelSize = buttonSize * 1.4

        // add ribon

        let ribonImage = UIImage(named: "RibbonSelect")

        let ribon = UIImageView(image: ribonImage)

        let ribbonWidth = panelframe.width * 0.6

        let ribbonHeigth = ribon.frame.height * (ribbonWidth / ribon.frame.size.width)

        ribon.frame = CGRect(x: ((self.frame.width - ribbonWidth) / 2), y: panelframe.origin.y - ( ribbonHeigth * 0.4) ,

            width: ribbonWidth, height: ribbonHeigth)

        self.addSubview(ribon)

        let scrollframe = CGRect(x: (self.frame.width - self.frame.width * 0.8) / 2 , y: (self.frame.height - self.frame.height * 0.8) / 2, width: self.frame.width * 0.8, height: self.frame.height * 0.8)

        buttonsGap = (scrollframe.width - (levelSize * buttonsPerPage)) / (buttonsPerPage + 1)

        // add scroll

        // This houses all of the UIViews / content

        

        scrollView = UIScrollView()

        //scrollView.backgroundColor = UIColor.clearColor()

        scrollView.frame = scrollframe

        scrollView.pagingEnabled = true

        scrollView.showsHorizontalScrollIndicator = false

        scrollView.delegate = self

        scrollView.bounces = false

        self.addSubview(scrollView)

        

        // page control

        self.pageControl = UIPageControl()

        pageControl.frame = CGRect(x: scrollframe.origin.x, y: (scrollframe.origin.y + scrollframe.height) - 20 , width: scrollframe.width, height: 30)

        //pageControl.backgroundColor = UIColor.whiteColor()

        pageControl.currentPage = 0

        let imageCurrent = UIImage(named: "dotSelected")

        let imageIndicator = UIImage(named: "dot")

        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: imageCurrent!)

        pageControl.pageIndicatorTintColor = UIColor(patternImage: imageIndicator!)

        //        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()

        //        pageControl.pageIndicatorTintColor = UIColor.blueColor()

        pageControl.autoresizesSubviews = true

        self.addSubview(pageControl)

        self.bringSubviewToFront(pageControl)

        //

        // buttons

        //

        //botao bsck

        buttonBack.frame = CGRect(

            x: ((self.frame.width / 2) - (buttonSize * 1.25)),

            y: (panelframe.origin.y + panelframe.height) - (buttonSize * 0.5) ,

            width: buttonSize,

            height: buttonSize

        )

        buttonBack.setImage(UIImage(named: "backButton"), forState: UIControlState.Normal)

        buttonBack.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)

        buttonBack.imageView?.frame = buttonBack.frame

        buttonBack.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill

        buttonBack.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill

        

        self.addSubview(buttonBack)

 

        //botao shop

        buttonShop.setImage(UIImage(named: "shopButton"), forState: UIControlState.Normal)

        buttonShop.addTarget(self, action: "reload", forControlEvents: UIControlEvents.TouchUpInside)

        buttonShop.frame = CGRect(

            x: ((self.frame.width / 2) - (buttonSize * 1.25)),

            y: self.frame.height - (buttonSize * 1.25) ,

            width: buttonSize,

            height: buttonSize)

        buttonShop.imageView?.frame = buttonShop.frame

        buttonShop.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill

        buttonShop.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill

        //self.addSubview(buttonShop)

        originYPos = self.frame.origin.y

        //botao bsck

        

        
        let arrowImage = UIImage(named: "arrowLeft")
        
        _ = UIImageView(image: arrowImage)
        
        let arrowWidth = GLOBALbuttonSize.width
        
        let arrownHeigth = (arrowImage?.size.height)! * (arrowWidth / arrowImage!.size.width)
        
        
        
        buttonLeft.setImage(UIImage(named: "arrowLeft"), forState: UIControlState.Normal)
        
        buttonLeft.setImage(UIImage(named: "arrowLeftInactive"), forState: UIControlState.Disabled)
        
        buttonLeft.addTarget(self, action: "prevPage", forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonLeft.frame = CGRect(
            
            x: 0,
            
            y: panelframe.origin.y + (panelframe.height - arrownHeigth ) / 2 ,
            
            width: arrowWidth,
            
            height: arrownHeigth
            
        )
        
        buttonLeft.imageView?.frame = buttonLeft.frame
        
        buttonLeft.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        
        buttonLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        buttonLeft.enabled = false
        
        self.addSubview(buttonLeft)
        
        
        
        buttonRight.setImage(UIImage(named: "arrowRight"), forState: UIControlState.Normal)
        
        buttonRight.setImage(UIImage(named: "arrowRightInactive"), forState: UIControlState.Disabled)
        
        buttonRight.addTarget(self, action: "nextPage", forControlEvents: UIControlEvents.TouchUpInside)
        
        buttonRight.frame = CGRect(
            
            x:self.frame.width - arrowWidth,
            
            y: (self.frame.height / 2) - (arrownHeigth / 2),
            
            width: arrowWidth,
            
            height: arrownHeigth)
        
        buttonRight.imageView?.frame = buttonRight.frame
        
        buttonRight.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        
        buttonRight.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        buttonRight.enabled = false
        
        self.addSubview(buttonRight)
        




        self.reloadLevels()

    }   

    func reloadLevels() {

        

        for view in self.scrollView.subviews {

            view.removeFromSuperview()

        }        

                

        // readind file Game Data

        let GameDataPath:NSString = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist")!

        let fases:NSArray = NSArray(contentsOfFile: GameDataPath as String)!

        

        

        pageControl.numberOfPages = fases.count



        // senting the content size

        let contentsize = self.scrollView.frame.width * CGFloat(fases.count)

        self.scrollView.contentSize = CGSize(width: contentsize , height: self.scrollView.frame.height)

        // reading fases

        var indFase:CGFloat = 0

        //

        // load fases

        //



        for fase in fases {

            // prepare view from each fase

            let frameview = CGRect(x: self.scrollView.frame.width *  indFase, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)

            let faseview = UIView()

            faseview.frame = frameview

            // get values and convert

            let indfase = fase.objectForKey("fase") as! Int

            let descriptionfase = fase.objectForKey("description") as! String

            // add label fase to view fase

            let label = UILabel()

            label.frame = CGRect(x: 0, y: 0, width: frameview.width, height: frameview.height * 0.1)

            label.layer.shadowOffset = (CGSize(width: 2, height: 2))

            label.layer.shadowOpacity = 1

            label.layer.shadowRadius = 1

            label.layer.shadowColor = UIColor(red: 58/255, green: 35/255, blue: 10/255, alpha: 1).CGColor

            label.textAlignment = NSTextAlignment.Center

            faseview.addSubview(label)

            // styling label

            if let font =  UIFont(name: "Skranji-Bold", size: frameview.width * 0.06 ) {

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

                    string: "\(descriptionfase)",

                    attributes: textFontAttributes)

                label.numberOfLines = 0

                label.lineBreakMode = NSLineBreakMode.ByCharWrapping

                label.attributedText = myMutableString
                
            }
            
            let levels = fase.objectForKey("levels") as! NSArray
            
            var nextx = buttonsGap
            
            let buttonLines = CGFloat(levels.count) / buttonsPerPage
            
            let buttonsHeigth =  (levelSize + buttonsGap)
            
            let buttonsColumnHeigth = buttonLines * buttonsHeigth
            
            
            
            var nexty = label.frame.origin.y + label.frame.height + ((self.scrollView.frame.height - (buttonsColumnHeigth + label.frame.origin.y + label.frame.height)) / 3)
            
            var buttonLine = CGFloat(0)
            
            //
            
            // load fase's levels
            
            //
            if levels.count > 0 {
                for level in levels {
                    
                    if buttonLine >= buttonsPerPage {
                        
                        nexty += levelSize + buttonsGap
                        
                        nextx = buttonsGap
                        
                        buttonLine = 0
                        
                    }
                    
                    buttonLine += 1
                    
                    let myLevel = myStructs.myLevel()
                    
                    myLevel.fase = indfase
                    
                    myLevel.level = level.objectForKey("level") as! Int
                    
                    myLevel.description = level.objectForKey("description") as! String
                    
                    myLevel.descriptionFase = descriptionfase
                    
                    myLevel.validaMultiplo = level.objectForKey("validaMultiplo") as! Int
                    
                    myLevel.locked = false
                    //myLevel.locked = level.objectForKey("locked") as! Bool
                    
                    myLevel.numBlocks = level.objectForKey("numBlocks") as! Int
                    
                    myLevel.checkpointVelocity = level.objectForKey("checkpointVelocity") as! Int
                    
                    myLevel.checkpointBonus = level.objectForKey("checkpointBonus") as! Int
                    
                    myLevel.checkpointLevel = level.objectForKey("checkpointLevel") as! Int
                    
                    myLevel.checkpointLevel2 = level.objectForKey("checkpointLevel2") as! Int
                    
                    myLevel.checkpointLevel3 = level.objectForKey("checkpointLevel3") as! Int
                    
                    myLevel.checkpointTimer = level.objectForKey("checkpointTimer") as! Int
                    
                    myLevel.timerBlocks = level.objectForKey("timerBlocks") as! Double
                    
                    myLevel.random = level.objectForKey("random") as! Bool
                    
                    myLevel.inGameBlocks = level.objectForKey("inGameBlocks") as! String
                    
                    myLevel.borders = level.objectForKey("borders") as! Bool
                    
                    myLevel.guides = level.objectForKey("guides") as! Bool
                    
                    myLevel.validaConjunto = level.objectForKey("validaConjunto") as! Bool
                    myLevel.numeroInicial = level.objectForKey("numeroInicial") as! Int
                    myLevel.numeroFinal = level.objectForKey("numeroFinal") as! Int
                    myLevel.posicional = level.objectForKey("posicional") as! Bool
                    myLevel.messagemValidacaoConjunto = level.objectForKey("messagemValidacaoConjunto") as! String
                    myLevel.blocksLine = level.objectForKey("blocksLine") as! Bool
                    myLevel.dynamic = level.objectForKey("dynamic") as! Bool
                    
                    //(menu as! MenuScene).levels[myLevel.level, myLevel.fase] = myLevel
                    
                    let button1 = MYLevelBtn(frame: CGRect(
                        
                        x: nextx,
                        
                        y: nexty,
                        
                        width: levelSize,
                        
                        height: levelSize),
                        
                        menu: menu,
                        
                        fase: myLevel.fase,
                        
                        level: myLevel.level,
                        
                        locked: myLevel.locked
                    )
                    
                    
                    
                    faseview.addSubview(button1)
                    
                    nextx += levelSize + buttonsGap
                    
                    
                }
            } else {
                label.layer.position = CGPoint(x: self.scrollView.frame.width / 2, y: self.scrollView.frame.height / 2 )
            }
            // add view from each fase

            // add view from each fase

            nextx = 25

            indFase += CGFloat(1)

            self.bringSubviewToFront(scrollView)

            self.scrollView.addSubview(faseview)

            self.scrollView.bringSubviewToFront(faseview)

        }

        self.bringSubviewToFront(buttonLeft)

        self.bringSubviewToFront(buttonRight)

        enabeleButton()

        originYPos = self.frame.origin.y

        

    }



    func scrollViewDidScroll(scrollView: UIScrollView) {

        

    }

    

    func enabeleButton() {

        buttonLeft.enabled = true

        buttonLeft.userInteractionEnabled = true

        buttonRight.enabled = true

        buttonRight.userInteractionEnabled = true

        if pageControl.currentPage == 0 {

            buttonLeft.enabled = false

            buttonLeft.userInteractionEnabled = false

        }

        if pageControl.currentPage == pageControl.numberOfPages - 1 {

            buttonRight.enabled = false

            buttonRight.userInteractionEnabled = false

        }

    }

    

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let pageWidth:CGFloat = self.scrollView.frame.size.width

        let fractionalPage = Int(self.scrollView.contentOffset.x / pageWidth)

        let page:NSInteger = fractionalPage

        self.pageControl.currentPage = page
        self.pageControl.currentPage = page
        if GLOBALsounds{
            self.menu.runAction(somFlipPage)
        }
        enabeleButton()

    }

    func scrollToPage(page: Int, animated: Bool) {

        var frame: CGRect = self.scrollView.frame

        frame.origin.x = frame.size.width * CGFloat(page);

        frame.origin.y = 0;

        self.scrollView.scrollRectToVisible(frame, animated: animated)
        if GLOBALsounds{
            somAVFlipPage?.play()
        }

    }

    func nextPage () {

        if pageControl.currentPage < pageControl.numberOfPages - 1 {
            pageControl.currentPage += 1
            scrollToPage(pageControl.currentPage, animated: true)
            enabeleButton()
        }
    }
    func prevPage () {
        if pageControl.currentPage > 0 {
            pageControl.currentPage -= 1
            scrollToPage(pageControl.currentPage, animated: true)
            enabeleButton()
        }
    }
    
    func back() {
        hideView()
        if GLOBALsounds{
            somAVBotao?.play()
        }
        (menu as! MenuScene).playBtn.userInteractionEnabled = true
    }
    
    func show() {
        showView()
        if GLOBALsounds{
            somAVFlipPage?.play()
        }
    }
    
    func showView() {
        
        self.hidden = false
        let startYposition = originYPos
        self.frame.origin.y = self.originYPos - (self.originYPos + self.frame.height)
        UIView.animateWithDuration(0.4,
            animations: {
                self.frame.origin.y = startYposition
                self.superview?.layoutIfNeeded()
            }
        )
        if GLOBALsounds{
            somAVFlipPage?.play()
        }
        
    }
    
    func hideView() {
        _ = self.frame.origin.y + self.frame.height
        UIView.animateWithDuration(0.4,
            animations: {
                self.frame.origin.y = self.originYPos - (self.originYPos + self.frame.height)
                self.superview?.layoutIfNeeded()
            }, completion: {
                (value: Bool) in
                self.hidden = true
            }
        )
    }
    
};