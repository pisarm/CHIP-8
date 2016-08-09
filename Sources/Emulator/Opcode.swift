//
//  Opcode.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

enum Opcode {
    //MARK: Typealiases
    typealias Address = UInt16
    typealias Register = UInt8
    typealias Constant = UInt8

    typealias RawOpcode = UInt16

    /**
     Opcode *00E0*

     Clears the screen.
     */
    case ClearScreen

    /**
     Opcode *00EE*

     Returns from a subroutine.
     */
    case Return

    /**
     Opcode *0NNN*

     Calls RCA 1802 program at address NNN. Not necessary for most ROMs.
     */
    case CallProgram(address: Address)

    /**
     Opcode *1NNN*

     Jumps to address NNN.
     */
    case JumpAbsolute(address: Address)

    /**
     Opcode *2NNN*

     Calls subroutine at NNN.
     */
    case CallSubroutine(address: Address)

    /**
     Opcode *3XNN*

     Skips the next instruction if register X equals NN.
     */
    case SkipIfEqualValue(x: Register, value: Constant)

    /**
     Opcode *4XNN*

     Skips the next instruction if register X doesn't equal NN.
     */
    case SkipIfNotEqualValue(x: Register, value: Constant)

    /**
     Opcode *5XY0*

     Skips the next instruction if register X equals register Y.
     */
    case SkipIfRegisterEqual(x: Register, y: Register)

    /**
     Opcode *6XNN*

     Sets register X to NN.
     */
    case SetValue(x: Register, value: Constant)

    /**
     Opcode *7XNN*

     Adds NN to register X.
     */
    case AddValue(x: Register, value: Constant)

    /**
     Opcode *8XY0*

     Sets register X to the value of register Y.
     */
    case SetRegister(x: Register, y: Register)

    /**
     Opcode *8XY1*

     Sets register X to register X | register Y.
     */
    case OrRegister(x: Register, y: Register)

    /**
     Opcode *8XY2*

     Sets register X to register X & register Y.
     */
    case AndRegister(x: Register, y: Register)

    /**
     Opcode *8XY3*

     Sets register X to register X ^ register Y.
     */
    case XorRegister(x: Register, y: Register)

    /**
     Opcode *8XY4*

     Adds register Y to register X. Register F is set to 1 when there's a carry, and 0 when there
     isn't.
     */
    case AddRegister(x: Register, y: Register)

    /**
     Opcode *8XY5*

     Register Y is subtracted from register X. Register F is set to 0 when there's a borrow, and 1
     when there isn't.
     */
    case SubtractYFromX(x: Register, y: Register)

    /**
     Opcode *8XY6*

     Shifts register X right by one. Register F is set to the value of the least significant bit of
     register X before the shift.
     */
    case ShiftRight(x: Register)

    /**
     Opcode *8XY7*

     Sets register X to register Y minus register X. Register F is set to 0 when there's a borrow,
     and 1 when there isn't.
     */
    case SubtractXFromY(x: Register, y: Register)

    /**
     Opcode *8XYE*

     Shifts register X left by one. Register F is set to the value of the most significant bit of
     register X before the shift.
     */
    case ShiftLeft(x: Register)

    /**
     Opcode *9XY0*

     Skips the next instruction if register X doesn't equal register Y
     */
    case SkipIfNotEqualRegister(x: Register, y: Register)

    /**
     Opcode *ANNN*
     */
    case SetIndex(address: Address)

    /**
     Opcode *BNNN*

     Jumps to the address NNN plus V0.
     */
    case JumpRelative(address: Address)

    /**
     Opcode *CXNN*

     Sets register X to the result of a bitwise AND operation on a random number and NN.
     */
    case AndRandom(x: Register, value: Constant)

    /**
     Opcode *DXYN*

     Sprites stored in memory at location in index register (I), 8bits wide.

     Wraps around the screen.

     If when drawn, clears a pixel, register F is set to 1 otherwise it is zero.

     All drawing is XOR drawing (i.e. it toggles the screen pixels).

     Sprites are drawn starting at position register X, register Y.

     N is the number of 8bit rows that need to be drawn.

     If N is greater than 1, second line continues at position register X, register Y+1, and so on.
     */
    case Draw(x: Register, y: Register, rows: Constant)

    /**
     Opcode *EX9E*

     Skips the next instruction if the key stored in register X is pressed.
     */
    case SkipIfKeyPressed(x: Register)

