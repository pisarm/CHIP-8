//
//  Screen.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 02/07/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

struct Screen {
    static let columnCount = 64
    static let rowCount = 32

    private (set) var pixels: [UInt8]

    //MARK: Initialization
    init() {
        (pixels) = Screen.commonInit()
    }

    private static func commonInit() -> ([UInt8]) {
        return [UInt8](count: Int(Screen.rowCount) * Int(Screen.columnCount), repeatedValue: 0)
    }

    /**
     Reset the screen.

     Internal data structure is set to all zeros
     */
    mutating func reset() {
        (pixels) = Screen.commonInit()
    }

    /**
     Toggle the pixel at the specified coordinate.

     - parameter x: X coordinate of the point to toggle
     - parameter y: Y coordinate of the point to toggle
     - returns: Value of pixel **prior** to being toggled
     */
    mutating func togglePixel(x: Int, y: Int) -> UInt8 {
        let sx = x % Screen.columnCount
        let sy = y % Screen.rowCount
        let index = (Int(sy) * Int(Screen.columnCount)) + Int(sx)

        let value = pixels[index]
        pixels[index] ^= 1
        return value
    }

    /**
     Get the value of the pixel at the specified coordinate.

     - parameter x: X-coordinate of the point to get
     - parameter y: Y-coordinate of the point to get

     - returns: Value of the pixel at x, y
     */
    subscript (x: Int, y: Int) -> UInt8 {
        get {
            let sx = x % Screen.columnCount
            let sy = y % Screen.rowCount
            let index = (Int(sy) * Int(Screen.columnCount)) + Int(sx)

            return pixels[index]
        }
    }
}
