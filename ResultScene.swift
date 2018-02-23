//
//  ResultScene.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 24/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

class ResultScene : Scene {
    
    var backgroundColor: Color<GLfloat> = .white

    let restartZone: TouchSensitiveZone
    let plane: Plane
    
    init() {
        let rectangle = Rectangle<GLfloat>(left: 10, top: 10, width: 120, height: 60)
        restartZone = TouchSensitiveZone(frame: rectangle, touches: TouchController.instance.touches)
        
        plane = Plane(capacity: 1)
        var quad = plane.coloredQuadrilateral()
        quad.quadrilateral = Quadrilateral(rectangle: rectangle)
        quad.color = Color.green
    }
    
    func load() {
        restartZone.selection = restart
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        restartZone.update(with: TouchController.instance.touches)
    }
    
    func draw() {
        plane.draw()
    }
    
    func restart(_ sender: TouchSensitiveZone) {
        Director.instance!.nextScene = GameScene()
    }
    
}
