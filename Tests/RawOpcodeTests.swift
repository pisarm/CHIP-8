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
    ///MARK: Setup
    let test: (UInt16) -> Void = {
        let opcode = Opcode(rawOpcode: $0)
        XCTAssertEqual(opcode!.rawOpcode, $0)
    }

    ///MARK: Test
    func testClearScreen() {
        test(0x00E0)
    }

    func testReturn() {
        test(0x00EE)
    }

    func testJumpAbsolute() {
        test(0x1111)
    }

    func testCallSubroutine() {
        test(0x2111)
    }

    func testSkipIfEqualValue() {
        test(0x3112)
    }

    func testSkipIfNotEqualValue() {
        test(0x4012)
    }

    func testSkipIfRegisterEqual() {
        test(0x5120)
    }

    func testSetValue() {
        test(0x6722)
    }

    func testAddValue() {
        test(0x7A22)
    }

    func testSetRegister() {
        test(0x8120)
    }

    func testOrRegister() {
        test(0x8401)
    }

    func testAndRegister() {
        test(0x8402)
    }

    func testXorRegister() {
        test(0x8403)
    }

    func testAddRegister() {
        test(0x8404)
    }

    func testSubtractYFromX() {
        test(0x8405)
    }

    func testShiftRight() {
        test(0x8406)
    }

    func testSubtractXFromY() {
        test(0x8347)
    }

    func testShiftLeft() {
        test(0x8A0E)
    }

    func testSkipIfNotEqualRegister() {
        test(0x9120)
    }

    func testSetIndex() {
        test(0xAABC)
    }

    func testJumpRelative() {
        test(0xBFED)
    }

    func testAndRandom() {
        test(0xCFAD)
    }

    func testDraw() {
        test(0xDEAD)
    }

    func testSkipIfKeyPressed() {
        test(0xED9E)
    }

    func testSkipIfKeyNotPressed() {
        test(0xEAA1)
    }

    func testStoreDelayTimer() {
        test(0xFB07)
    }

    func testStoreKeyPress() {
        test(0xF00A)
    }

    func testSetDelayTimer() {
        test(0xFA15)
    }

    func testSetSoundTimer() {
        test(0xFE18)
    }

    func testAddIndex() {
        test(0xF71E)
    }

    func testSetIndexFontCharacter() {
        test(0xF729)
    }

    func testStoreBCD() {
        test(0xF533)
    }

    func testWriteMemory() {
        test(0xF555)
    }

    func testReadMemory() {
        test(0xF765)
    }
}
