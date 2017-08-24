//
//  ExplosiveFade.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 24/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

protocol Exploding {
    var explosionCenter: Point<GLfloat> { get }
}

class ExplosiveFade : Fade {
    
    var backgroundColor = Color<GLfloat>.black
    
    var progress: GLfloat = 0
    var previousScene: Scene = EmptyScene()
    var nextScene: Scene = EmptyScene()
    
    let plane = Plane(capacity: 1)
    var mask: ColoredQuadrilateral
    
    var time: TimeInterval = 0
    
    var explosionCenter: Point<GLfloat>
    var maximumSize = Size<GLfloat>()
    
    var rotation: GLfloat {
        return progress * .pi * 2
    }
    var size: Size<GLfloat> {
        return maximumSize * progress
    }
    
    init() {
        mask = plane.coloredQuadrilateral()
        explosionCenter = Point(x: View.instance.width / 2, y: View.instance.height / 2)
    }
    
    func load() {
        backgroundColor = previousScene.backgroundColor
        
        let color = nextScene.backgroundColor
        mask.color = Color(red: GLubyte(color.red * 255), green: GLubyte(color.green * 255), blue: GLubyte(color.blue * 255), alpha: GLubyte(color.alpha * 255))
        
        if let explosionCenter = (previousScene as? Exploding)?.explosionCenter {
            self.explosionCenter = explosionCenter
        }

        let maxWidth = max(View.instance.width - explosionCenter.x, explosionCenter.x) * 2
        let maxHeight = max(View.instance.height - explosionCenter.y, explosionCenter.y) * 2
        
        maximumSize = Size(size: max(maxWidth, maxHeight))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        time += timeSinceLastUpdate
        progress = smoothStep(0, to: 1.5, value: time)
        
        mask.quadrilateral = Rectangle(center: explosionCenter, size: size).rotate(rotation, withPivot: explosionCenter)
        
        if progress == 1 {
            Director.instance!.nextScene = nextScene
        }
    }
    
    func draw() {
        previousScene.draw()
        plane.draw()
    }
    
}
