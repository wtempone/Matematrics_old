//
//  enterPause.swift
//  Matematrics
//
//  Created by William Tempone on 26/03/15.
//  Copyright (c) 2015 William Tempone. All rights reserved.
//

import Foundation
import SpriteKit

class MyView: SKView {
    var stayPaused = false as Bool

    override var paused: Bool {
        get {
            return super.paused
        }
        set {
            if (!stayPaused) {
                super.paused = newValue
            }
            stayPaused = false
        }
    }

    func setStayPaused() {
        self.stayPaused = true
    }
}