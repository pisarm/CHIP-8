//
//  Rom.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 20/06/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

struct Rom {
    //MARK: Properties
    let name: String
    let bytes: [UInt8]

    //MARK: Initialization
    init(name: String, data: NSData) {
        self.name = name
        
        let bytesPtr = unsafeBitCast(data.bytes, to: UnsafePointer<UInt8>.self)
        let bytesBufferPtr = UnsafeBufferPointer(start: bytesPtr, count: data.length)
        self.bytes = [UInt8](bytesBufferPtr)

//        findKeys()
    }

//    private func findKeys() {
//        for index in 0.stride(to: bytes.count, by: 2) {
//            let rawOpcode = (Opcode.Address(bytes[index]) << 8) | (Opcode.Address(bytes[index + 1]))
//            guard let opcode = Opcode(rawOpcode: rawOpcode) else {
//                print("Invalid opcode: 0x\(String(rawOpcode, radix: 16, uppercase: true))")
//                continue
//            }
//
//            switch opcode {
//            case let .SetValue(x, value):
//                print("V\(x) = \(value)")
//            case let .SkipIfKeyPressed(x):
//                print("pressed : V\(x)")
//            case let .SkipIfKeyNotPressed(x):
//                print("!pressed : V\(x)")
//            default:
//                break
//            }
//
//
//        }
//    }

    //TODO: init with array of Opcode objects

    //TODO: expose which keys are used in a particular ROM - scan through opcodes and look for EX9E, FX0A and EXA1 ?? so the view can signal to the user which keys are actually active in a given ROM

    /*
     
     Iterate over bytes
     grab a pair of bytes in every iteration
     if they match the above - find out what value the referenced register has at the time (perhaps run some part(full?) emulation?)

     */
}

//extension Rom {
//    static func loadAll() throws -> [Rom] {
//        let bundleUrl = Bundle(for: self.dynamicType).bundleURL
//
//            let urls = try FileManager.default.contentsOfDirectory(at: bundleUrl, includingPropertiesForKeys: [], options: [])
//            let romUrls = urls.filter { $0.pathExtension == "ch8" }
//            let romData = try romUrls.map { try Data(contentsOf: $0) }
//            return romData.map { Rom(data: $0) }
//    }
//}
