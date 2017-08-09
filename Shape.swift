//
//  Shape.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

enum Shape : Enumerable {
    case round
    case triangular
    case diamond
    
    static let all = [Shape.round, .triangular, .diamond]
}
