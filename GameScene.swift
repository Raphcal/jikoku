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

    static var current: GameScene?
    
    let backgroundColor = Color<GLfloat>(hex: 0xE4C9A0)
    
    let atlas: SpriteAtlas
    let spriteFactory: SpriteFactory
    let player: Sprite
    var camera: Camera
    
    /// Test de tir
    let style1: ShootingStyle
    
    init(panGestureRecognizer: UIPanGestureRecognizer) {
        if let atlas = SpriteAtlas(string: "私一二三四五六七八九十日本元気白", size: Int(spriteSize)) {
            self.atlas = atlas
            spriteFactory = SpriteFactory(capacity: 1024, spriteAtlas: atlas)
        } else {
            print("Atlas creation error")
            spriteFactory = SpriteFactory()
            atlas = SpriteAtlas()
        }
        
        let screenBounds = UIScreen.main.bounds
        
        camera = Camera()
        camera.center(GLfloat(screenBounds.width), height: GLfloat(screenBounds.height))
        
        player = spriteFactory.sprite(0, topLeft: Point(x: camera.frame.width / 2 - spriteSize, y: camera.frame.height - spriteSize - 128))
        player.setAnimation(DefaultAnimationName.normal, force: true)
        player.motion = PlayerMotion(panGestureRecognizer: panGestureRecognizer)
        
        _ = spriteFactory.sprite(1, topLeft: Point(x: 64, y: 96))
        _ = spriteFactory.sprite(2, topLeft: Point(x: 256, y: 128))
        
        style1 = StraightShootingStyle(definition: StraightShootingStyleDefinition(
            shotAmount: 2,
            shotAmountVariation: 0,
            shotSpeed: 500,
            shootInterval: 0.1,
            baseAngle: toRadian(-90),
            inversions: [],
            inversionInterval: 0,
            spriteDefinition: 5,
            space: 32), spriteFactory: spriteFactory)
    }
    
    func load() {
        GameScene.current = self
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        spriteFactory.updateWith(timeSinceLastUpdate)
        style1.shoot(from: player, origin: .up, since: timeSinceLastUpdate)
    }
    
    func draw() {
        spriteFactory.draw(at: camera.frame.topLeft)
    }

}
