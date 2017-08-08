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

struct SimplePackMap<Element> where Element : Packable {

    var size: Size<Int> = Size(width: 32, height: 32)
    var elements = [Element]()
    
    fileprivate var rows = [Row<Element>]()
    
    mutating func add(element: Element) {
        let elementSize = element.packSize
        while true {
            for var row in rows {
                if row.size.height >= elementSize.height && row.remainingWidth >= elementSize.width {
                    row.add(element: element)
                    return
                }
            }
            grow()
        }
    }
    
    mutating func grow() {
        self.size = size * 2
    }

}

fileprivate struct Row<Element> where Element : Packable {

    var parent: SimplePackMap<Element>
    var size: Size<Int>
    var elements = [Element]()
    
    var remainingWidth: Int {
        return parent.size.width - size.width
    }
    
    mutating func add(element: Element) {
        size.width += element.packSize.width
        elements.append(element)
    }

}

// MARK: - PackMap (à finir d'implémenter)

fileprivate class PackMap<Element> where Element : Packable {
    fileprivate let topLeftCell: Cell<Element>
    
    init(size: Size<Int>) {
        self.topLeftCell = Cell(size: size)
    }
    
    func put(element: Element) {
        var row: Cell<Element>? = nil
        while row == nil {
            row = topLeftCell
            while row != nil && !didFit(in: row!) {
                row = row!.bottomCell
            }
            if row == nil {
                // TODO: Élargir la map
                return
            }
        }
    }
    
    private func didFit(in row: Cell<Element>) -> Bool {
        return false
    }
}

fileprivate class Cell<Element> where Element : Packable {

    var content: Element?
    
    var size: Size<Int>
    
    var rightCell: Cell<Element>?
    var bottomCell: Cell<Element>?
    
    var isEmpty: Bool {
        return content == nil
    }
    
    init(size: Size<Int>, rightCell: Cell<Element>? = nil, bottomCell: Cell<Element>? = nil) {
        self.size = size
        self.rightCell = rightCell
        self.bottomCell = bottomCell
    }
    
    func put(element: Element) {
        let oldSize = size
        self.size = element.packSize
        
        if oldSize.width > size.width {
            if let rightCell = rightCell, rightCell.size.height == size.height {
                rightCell.size.width += oldSize.width - size.width
            } else {
                self.rightCell = Cell(size: Size(width: oldSize.width - size.width, height: size.height), rightCell: self.rightCell)
            }
        }
        if oldSize.height > size.height {
            if let bottomCell = bottomCell, bottomCell.size.width == oldSize.width {
                bottomCell.size.height += oldSize.height - size.height
            } else {
                self.bottomCell = Cell(size: Size(width: oldSize.width, height: oldSize.height - size.height), bottomCell: self.bottomCell)
            }
        }
    }

}
