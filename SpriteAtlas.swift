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

}