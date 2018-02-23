//
//  GameViewController.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

class GameViewController : MelisseViewController {
    
    override func viewDidLoad() {
        View.instance.width = 320
        super.viewDidLoad()
    }
    
    override func initialScene() -> Scene {
        if let gameScene = GameScene() {
            return gameScene
        } else {
            return EmptyScene()
        }
    }
    
}
