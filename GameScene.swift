//
//  GameScene.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

fileprivate let spriteSize: GLfloat = 48

class GameScene : Scene {

    let backgroundColor = Color<GLfloat>(hex: 0xE4C9A0)
    
    let spriteFactory: SpriteFactory
    let player: Sprite
    var camera: Camera
    
    init() {
        if let atlas = SpriteAtlas(string: "私一二三四五六七八九十日本元気白", size: Int(spriteSize)) {
            spriteFactory = SpriteFactory(capacity: 1024, spriteAtlas: atlas)
        } else {
            print("Atlas creation error")
            spriteFactory = SpriteFactory()
        }
        
        let screenBounds = UIScreen.main.bounds
        
        camera = Camera()
        camera.center(GLfloat(screenBounds.width), height: GLfloat(screenBounds.height))
        
        player = spriteFactory.sprite(0, topLeft: Point(x: camera.frame.width / 2 - spriteSize, y: camera.frame.height - spriteSize - 128))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        spriteFactory.updateWith(timeSinceLastUpdate)
    }
    
    func draw() {
        spriteFactory.draw(at: camera.frame.topLeft)
    }

}
