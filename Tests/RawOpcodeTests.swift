//
//  RawOpcodeTests.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 18/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import XCTest
@testable import CHIP_8

final class RawOpcodeTests: XCTestCase {
    //MARK: Setup
    let test: (rawOpcode: UInt16) -> Void = {
        let opcode = Opcode(rawOpcode: $0)
        XCTAssertEqual(opcode!.rawOpcode, $0)
    }

    //MARK: Test
    func testClearScreen() {
        test(rawOpcode: 0x00E0)
    }

    func testReturn() {
        test(rawOpcode: 0x00EE)
    }

    func testJumpAbsolute() {
        test(rawOpcode: 0x1111)
    }

    func testCallSubroutine() {
        test(rawOpcode: 0x2111)
    }

    func testSkipIfEqualValue() {
        test(rawOpcode: 0x3112)
    }

    func testSkipIfNotEqualValue() {
        test(rawOpcode: 0x4012)
    }

    func testSkipIfRegisterEqual() {
        test(rawOpcode: 0x5120)
    }

    func testSetValue() {
        test(rawOpcode: 0x6722)
    }

    func testAddValue() {
        test(rawOpcode: 0x7A22)
    }

    func testSetRegister() {
        test(rawOpcode: 0x8120)
    }

    func testOrRegister() {
        test(rawOpcode: 0x8401)
    }

    func testAndRegister() {
        test(rawOpcode: 0x8402)
    }

    func testXorRegister() {
        test(rawOpcode: 0x8403)
    }

    func testAddRegister() {
        test(rawOpcode: 0x8404)
    }

    func testSubtractYFromX() {
        test(rawOpcode: 0x8405)
    }

    func testShiftRight() {
        test(rawOpcode: 0x8406)
    }

    func testSubtractXFromY() {
        test(rawOpcode: 0x8347)
    }

    func testShiftLeft() {
        test(rawOpcode: 0x8A0E)
    }

    func testSkipIfNotEqualRegister() {
        test(rawOpcode: 0x9120)
    }

    func testSetIndex() {
        test(rawOpcode: 0xAABC)
    }

    func testJumpRelative() {
        test(rawOpcode: 0xBFED)
    }

    func testAndRandom() {
        test(rawOpcode: 0xCFAD)
    }

    func testDraw() {
        test(rawOpcode: 0xDEAD)
    }

    func testSkipIfKeyPressed() {
        test(rawOpcode: 0xED9E)
    }

    func testSkipIfKeyNotPressed() {
        test(rawOpcode: 0xEAA1)
    }

    func testStoreDelayTimer() {
        test(rawOpcode: 0xFB07)
    }

    func testStoreKeyPress() {
        test(rawOpcode: 0xF00A)
    }

    func testSetDelayTimer() {
        test(rawOpcode: 0xFA15)
    }

    func testSetSoundTimer() {
        test(rawOpcode: 0xFE18)
    }

    func testAddIndex() {
        test(rawOpcode: 0xF71E)
    }

    func testSetIndexFontCharacter() {
        test(rawOpcode: 0xF729)
    }

    func testStoreBCD() {
        test(rawOpcode: 0xF533)
    }

    func testWriteMemory() {
        test(rawOpcode: 0xF555)
    }

    func testReadMemory() {
        test(rawOpcode: 0xF765)
    }
}
