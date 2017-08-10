//
//  Paint.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

protocol Paint {
    func paint(rectangle: CGRect, in context: CGContext)
}

func ~=(lhs: Paint?, rhs: Paint?) -> Bool {
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

extension Paint {
    var hashValue: Int {
        if let paint = self as? RadialGradient {
            return paint.hashValue &* 61
        }
        else if let paint = self as? Color<GLubyte> {
            return paint.hashValue &* 67
        }
        else if let paint = self as? Color<GLfloat> {
            return paint.hashValue &* 71
        }
        else {
            return 0
        }
    }
}

struct RadialGradient : Paint, Hashable {
    var innerColor: Color<GLfloat>
    var outerColor: Color<GLfloat>
    
    var hashValue: Int {
        return innerColor.hashValue &* 211
            &+ outerColor.hashValue &* 137
    }
    
    func paint(rectangle: CGRect, in context: CGContext) {
        let gradient = CGGradient(colorsSpace: nil, colors: [] as CFArray, locations: [0, 1])!
        context.drawRadialGradient(gradient, startCenter: CGPoint(x: rectangle.origin.x + rectangle.size.width / 2, y: rectangle.origin.y + rectangle.size.height / 2), startRadius: 5.11,
                                   endCenter: CGPoint(x: 120, y: 45), endRadius: 17.45,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }
    
    static func ==(lhs: RadialGradient, rhs: RadialGradient) -> Bool {
        return lhs.innerColor == rhs.innerColor
            && lhs.outerColor == rhs.outerColor
    }
}

extension Color : Paint {
    func paint(rectangle: CGRect, in context: CGContext) {
        // TODO
    }

}

extension Color where Component == GLfloat {
    var cgColor: CGColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)).cgColor
    }
}
