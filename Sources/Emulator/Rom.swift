//
//  Rom.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 20/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

final class Rom {
    //MARK: Properties
    let bytes: [UInt8]

    //MARK: Initialization
    init(data: NSData) {
        let bytesPtr = unsafeBitCast(data.bytes, UnsafePointer<UInt8>.self)
        let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: data.length)
        self.bytes = [UInt8](bytesBufferPtr)
    }

    init(bytes: [UInt8]) {
        self.bytes = bytes
    }

    //TODO: init with array of Opcode objects

    //TODO: expose which keys are used in a particular ROM - scan through opcodes and look for EX9E, FX0A and EXA1 ?? so the view can signal to the user which keys are actually active in a given ROM
}
