//
//  Sprite.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

extension Sprite {
    var alpha: GLubyte {
        get {
            return translucentSpriteFactory.alpha(of: self)
        }
        set {
            translucentSpriteFactory.setAlpha(newValue, of: self)
        }
    }
    
    var tint: Color<GLubyte> {
        get {
            return translucentSpriteFactory.tint(of: self)
        }
        set {
            translucentSpriteFactory.setTint(newValue, of: self)
        }
    }
    
    var group: Group? {
        get {
            return objects["group"] as? Group
        }
        set {
            objects["group"] = newValue
        }
    }
    
    var translucentSpriteFactory: TranslucentSpriteFactory {
        return self.factory as! TranslucentSpriteFactory
    }
}
