//
//  GameViewController.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import UIKit
import Melisse

class GameViewController : MelisseViewController {
    
    var panOrigin = Point<GLfloat>()
    
    override func initialScene() -> Scene {
        return GameScene()
    }
    
    @IBAction func handlePan(from recognizer: UIPanGestureRecognizer) {
        guard let gameScene = GameScene.current else {
            return
        }
        
        let player = gameScene.player
        
        if recognizer.state == .began {
            panOrigin = player.frame.center
        }
        
        let translation = recognizer.translation(in: self.view)
        
        player.frame.center = Point(x: panOrigin.x + GLfloat(translation.x), y: panOrigin.y + GLfloat(translation.y))
    }
    
}
