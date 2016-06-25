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
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)

        run(emulator, bytes: bytes)

        XCTAssertEqual(emulator.pc, 0x123)
    }

    func testCallSubroutine() {
        XCTFail()
    }

    func testSkipIfEqualValue() {
        XCTFail()
    }

    func testSkipIfNotEqualValue() {
        XCTFail()
    }

    func testSkipIfRegisterEqual() {
        XCTFail()
    }

    func testSetValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            ]
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)

        run(emulator, bytes: bytes)

        var expectedRegisters = [UInt8](count: 16, repeatedValue: 0)
        expectedRegisters.replaceRange(0..<1, with: [0x11])

        XCTAssertEqual(emulator.registers, expectedRegisters)
    }

    func testAddValue() {
        let bytes: [UInt8] = [
            0x60, 0x11,
            0x70, 0x1
            ]
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)

        run(emulator, bytes: bytes)

        var expectedRegisters = [UInt8](count: 16, repeatedValue: 0)
        expectedRegisters.replaceRange(0..<1, with: [0x12])

        XCTAssertEqual(emulator.registers, expectedRegisters)
    }

    func testDraw() {
        let bytes: [UInt8] = [
            0x60, 0x11,
        ]
        let rom = Rom(bytes: bytes)
        let emulator = Emulator(rom: rom)

        run(emulator, bytes: bytes)

        var expectations = [UInt8](count: Emulator.Screen.size, repeatedValue: 0)


//        var expectedRegisters = [UInt8](count: 16, repeatedValue: 0)
//        expectedRegisters.replaceRange(0..<1, with: [0x12])

        XCTAssertEqual(emulator.screen, expectations)
    }
}

extension EmulatorTests {
    //MARK: Helpers
    func run(emulator: Emulator, bytes: [UInt8]) {
        var count = bytes.count / 2
        while count > 0 {
            emulator.begin()
            count = count - 1
        }
    }
}