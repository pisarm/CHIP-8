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
        let bytes: [UInt8] = [
            0x60, 0x11,
            0x61, 0x8,
            0x80, 0x11,
            0x6A, 0x22,
            0x8A, 0x6,
            0x8A, 0xE
            ]
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)
        print(emulator.registers)

        var count = bytes.count / 2

        while count > 0 {
            emulator.begin()
            count = count - 1
            print(emulator.registers)
        }


    }
}
