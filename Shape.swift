//
//  Shape.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import UIKit
import Melisse

class Shape : Equatable, Hashable {
    static let round: Shape = RoundShape()
    static let triangular: Shape = TriangularShape()
    static let diamond: Shape = DiamondShape()
    
    var hashValue: Int {
        return 1
    }
    
    open func addPath(in rectangle: CGRect, to context: CGContext) {
        // Pas de traitement.
    }
    
    static let all = [Shape.round, .triangular, .diamond]
    
    static var random: Shape {
        return Melisse.random(itemFrom: all)
    }
    
    static func ==(lhs: Shape, rhs: Shape) -> Bool {
        if let lhs = lhs as? TextShape, let rhs = rhs as? TextShape {
            return lhs == rhs
        }
        return type(of: lhs) == type(of: rhs)
    }
}

fileprivate final class RoundShape : Shape {
    
    override var hashValue: Int {
        return "round".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        context.addEllipse(in: rectangle)
    }
    
}

fileprivate final class TriangularShape : Shape {
    
    override var hashValue: Int {
        return "triangular".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let origin = rectangle.origin
        let center = rectangle.center
        let size = rectangle.size
        
        context.move(to: CGPoint(x: origin.x, y: origin.y + size.height))
        context.addLine(to: CGPoint(x: center.x, y: origin.y))
        context.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y + size.height))
        context.closePath()
    }
    
}

fileprivate final class DiamondShape : Shape {
    
    override var hashValue: Int {
        return "diamond".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let origin = rectangle.origin
        let center = rectangle.center
        let size = rectangle.size
        
        context.move(to: CGPoint(x: center.x, y: origin.y))
        context.addLine(to: CGPoint(x: origin.x + size.width, y: center.y))
        context.addLine(to: CGPoint(x: center.x, y: origin.y + size.height))
        context.addLine(to: CGPoint(x: origin.x, y: center.y))
        context.closePath()
    }
    
}

class TextShape : Shape {
    
    let text: String
    let font: UIFont
    
    init(text: String = "", font: UIFont? = nil) {
        self.text = text
        self.font = font ?? UIFont.systemFont(ofSize: 12)
    }
    
    override var hashValue: Int {
        return "text \(text)".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let font = self.font.withSize(min(rectangle.size.width, rectangle.size.height))
        
        var unichars = [UniChar](text.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font as CTFont, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            for glyph in glyphs {
                var origin = rectangle.origin
                
                if let cgPath = CTFontCreatePathForGlyph(font as CTFont, glyph, nil) {
                    let bounds = cgPath.boundingBox
                    origin = CGPoint(x: origin.x + (rectangle.size.width - bounds.width) / 2 - bounds.origin.x, y: origin.y + rectangle.size.height - (rectangle.size.height - bounds.height) / 2 + bounds.origin.y)
                }
                
                var transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: origin.x, y: -origin.y)
                
                if let cgPath = CTFontCreatePathForGlyph(font as CTFont, glyph, &transform) {
                    context.addPath(cgPath)
                }
            }
        }
    }
    
    static func ==(lhs: TextShape, rhs: TextShape) -> Bool {
        return lhs.text == rhs.text
            && lhs.font == rhs.font
    }
}
