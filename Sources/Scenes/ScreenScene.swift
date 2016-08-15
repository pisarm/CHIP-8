//
//  EmulatorScene.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 02/07/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

final class ScreenScene: SKScene, HUDScene {
    private var pixels: [SKSpriteNode] = []

    //MARK: Initialization
    override init(size: CGSize) {
        super.init(size: size)

        setupHUD()
        setupScreen()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Setup
    private func setupHUD() {
        add(element: .upperRight)
    }

    private func setupScreen() {
        let pixelSide = size.width / CGFloat(Screen.columnCount)
        let pixelSize = CGSize(width: pixelSide, height: pixelSide)

        for row in 0..<Screen.rowCount {
            for col in 0..<Screen.columnCount {

                var color = UIColor.black
                //                if row == 0 || col == 0 || row == Screen.rowCount-1 || col == Screen.columnCount-1 {
                //                    color = UIColor.whiteColor()
                //                }

                let pixel = SKSpriteNode(color: color, size: pixelSize)
                pixel.position = CGPoint(
                    x: (CGFloat(col) * pixelSide) + (pixelSide / 2),
                    y: size.height - (pixelSide * CGFloat(row + 1)) + (pixelSide / 2)
                )
                pixel.zPosition = 1
                pixels.append(pixel)
            }
        }
        pixels.forEach { addChild($0) }
    }

}

extension ScreenScene: ScreenDelegate {
    //MARK: ScreenDelegate
    func refreshed(index: Int, withValue: Int) {
        pixels[index].color = withValue == 0 ? .black : .white
    }

    func reset() {
        pixels.forEach { $0.color = .black }
    }

}
