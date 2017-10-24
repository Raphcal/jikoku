//
//  AppDelegate.swift
//  Jikoku Mac
//
//  Created by Raphaël Calabro on 20/10/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true;
    }

}

