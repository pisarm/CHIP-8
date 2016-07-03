//
//  Emulator.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

protocol EmulatorDelegate: class {
    func beep()
    func draw(screen screen: Screen)
}

final class Emulator {
    weak var delegate: EmulatorDelegate?
    //TODO: configurable cycleRate - change while running
    lazy var cycleTimer: Timer = Timer(rate: 500, queue: self.timerQueue) { [weak self] in self?.cycle() }
    lazy var tickTimer: Timer = Timer(rate: 50, queue: self.timerQueue) { [weak self] in self?.timerTick() }
    lazy var timerQueue: dispatch_queue_t = dispatch_queue_create("dk.pisarm.CHIP-8.timer", DISPATCH_QUEUE_CONCURRENT)

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
    private (set) var screen = Screen()
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

    func resume() {
        cycleTimer.resume()
        tickTimer.resume()
    }

    func suspend() {
        cycleTimer.suspend()
        tickTimer.suspend()
    }
}

extension Emulator {
    //MARK: Emulation
    private func cycle() {
        let rawOpcode = (Opcode.Address(memory[Int(pc)]) << 8) | (Opcode.Address(memory[Int(pc) + 1]))
        guard let opcode = Opcode(rawOpcode: rawOpcode) else {
            print("Invalid opcode: 0x\(String(rawOpcode, radix: 16, uppercase: true))")
            fatalError()
        }
//                print(String(opcode.rawOpcode, radix: 16, uppercase: true))

        var shouldIncrementPC = true
        var shouldRedraw = false

        switch opcode {

        case .ClearScreen:
            screen.reset()
            shouldRedraw = true

        case .Return:
            sp -= 1
            pc = stack[Int(sp)]

        case let .CallProgram(address):
            pc = address
            shouldIncrementPC = false

        case let .JumpAbsolute(address):
            pc = address
            shouldIncrementPC = false

        case let .CallSubroutine(address):
            stack[Int(sp)] = pc
            sp += 1
            pc = address
            shouldIncrementPC = false

        case let .SkipIfEqualValue(x, value):
            if registers[Int(x)] == value {
                incrementPC()
            }

        case let .SkipIfNotEqualValue(x, value):
            if registers[Int(x)] != value {
                incrementPC()
            }

        case let .SkipIfRegisterEqual(x, y):
            if registers[Int(x)] == registers[Int(y)] {
                incrementPC()
            }

        case let .SetValue(x, value):
            registers[Int(x)] = value

        case let .AddValue(x, value):
            registers[Int(x)] = registers[Int(x)] &+ value

        case let .SetRegister(x, y):
            registers[Int(x)] = registers[Int(y)]

        case let .OrRegister(x, y):
            registers[Int(x)] |= registers[Int(y)]

        case let .AndRegister(x, y):
            registers[Int(x)] &= registers[Int(y)]

        case let .XorRegister(x, y):
            registers[Int(x)] ^= registers[Int(y)]

        case let .AddRegister(x, y):
            registers[0xF] = Int(registers[Int(x)]) + Int(registers[Int(y)]) > Int(UInt8.max) ? 1 : 0
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
            registers[0xF] = (registers[Int(x)] & 0x80) >> 7
            registers[Int(x)] <<= 1

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
            delegate?.draw(screen: screen)

//            for row in 0..<Screen.rowCount {
//                var str = ""
//                for col in 0..<Screen.columnCount {
//                    let pixel = screen[col, row] == 1 ? "⬜" : "⬛"
//                    str += "\(pixel)"
//                }
//                print(str)
//            }
//            print("")
        }
    }

    /**
     */
    private func timerTick() {
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

    func set(key: Key, pressed: Bool) {
        keypad[Int(key.rawValue)] = pressed

        if pressed {
            lastPressedKey = key
        }
    }
}

extension Emulator {
    //MARK: Helpers
    private func incrementPC() {
        pc += 2
    }

    private func draw(x: Opcode.Register, y: Opcode.Register, rows: Opcode.Constant) {
        let startX = registers[Int(x)]
        let startY = registers[Int(y)]

        registers[0xF] = 0

        // Iterate over the number of rows
        for row in 0..<rows {
            // Get data for current row
            var pixelData = memory[Int(index + UInt16(row))]
            
            // Iterate over all bits in the row data
            for column in 0..<UInt8(8) {
                // Look at MSB pixel and continue if it is 1
                if (pixelData & 0x80) != 0 {
                    registers[0xF] = screen.togglePixel(startX + column, y: startY + row)
                }
                
                // Shift pixels left to look at MSB during next iteration
                pixelData <<= 1
            }
        }
    }
}
