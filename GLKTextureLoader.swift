//
//  Texture.swift
//  Yamato
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

enum TextureError : Error {
    case imageNotGenerated
}

extension GLKTextureLoader {

    static func texture(with string: String, size: Int = 48) throws -> GLKTextureInfo {
        let width = Int(ceil(sqrt(Double(string.characters.count)))) * size
        let font = UIFont.systemFont(ofSize: CGFloat(size * 3/4))
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: width), false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            
            var x = 0, y = 0
            for character in string.characters {
                let rect = CGRect(x: x, y: y, width: size, height: size)
                context.setFillColor(UIColor.red.cgColor)
                context.fillEllipse(in: rect)
                
                context.setFillColor(UIColor.white.cgColor)
                context.fill(character: character, font: font, in: rect)
                
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
    
    static func texture(with blueprints: [SpriteBlueprint]) throws -> GLKTextureInfo {
        // TODO: Implémenter la méthode.
        let packMap = SimplePackMap<SpriteBlueprint>()
        packMap.add(contentsOf: blueprints)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: packMap.size.width, height: packMap.size.height), false, UIScreen.main.scale)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        
            for blueprint in blueprints {
                let origin = packMap.point(for: blueprint)!
                let size = blueprint.size
                
                let font = UIFont.systemFont(ofSize: CGFloat(min(size.width, size.height) * 3/4))
                let rect = CGRect(x: origin.x, y: origin.y, width: Int(size.width), height: Int(size.height))
                
                if let shape = blueprint.shape {
                    if let color = blueprint.shapePaint as? Color<GLfloat> {
                        context.setFillColor(color.cgColor)
                    } else {
                        context.setFillColor(UIColor.red.cgColor)
                    }
                    context.fillEllipse(in: rect)
                }
                
                if let text = blueprint.text {
                    context.setFillColor(blueprint.textColor!.cgColor)
                    context.fill(string: text, font: font, in: rect)
                }
            }
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        try UIImagePNGRepresentation(image!)?.write(to: URL(fileURLWithPath: "/Users/raphael/Downloads/out.png"))
        
        if let image = image?.cgImage {
            return try GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderOriginBottomLeft: false])
        }
        
        throw TextureError.imageNotGenerated
    }

}

extension CGContext {
    
    func fill(character: Character, font: UIFont, in rect: CGRect) {
        fill(string: String(character), font: font, in: rect)
    }

    func fill(string: String, font: UIFont, in rect: CGRect) {
        let lineText = NSMutableAttributedString(string: string)
        lineText.addAttribute(kCTFontAttributeName as String, value: font, range: NSRange(location: 0, length: lineText.length))
        lineText.addAttribute(kCTForegroundColorFromContextAttributeName as String, value: true, range: NSRange(location: 0, length: lineText.length))
        
        let lineToDraw = CTLineCreateWithAttributedString(lineText)
        
        textPosition = CGPoint()
        let bounds = CTLineGetImageBounds(lineToDraw, self)
        
        setTextDrawingMode(.fill)
        
        textPosition = CGPoint(x: rect.origin.x + (rect.size.width - bounds.width) / 2 - bounds.origin.x, y: rect.origin.y + rect.size.height - (rect.size.height - bounds.height) / 2 + bounds.origin.y)
        CTLineDraw(lineToDraw, self)
    }

}
