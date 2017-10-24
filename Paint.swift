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
    func paint(shape: Shape, rectangle: CGRect, in context: CGContext)
}

func ~=(lhs: Paint?, rhs: Paint?) -> Bool {
    if lhs == nil {
        return rhs == nil
    }
    if let lhs = lhs as? Color<GLfloat>, let rhs = rhs as? Color<GLfloat> {
        return lhs == rhs
    }
    else if let lhs = lhs as? Color<GLubyte>, let rhs = rhs as? Color<GLubyte> {
        return lhs == rhs
    }
    else if let lhs = lhs as? RadialGradient, let rhs = rhs as? RadialGradient {
        return lhs == rhs
    }
    else if let lhs = lhs as? ShadowPaint, let rhs = rhs as? ShadowPaint {
        return lhs == rhs
    }
    else if let lhs = lhs as? EmbossPaint, let rhs = rhs as? EmbossPaint {
        return lhs == rhs
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
        else if let paint = self as? ShadowPaint {
            return paint.hashValue &* 73
        }
        else {
            return 0
        }
    }
}

/// Dessine la forme avec un dégradé radiale.
struct RadialGradient : Paint, Hashable {
    var innerColor: Color<GLfloat>
    var outerColor: Color<GLfloat>
    
    var hashValue: Int {
        return innerColor.hashValue &* 211
            &+ outerColor.hashValue &* 137
    }
    
    func paint(shape: Shape, rectangle: CGRect, in context: CGContext) {
        if let gradient = CGGradient(colorsSpace: nil, colors: [innerColor.cgColor, outerColor.cgColor] as CFArray, locations: [0, 1]) {
            shape.addPath(in: rectangle, to: context)
            context.clip()
            context.drawRadialGradient(
                gradient,
                startCenter: rectangle.center, startRadius: 0,
                endCenter: rectangle.center, endRadius: min(rectangle.size.width, rectangle.size.height) / 2,
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
    }
    
    static func ==(lhs: RadialGradient, rhs: RadialGradient) -> Bool {
        return lhs.innerColor == rhs.innerColor
            && lhs.outerColor == rhs.outerColor
    }
}

/// Dessine la forme de cette couleur.
extension Color : Paint {

    #if os(iOS)
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
    #elseif os(macOS)
    var cgColor: CGColor {
        if red is GLfloat {
            return NSColor(red: CGFloat(red as! GLfloat), green: CGFloat(green as! GLfloat), blue: CGFloat(blue as! GLfloat), alpha: CGFloat(alpha as! GLfloat)).cgColor
        }
        else if red is GLubyte {
            return NSColor(red: CGFloat(red as! GLubyte) / 255, green: CGFloat(green as! GLubyte) / 255, blue: CGFloat(blue as! GLubyte) / 255, alpha: CGFloat(alpha as! GLubyte) / 255).cgColor
        }
        else {
            return NSColor.white.cgColor
        }
    }
    #endif

    func paint(shape: Shape, rectangle: CGRect, in context: CGContext) {
        shape.addPath(in: rectangle, to: context)
        context.setFillColor(self.cgColor)
        context.fillPath()
    }

}

/// Dessine la forme en noir translucide avec un flou gaussien.
/// Utilisée pour dessiner les ombres.
struct ShadowPaint : Paint, Hashable {
    
    let amount: CGFloat = 10
    let color = Color<GLfloat>(white: 0, alpha: 0.25)
    
    static private var _ciContext: CIContext?
    static var ciContext: CIContext {
        if let _ciContext = _ciContext {
            return _ciContext
        }
        _ciContext = CIContext()
        return _ciContext!
    }
    
    var hashValue: Int {
        return "shadow".hashValue
    }
    
    func paint(shape: Shape, rectangle: CGRect, in context: CGContext) {
        if let otherContext = CGContext(data: nil, width: Int(rectangle.size.width), height: Int(rectangle.size.width), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            shape.addPath(in: CGRect(x: amount, y: amount, width: rectangle.size.width - amount * 2, height: rectangle.size.height - amount * 2), to: otherContext)
            otherContext.setFillColor(color.cgColor)
            otherContext.fillPath()

            let image = otherContext.makeImage()!
            let ciImage = CIImage(cgImage: image)
            let filter = CIFilter(name: "CIGaussianBlur")!
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            filter.setValue(NSNumber(value: Float(amount / 2)), forKey: "inputRadius")
            let result = ShadowPaint.ciContext.createCGImage(filter.outputImage!, from: CGRect(x: 0, y: 0, width: rectangle.size.width, height: rectangle.size.height))!
            context.draw(result, in: rectangle)
        }
    }
    
    static func ==(lhs: ShadowPaint, rhs: ShadowPaint) -> Bool {
        return true
    }
    
}

/// Dessine la forme avec une bordure noire avec relief.
/// Utilisée pour afficher la lecture d'un mot.
struct EmbossPaint : Paint, Hashable {

    var color: Color<GLfloat>
    var borderColor: Color<GLfloat>
    var weight: Int
    
    var hashValue: Int {
        return color.hashValue &* 601
            &+ borderColor.hashValue &* 443
    }
    
    init(color: Color<GLfloat> = .white, borderColor: Color<GLfloat> = .black, weight: Int = 2) {
        self.color = color
        self.borderColor = borderColor
        self.weight = weight
    }
    
    func paint(shape: Shape, rectangle: CGRect, in context: CGContext) {
        var rect = CGRect(x: Int(rectangle.origin.x) + weight / 2, y: Int(rectangle.origin.y) + 2, width: Int(rectangle.width) - weight, height: Int(rectangle.height) - weight)
        
        shape.addPath(in: rect, to: context)
        context.setFillColor(borderColor.cgColor)
        context.fillPath()
        
        rect.origin.y = rectangle.origin.y
        shape.addPath(in: rect, to: context)
        context.setStrokeColor(borderColor.cgColor)
        context.setFillColor(color.cgColor)
        context.setLineWidth(1)
        context.drawPath(using: .fillStroke)
    }
    
    static func ==(lhs: EmbossPaint, rhs: EmbossPaint) -> Bool {
        return lhs.color == rhs.color
            && lhs.borderColor == rhs.borderColor
    }
    
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}
