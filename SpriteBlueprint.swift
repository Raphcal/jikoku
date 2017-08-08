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

struct SpriteBlueprint : Equatable, Packable {
    var id: Int
    var shape: Shape?
    var shapePaint: Paint?
    var text: String?
    var textColor: Color<GLfloat>?
    var size: Size<GLfloat>
    
    var packSize: Size<Int> {
        return Size(width: Int(size.width), height: Int(size.height))
    }
    
    static func ==(lhs: SpriteBlueprint, rhs: SpriteBlueprint) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol Paint {
}

struct RadialGradient : Paint {
    var innerColor: Color<GLfloat>
    var outerColor: Color<GLfloat>
}

extension Color : Paint {
}

extension Color where Component == GLfloat {
    var cgColor: CGColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)).cgColor
    }
}
