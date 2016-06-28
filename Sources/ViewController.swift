//
//  ViewController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cycleTimer: Timer!
    var tickTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gameUrl = NSBundle(forClass: self.dynamicType).URLForResource("Maze", withExtension: "ch8"), data = NSData(contentsOfURL: gameUrl) {
            let rom = Rom(data: data)
            let emulator = Emulator(rom: rom)

            cycleTimer = Timer(rate: 50) { emulator.cycle() }
            tickTimer = Timer(rate: 60) { emulator.timerTick() }

            cycleTimer.start()
            tickTimer.start()
        } else {
            print(".ch8 file not found")
        }
    }
}
