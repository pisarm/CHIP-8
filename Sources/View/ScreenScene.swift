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

final class ScreenScene: SKScene {
    var screen: Screen {
        didSet {
            for (index, pixel) in screen.pixels.enumerate() {
                self.pixels[index].color = pixel == 0 ? .blackColor() : .whiteColor()
            }
        }
    }

    //TODO: 
    // Optimize by not drawing black pixels - have a dictionary instead, where the index is the key
    // 0 = remove from dictionary, 1 = add to dictionary
    // - remember to have method for calculating x,y from index (see Screen struct)
    var pixels: [SKSpriteNode] = []

    init(size: CGSize, screen: Screen) {
        self.screen = screen

        super.init(size: size)

        let pixelSide = size.width / CGFloat(Screen.columnCount)
        let pixelSize = CGSize(width: pixelSide, height: pixelSide)

        for row in 0..<Screen.rowCount {
            for col in 0..<Screen.columnCount {

                var color = UIColor.blackColor()
//                if row == 0 || col == 0 || row == Screen.rowCount-1 || col == Screen.columnCount-1 {
//                    color = UIColor.whiteColor()
//                }

                let pixel = SKSpriteNode(color: color, size: pixelSize)
                pixel.position = CGPoint(
                    x: (CGFloat(col) * pixelSide) + (pixelSide / 2),
                    y: size.height - (pixelSide * CGFloat(row + 1)) + (pixelSide / 2)
                )
                pixels.append(pixel)
            }

        }
        pixels.forEach { addChild($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func didMoveToView(view: SKView) {
//        
//    }
}
