//
//  Screen.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 02/07/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

protocol ScreenDelegate: class {
    func refreshed(index: Int, withValue: Int)
    func reset()
}

final class Screen {
    //MARK: Properties
    static let columnCount = 64
    static let rowCount = 32

    weak var delegate: ScreenDelegate?

    private var pixels: [UInt8]

    //MARK: Initialization
    init() {
        (pixels) = Screen.commonInit()
    }

    private static func commonInit() -> ([UInt8]) {
        return [UInt8](repeating: 0, count: Int(Screen.rowCount) * Int(Screen.columnCount))
    }

    /**
     Reset the screen.

     Internal data structure is set to all zeros
     */
    func reset() {
        (pixels) = Screen.commonInit()
        delegate?.reset()
    }

    /**
     Toggle the pixel at the specified coordinate.

     - parameter x: X coordinate of the point to toggle
     - parameter y: Y coordinate of the point to toggle
     - returns: Value of pixel **prior** to being toggled
     */
    func togglePixel(x: Int, y: Int) -> UInt8 {
        let sx = x % Screen.columnCount
        let sy = y % Screen.rowCount
        let index = (Int(sy) * Int(Screen.columnCount)) + Int(sx)

        let value = pixels[index]
        pixels[index] ^= 1

        let newValue = Int(pixels[index])
        delegate?.refreshed(index: index, withValue: newValue)

        return value
    }
}
