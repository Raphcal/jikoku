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
    
    var width: GLfloat = 48
    
    var interval: TimeInterval {
        return 0.3
    }
    
    var creationPoints: [Point<GLfloat>] {
        if points.isEmpty {
            points = stride(from: width / 2, to: View.instance.width - width / 2, by: width).map { Point(x: $0, y: -32) }
        }
        return [points.removeAtRandom()]
    }
    
    fileprivate var points = [Point<GLfloat>]()
    
}

struct QuarterCircleFormationDefinition : FormationDefinition {
    
    let count: Int
    let interval: TimeInterval = 0.4
    let creationPoints: [Point<GLfloat>]
    
    init(count: Int) {
        self.count = count
        if count <= 6 {
            self.creationPoints = [Point<GLfloat>(x: 0, y: -128)]
        } else {
            self.creationPoints = [Point<GLfloat>(x: 0, y: -128), Point<GLfloat>(x: 0, y: -128)]
        }
    }
    
}
