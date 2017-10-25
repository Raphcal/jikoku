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
    
    var definitions: [Int] = []
    
    init() {
        self.camera = Camera()
        camera.center(View.instance.width, height: View.instance.height)
        
        do {
            #if os(iOS)
                let cgImage = UIImage(named: "Texture")?.cgImage
            #elseif os(macOS)
                let cgImage = NSImage(named: NSImage.Name("Texture"))?.cgImage(forProposedRect: nil, context: nil, hints: nil)
            #endif
            
            if let cgImage = cgImage {
                let texture = try GLKTextureLoader.texture(with: cgImage, options: nil)
                let size640 = cgImage.width
                let size800 = size640 * (800 / 640)
                let size560 = size640 * (560 / 640)
                let size320 = size640 / 2
                let size240 = size640 * (240 / 640)
                let size224 = size640 * (224 / 640)
                let size160 = size640 * (160 / 640)
                
                self.atlas = SpriteAtlas(definitions: [
                    SpriteDefinition(index: 0, rectangle: Rectangle(x: 0, y: size320, width: size320, height: size240), distance: .shadow),
                    SpriteDefinition(index: 1, rectangle: Rectangle(x: 0, y: size560, width: size320, height: size240), distance: .shadow),
                    SpriteDefinition(index: 2, rectangle: Rectangle(x: 0, y: 0, width: size320, height: size320)),
                    SpriteDefinition(index: 3, rectangle: Rectangle(x: 0, y: size800, width: size320, height: size160)),
                    SpriteDefinition(index: 4, rectangle: Rectangle(x: size320, y: 0, width: size320, height: size640)),
                    SpriteDefinition(index: 5, rectangle: Rectangle(x: size320, y: size640, width: size320, height: size224))
                    ], texture: texture)
                self.factory = SpriteFactory(spriteAtlas: atlas, pools: ReferencePool.pools(capacities: [16, 16]))
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
        
        nextBackgroundElement(margin: 0)
        nextCloud(margin: -View.instance.height / 2)
    }
    
    func update(timeSinceLastUpdate: TimeInterval) {
        camera.frame.y -= speed * GLfloat(timeSinceLastUpdate)
        factory.updateWith(timeSinceLastUpdate)
    }
    
    func draw() {
        factory.draw(at: camera.frame.topLeft)
    }
    
    func nextBackgroundElement(margin: GLfloat) {
        if definitions.isEmpty {
            definitions = [2, 3, 4, 5]
        }
        
        let sprite = factory.sprite(definitions.removeAtRandom())
        sprite.motion = BackgroundMotion(background: self)
        
        var frame = sprite.frame
        frame.bottom = camera.frame.top - margin
        frame.left = 0
        sprite.frame = frame
    }
    
    func nextCloud(margin: GLfloat) {
        let sprite = factory.sprite(random(2))
        sprite.motion = CloudMotion(background: self)
        
        var frame = sprite.frame
        frame.bottom = camera.frame.top - margin
        frame.left = 0
        sprite.frame = frame
    }
}

fileprivate struct BackgroundMotion : Motion {
    
    let background: Background
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        if sprite.objects["hasNext"] == nil && sprite.frame.top > background.camera.frame.top {
            background.nextBackgroundElement(margin: random(from: 32, to: 64))
            sprite.objects["hasNext"] = true
        }
        else if sprite.frame.top > background.camera.frame.bottom {
            sprite.destroy()
        }
    }
    
}

fileprivate struct CloudMotion : Motion {
    
    let background: Background
    let parallax = GLfloat(0.5)
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        sprite.frame.y -= background.speed * parallax * GLfloat(timeSinceLastUpdate)
        
        if sprite.objects["hasNext"] == nil && sprite.frame.top > background.camera.frame.top {
            background.nextCloud(margin: random(from: View.instance.height / 2, to: View.instance.height * 2))
            sprite.objects["hasNext"] = true
        }
        else if sprite.frame.top > background.camera.frame.bottom {
            sprite.destroy()
        }
    }
    
}

extension SpriteDefinition {
    init(index: Int, rectangle: Rectangle<Int>, distance: Distance = .ground) {
        let scale = Int(UIScreen.main.scale)
        
        self.index = index
        self.name = nil
        self.type = SpriteType.decoration
        self.distance = distance
        self.animations = [
            DefaultAnimationName.normal.name: AnimationDefinition(frames: [
                AnimationFrame(frame: rectangle * scale, size: Size(width: GLfloat(rectangle.size.width), height: GLfloat(rectangle.size.height)))
                ], looping: false)
        ]
        self.motionName = nil
    }
}
