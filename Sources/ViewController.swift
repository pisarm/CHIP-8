//
//  ViewController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let gameUrl = NSBundle(forClass: self.dynamicType).URLForResource("Maze", withExtension: "ch8"), data = NSData(contentsOfURL: gameUrl) {
            let rom = Rom(data: data)
            let emulator = Emulator(rom: rom)

            while true {
                emulator.cycle()
//                sleep(1)
            }
        }
    }
}
