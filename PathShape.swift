//
//  PathShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import QuartzCore
import Melisse

class PathShape : Shape {
    
    let path: String
    let points: [Point<CGFloat>]
    
    override var hashValue: Int {
        return path.hashValue &* 87
    }
    
    init(path: String) {
        self.path = path
        
        var size = Size<CGFloat>()
        
        var points = [Point<CGFloat>]()
        var values = [CGFloat]()
        
        for value in path.components(separatedBy: " ") {
            if let double = Double(value) {
                values.append(CGFloat(double))
                
                if values.count == 2 {
                    let point = Point(x: values[0], y: values[1])
                    points.append(point)
                    values = []
                    
                    size = Size(width: max(point.x, size.width), height: max(point.y, size.height))
                }
            }
        }
        
        self.points = points.map { Point(x: $0.x / size.width, y: $0.y / size.height) }
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        if points.isEmpty {
            return
        }
        let translation = Point<CGFloat>(x: rectangle.minX, y: rectangle.minY)
        let scale = Point<CGFloat>(x: rectangle.width, y: rectangle.height)
        
        var isFirst = true
        for point in points {
            let cgPoint = (point * scale + translation).cgPoint
            if isFirst {
                context.move(to: cgPoint)
                isFirst = false
            } else {
                context.addLine(to: cgPoint)
            }
        }
        context.closePath()
    }
    
    static func ==(lhs: PathShape, rhs: PathShape) -> Bool {
        return lhs.path == rhs.path
    }
    
}
