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

class StationaryFormationDefinition {
    
    var interval: TimeInterval {
        return 0.3
    }
    
    var creationPoints: [Point<GLfloat>] {
        if points.isEmpty {
            points = stride(from: 16, to: View.instance.width - 16, by: 32).map { Point(x: $0, y: -32) }
        }
        return [points.removeAtRandom()]
    }
    
    fileprivate var points = [Point<GLfloat>]()
    
}

class QuarterCircleFormationDefinition {

    var length = 3
    
    var interval: TimeInterval {
        if count > 0 && count % length == 0 {
            return 1.5
        }
        return 0.4
    }
    
    var creationPoints: [Point<GLfloat>] {
        count += 1
        return [Point(x: 0, y: -128)]
    }

    fileprivate var count = 0
    
}
