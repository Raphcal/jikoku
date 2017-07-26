//
//  GameViewController.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import UIKit
import Melisse

class GameViewController : MelisseViewController {
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        View.instance.width = 320
        super.viewDidLoad()
    }
    
    override func initialScene() -> Scene {
        return GameScene(panGestureRecognizer: panGesture)
    }
    
}
