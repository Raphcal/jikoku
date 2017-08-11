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
        if let gradient = CGGradient(colorsSpace: nil, colors: [innerColor.cgColor, outerColor.cgColor] as CFArray, locations: [0, 1]) {
            context.drawRadialGradient(
                gradient,
                startCenter: rectangle.center, startRadius: 0,
                endCenter: rectangle.center, endRadius: min(rectangle.size.width, rectangle.size.height),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
    }
    
    static func ==(lhs: RadialGradient, rhs: RadialGradient) -> Bool {
        return lhs.innerColor == rhs.innerColor
            && lhs.outerColor == rhs.outerColor
    }
}

extension Color : Paint {

    var cgColor: CGColor {
        if red is GLfloat {
            return UIColor(red: CGFloat(red as! GLfloat), green: CGFloat(green as! GLfloat), blue: CGFloat(blue as! GLfloat), alpha: CGFloat(alpha as! GLfloat)).cgColor
        }
        else if red is GLubyte {
            return UIColor(red: CGFloat(red as! GLubyte) / 255, green: CGFloat(green as! GLubyte) / 255, blue: CGFloat(blue as! GLubyte) / 255, alpha: CGFloat(alpha as! GLubyte) / 255).cgColor
        }
        else {
            return UIColor.white.cgColor
        }
    }

    func paint(rectangle: CGRect, in context: CGContext) {
        context.setFillColor(self.cgColor)
        context.fill(rectangle)
    }

}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
