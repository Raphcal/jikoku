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

let PlayerDiedNotification = Notification.Name(rawValue: "playerDiedNotification")

class GameScene : Scene {

    static var current: GameScene?
    
    let backgroundColor = Color<GLfloat>(hex: 0xF4D6B2)
    
    let atlas: SpriteAtlas
    let spriteFactory: TranslucentSpriteFactory
    let plane = Plane(capacity: 8)
    let background: Background
    let levelManager: LevelManager
    var player: Sprite
    var camera = Camera()
    
    var lives = 3
    var reloadTimer: TimeInterval?
    
    var zones = [TouchSensitiveZone]()
    var currentShootingStyle: ShootingStyleDefinition
    
    private var isRunning: Bool {
        return TouchController.instance.touches.count > 0
    }
    
    init() {
        var level = Level.random(with: Kanji.all)
        if let atlas = SpriteAtlas(level: &level) {
            self.atlas = atlas
            self.spriteFactory = TranslucentSpriteFactory(spriteAtlas: atlas, pools: ReferencePool.pools(capacities: [256, 256, 512, 256, 8]))
        } else {
            print("Atlas creation error")
            self.spriteFactory = TranslucentSpriteFactory()
            self.atlas = SpriteAtlas()
        }
        
        self.background = Background()
        
        self.camera.center(View.instance.width, height: View.instance.height)
        
        self.player = GameScene.playerSprite(spriteFactory: spriteFactory, cameraFrame: camera.frame)
        
        let weaponDefinitions: [ShootingStyleDefinition] = [
            StraightShootingStyleDefinition(
                shotAmount: 2,
                shotSpeed: 500,
                shootInterval: 0.1,
                spriteDefinition: playerShotDefinition,
                space: 32),
            CircularShootingStyleDefinition(
                shotAmount: 4,
                shotSpeed: 500,
                shootInterval: 0.1,
                spriteDefinition: playerShotDefinition,
                baseAngle: -3 * .pi / 24,
                angleIncrement: .pi / 12
            ),
            StraightShootingStyleDefinition(
                shotAmount: 1,
                shotSpeed: 250,
                shootInterval: 0.05,
                spriteDefinition: playerShotDefinition,
                space: 32),
            AimedShootingStyleDefinition(
                shotAmount: 4,
                shotSpeed: 500,
                shootInterval: 0.1,
                spriteDefinition: playerShotDefinition,
                targetType: .enemy
            ),
            CircularShootingStyleDefinition(
                shotAmount: 4,
                shotSpeed: 500,
                shootInterval: 0.05,
                inversions: [.angle],
                inversionInterval: 8,
                spriteDefinition: playerShotDefinition,
                baseAngle: -.pi / 4,
                baseAngleVariation: .pi / 24
            ),
            ]
        self.currentShootingStyle = weaponDefinitions[0]
        
        self.levelManager = LevelManager(level: level, spriteFactory: spriteFactory)
        self.levelManager.gameScene = self
        
        var weapons = [Sprite]()
        
        let margin: GLfloat = 16
        let spacing = (View.instance.width - margin - margin) / GLfloat(level.weapons.count)
        for index in 0 ..< level.weapons.count {
            let weapon = self.spriteFactory.sprite(weaponSelectorDefinition)
            
            weapon.animation = weapon.definition.animations[index.description]!.toAnimation()
            if index == 0 {
                weapon.animation.frameIndex = 1
            }
            
            var frame = weapon.frame
            frame.left = margin + 26 + spacing * GLfloat(index)
            frame.bottom = camera.frame.height - margin - 26
            frame.size = weapon.animation.frame.size
            weapon.frame = frame
            
            weapons.append(weapon)
            
            let zone = TouchSensitiveZone(hasFrame: weapon, touches: TouchController.instance.touches)
            zone.selection = { [unowned self] _ in
                for weapon in weapons {
                    weapon.animation.frameIndex = 0
                }
                weapon.animation.frameIndex = 1
                
                self.currentShootingStyle = weaponDefinitions[index]
                
                let playerMotion = self.player.motion as! PlayerMotion
                playerMotion.shootingStyles = [weaponDefinitions[index].shootingStyle(spriteFactory: self.spriteFactory)]
            }
            zones.append(zone)
        }
        
    }
    
    func load() {
        GameScene.current = self

        NotificationCenter.default.addObserver(forName: PlayerDiedNotification, object: nil, queue: nil) { _ in
            self.lives -= 1
            self.reloadTimer = 1
        }
    }
    
    func reload() {
        player = GameScene.playerSprite(spriteFactory: spriteFactory, cameraFrame: camera.frame)
        let playerMotion = player.motion as! PlayerMotion
        playerMotion.makeInvicible(sprite: player)
        playerMotion.shootingStyles = [currentShootingStyle.shootingStyle(spriteFactory: self.spriteFactory)]
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        let delta = isRunning ? timeSinceLastUpdate : timeSinceLastUpdate / 20
        
        for zone in zones {
            zone.update(with: TouchController.instance.touches)
        }
        
        background.update(timeSinceLastUpdate: delta)
        levelManager.update(with: delta)
        spriteFactory.updateWith(delta)
        
        if var reloadTimer = reloadTimer {
            reloadTimer -= timeSinceLastUpdate
            if reloadTimer <= 0 {
                self.reloadTimer = nil
                Director.instance!.restart()
            } else {
                self.reloadTimer = reloadTimer
            }
        }
    }
    
    func draw() {
        background.draw()
        spriteFactory.draw(at: camera.frame.topLeft)
        plane.draw()
    }
    
    private static func playerSprite(spriteFactory: SpriteFactory, cameraFrame: Rectangle<GLfloat>) -> Sprite {
        let player = spriteFactory.sprite(playerDefinition, topLeft: Point(x: cameraFrame.width / 2 - spriteSize / 2, y: cameraFrame.height - spriteSize - 128))
        let playerMotion = PlayerMotion(spriteFactory: spriteFactory)
        player.motion = playerMotion
        playerMotion.load(player)
        
        let playerShadow = spriteFactory.sprite(playerShadowDefinition)
        playerShadow.motion = ShadowMotion(reference: player)
        
        return player
    }

}
