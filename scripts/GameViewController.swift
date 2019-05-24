//
//  GameViewController.swift
//  Breakout
//
//  Created by Training on 28/11/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import CoreData
import AVFoundation

var somAVBotao: AVAudioPlayer?
var somAVInicio: AVAudioPlayer?
var somAVFlipPage: AVAudioPlayer?
var somAVBackGround: AVAudioPlayer?

@available(iOS 8.0, *)
extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MenuScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}



@available(iOS 8.0, *)
class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
            // Configure the view.
            let skView = self.view as! SKView            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView
        
        if skView.scene == nil {
            //skView.showsPhysics = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            skView.showsQuadCount = true
            
            let menuScene = MenuScene(size: skView.bounds.size)
            menuScene.scaleMode = .AspectFill
            // load Sons AVFoundation
            do {
                somAVBotao = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(
                    NSBundle.mainBundle().pathForResource("botao",
                        ofType: "mp3")!))
                somAVInicio = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(
                    NSBundle.mainBundle().pathForResource("inicioNivel2",
                        ofType: "mp3")!))
                somAVFlipPage = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(
                    NSBundle.mainBundle().pathForResource("FlipPage",
                        ofType: "mp3")!))
                somAVBackGround = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(
                    NSBundle.mainBundle().pathForResource("MathTrics",
                        ofType: "mp3")!))
                
            } catch {
                print("Erro no carregamento do som")
            }

            skView.presentScene(menuScene)
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
