//
//  Background.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 23/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class Background {
    
    let atlas: SpriteAtlas
    let factory: SpriteFactory
    
    var camera: Camera
    var speed: GLfloat = 100
    
    init() {
        self.camera = Camera()
        camera.center(View.instance.width, height: View.instance.height)
        
        do {
            if let image = UIImage(named: "Texture") {
                let texture = try GLKTextureLoader.texture(with: image.cgImage!, options: nil)
                self.atlas = SpriteAtlas(definitions: [
                    SpriteDefinition(index: 0, rectangle: Rectangle(x: 0, y: 0, width: 320, height: 320)),
                    SpriteDefinition(index: 1, rectangle: Rectangle(x: 0, y: 320, width: 320, height: 480)),
                    SpriteDefinition(index: 2, rectangle: Rectangle(x: 0, y: 800, width: 320, height: 160)),
                    SpriteDefinition(index: 3, rectangle: Rectangle(x: 320, y: 0, width: 320, height: 640)),
                    SpriteDefinition(index: 4, rectangle: Rectangle(x: 320, y: 640, width: 320, height: 224))
                    ], texture: texture)
                self.factory = SpriteFactory(spriteAtlas: atlas, pools: ReferencePool.pools(capacities: [16]))
            } else {
                print("Texture non trouvée")
                self.atlas = SpriteAtlas()
                self.factory = SpriteFactory()
            }
        } catch {
            print("Erreur de chargement de la texture OpenGL")
            self.atlas = SpriteAtlas()
            self.factory = SpriteFactory()
        }
        
        _ = factory.sprite(0, topLeft: Point(x: 0, y: 0))
        _ = factory.sprite(1, topLeft: Point(x: 0, y: -160))
        _ = factory.sprite(2, topLeft: Point(x: 0, y: -1024))
        _ = factory.sprite(3, topLeft: Point(x: 0, y: -1800))
        _ = factory.sprite(4, topLeft: Point(x: 0, y: -2024))
    }
    
    func update(timeSinceLastUpdate: TimeInterval) {
        camera.frame.y -= speed * GLfloat(timeSinceLastUpdate)
        factory.updateWith(timeSinceLastUpdate)
    }
    
    func draw() {
        factory.draw(at: camera.frame.topLeft)
    }
}

extension SpriteDefinition {
    init(index: Int, rectangle: Rectangle<Int>) {
        let scale = Int(UIScreen.main.scale)
        
        self.index = index
        self.name = nil
        self.type = SpriteType.decoration
        self.distance = Distance.ground
        self.animations = [
            DefaultAnimationName.normal.name: AnimationDefinition(frames: [
                AnimationFrame(frame: rectangle * scale, size: Size(width: GLfloat(rectangle.size.width), height: GLfloat(rectangle.size.height)))
                ], looping: false)
        ]
        self.motionName = nil
    }
}
