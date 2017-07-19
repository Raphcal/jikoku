//
//  Texture.swift
//  Yamato
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit

enum TextureError : Error {
    case imageNotGenerated
}

extension GLKTextureLoader {

    static func texture(with string: String, size: Int = 48) throws -> GLKTextureInfo {
        let width = Int(ceil(sqrt(Double(string.characters.count)))) * size
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: width))
        if let context = UIGraphicsGetCurrentContext() {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            
            var x = 0, y = 0
            for character in string.characters {
                let rect = CGRect(x: size, y: size, width: width, height: width)
                context.setFillColor(UIColor.red.cgColor)
                context.fillEllipse(in: rect)
                
                context.setFillColor(UIColor.white.cgColor)
                context.fill(character: character, font: UIFont.systemFont(ofSize: 12), in: rect)
                
                x += size
                if x >= width {
                    x = 0
                    y += size
                }
            }
        }
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image?.cgImage {
            return try GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderOriginBottomLeft: false])
        }
        
        throw TextureError.imageNotGenerated
    }

}

extension CGContext {

    func fill(character: Character, font: UIFont, in rect: CGRect) {
        let lineText = NSMutableAttributedString(string: String(character))
        lineText.addAttribute(kCTFontAttributeName as String, value: font, range: NSRange(location: 0, length: lineText.length))
        lineText.addAttribute(kCTForegroundColorFromContextAttributeName as String, value: true, range: NSRange(location: 0, length: lineText.length))
        
        let lineToDraw = CTLineCreateWithAttributedString(lineText)
        let bounds = CTLineGetImageBounds(lineToDraw, self)
        
        setTextDrawingMode(.fill)
        
        textPosition = CGPoint(x: rect.origin.x + (rect.size.width - bounds.width) / 2 - bounds.origin.x, y: rect.origin.y + rect.size.height - (rect.size.height - bounds.height) / 2 + bounds.origin.y)
        CTLineDraw(lineToDraw, self)
    }

}