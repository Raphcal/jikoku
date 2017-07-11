//
//  GameScene.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

class GameScene : Scene {

    let backgroundColor = Color<GLfloat>(hex: 0xE4C9A0)
    
    func load() {
        if let context = CGContext(data: nil, width: 96, height: 96, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -96)
            
            add(kanji: "日", in: context, rect: CGRect(x: 0, y: 0, width: 48, height: 48))
            add(kanji: "本", in: context, rect: CGRect(x: 48, y: 0, width: 48, height: 48))
            add(kanji: "一", in: context, rect: CGRect(x: 0, y: 48, width: 48, height: 48))
            add(kanji: "二", in: context, rect: CGRect(x: 48, y: 48, width: 48, height: 48))
            
            if let image = context.makeImage() {
                try? UIImagePNGRepresentation(UIImage(cgImage: image))?.write(to: URL(fileURLWithPath: "/Users/raphael/Desktop/test.png"))
            }
        }
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval) {
        // TODO: Écrire le code
    }
    
    func draw() {
        // TODO: Écrire le code
    }
    
    private func add(kanji: Character, in context: CGContext, rect: CGRect) {
        drawBackgroundCircle(in: context, rect: rect)
        draw(kanji: kanji, in: context, rect: rect)
    }
    
    private func drawBackgroundCircle(in context: CGContext, rect: CGRect) {
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: rect)
    }
    
    private func draw(kanji: Character, in context: CGContext, rect: CGRect) {
        if let font = UIFont(name: "Helvetica", size: rect.size.height * 2 / 3) {
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            
            let lineText = NSMutableAttributedString(string: String(kanji))
            lineText.addAttribute(kCTFontAttributeName as String, value: font, range: NSRange(location: 0, length: lineText.length))
            lineText.addAttribute(kCTForegroundColorFromContextAttributeName as String, value: true, range: NSRange(location: 0, length: lineText.length))
            
            let lineToDraw = CTLineCreateWithAttributedString(lineText)
            let bounds = CTLineGetImageBounds(lineToDraw, context)
            
            context.setTextDrawingMode(.fill)
            context.setFillColor(UIColor.white.cgColor)
            context.textPosition = CGPoint(x: rect.origin.x + (rect.size.width - bounds.width) / 2 - bounds.origin.x, y: rect.origin.y + rect.size.height - (rect.size.height - bounds.height) / 2 + bounds.origin.y)
            CTLineDraw(lineToDraw, context)
        }
    }

}

extension Character {
    var uniChar: UniChar {
        get {
            let string = String(self)
            return string.utf16[string.utf16.startIndex]
        }
    }
}
