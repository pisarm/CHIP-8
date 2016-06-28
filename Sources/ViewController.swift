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

        if let gameUrl = NSBundle(forClass: self.dynamicType).URLForResource("ZeroDemo", withExtension: "ch8"), data = NSData(contentsOfURL: gameUrl) {
            let rom = Rom(data: data)
            let emulator = Emulator(rom: rom)

            let queue = dispatch_queue_create("timers", DISPATCH_QUEUE_SERIAL)
            cycleTimer = Timer(rate: 500, queue: queue) { emulator.cycle() }
            tickTimer = Timer(rate: 60, queue: queue) { emulator.timerTick() }

            cycleTimer.resume()
            tickTimer.resume()
        } else {
            print(".ch8 file not found")
        }
    }
}
