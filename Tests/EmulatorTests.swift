//
//  EmulatorTests.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 22/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import XCTest
@testable import CHIP_8

final class EmulatorTests: XCTestCase {
    //MARK: Tests
    func testCallProgram() {
        XCTFail()
    }

    func testClearScreen() {
        XCTFail()
    }

    func testReturn() {
        XCTFail()
    }

    func testJumpAbsolute() {
        let bytes: [UInt8] = [
            0x11, 0x23,
            ]

        XCTAssertEqual(emulate(bytes: bytes).pc, 0x123)
    }

    func testCallSubroutine() {
        XCTFail()
    }

    func testSkipIfEqualValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            0x30, 0x11,
            ]

        XCTAssertEqual(emulate(bytes: bytes).pc, 0x206)
    }

    func testSkipIfNotEqualValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            0x40, 0x12,
            ]

        XCTAssertEqual(emulate(bytes: bytes).pc, 0x206)
    }

    func testSkipIfRegisterEqual() {
        XCTFail()
    }

    func testSetValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            ]

        var expectedRegisters = [UInt8](repeating: 0, count: 16)
        expectedRegisters.replaceSubrange(0..<1, with: [0x11])

        XCTAssertEqual(emulate(bytes: bytes).registers, expectedRegisters)
    }

    func testAddValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            0x70, 0x1
            ]

        var expectedRegisters = [UInt8](repeating: 0, count: 16)
        expectedRegisters.replaceSubrange(0..<1, with: [0x12])

        XCTAssertEqual(emulate(bytes: bytes).registers, expectedRegisters)
    }

//    func testDraw() {
//        let bytes: [UInt8] = [
//            0x60, 0x11,
//        ]
//
//        var expectations = [UInt8](repeating: 0, count: Screen.size)
//
//        XCTFail()
//
//        XCTAssertEqual(emulate(bytes).screen.content, expectations)
//    }

    func testSkipIfKeyPressed() {
        XCTFail()
    }

    func testSkipIfKeyNotPressed() {
        XCTFail()
    }

    func testStoreDelayTimer() {
        XCTFail()
    }

    func testStoreKeyPress() {
        XCTFail()
    }

    func testSetDelayTimer() {
        XCTFail()
    }

    func testSoundTimer() {
        XCTFail()
    }

    func testAddIndex() {
        XCTFail()
    }

    func testSetIndexFontCharacter() {
        XCTFail()
    }

    func testStoreBCD() {
        XCTFail()
    }

    func testWriteMemory() {
        XCTFail()
    }

    func testReadMemory() {
        XCTFail()
    }

}

extension EmulatorTests {
    //MARK: Helpers

    func emulate(bytes: [UInt8]) -> Emulator {
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)

        var count = bytes.count / 2
        while count > 0 {
            emulator.cycle()
            count = count - 1
        }

        return emulator
    }

}
