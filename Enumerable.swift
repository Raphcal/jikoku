//
//  Enumerable.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

protocol Enumerable {
    static var all: [Self] { get }
}

extension Enumerable {
    static var random: Self {
        return Melisse.random(itemFrom: all)
    }
}
