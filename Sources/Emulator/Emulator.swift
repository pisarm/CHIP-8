//
//  Emulator.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

final class Emulator {
    struct Screen {
        static let rows: UInt8 = 32
        static let columns: UInt8 = 64
        static let size = Int(rows) * Int(columns)
    }

    // See http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#keyboard
    enum Key: UInt8 {
        case Zero = 0x0
        case One = 0x1
        case Two = 0x2
        case Three = 0x3
        case Four = 0x4
        case Five = 0x5
        case Six = 0x6
        case Seven = 0x7
        case Eight = 0x8
        case Nine = 0x9
        case A = 0xA
        case B = 0xB
        case C = 0xC
        case D = 0xD
        case E = 0xE
        case F = 0xF
    }

    //MARK: Internals
    //TODO: replace arrays with a fixed size arrays
    private (set) var registers: [UInt8] = Array(count: 16, repeatedValue: 0)
    private (set) var index: Opcode.Address = 0x0
    private (set) var pc: Opcode.Address = 0x200
    private (set) var memory: [UInt8] = Array(count: 4096, repeatedValue: 0)
    private (set) var opcode: Opcode.Address = 0x0
    private (set) var stack: [Opcode.Address] = Array(count: 16, repeatedValue: 0)
    private (set) var sp: Opcode.Address = 0x0
    private (set) var delayTimer: UInt8 = 0x0
    private (set) var soundTimer: UInt8 = 0x0
    private (set) var screen: [UInt8] = Array(count: Int(Screen.size), repeatedValue: 0)
    private (set) var keypad = [Bool](count: 16, repeatedValue: false)
    private (set) var lastPressedKey: Key?

    // See http://devernay.free.fr/hacks/chip8/C8TECH10.HTM
    private (set) static var fonts: [UInt8] = [
        0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
        0x20, 0x60, 0x20, 0x20, 0x70, // 1
        0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
        0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
        0x90, 0x90, 0xF0, 0x10, 0x10, // 4
        0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
        0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
        0xF0, 0x10, 0x20, 0x40, 0x40, // 7
        0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
        0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
        0xF0, 0x90, 0xF0, 0x90, 0x90, // A
        0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
        0xF0, 0x80, 0x80, 0x80, 0xF0, // C
        0xE0, 0x90, 0x90, 0x90, 0xE0, // D
        0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
        0xF0, 0x80, 0xF0, 0x80, 0x80, // F
    ]

    //MARK: Init
    init(rom: Rom) {
        memory.replaceRange(Int(pc)..<Int(pc) + rom.bytes.count, with: rom.bytes)
    }
}

