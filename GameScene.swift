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
    
    let panGestureRecognizer: UIPanGestureRecognizer
    var isPaning = false
    
    var zones = [TouchSensitiveZone]()
    
    private var isRunning: Bool {
        return isPaning || TouchController.instance.touches.count > 0
    }
    
    init(panGestureRecognizer: UIPanGestureRecognizer) {
        self.panGestureRecognizer = panGestureRecognizer

        var level = Level.random(with: Kanji.all)
        if let atlas = SpriteAtlas(level: &level) {
            self.atlas = atlas
            spriteFactory = TranslucentSpriteFactory(spriteAtlas: atlas, pools: ReferencePool.pools(capacities: [256, 256, 512, 256, 8]))
        } else {
            print("Atlas creation error")
            spriteFactory = TranslucentSpriteFactory()
            atlas = SpriteAtlas()
        }
        
        background = Background()
        
        camera.center(View.instance.width, height: View.instance.height)
        
        player = GameScene.playerSprite(spriteFactory: spriteFactory, panGestureRecognizer: panGestureRecognizer, cameraFrame: camera.frame)
        
        levelManager = LevelManager(level: level, spriteFactory: spriteFactory)
        levelManager.gameScene = self
        
        panGestureRecognizer.addTarget(self, action: #selector(GameScene.panGestureRecognized(by:)))
        
        var weapons = [Sprite]()
        
        let margin: GLfloat = 16
        let spacing = (View.instance.width - margin - margin) / GLfloat(level.weapons.count)
        for index in 0 ..< level.weapons.count {
            let weapon = spriteFactory.sprite(weaponSelectorDefinition)
            
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
            zone.selection = { _ in
                for weapon in weapons {
                    weapon.animation.frameIndex = 0
                }
                weapon.animation.frameIndex = 1
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
        player = GameScene.playerSprite(spriteFactory: spriteFactory, panGestureRecognizer: panGestureRecognizer, cameraFrame: camera.frame)
        (player.motion as! PlayerMotion).makeInvicible(sprite: player)
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
    
    @objc func panGestureRecognized(by sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            isPaning = true
        case .ended:
            isPaning = false
        default:
            break
        }
    }
    
    private static func playerSprite(spriteFactory: SpriteFactory, panGestureRecognizer: UIPanGestureRecognizer, cameraFrame: Rectangle<GLfloat>) -> Sprite {
        let player = spriteFactory.sprite(playerDefinition, topLeft: Point(x: cameraFrame.width / 2 - spriteSize / 2, y: cameraFrame.height - spriteSize - 128))
        let playerMotion = PlayerMotion(panGestureRecognizer: panGestureRecognizer, spriteFactory: spriteFactory)
        player.motion = playerMotion
        playerMotion.load(player)
        
        let playerShadow = spriteFactory.sprite(playerShadowDefinition)
        playerShadow.motion = ShadowMotion(reference: player)
        
        return player
    }

}
