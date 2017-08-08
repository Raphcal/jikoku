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
    
    convenience init?(string: String, size: Int) {
        do {
            let texture = try GLKTextureLoader.texture(with: string, size: size)
            var definitions = [SpriteDefinition]()

            // TODO: Inclure des sprites pour les tirs et gérer les différentes formes de vaisseaux
            
            var index = 0
            var x = 0, y = 0
            let textureSize = size * Int(UIScreen.main.scale)

            for character in string.characters {
                var definition = SpriteDefinition()
                definition.index = index
                definition.name = String(character)
                definition.type = index == 0 ? SpriteType.player : SpriteType.enemy
                definition.distance = .behind
                definition.animations = [
                    DefaultAnimationName.normal.name: AnimationDefinition(frames: [AnimationFrame(frame: Rectangle(x: x, y: y, width: textureSize, height: textureSize), size: Size(width: GLfloat(size), height: GLfloat(size)))], looping: false)
                ]
                
                definitions.append(definition)
                
                index += 1
                x += textureSize
                if x >= Int(texture.width) {
                    x = 0
                    y += textureSize
                }
            }
            
            self.init(definitions: definitions, texture: texture)
        } catch {
            print("Texture creation error : \(error)")
            return nil
        }
    }
    
    convenience init?(level: Level) {
        // TODO: Implémenter la méthode
        
        var blueprints = [SpriteBlueprint]()
        
        blueprints.append(SpriteBlueprint(
            id: blueprints.count,
            shape: .triangular,
            shapePaint: Color<GLfloat>.black,
            text: "私",
            textColor: .white,
            size: Size(width: 48, height: 48)
        ))
        
        for wave in level.waves {
            for group in wave.groups {
                // Sprite
                blueprints.append(SpriteBlueprint(
                    id: blueprints.count,
                    shape: group.shape,
                    shapePaint: Color<GLfloat>(red: 1, green: 0, blue: 0, alpha: 1),
                    text: String(group.kanji),
                    textColor: .white,
                    size: Size(width: group.size.pixelSize, height: group.size.pixelSize))
                )
                // Tir
                blueprints.append(SpriteBlueprint(
                    id: blueprints.count,
                    shape: .round,
                    shapePaint: Color<GLfloat>.white,
                    text: nil,
                    textColor: nil,
                    size: Size(width: 16, height: 16))
                )
                // TODO: Sauvegarder quelque part les blueprints pour le groupe actuel
            }
        }
        
        for hiragana in "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんゔがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽぁぃぅぇぉゕゖっゃゅょゎゔか゚き゚く゚け゚こ゚ゝゞゟ".characters {
            blueprints.append(SpriteBlueprint(
                id: blueprints.count,
                shape: nil,
                shapePaint: nil,
                text: String(hiragana),
                textColor: .black,
                size: Size(width: 16, height: 16))
            )
        }
        
        for katakana in "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポァィゥェォヵヶッャュョヮヴヷヸヹヺカ゚キ゚ク゚ケ゚コ゚セ゚ツ゚ト゚ㇰㇱㇲㇳㇴㇵㇶㇷㇷ゚ㇸㇹㇺㇻㇼㇽㇾㇿヽヾヿ".characters {
            blueprints.append(SpriteBlueprint(
                id: blueprints.count,
                shape: nil,
                shapePaint: nil,
                text: String(katakana),
                textColor: .black,
                size: Size(width: 16, height: 16))
            )
        }
        
        let texture = try? GLKTextureLoader.texture(with: blueprints)
        
        return nil
    }
    
    fileprivate func font() -> SpriteDefinition {
        var definition = SpriteDefinition()
        definition.type = SpriteType.decoration
        definition.distance = .behind
        definition.animations = [
            KanaFontAnimationName.hiragana.name: AnimationDefinition(),
            KanaFontAnimationName.katakana.name: AnimationDefinition()
        ]
        return definition
    }

}
