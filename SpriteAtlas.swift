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
let weaponSelectorDefinition = 4

extension SpriteAtlas {
    
    convenience init?(level: inout Level) {
        let hiraginoW3 = UIFont(name: "HiraginoSans-W3", size: 10)
        let hiraginoW6 = UIFont(name: "HiraginoSans-W6", size: 10)
        
        // Joueur
        let player = SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .triangular, paint: Color<GLfloat>(hex: 0x50E3C2)),
            PaintedShape(shape: "私".shape(font: hiraginoW3), paint: Color<GLfloat>.white, rectangle: Rectangle(x: 0, y: 20, width: 48, height: 24)),
            PaintedShape(shape: .round, paint: Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 0.5), rectangle: Rectangle(x: 20, y: 20, width: 8, height: 8))],
            size: Size(width: 48, height: 48))
        let playerShots = SpriteBlueprint(paintedShapes: [PaintedShape(shape: .roundedArrow, paint: RadialGradient(innerColor: .white, outerColor: Color(hex: 0x44B6DE)))],
            size: Size(width: 16, height: 24))
        
        var blueprints = [player, player.shadow, playerShots]
        var groups = [Group : (sprite: SpriteBlueprint, shot: SpriteBlueprint)]()
        
        // Choix de l'arme
        var weaponSelectorBlueprints: [SpriteBlueprint] = []
        level.weapons.forEach {
            weaponSelectorBlueprints.append(SpriteBlueprint(paintedShapes: [
                PaintedShape(shape: .circle, paint: Color<GLubyte>.red, rectangle: Rectangle(x: 4, y: 4, width: 44, height: 44)),
                PaintedShape(shape: $0.shape(font: hiraginoW3), paint: Color<GLubyte>.red, rectangle: Rectangle(x: 15, y: 15, width: 22, height: 22)),
                ], size: Size(size: 52)))
            
            weaponSelectorBlueprints.append(SpriteBlueprint(paintedShapes: [
                PaintedShape(shape: .brushRound, paint: Color<GLubyte>.red),
                PaintedShape(shape: $0.shape(font: hiraginoW6), paint: Color<GLubyte>.red, rectangle: Rectangle(x: 15, y: 15, width: 22, height: 22)),
                ], size: Size(size: 52)))
        }
        blueprints.append(contentsOf: weaponSelectorBlueprints)
        
        // Vagues d'ennemis
        let red = Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 1)
        
        for wave in level.waves {
            for group in wave.groups {
                var groupBlueprints = [SpriteBlueprint]()
                
                let textSize = group.size.pixelSize * 2 / 3
                
                // Sprite
                let sprite = SpriteBlueprint(paintedShapes: [
                    PaintedShape(shape: group.shape, paint: red),
                    PaintedShape(shape: TextShape(text: String(group.kanji.character), font: hiraginoW3), paint: Color<GLfloat>.white, rectangle: Rectangle(x: (group.size.pixelSize - textSize) / 2, y: (group.size.pixelSize - textSize) / 2, width: textSize, height: textSize))], size: Size(size: group.size.pixelSize))
                groupBlueprints.append(sprite)
                
                // Ombre
                if group.isFlying {
                    groupBlueprints.append(sprite.shadow)
                }
                
                // Tir
                groupBlueprints.append(SpriteBlueprint(paintedShapes: [PaintedShape(shape: .round, paint: RadialGradient(innerColor: .white, outerColor: Color(hex: 0xFB00FF)))],
                    size: Size(width: 16, height: 16)))
                groups[group] = (sprite: sprite, shot: groupBlueprints.last!)
                blueprints.append(contentsOf: groupBlueprints)
            }
        }
        
        // Boss
        var bossBlueprints = [SpriteBlueprint]()
        
        let bossSize: GLfloat = 256
        let textSize = bossSize * 2 / 3
        
        let bossSprite = SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .round, paint: Color<GLfloat>(hex: 0xF6A623)),
            PaintedShape(
                shape: TextShape(text: String("陽"), font: hiraginoW6),
                paint: Color<GLfloat>.white,
                rectangle: Rectangle(x: (bossSize - textSize) / 2, y: (bossSize - textSize) / 2, width: textSize, height: textSize))], size: Size(size: bossSize))

        bossBlueprints.append(bossSprite)
        bossBlueprints.append(bossSprite.shadow)
        bossBlueprints.append(SpriteBlueprint(paintedShapes: [PaintedShape(shape: .diamond, paint: Color<GLubyte>(hex: 0xF6A623))], size: Size(width: 8, height: 24)))
        blueprints.append(contentsOf: bossBlueprints)
        
        // Polices d'écriture
        let hiraganas = stride(from: "あ".utf16.first!, to: "ゟ".utf16.first! + 1, by: 1).map { (hiragana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(hiragana)!)
            return SpriteBlueprint(paintedShapes: [PaintedShape(shape: TextShape(text: String(character), font: hiraginoW6), paint: EmbossPaint(color: Color(hex: 0x7ED321)))], size: Size(width: 24, height: 24))
        }
        blueprints.append(contentsOf: hiraganas)
        
        let katakanas = stride(from: "ア".utf16.first!, to: "ヿ".utf16.first! + 1, by: 1).map { (katakana: UInt16) -> SpriteBlueprint in
            let character = Character(UnicodeScalar(katakana)!)
            return SpriteBlueprint(paintedShapes: [PaintedShape(shape: TextShape(text: String(character), font: hiraginoW6), paint: EmbossPaint(color: Color(hex: 0xF382D9)))], size: Size(width: 24, height: 24))
        }
        blueprints.append(contentsOf: katakanas)
        
        // Création des définitions
        let packMap = PackMap<SpriteBlueprint>(elements: blueprints)
        
        var definitions: [SpriteDefinition] = [
            SpriteDefinition(index: playerDefinition, type: .player, blueprint: player, packMap: packMap),
            SpriteDefinition(index: playerShadowDefinition, distance: .shadow, blueprint: player.shadow, packMap: packMap),
            SpriteDefinition(index: playerShotDefinition, type: .friendlyShot, distance: .shot, blueprint: playerShots, packMap: packMap),
            font(hiraganas: hiraganas, katakanas: katakanas, packMap: packMap),
            weaponSelector(level: level, blueprints: weaponSelectorBlueprints, packMap: packMap)
        ]
        
        for i in 0 ..< level.waves.count {
            var wave = level.waves[i]
            for j in 0 ..< wave.groups.count {
                var group = wave.groups[j]
                let blueprints = groups[group]!
                
                group.spriteDefinition = definitions.count
                definitions.append(SpriteDefinition(index: definitions.count, type: .enemy, blueprint: blueprints.sprite, packMap: packMap))
                
                if group.isFlying {
                    group.shadowDefinition = definitions.count
                    definitions.append(SpriteDefinition(index: definitions.count, distance: .shadow, blueprint: blueprints.sprite.shadow, packMap: packMap))
                }
                
                if var shootingStyleDefinition = group.shootingStyleDefinition as? BaseShootingStyleDefinition {
                    shootingStyleDefinition.spriteDefinition = definitions.count
                    definitions.append(SpriteDefinition(index: definitions.count, type: .enemyShot, distance: .shot, blueprint: blueprints.shot, packMap: packMap))
                    group.shootingStyleDefinition = shootingStyleDefinition
                }
                wave.groups[j] = group
            }
            level.waves[i] = wave
        }
        
        level.bossDefinition = definitions.count
        definitions.append(SpriteDefinition(index: definitions.count, type: .enemy, blueprint: bossBlueprints[0], packMap: packMap))
        
        level.bossShadowDefinition = definitions.count
        definitions.append(SpriteDefinition(index: definitions.count, distance: .shadow, blueprint: bossBlueprints[1], packMap: packMap))
        
        level.bossShotDefinition = definitions.count
        definitions.append(SpriteDefinition(index: definitions.count, type: .enemyShot, distance: .shot, blueprint: bossBlueprints[2], packMap: packMap))
        
        do {
            self.init(definitions: definitions, texture: try GLKTextureLoader.texture(with: packMap))
        } catch {
            print("Texture creation error : \(error)")
            return nil
        }
    }
    
    convenience init(hasBlueprints: [HasBlueprints]) {
        self.init(definitions: [], texture: GLKTextureInfo())
    }

}

extension SpriteDefinition {
    init(index: Int, type: SpriteType = SpriteType.decoration, distance: Distance = .spaceship, blueprint: SpriteBlueprint, packMap: PackMap<SpriteBlueprint>) {
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

fileprivate func weaponSelector(level: Level, blueprints: [SpriteBlueprint], packMap: PackMap<SpriteBlueprint>) -> SpriteDefinition {
    var animations = [String : AnimationDefinition]()
    for index in 0 ..< level.weapons.count {
        animations[index.description] = AnimationDefinition(frames: [
            AnimationFrame(blueprint: blueprints[index * 2], packMap: packMap),
            AnimationFrame(blueprint: blueprints[index * 2 + 1], packMap: packMap),
            ], type: .singleFrame)
    }
    
    var definition = SpriteDefinition()
    definition.distance = Distance.interface
    definition.animations = animations
    return definition
}
