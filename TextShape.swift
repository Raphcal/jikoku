//
//  TextShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import UIKit

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