extension Emulator {
    //MARK: Emulation
    func cycle() {
        let rawOpcode = (Opcode.Address(memory[Int(pc)]) << 8) | (Opcode.Address(memory[Int(pc) + 1]))
        guard let opcode = Opcode(rawOpcode: rawOpcode) else {
            fatalError()
        }
        print(opcode)
        var shouldIncrementPC = true
        var shouldRedraw = false

        switch opcode {

        case .CallProgram:
            //Not implemented
            break

        case .ClearScreen:
            screen = Array(count: Int(Screen.size), repeatedValue: 0)
            shouldRedraw = true

        case .Return:
            sp = sp - 1
            pc = stack[Int(pc)]

        case let .JumpAbsolute(address):
            pc = address
            shouldIncrementPC = false

        case let .CallSubroutine(address):
            stack[Int(sp)] = pc
            sp = sp + 1
            pc = address
            shouldIncrementPC = false

        case let .SkipIfEqualValue(x, value):
            if x == value {
                incrementPC()
            }

        case let .SkipIfNotEqualValue(x, value):
            if x != value {
                incrementPC()
            }

        case let .SkipIfRegisterEqual(x, y):
            if registers[Int(x)] == registers[Int(y)] {
                incrementPC()
            }

        case let .SetValue(x, value):
            registers[Int(x)] = value

        case let .AddValue(x, value):
            let tmp = registers[Int(x)] &+ value
            registers[Int(x)] = tmp

        case let .SetRegister(x, y):
            registers[Int(x)] = registers[Int(y)]

        case let .OrRegister(x, y):
            let registerX = registers[Int(x)]
            let registerY = registers[Int(y)]
            registers[Int(x)] = registerX | registerY

        case let .AndRegister(x, y):
            let registerX = registers[Int(x)]
            let registerY = registers[Int(y)]
            registers[Int(x)] = registerX & registerY

        case let .XorRegister(x, y):
            let registerX = registers[Int(x)]
            let registerY = registers[Int(y)]
            registers[Int(x)] = registerX ^ registerY

        case let .AddRegister(x, y):
            registers[0xF] = registers[Int(x)] + registers[Int(y)] > UInt8.max ? 1 : 0
            registers[Int(x)] = registers[Int(x)] &+ registers[Int(y)]

        case let .SubtractYFromX(x, y):
            registers[0xF] = registers[Int(x)] < registers[Int(y)] ? 0 : 1
            registers[Int(x)] = registers[Int(x)] &- registers[Int(y)]

        case let .ShiftRight(x):
            registers[0xF] = registers[Int(x)] & 0x1
            registers[Int(x)] = registers[Int(x)] >> 1

        case let .SubtractXFromY(x, y):
            registers[0xF] = registers[Int(y)] < registers[Int(x)] ? 0 : 1
            registers[Int(x)] = registers[Int(y)] &- registers[Int(x)]

        case let .ShiftLeft(x):
            registers[0xF] = registers[Int(x)] & 0x80
            registers[Int(x)] = registers[Int(x)] << 1

        case let .SkipIfNotEqualRegister(x, y):
            if registers[Int(x)] != registers[Int(y)] {
                incrementPC()
            }

        case let .SetIndex(address):
            index = address

        case let .JumpRelative(address):
            pc = address + Opcode.Address(registers[0x0])
            shouldIncrementPC = false

        case let .AndRandom(x, value):
            registers[Int(x)] = UInt8(rand() % UINT8_MAX) & value

        case let .Draw(x, y, rows):
            draw(x, y: y, rows: rows)
            shouldRedraw = true

        case let .SkipIfKeyPressed(x):
            if keypad[Int(x)] == true {
                incrementPC()
            }

        case let .SkipIfKeyNotPressed(x):
            if keypad[Int(x)] == false {
                incrementPC()
            }

        case let .StoreDelayTimer(x):
            registers[Int(x)] = delayTimer

        case let .StoreKeyPress(x):
            if let key = lastPressedKey {
                registers[Int(x)] = key.rawValue
            } else {
                //TODO: signal via delegate - no redrawing of screen
            }

        case let .SetDelayTimer(x):
            delayTimer = registers[Int(x)]

        case let .SetSoundTimer(x):
            soundTimer = registers[Int(x)]

        case let .AddIndex(x):
            let value = UInt16(registers[Int(x)])
            registers[0xF] = (value + index) > UInt16(0xFFF) ? 1 : 0
            index += value

        case let .SetIndexFontCharacter(x):
            index = UInt16(registers[Int(x)] * 5)

        case let .StoreBCD(x):
            let xValue = registers[Int(x)]
            memory[Int(index)] = xValue / 100
            memory[Int(index) + 1] = (xValue / 10) % 10
            memory[Int(index) + 2] = (xValue % 100) % 10

        case let .WriteMemory(x):
            for xi in 0...Int(x) {
                memory[Int(index) + xi] = registers[xi]
            }

        case let .ReadMemory(x):
            for xi in 0...Int(x) {
                registers[xi] = memory[Int(index) + xi]
            }

        }

        if shouldIncrementPC {
            incrementPC()
        }

        if shouldRedraw {
////            print("\n\(screen)")
//            for (index, element) in screen.enumerate() {
//                print(element, separator: ",", terminator: "")
//                if index % 32 == 0 && index != 0 {
//                    print("\n")
//
//                }
//            }
        }

        //TODO: signal redraw using delegate
    }

    /**
     */
    func timerTick() {
        if delayTimer > 0 {
            delayTimer -= 1
        }

        if soundTimer > 0 {
            soundTimer -= 1
            if soundTimer == 0 {
                //TODO: signal beep using delegate
            }
        }
    }

    /**
     */
    func set(key: Key, pressed: Bool) {
        keypad[Int(key.rawValue)] = pressed

        if pressed {
            lastPressedKey = key
        }
    }
}

extension Emulator {
    //MARK: Helpers
    func incrementPC() {
        pc = pc + 2
    }

    func draw(x: Opcode.Register, y: Opcode.Register, rows: Opcode.Constant) {
        let startX = registers[Int(x)]
        let startY = registers[Int(y)]

        registers[0xF] = 0

        // Iterate over the number of rows
        for row in 0..<rows {
            // Get data for current row
            var rowData = memory[Int(index + UInt16(row))]

            // Iterate over all bits in the row data
            for column in 0..<UInt8(8) {

                // Look at MSB pixel and continue if it is 1
                if (rowData & 0x80) != 0 {
                    let screenX = (startX + column) % Screen.columns
                    let screenY = (startY + row) % Screen.rows
                    let screenIndex = (screenY * Screen.columns) + screenX
                    if screen[Int(screenIndex)] == 1 {
                        registers[0xF] = 1
                    }
                    screen[Int(screenIndex)] ^= 1
                }
                
                // Shift pixels left to look at MSB during next iteration
                rowData <<= 1
            }
        }
    }
}
