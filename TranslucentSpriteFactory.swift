//
//  TranslucentSpriteFactory.swift
//  Yamato
//
//  Created by Raphaël Calabro on 27/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse
import GLKit

/// Version spécifique de `SpriteFactory` permettant de rendre semi-transparent et de teinter les sprites.
class TranslucentSpriteFactory : SpriteFactory {
    
    /// Surface stockant la couleur des sprites.
    public let colorPointer: SurfaceArray<GLubyte>
    
    init(capacity: Int, spriteAtlas: SpriteAtlas) {
        self.colorPointer = SurfaceArray(capacity: capacity * vertexesByQuad, coordinates: coordinatesByColor)
        super.init(capacity: capacity, spriteAtlas: spriteAtlas)
    }
    
    /// Défini la transparence du sprite donné.
    /// - Parameter alpha: Valeur de la transparence. Entre 0 et 255.
    func setAlpha(_ alpha: GLubyte, of sprite: Sprite) {
        colorPointer.surfaceAt(sprite.reference).setColor(with: 1, alpha: alpha)
    }
    
    override func draw(at translation: Point<GLfloat>) {
        Draws.bindTexture(textureAtlas)
        Draws.translateTo(translation)
        Draws.drawWith(vertexPointer.memory, texCoordPointer: texCoordPointer.memory, colorPointer: colorPointer.memory, count: GLsizei(capacity * vertexesByQuad))
    }
    
}
