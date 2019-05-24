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
class Tutorial: UIView, UIScrollViewDelegate {
    
    var originYPos: CGFloat = CGFloat()
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
    let imagesPage: [UIImage] = [
        UIImage(named: "tutorial0")!,
        UIImage(named: "tutorial1")!,
        UIImage(named: "tutorial2")!,
        UIImage(named: "tutorial3")!,
        UIImage(named: "tutorial4")!,
        UIImage(named: "tutorial5")!,
        UIImage(named: "tutorial6")!,
    ]
    
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
        
        
        
        
        // add ribon
        
        let ribonImage = UIImage(named: "ribbonTutorial")
        
        let ribon = UIImageView(image: ribonImage)
        
        let ribbonWidth = panelframe.width * 0.6
        
        let ribbonHeigth = ribon.frame.height * (ribbonWidth / ribon.frame.size.width)
        
        ribon.frame = CGRect(x: ((self.frame.width - ribbonWidth) / 2), y: panelframe.origin.y - ( ribbonHeigth * 0.4) ,
            
            width: ribbonWidth, height: ribbonHeigth)
        
        self.addSubview(ribon)
        
        let scrollframe = CGRect(x: (self.frame.width - self.frame.width * 0.8) / 2 , y: (self.frame.height - self.frame.height * 0.8) / 2, width: self.frame.width * 0.8, height: self.frame.height * 0.8)
        
        buttonsGap = (scrollframe.width - (GLOBALbuttonSize.height * buttonsPerPage)) / (buttonsPerPage + 1)
        
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
            
            x: ((self.frame.width / 2) - (GLOBALbuttonSize.height * 1.25)),
            
            y: (panelframe.origin.y + panelframe.height) - (GLOBALbuttonSize.height * 0.5) ,
            
            width: GLOBALbuttonSize.width,
            
            height: GLOBALbuttonSize.height
            
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
            
            x: ((self.frame.width / 2) - (GLOBALbuttonSize.height * 1.25)),
            
            y: self.frame.height - (GLOBALbuttonSize.height * 1.25) ,
            
            width: GLOBALbuttonSize.height,
            
            height: GLOBALbuttonSize.height)
        
        buttonShop.imageView?.frame = buttonShop.frame
        
        buttonShop.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        
        buttonShop.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        
        //self.addSubview(buttonShop)
        
        originYPos = self.frame.origin.y
        
        //botao bsck
        
        
        
        //botao shop
        
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
    
        
        self.reloadPages()
        
    }
    
    func reloadPages() {
        
        let contentsize = self.scrollView.frame.width * CGFloat(imagesPage.count)
        pageControl.numberOfPages = imagesPage.count
        self.scrollView.contentSize = CGSize(width: contentsize , height: self.scrollView.frame.height)
        
        for view in self.scrollView.subviews {
            
            view.removeFromSuperview()
            
        }
  
        for ind in 0...imagesPage.count - 1 {
            
            
            let frameview = CGRect(x: self.scrollView.frame.width *  CGFloat(ind), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            let pageview = UIView()
            
            pageview.frame = frameview
            let myImage = imagesPage[ind]
            let imageview = UIImageView()
            let scrollframe = CGRect(x: 0 , y: 0, width: self.frame.width * 0.8, height: self.frame.height * 0.8)
            let imageHeight = scrollframe.height
            let imagewidth = myImage.size.width *  scrollframe.height / myImage.size.height
            imageview.frame = CGRect(x: (scrollframe.width / 2) - (imagewidth / 2) , y: 0, width: imagewidth, height: imageHeight)
                
            imageview.image = myImage
            pageview.addSubview(imageview)
            self.bringSubviewToFront(scrollView)
            
            self.scrollView.addSubview(pageview)
            
            self.scrollView.bringSubviewToFront(pageview)
            self.scrollView.bringSubviewToFront(imageview)
            
        }
        
        self.bringSubviewToFront(buttonLeft)
        
        self.bringSubviewToFront(buttonRight)
        
        enabeleButton()
        
        originYPos = self.frame.origin.y
        self.bringSubviewToFront(pageControl)
 
        
        
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
        if GLOBALsounds {
            self.menu.runAction(somFlipPage)
        }
        enabeleButton()
        
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        
        var frame: CGRect = self.scrollView.frame
        
        frame.origin.x = frame.size.width * CGFloat(page);
        
        frame.origin.y = 0;
        
        self.scrollView.scrollRectToVisible(frame, animated: animated)
        
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        
    }
    
    func nextPage () {
        
        print(" \(pageControl.currentPage) < \(pageControl.numberOfPages - 1)" )
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
        if GLOBALsounds {
            somAVBotao?.play()
        }
            (menu as! MenuScene).playBtn.userInteractionEnabled = true
            (menu as! MenuScene).helpBtn.userInteractionEnabled = true
            (menu as! MenuScene).settingsBtn.userInteractionEnabled = true
        
        hideView()
    }
    
    func show() {
        if GLOBALsounds {
            somAVFlipPage?.play()
        }
        showView()
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
        if GLOBALsounds {
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