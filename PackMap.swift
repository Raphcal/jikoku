//
//  PackMap.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

protocol Packable: Equatable {
    var packSize: Size<Int> { get }
}

class SimplePackMap<Element> where Element : Packable {

    var size: Size<Int> = Size(width: 32, height: 32)
    var elements = [Element]()
    
    fileprivate var rows = [Row<Element>]()
    fileprivate var takenHeight = 0
    fileprivate var remainingHeight: Int {
        return size.height - takenHeight
    }
    
    func add(_ element: Element) {
        if elements.contains(element) {
            return
        }
        elements.append(element)
        
        let elementSize = element.packSize
        while true {
            for index in 0 ..< rows.count {
                let row = rows[index]
                if row.size.height >= elementSize.height && row.remainingWidth >= elementSize.width {
                    rows[index].add(element: element)
                    return
                }
            }
            if remainingHeight >= elementSize.height {
                rows.append(Row(parent: self, first: element, y: takenHeight))
                takenHeight += elementSize.height
                return
            } else {
                grow()
            }
        }
    }
    
    func add(contentsOf elements: [Element]) {
        for element in elements.sorted(by: { $0.packSize.height > $1.packSize.height }) {
            add(element)
        }
    }
    
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
    
    func grow() {
        self.size = size * 2
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
