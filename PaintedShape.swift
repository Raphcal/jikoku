//
//  PaintedShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 18/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct PaintedShape : Hashable {
    var shape: Shape
    var paint: Paint
    var rectangle: Rectangle<GLfloat>?
    
    var hashValue: Int {
        return shape.hashValue &* 3
            &+ paint.hashValue &* 7
            &+ (rectangle?.hashValue ?? 0) &* 11
    }
    
    init(shape: Shape, paint: Paint, rectangle: Rectangle<GLfloat>? = nil) {
        self.shape = shape
        self.paint = paint
        self.rectangle = rectangle
    }
    
    func cgRect(origin: Point<Int>, size: Size<GLfloat>) -> CGRect {
        if let inner = rectangle {
            return CGRect(x: origin.x + Int(inner.x), y: origin.y + Int(inner.y), width: Int(inner.width), height: Int(inner.height))
        } else {
            return CGRect(x: origin.x, y: origin.y, width: Int(size.width), height: Int(size.height))
        }
    }
}

func ==(lhs: PaintedShape, rhs: PaintedShape) -> Bool {
    return lhs.shape == rhs.shape
        && lhs.paint ~= rhs.paint
        && lhs.rectangle == rhs.rectangle
}

extension Array where Element == PaintedShape {
    var hashValue: Int {
        return self.reduce(0) { $0 &+ $1.hashValue }
    }
}