    /**
     Opcode *EXA1*

     Skips the next instruction if the key stored in register X isn't pressed.
     */
    case SkipIfKeyNotPressed(x: Register)

    /**
     Opcode *FX07*

     Sets register X to the value of the delay timer.
     */
    case StoreDelayTimer(x: Register)

    /**
     Opcode *FX0A*

     Waits for a key press and stores it in register X.
     */
    case StoreKeyPress(x: Register)

    /**
     Opcode *FX0A*

     Set the delay timer to the value of register X.
     */
    case SetDelayTimer(x: Register)

    /**
     Opcode *FX18*

     Sets the sound timer to the value of register X.
     */
    case SetSoundTimer(x: Register)

    /**
     Opcode *FX1E*

     Register F is set to 1 when range overflow (I+x>0xFFF), and 0 when there isn't. This is an
     undocumented feature of the CHIP-8 and used by Spacefight 2091! game.
     */
    case AddIndex(x: Register)

    /**
     Opcode *FX29*

     Sets register I to the location of the sprite for the character in register X.
     */
    case SetIndexFontCharacter(x: Register)

    /**
     Opcode *FX33*

     Stores the binary-coded decimal representation of register X, with the most significant of
     three digits at the address in register I, the middle digit at register I plus 1, and the least
     significant digit at register I plus 2.

     In other words, takes the decimal representation of register X, places the hundreds digit in
     memory at location in register I, the tens digit at location register I+1, and the ones digit
     at location register I+2.
     */
    case StoreBCD(x: Register)

    /**
     Opcode *FX55*

     Stores register 0 to register X (including register X) in memory starting at the address stored
     in register I.
     */
    case WriteMemory(x: Register)

    /**
     Opcode *FX65*

     Fills register 0 to register X (including register X) with values from memory starting at the
     address stored in register I.
     */
    case ReadMemory(x: Register)

