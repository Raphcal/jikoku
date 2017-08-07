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
            points = stride(from: width / 2 + 8, to: View.instance.width - width / 2 - 8, by: width).map { Point(x: $0, y: -width / 2) }
        }
        return [points.removeAtRandom()]
    }
    
    fileprivate var points = [Point<GLfloat>]()
    
    init(group: Group) {
        self.width = group.size.pixelSize
    }
    
}

struct QuarterCircleFormationDefinition : FormationDefinition {
    
    let interval: TimeInterval = 0.4
    let creationPoints: [Point<GLfloat>]
    
    init(group: Group) {
        let margin = -group.size.pixelSize - 8
        self.creationPoints = (0 ..< group.count / 6).map { index in Point<GLfloat>(x: 0, y: GLfloat(index) * margin) }
    }
    
}
