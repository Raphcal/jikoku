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
            &+ (text?.hashValue ?? 0) &* 79
            &+ (textColor?.hashValue ?? 0) &* 131
            &+ size.hashValue &* 181
    }
    
    static func ==(lhs: SpriteBlueprint, rhs: SpriteBlueprint) -> Bool {
        return lhs.shape == rhs.shape
            && isPaint(lhs.shapePaint, equalTo: rhs.shapePaint)
            && lhs.text == rhs.text
            && lhs.textColor == rhs.textColor
            && lhs.size == rhs.size
    }
}

func isPaint(_ lhs: Paint?, equalTo rhs: Paint?) -> Bool {
    if lhs == nil {
        return rhs == nil
    }
    if let leftColor = lhs as? Color<GLfloat>, let rightColor = rhs as? Color<GLfloat> {
        return leftColor == rightColor
    }
    else if let leftColor = lhs as? Color<GLubyte>, let rightColor = rhs as? Color<GLubyte> {
        return leftColor == rightColor
    }
    else if let leftGradient = lhs as? RadialGradient, let rightGradient = rhs as? RadialGradient {
        return leftGradient == rightGradient
    }
    return false
}

protocol Paint {
}

struct RadialGradient : Paint, Equatable {
    var innerColor: Color<GLfloat>
    var outerColor: Color<GLfloat>
    
    static func ==(lhs: RadialGradient, rhs: RadialGradient) -> Bool {
        return lhs.innerColor == rhs.innerColor
            && lhs.outerColor == rhs.outerColor
    }
}

extension Color : Paint {
}

extension Color where Component == GLfloat {
    var cgColor: CGColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)).cgColor
    }
}
