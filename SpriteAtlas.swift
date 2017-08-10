//
//  SpriteAtlas.swift
//  Yamato
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

extension SpriteAtlas {
    
    convenience init?(level: inout Level) {
        let player = SpriteBlueprint(
            shape: .triangular,
            shapePaint: Color<GLfloat>.black,
            text: "私",
            textColor: .white,
            size: Size(width: 48, height: 48))
        let playerShots = SpriteBlueprint(
            shape: .diamond,
            shapePaint: Color<GLfloat>(red: 0.7, green: 0.5, blue: 0, alpha: 1),
            size: Size(width: 16, height: 24))
        
        var blueprints = [player, playerShots]
        var groups = [Group : (sprite: SpriteBlueprint, shot: SpriteBlueprint)]()
        
        for wave in level.waves {
            for group in wave.groups {
                let groupBlueprints = [
                    // Sprite
                    SpriteBlueprint(
                        shape: group.shape,
                        shapePaint: Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 1),
                        text: String(group.kanji.character),
                        textColor: .white,
                        size: Size(width: group.size.pixelSize, height: group.size.pixelSize)),
                    // Tir
                    SpriteBlueprint(
                        shape: .round,
                        shapePaint: Color<GLfloat>.white,
                        size: Size(width: 16, height: 16))
                ]
                groups[group] = (sprite: groupBlueprints[0], shot: groupBlueprints[1])
                blueprints.append(contentsOf: groupBlueprints)
            }
        }
        
        let hiraganas = stride(from: "あ".utf16.first!, to: "ゟ".utf16.first! + 1, by: 1).map { (hiragana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(hiragana)!)
            return SpriteBlueprint(text: String(character), textColor: .black, size: Size(width: 32, height: 32))
        }
        blueprints.append(contentsOf: hiraganas)
        
        let katakanas = stride(from: "ア".utf16.first!, to: "ヿ".utf16.first! + 1, by: 1).map { (katakana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(katakana)!)
            return SpriteBlueprint(text: String(character), textColor: .black, size: Size(width: 32, height: 32))
        }
        blueprints.append(contentsOf: katakanas)
        
        let packMap = PackMap<SpriteBlueprint>()
        packMap.add(contentsOf: blueprints)
        
        var definitions: [SpriteDefinition] = [
            playerDefinition(blueprint: player, packMap: packMap),
            shotDefinition(index: 1, isFriendly: true, blueprint: playerShots, packMap: packMap),
            font(hiraganas: hiraganas, katakanas: katakanas, packMap: packMap)
        ]
        
        for i in 0 ..< level.waves.count {
            var wave = level.waves[i]
            for j in 0 ..< wave.groups.count {
                var group = wave.groups[j]
                let blueprints = groups[group]!
                
                var sprite = SpriteDefinition()
                sprite.index = definitions.count
                sprite.name = String(group.kanji.character)
                sprite.type = SpriteType.enemy
                sprite.distance = .behind
                sprite.animations = [
                    DefaultAnimationName.normal.name: AnimationDefinition(blueprint: blueprints.sprite, packMap: packMap)
                ]
                definitions.append(sprite)
                group.spriteDefinition = sprite.index
                
                if var shootingStyleDefinition = group.shootingStyleDefinition {
                    var shot = sprite
                    shot.index += 1
                    shot.type = SpriteType.enemyShot
                    shot.animations = [
                        DefaultAnimationName.normal.name: AnimationDefinition(blueprint: blueprints.shot, packMap: packMap)
                    ]
                    definitions.append(shot)
                    shootingStyleDefinition.spriteDefinition = shot.index
                    group.shootingStyleDefinition = shootingStyleDefinition
                }
                wave.groups[j] = group
            }
            level.waves[i] = wave
        }
        
        do {
            self.init(definitions: definitions, texture: try GLKTextureLoader.texture(with: packMap))
        } catch {
            print("Texture creation error : \(error)")
            return nil
        }
    }

}

extension AnimationFrame {
    init(blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) {
        let scale = Int(UIScreen.main.scale)
        self.init(frame: Rectangle(center: packMap.locations[blueprint]! * scale, size: blueprint.packSize * scale), size: blueprint.size)
    }
}

extension AnimationDefinition {
    init(blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) {
        self.init(frames: [AnimationFrame(blueprint: blueprint, packMap: packMap)])
    }
}

fileprivate func playerDefinition(blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) -> SpriteDefinition {
    var definition = SpriteDefinition()
    definition.index = 0
    definition.name = "player"
    definition.type = SpriteType.player
    definition.distance = .middle
    definition.animations = [
        DefaultAnimationName.normal.name: AnimationDefinition(blueprint: blueprint, packMap: packMap)
    ]
    return definition
}

fileprivate func shotDefinition(index: Int, isFriendly: Bool, blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) -> SpriteDefinition {
    var definition = SpriteDefinition()
    definition.index = index
    definition.name = "shot"
    definition.type = isFriendly ? SpriteType.friendlyShot : SpriteType.enemyShot
    definition.distance = .behind
    definition.animations = [
        DefaultAnimationName.normal.name: AnimationDefinition(blueprint: blueprint, packMap: packMap)
    ]
    return definition
}

fileprivate func font(hiraganas: [SpriteBlueprint], katakanas: [SpriteBlueprint], packMap: PackMap<SpriteBlueprint>) -> SpriteDefinition {
    var definition = SpriteDefinition()
    definition.type = SpriteType.decoration
    definition.distance = .behind
    definition.animations = [
        KanaFontAnimationName.hiragana.name: AnimationDefinition(frames: hiraganas.map {
            AnimationFrame(blueprint: $0, packMap: packMap)
        }),
        KanaFontAnimationName.katakana.name: AnimationDefinition(frames: katakanas.map {
            AnimationFrame(blueprint: $0, packMap: packMap)
        })
    ]
    return definition
}
