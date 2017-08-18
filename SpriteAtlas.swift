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

let playerDefinition = 0
let playerShadowDefinition = 1
let playerShotDefinition = 2
let fontDefinition = 3

extension SpriteAtlas {
    
    convenience init?(level: inout Level) {
        let hiraginoW3Font = UIFont(name: "HiraginoSans-W3", size: 10)
        let hiraginoW6Font = UIFont(name: "HiraginoSans-W6", size: 10)
        
        let player = SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .triangular, paint: Color<GLfloat>.black),
            PaintedShape(shape: TextShape(text: "私", font: hiraginoW3Font), paint: Color<GLfloat>.white, rectangle: Rectangle(x: 0, y: 20, width: 48, height: 24)),
            PaintedShape(shape: .round, paint: Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 0.5), rectangle: Rectangle(x: 20, y: 20, width: 8, height: 8))],
            size: Size(width: 48, height: 48))
        let playerShots = SpriteBlueprint(paintedShapes: [PaintedShape(shape: .diamond, paint: RadialGradient(innerColor: .white, outerColor: Color(red: 0, green: 0.88, blue:1, alpha: 1)))],
            size: Size(width: 16, height: 24))
        
        var blueprints = [player, player.shadow, playerShots]
        var groups = [Group : (sprite: SpriteBlueprint, shot: SpriteBlueprint)]()
        
        
        let red = Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 1)
        
        for wave in level.waves {
            for group in wave.groups {
                var groupBlueprints = [SpriteBlueprint]()
                
                let textSize = group.size.pixelSize * 2 / 3
                
                // Sprite
                let sprite = SpriteBlueprint(paintedShapes: [
                    PaintedShape(shape: group.shape, paint: red),
                    PaintedShape(shape: TextShape(text: String(group.kanji.character), font: hiraginoW3Font), paint: Color<GLfloat>.white, rectangle: Rectangle(x: (group.size.pixelSize - textSize) / 2, y: (group.size.pixelSize - textSize) / 2, width: textSize, height: textSize))], size: Size(width: group.size.pixelSize, height: group.size.pixelSize))
                groupBlueprints.append(sprite)
                
                // Ombre
                if group.isFlying {
                    groupBlueprints.append(sprite.shadow)
                }
                
                // Tir
                groupBlueprints.append(SpriteBlueprint(paintedShapes: [PaintedShape(shape: .round, paint: RadialGradient(innerColor: .white, outerColor: Color(red: 0.98, green: 0, blue: 1, alpha: 1)))],
                    size: Size(width: 16, height: 16)))
                groups[group] = (sprite: sprite, shot: groupBlueprints.last!)
                blueprints.append(contentsOf: groupBlueprints)
            }
        }
        
        let hiraganas = stride(from: "あ".utf16.first!, to: "ゟ".utf16.first! + 1, by: 1).map { (hiragana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(hiragana)!)
            return SpriteBlueprint(paintedShapes: [PaintedShape(shape: TextShape(text: String(character), font: hiraginoW6Font), paint: EmbossPaint(color: Color(hex: 0x7ED321)))], size: Size(width: 24, height: 24))
        }
        blueprints.append(contentsOf: hiraganas)
        
        let katakanas = stride(from: "ア".utf16.first!, to: "ヿ".utf16.first! + 1, by: 1).map { (katakana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(katakana)!)
            return SpriteBlueprint(paintedShapes: [PaintedShape(shape: TextShape(text: String(character), font: hiraginoW6Font), paint: EmbossPaint(color: Color(hex: 0xF382D9)))], size: Size(width: 24, height: 24))
        }
        blueprints.append(contentsOf: katakanas)
        
        let packMap = PackMap<SpriteBlueprint>()
        packMap.add(contentsOf: blueprints)
        
        var definitions: [SpriteDefinition] = [
            SpriteDefinition(index: playerDefinition, type: .player, distance: .middle, blueprint: player, packMap: packMap),
            SpriteDefinition(index: playerShadowDefinition, blueprint: player.shadow, packMap: packMap),
            SpriteDefinition(index: playerShotDefinition, type: .friendlyShot, blueprint: playerShots, packMap: packMap),
            font(hiraganas: hiraganas, katakanas: katakanas, packMap: packMap)
        ]
        
        for i in 0 ..< level.waves.count {
            var wave = level.waves[i]
            for j in 0 ..< wave.groups.count {
                var group = wave.groups[j]
                let blueprints = groups[group]!
                
                group.spriteDefinition = definitions.count
                definitions.append(SpriteDefinition(index: definitions.count, type: .enemy, distance: .middle, blueprint: blueprints.sprite, packMap: packMap))
                
                if group.isFlying {
                    group.shadowDefinition = definitions.count
                    definitions.append(SpriteDefinition(index: definitions.count, blueprint: blueprints.sprite.shadow, packMap: packMap))
                }
                
                if var shootingStyleDefinition = group.shootingStyleDefinition {
                    shootingStyleDefinition.spriteDefinition = definitions.count
                    definitions.append(SpriteDefinition(index: definitions.count, type: .enemyShot, blueprint: blueprints.shot, packMap: packMap))
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

extension SpriteDefinition {
    init(index: Int, type: SpriteType = SpriteType.decoration, distance: Distance = .behind, blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) {
        self.index = index
        self.name = nil
        self.type = type
        self.distance = distance
        self.animations = [
            DefaultAnimationName.normal.name: AnimationDefinition(blueprint: blueprint, packMap: packMap)
        ]
        self.motionName = nil
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

fileprivate func font(hiraganas: [SpriteBlueprint], katakanas: [SpriteBlueprint], packMap: PackMap<SpriteBlueprint>) -> SpriteDefinition {
    var definition = SpriteDefinition()
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
