//
//  PackMap.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

protocol Packable {
    var packSize: Size<Int> { get }
}

protocol PackableObject : Packable {
    static func ===(lhs: Self, rhs: Self) -> Bool
}

struct SimplePackMap<Element> where Element : Packable {

    var size: Size<Int> = Size(width: 32, height: 32)
    var elements = [Element]()
    
    fileprivate var rows = [Row<Element>]()
    fileprivate var takenHeight = 0
    fileprivate var remainingHeight: Int {
        return size.height - takenHeight
    }
    
    mutating func add(_ element: Element) {
        elements.append(element)

        let elementSize = element.packSize
        while true {
            for index in 0 ..< rows.count {
                var row = rows[index]
                if row.size.height >= elementSize.height && row.remainingWidth >= elementSize.width {
                    row.add(element: element)
                    rows[index] = row
                    return
                }
            }
            if remainingHeight >= elementSize.height {
                rows.append(Row(parent: self, first: element, y: takenHeight))
                takenHeight += elementSize.height
            } else {
                grow()
            }
        }
    }
    
    mutating func add(contentsOf elements: [Element]) {
        for element in elements {
            add(element)
        }
    }
    
    mutating func grow() {
        self.size = size * 2
    }

}

extension SimplePackMap where Element : Equatable {
    func point(for element: Element) -> Point<Int>? {
        for row in rows {
            for cell in row.cells {
                if cell.element == element {
                    return Point(x: cell.x, y: row.y)
                }
            }
        }
        return nil
    }
}

extension SimplePackMap where Element : PackableObject {
    func point(for element: Element) -> Point<Int>? {
        for row in rows {
            for cell in row.cells {
                if cell.element === element {
                    return Point(x: cell.x, y: row.y)
                }
            }
        }
        return nil
    }
}

fileprivate struct Row<Element> where Element : Packable {

    var parent: SimplePackMap<Element>
    var size: Size<Int>
    var y: Int
    var cells = [Cell<Element>]()
    
    init(parent: SimplePackMap<Element>, first: Element, y: Int) {
        self.parent = parent
        self.size = first.packSize
        self.cells = [Cell(x: 0, element: first)]
        self.y = y
    }
    
    var remainingWidth: Int {
        return parent.size.width - size.width
    }
    
    mutating func add(element: Element) {
        cells.append(Cell(x: size.width, element: element))
        size.width += element.packSize.width
    }

}

fileprivate struct Cell<Element> where Element : Packable {
    var x: Int
    var element: Element
}
