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
     Opcode *0NNN*

     Calls RCA 1802 program at address NNN. Not necessary for most ROMs.
     */
    case CallProgram(address: Address)

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

     Skips the next instruction if VX equals NN.
     */
    case SkipIfEqualValue(vx: Register, value: Constant)

    /**
     Opcode *4XNN*

     Skips the next instruction if VX doesn't equal NN.
     */
    case SkipIfNotEqualValue(vx: Register, value: Constant)

    /**
     Opcode *5XY0*

     Skips the next instruction if VX equals VY.
     */
    case SkipIfRegisterEqual(vx: Register, vy: Register)

    /**
     Opcode *6XNN*

     Sets VX to NN.
     */
    case SetValue(vx: Register, value: Constant)

    /**
     Opcode *7XNN*

     Adds NN to VX.
     */
    case AddValue(vx: Register, value: Constant)

    /**
     Opcode *8XY0*

     Sets VX to the Value of VY.
     */
    case SetRegister(vx: Register, vy: Register)

    /**
     Opcode *8XY1*

     Sets VX to VX | VY.
     */
    case OrRegister(vx: Register, vy: Register)

    /**
     Opcode *8XY2*

     Sets VX to VX & VY.
     */
    case AndRegister(vx: Register, vy: Register)

    /**
     Opcode *8XY3*

     Sets VX to VX ^ VY.
     */
    case XorRegister(vx: Register, vy: Register)

    /**
     Opcode *8XY4*

     Adds VY to VX. VF is set to 1 when there's a carry, and 0 when there isn't.
     */
    case AddRegister(vx: Register, vy: Register)

    /**
     Opcode *8XY5*

     VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
     */
    case SubtractYFromX(vx: Register, vy: Register)

    /**
     Opcode *8XY6*

     Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.
     */
    case ShiftRight(vx: Register)

    /**
     Opcode *8XY7*

     Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
     */
    case SubtractXFromY(vx: Register, vy: Register)

    /**
     Opcode *8XYE*

     Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.
     */
    case ShiftLeft(vx: Register)

    /**
     Opcode *9XY0*

     Skips the next instruction if VX doesn't equal VY
     */
    case SkipIfNotEqualRegister(vx: Register, vy: Register)

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

     Sets VX to the result of a bitwise AND operation on a random number and NN.
     */
    case AndRandom(vx: Register, value: Constant)

    /**
     Opcode *DXYN*

     Sprites stored in memory at location in index register (I), 8bits wide.

     Wraps around the screen.

     If when drawn, clears a pixel, register VF is set to 1 otherwise it is zero.

     All drawing is XOR drawing (i.e. it toggles the screen pixels).

     Sprites are drawn starting at position VX, VY.

     N is the number of 8bit rows that need to be drawn.

     If N is greater than 1, second line continues at position VX, VY+1, and so on.
     */
    case Draw(vx: Register, vy: Register, rows: Constant)

    /**
     Opcode *EX9E*

     Skips the next instruction if the key stored in VX is pressed.
     */
    case SkipIfKeyPressed(vx: Register)

    /**
     Opcode *EXA1*

     Skips the next instruction if the key stored in VX isn't pressed.
     */
    case SkipIfKeyNotPressed(vx: Register)

    /**
     Opcode *FX07*

     Sets VX to the value of the delay timer.
     */
    case StoreDelayTimer(vx: Register)

    /**
     Opcode *FX0A*

     Waits for a key press and stores it in VX.
     */
    case StoreKeyPress(vx: Register)

    /**
     Opcode *FX0A*

     Set the delay timer to the value of VX:
     */
    case SetDelayTimer(vx: Register)

    /**
     Opcode *FX18*

     Sets the sound timer to the value of VX:
     */
    case SetSoundTimer(vx: Register)

    /**
     Opcode *FX1E*

     VF is set to 1 when range overflow (I+VX>0xFFF), and 0 when there isn't. This is undocumented
     feature of the CHIP-8 and used by Spacefight 2091! game.
     */
    case AddIndex(vx: Register)

    /**
     Opcode *FX29*

     Sets I to the location of the sprite for the character in VX.
     */
    case SetIndexFontCharacter(vx: Register)

    /**
     Opcode *FX33*

     Stores the binary-coded decimal representation of VX, with the most significant of three digits
     at the address in I, the middle digit at I plus 1, and the least significant digit at I plus 2.

     In other words, takes the decimal representation of VX, places the hundreds digit in memory at
     location in I, the tens digit at location I+1, and the ones digit at location I+2.
     */
    case StoreBCD(vx: Register)

    /**
     Opcode *FX55*

     Stores V0 to VX (including VX) in memory starting at address I.
     */
    case WriteMemory(vx: Register)

    /**
     Opcode *FX65*

     Fills V0 to VX (including VX) with values from memory starting at address I.
     */
    case ReadMemory(vx: Register)

    /**

     */
    var rawOpcode: RawOpcode {
        switch self {

        case let .CallProgram(address):
            return address

        case .ClearScreen:
            return 0x00E0

        case .Return:
            return 0x00EE

        case let .JumpAbsolute(address):
            return (0x1 << 12) | address

        case let .CallSubroutine(address):
            return (0x2 << 12) | address

        case let .SkipIfEqualValue(vx, value):
            return (0x3 << 12) | (UInt16(vx) << 8) | UInt16(value)

        case let .SkipIfNotEqualValue(vx, value):
            return (0x4 << 12) | (UInt16(vx) << 8) | UInt16(value)

        case let .SkipIfRegisterEqual(vx, vy):
            return (0x5 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x0

        case let .SetValue(vx, value):
            return (0x6 << 12) | (UInt16(vx) << 8) | UInt16(value)

        case let .AddValue(vx, value):
            return (0x7 << 12) | (UInt16(vx) << 8) | UInt16(value)

        case let .SetRegister(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x0

        case let .OrRegister(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x1

        case let .AndRegister(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x2

        case let .XorRegister(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x3

        case let .AddRegister(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x4

        case let .SubtractYFromX(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x5

        case let .ShiftRight(vx):
            return (0x8 << 12) | (UInt16(vx) << 8) | 0x0 | 0x6

        case let .SubtractXFromY(vx, vy):
            return (0x8 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x7

        case let .ShiftLeft(vx):
            return (0x8 << 12) | (UInt16(vx) << 8) | 0x0 | 0xE

        case let .SkipIfNotEqualRegister(vx, vy):
            return (0x9 << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | 0x0

        case let .SetIndex(address):
            return (0xA << 12) | address

        case let .JumpRelative(address):
            return (0xB << 12) | address

        case let .AndRandom(vx, value):
            return (0xC << 12) | (UInt16(vx) << 8) | UInt16(value)

        case let .Draw(vx, vy, rows):
            return (0xD << 12) | (UInt16(vx) << 8) | (UInt16(vy) << 4) | UInt16(rows)

        case let .SkipIfKeyPressed(vx):
            return (0xE << 12) | (UInt16(vx) << 8) | 0x9E

        case let .SkipIfKeyNotPressed(vx):
            return (0xE << 12) | (UInt16(vx) << 8) | 0xA1

        case let .StoreDelayTimer(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x7

        case let .StoreKeyPress(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0xA

        case let .SetDelayTimer(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x15

        case let .SetSoundTimer(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x18

        case let .AddIndex(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x1E

        case let .SetIndexFontCharacter(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x29

        case let .StoreBCD(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x33

        case let .WriteMemory(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x55

        case let .ReadMemory(vx):
            return (0xF << 12) | (UInt16(vx) << 8) | 0x65

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

        case (0x1, _, _, _):
            self = .JumpAbsolute(address: rawOpcode & 0xFFF)

        case (0x2, _, _, _):
            self = .CallSubroutine(address: rawOpcode & 0xFFF)

        case let (0x3, vx, _, _):
            self = .SkipIfEqualValue(vx: vx, value: Constant(rawOpcode & 0xFF))

        case let (0x4, vx, _, _):
            self = .SkipIfNotEqualValue(vx: vx, value: Constant(rawOpcode & 0xFF))

        case let (0x5, vx, vy, _):
            self = .SkipIfRegisterEqual(vx: vx, vy: vy)

        case let (0x6, vx, _, _):
            self = .SetValue(vx: vx, value: Constant(rawOpcode & 0xFF))

        case let (0x7, vx, _, _):
            self = .AddValue(vx: vx, value: Constant(rawOpcode & 0xFF))

        case let (0x8, vx, vy, 0x0):
            self = .SetRegister(vx: vx, vy: vy)

        case let (0x8, vx, vy, 0x1):
            self = .OrRegister(vx: vx, vy: vy)

        case let (0x8, vx, vy, 0x2):
            self = .AndRegister(vx: vx, vy: vy)

        case let (0x8, vx, vy, 0x3):
            self = .XorRegister(vx: vx, vy: vy)

        case let (0x8, vx, vy, 0x4):
            self = .AddRegister(vx: vx, vy: vy)

        case let (0x8, vx, vy, 0x5):
            self = .SubtractYFromX(vx: vx, vy: vy)

        case let (0x8, vx, _, 0x6):
            self = .ShiftRight(vx: vx)

        case let (0x8, vx, vy, 0x7):
            self = .SubtractXFromY(vx: vx, vy: vy)

        case let (0x8, vx, _, 0xE):
            self = .ShiftLeft(vx: vx)

        case let (0x9, vx, vy, 0x0):
            self = .SkipIfNotEqualRegister(vx: vx, vy: vy)

        case (0xA, _, _, _):
            self = .SetIndex(address: rawOpcode & 0xFFF)

        case (0xB, _, _, _):
            self = .JumpRelative(address: rawOpcode & 0xFFF)

        case let (0xC, vx, _, _):
            self = .AndRandom(vx: vx, value: Constant(rawOpcode & 0xFF))

        case let (0xD, vx, vy, rows):
            self = .Draw(vx: vx, vy: vy, rows: rows)

        case let (0xE, vx, 0x9, 0xE):
            self = .SkipIfKeyPressed(vx: vx)
            
        case let (0xE, vx, 0xA, 0x1):
            self = .SkipIfKeyNotPressed(vx: vx)
            
        case let (0xF, vx, 0x0, 0x7):
            self = .StoreDelayTimer(vx: vx)
            
        case let (0xF, vx, 0x0, 0xA):
            self = .StoreKeyPress(vx: vx)
            
        case let (0xF, vx, 0x1, 0x5):
            self = .SetDelayTimer(vx: vx)
            
        case let (0xF, vx, 0x1, 0x8):
            self = .SetSoundTimer(vx: vx)
            
        case let (0xF, vx, 0x1, 0xE):
            self = .AddIndex(vx: vx)
            
        case let (0xF, vx, 0x2, 0x9):
            self = .SetIndexFontCharacter(vx: vx)
            
        case let (0xF, vx, 0x3, 0x3):
            self = .StoreBCD(vx: vx)
            
        case let (0xF, vx, 0x5, 0x5):
            self = .WriteMemory(vx: vx)
            
        case let (0xF, vx, 0x6, 0x5):
            self = .ReadMemory(vx: vx)
            
        default:
            return nil
            
        }
    }
}

extension Opcode: Comparable { }

func ==(lhs: Opcode, rhs: Opcode) -> Bool {
    return lhs.rawOpcode == rhs.rawOpcode
}

func <(lhs: Opcode, rhs: Opcode) -> Bool {
    return lhs.rawOpcode < rhs.rawOpcode
}
