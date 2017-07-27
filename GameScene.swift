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
    
    let backgroundColor = Color<GLfloat>(hex: 0xE4C9A0)
    
    let atlas: SpriteAtlas
    let spriteFactory: SpriteFactory
    let levelManager: LevelManager
    var player: Sprite
    var camera = Camera()
    
    var lives = 3
    var reloadTimer: TimeInterval?
    
    let panGestureRecognizer: UIPanGestureRecognizer
    var isPaning = false
    
    private var isRunning: Bool {
        return isPaning || TouchController.instance.touches.count > 0
    }
    
    init(panGestureRecognizer: UIPanGestureRecognizer) {
        self.panGestureRecognizer = panGestureRecognizer

        if let atlas = SpriteAtlas(string: "私一二三四五六七八九十百千万年月火水木金土曜日本元気白黒西北南東国小大人子男女母父中長高出入時行見午先後前生間上下今学校円外来山話読語書名川水雨半電聞食車何毎天右左友休早", size: Int(spriteSize)) {
            self.atlas = atlas
            spriteFactory = SpriteFactory(capacity: 1024, spriteAtlas: atlas)
        } else {
            print("Atlas creation error")
            spriteFactory = SpriteFactory()
            atlas = SpriteAtlas()
        }
        
        camera.center(View.instance.width, height: View.instance.height)
        
        player = GameScene.playerSprite(spriteFactory: spriteFactory, panGestureRecognizer: panGestureRecognizer, cameraFrame: camera.frame)
        
        levelManager = LevelManager(level: Level.random(with: Kanji.jlptN5), spriteFactory: spriteFactory)
        levelManager.gameScene = self
        
        panGestureRecognizer.addTarget(self, action: #selector(GameScene.panGestureRecognized(by:)))
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
        let delta = isRunning ? timeSinceLastUpdate : 0
        
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
        spriteFactory.draw(at: camera.frame.topLeft)
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
        let player = spriteFactory.sprite(0, topLeft: Point(x: cameraFrame.width / 2 - spriteSize / 2, y: cameraFrame.height - spriteSize - 128))
        let playerMotion = PlayerMotion(panGestureRecognizer: panGestureRecognizer, spriteFactory: spriteFactory)
        player.motion = playerMotion
        playerMotion.load(player)
        return player
    }

}
