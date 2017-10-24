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
                self.atlas = SpriteAtlas(definitions: [
                    SpriteDefinition(index: 0, rectangle: Rectangle(x: 0, y: 320, width: 320, height: 240), distance: .shadow),
                    SpriteDefinition(index: 1, rectangle: Rectangle(x: 0, y: 560, width: 320, height: 240), distance: .shadow),
                    SpriteDefinition(index: 2, rectangle: Rectangle(x: 0, y: 0, width: 320, height: 320)),
                    SpriteDefinition(index: 3, rectangle: Rectangle(x: 0, y: 800, width: 320, height: 160)),
                    SpriteDefinition(index: 4, rectangle: Rectangle(x: 320, y: 0, width: 320, height: 640)),
                    SpriteDefinition(index: 5, rectangle: Rectangle(x: 320, y: 640, width: 320, height: 224))
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
