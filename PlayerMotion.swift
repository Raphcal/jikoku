//
//  PlayerMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 21/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import UIKit

fileprivate let maxSpeed: GLfloat = 500

class PlayerMotion : Motion {
    
    let panGestureRecognizer: UIPanGestureRecognizer
    let view: UIView?
    
    var oldTranslation = Point<GLfloat>()
    var translation = Point<GLfloat>()
    
    init(panGestureRecognizer: UIPanGestureRecognizer) {
        self.panGestureRecognizer = panGestureRecognizer
        self.view = Director.instance?.viewController?.view
        
        panGestureRecognizer.addTarget(self, action: #selector(PlayerMotion.panGestureRecognized(by:)))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        var move = translation - oldTranslation
        oldTranslation = translation
        
        let delta = GLfloat(timeSinceLastUpdate)
        move.x = move.x == 0 ? 0 : move.x / abs(move.x) * min(abs(move.x), delta * maxSpeed)
        move.y = move.y == 0 ? 0 : move.y / abs(move.y) * min(abs(move.y), delta * maxSpeed)
        
        sprite.frame.center += move
    }
    
    @objc func panGestureRecognized(by sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            oldTranslation = Point()
        }
        let translation = sender.translation(in: self.view)
        self.translation = Point(x: GLfloat(translation.x), y: GLfloat(translation.y))
    }
    
}