    /**

     */
    var rawOpcode: RawOpcode {
        switch self {

        case .ClearScreen:
            return 0x00E0

        case .Return:
            return 0x00EE

        case let .CallProgram(address):
            return address

        case let .JumpAbsolute(address):
            return (0x1 << 12) | address

        case let .CallSubroutine(address):
            return (0x2 << 12) | address

        case let .SkipIfEqualValue(x, value):
            return (0x3 << 12) | (UInt16(x) << 8) | UInt16(value)

        case let .SkipIfNotEqualValue(x, value):
            return (0x4 << 12) | (UInt16(x) << 8) | UInt16(value)

        case let .SkipIfRegisterEqual(x, y):
            return (0x5 << 12) | (UInt16(x) << 8) | (UInt16(y) << 4)

        case let .SetValue(x, value):
            return (0x6 << 12) | (UInt16(x) << 8) | UInt16(value)

        case let .AddValue(x, value):
            return (0x7 << 12) | (UInt16(x) << 8) | UInt16(value)

        case let .SetRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)

        case let .OrRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x1

        case let .AndRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x2

        case let .XorRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x3

        case let .AddRegister(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x4

        case let .SubtractYFromX(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x5

        case let .ShiftRight(x):
            return (0x8 << 12) | (UInt16(x) << 8) | 0x6

        case let .SubtractXFromY(x, y):
            return (0x8 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8) | 0x7

        case let .ShiftLeft(x):
            return (0x8 << 12) | (UInt16(x) << 8) | 0xE

        case let .SkipIfNotEqualRegister(x, y):
            return (0x9 << 12) | (UInt16(x) << 8) | (UInt16(y) << 8)

        case let .SetIndex(address):
            return (0xA << 12) | address

        case let .JumpRelative(address):
            return (0xB << 12) | address

        case let .AndRandom(x, value):
            return (0xC << 12) | (UInt16(x) << 8) | UInt16(value)

        case let .Draw(x, vy, rows):
            return (0xD << 12) | (UInt16(x) << 8) | (UInt16(vy) << 8) | UInt16(rows)

        case let .SkipIfKeyPressed(x):
            return (0xE << 12) | (UInt16(x) << 8) | 0x9E

        case let .SkipIfKeyNotPressed(x):
            return (0xE << 12) | (UInt16(x) << 8) | 0xA1

        case let .StoreDelayTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x7

        case let .StoreKeyPress(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0xA

        case let .SetDelayTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x15

        case let .SetSoundTimer(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x18

        case let .AddIndex(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x1E

        case let .SetIndexFontCharacter(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x29

        case let .StoreBCD(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x33

        case let .WriteMemory(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x55

        case let .ReadMemory(x):
            return (0xF << 12) | (UInt16(x) << 8) | 0x65

        }
    }

    init?(rawOpcode: RawOpcode) {
        let nibble1 = UInt8((rawOpcode & 0xF000) >> 12)
        let nibble2 = UInt8((rawOpcode & 0x0F00) >> 8)
        let nibble3 = UInt8((rawOpcode & 0x00F0) >> 4)
        let nibble4 = UInt8(rawOpcode & 0x000F)

        switch (nibble1, nibble2, nibble3, nibble4) {

        case (0x0, 0x0, 0xE, 0x0):
            self = .ClearScreen

        case (0x0, 0x0, 0xE, 0xE):
            self = .Return

        case (0x0, _, _, _):
            self = .CallProgram(address: rawOpcode & 0xFFF)

        case (0x1, _, _, _):
            self = .JumpAbsolute(address: rawOpcode & 0xFFF)

        case (0x2, _, _, _):
            self = .CallSubroutine(address: rawOpcode & 0xFFF)

        case let (0x3, x, _, _):
            self = .SkipIfEqualValue(x: x, value: Constant(rawOpcode & 0xFF))

        case let (0x4, x, _, _):
            self = .SkipIfNotEqualValue(x: x, value: Constant(rawOpcode & 0xFF))

        case let (0x5, x, y, _):
            self = .SkipIfRegisterEqual(x: x, y: y)

        case let (0x6, x, _, _):
            self = .SetValue(x: x, value: Constant(rawOpcode & 0xFF))

        case let (0x7, x, _, _):
            self = .AddValue(x: x, value: Constant(rawOpcode & 0xFF))

        case let (0x8, x, y, 0x0):
            self = .SetRegister(x: x, y: y)

        case let (0x8, x, y, 0x1):
            self = .OrRegister(x: x, y: y)

        case let (0x8, x, y, 0x2):
            self = .AndRegister(x: x, y: y)

        case let (0x8, x, y, 0x3):
            self = .XorRegister(x: x, y: y)

        case let (0x8, x, y, 0x4):
            self = .AddRegister(x: x, y: y)

        case let (0x8, x, y, 0x5):
            self = .SubtractYFromX(x: x, y: y)

        case let (0x8, x, _, 0x6):
            self = .ShiftRight(x: x)

        case let (0x8, x, y, 0x7):
            self = .SubtractXFromY(x: x, y: y)

        case let (0x8, x, _, 0xE):
            self = .ShiftLeft(x: x)

        case let (0x9, x, y, 0x0):
            self = .SkipIfNotEqualRegister(x: x, y: y)

        case (0xA, _, _, _):
            self = .SetIndex(address: rawOpcode & 0xFFF)

        case (0xB, _, _, _):
            self = .JumpRelative(address: rawOpcode & 0xFFF)

        case let (0xC, x, _, _):
            self = .AndRandom(x: x, value: Constant(rawOpcode & 0xFF))

        case let (0xD, x, y, rows):
            self = .Draw(x: x, y: y, rows: rows)

        case let (0xE, x, 0x9, 0xE):
            self = .SkipIfKeyPressed(x: x)

        case let (0xE, x, 0xA, 0x1):
            self = .SkipIfKeyNotPressed(x: x)

        case let (0xF, x, 0x0, 0x7):
            self = .StoreDelayTimer(x: x)

        case let (0xF, x, 0x0, 0xA):
            self = .StoreKeyPress(x: x)

        case let (0xF, x, 0x1, 0x5):
            self = .SetDelayTimer(x: x)

        case let (0xF, x, 0x1, 0x8):
            self = .SetSoundTimer(x: x)

        case let (0xF, x, 0x1, 0xE):
            self = .AddIndex(x: x)

        case let (0xF, x, 0x2, 0x9):
            self = .SetIndexFontCharacter(x: x)

        case let (0xF, x, 0x3, 0x3):
            self = .StoreBCD(x: x)

        case let (0xF, x, 0x5, 0x5):
            self = .WriteMemory(x: x)

        case let (0xF, x, 0x6, 0x5):
            self = .ReadMemory(x: x)

        default:
            return nil

        }
    }
}

extension Opcode: Comparable {
    //MARK: Comparable
    static func == (lhs: Opcode, rhs: Opcode) -> Bool {
        return lhs.rawOpcode == rhs.rawOpcode
    }

    static func < (lhs: Opcode, rhs: Opcode) -> Bool {
        return lhs.rawOpcode < rhs.rawOpcode
    }
}
