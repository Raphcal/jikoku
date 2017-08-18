//
//  FormationDefinition.swift
//  Yamato
//
//  Created by Raphaël Calabro on 02/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

fileprivate let spacing: GLfloat = 8

protocol FormationDefinition {
    var interval: TimeInterval { get }
    var creationPoints: [Point<GLfloat>] { get }
}

struct NoFormationDefinition : FormationDefinition {
    var interval: TimeInterval = 0.5
    var creationPoints = [Point<GLfloat>(x: View.instance.width / 2, y: 0)]
}

class StationaryFormationDefinition : FormationDefinition {
    
    let width: GLfloat
    
    let interval: TimeInterval = 0.3
    
    var creationPoints: [Point<GLfloat>] {
        if points.isEmpty {
            if width >= View.instance.width / 2 {
                points = [
                    Point<GLfloat>(x: View.instance.width / 2, y: -width / 2),
                    Point<GLfloat>(x: View.instance.width / 2, y: -width / 2 - 20),
                    Point<GLfloat>(x: View.instance.width / 2, y: -width / 2 - 40),
                ]
            } else {
                let left = width / 2 + spacing
                let right = View.instance.width - width / 2
                points = stride(from: left, to: right, by: width + spacing).flatMap {
                    [Point(x: $0, y: -width / 2), Point(x: $0, y: -width / 2 - 20), Point(x: $0, y: -width / 2 - 40)]
                }
            }
        }
        return [points.removeAtRandom()]
    }
    
    fileprivate var points = [Point<GLfloat>]()
    
    init(group: Group) {
        self.width = group.size.pixelSize
    }
    
}

struct QuarterCircleFormationDefinition : FormationDefinition {
    
    let interval: TimeInterval = 0.2
    let creationPoints: [Point<GLfloat>]
    
    init(group: Group) {
        let margin = -group.size.pixelSize - spacing
        self.creationPoints = (0 ..< group.count / 6).map { index in Point<GLfloat>(x: 0, y: GLfloat(index) * margin) }
    }
    
}
