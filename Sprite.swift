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
    
    var translucentSpriteFactory: TranslucentSpriteFactory {
        return self.factory as! TranslucentSpriteFactory
    }
}
