//
//  SpriteBlueprint.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct SpriteBlueprint : Hashable, Equatable, Packable {
    var shape: Shape?
    var shapePaint: Paint?
    var text: String?
    var textColor: Color<GLfloat>?
    var size: Size<GLfloat>
    
    var shadow: SpriteBlueprint {
        return SpriteBlueprint(shape: shape, shapePaint: Color<GLfloat>(red: 0, green: 0, blue: 0, alpha: 0.2), size: size * 0.9)
    }
    
    init(shape: Shape? = nil, shapePaint: Paint? = nil, text: String? = nil, textColor: Color<GLfloat>? = nil, size: Size<GLfloat>) {
        self.shape = shape
        self.shapePaint = shapePaint
        self.text = text
        self.textColor = textColor
        self.size = size
    }
    
    var packSize: Size<Int> {
        return Size(width: Int(size.width), height: Int(size.height))
    }
    
    var hashValue: Int {
        return (shape?.hashValue ?? 0) &* 37
            &+ (shapePaint?.hashValue ?? 0) &* 43
            &+ (text?.hashValue ?? 0) &* 79
            &+ (textColor?.hashValue ?? 0) &* 131
            &+ size.hashValue &* 181
    }
    
    static func ==(lhs: SpriteBlueprint, rhs: SpriteBlueprint) -> Bool {
        return lhs.shape == rhs.shape
            && lhs.shapePaint ~= rhs.shapePaint
            && lhs.text == rhs.text
            && lhs.textColor == rhs.textColor
            && lhs.size == rhs.size
    }
    
}
