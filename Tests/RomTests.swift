//
//  RomTests.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 20/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import XCTest
@testable import CHIP_8

final class RomTests: XCTestCase {
    ///MARK: Properties
    let bytes: [UInt8] = [0x67, 0x22]

    ///MARK: Tests
    func testInitData() {
        let data = NSData(bytes: bytes, length: bytes.count)
        let rom = Rom(name: "dummy", data: data)
        XCTAssertEqual(rom.bytes, bytes)
    }

    func testInitBytes() {
        let rom = Rom(name: "dummy", bytes: bytes)
        XCTAssertEqual(rom.bytes, bytes)
    }
}
