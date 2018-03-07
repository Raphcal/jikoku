//
//  SVGPathShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import QuartzCore
import Melisse

fileprivate let closePath: Character = "z"
fileprivate let closePathAlias: Character = "Z"
fileprivate let absoluteMoveTo: Character = "M"
fileprivate let relativeMoveTo: Character = "m"
fileprivate let absoluteLineTo: Character = "L"
fileprivate let relativeLineTo: Character = "l"
fileprivate let absoluteHorizontalLineTo: Character = "H"
fileprivate let relativeHorizontalLineTo: Character = "h"
fileprivate let absoluteVerticalLineTo: Character = "V"
fileprivate let relativeVerticalLineTo: Character = "v"
fileprivate let absoluteCurveTo: Character = "C"
fileprivate let relativeCurveTo: Character = "c"
fileprivate let space: Character = " "
fileprivate let comma: Character = ","

class SVGPathShape : Shape {
    
    let path: String
    let size: Size<CGFloat>
    
    init(path: String, size: Size<CGFloat>) {
        self.path = path
        self.size = size
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let translation = Point<CGFloat>(x: rectangle.minX, y: rectangle.minY)
        let scale = Point<CGFloat>(x: rectangle.width / size.width, y: rectangle.height / size.height)
        
        var buffer = ""
        var values = [CGFloat]()
        var arguments: Int?
        var state = space
        
        var index = path.startIndex
        while index < path.endIndex {
            let character = path[index]
            
            switch character {
            case closePathAlias: fallthrough
            case closePath:
                context.closePath()
            case absoluteMoveTo: fallthrough
            case relativeMoveTo: fallthrough
            case absoluteLineTo: fallthrough
            case relativeLineTo:
                state = character
                arguments = 2
            case absoluteCurveTo: fallthrough
            case relativeCurveTo:
                state = character
                arguments = 6
            case comma: fallthrough
            case space:
                if let double = Double(buffer) {
                    values.append(CGFloat(double))
                }
                buffer = ""
            default:
                buffer.append(character)
            }
            
            if let count = arguments, values.count == count {
                switch state {
                case absoluteMoveTo:
                    context.move(to: values.points(scale: scale, translation: translation)[0])
                case absoluteLineTo:
                    context.addLine(to: values.points(scale: scale, translation: translation)[0])
                case absoluteCurveTo:
                    let points = values.points(scale: scale, translation: translation)
                    context.addCurve(to: points[2], control1: points[0], control2: points[1])
                default:
                    break
                }
                
                values = []
                arguments = nil
            }
            
            index = path.index(after: index)
        }
    }
    
}

extension Array where Element == CGFloat {
    func points(scale: Point<CGFloat>, translation: Point<CGFloat>) -> [CGPoint] {
        var points = [CGPoint]()
        for index in stride(from: 0, to: count, by: 2) {
            points.append((Point<CGFloat>(x: self[index], y: self[index + 1]) * scale + translation).cgPoint)
        }
        return points
    }
}
