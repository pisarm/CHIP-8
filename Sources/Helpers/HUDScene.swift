//
//  HUDScene.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

enum HUDElement {
    case upperLeft
    case upperRight
    case lowerRight
    case lowerLeft
}

protocol HUDScene {
    func add(element: HUDElement)
}

extension HUDScene where Self: SKScene {
    func add(element: HUDElement) {

        let position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        let size = CGSize(width: 75, height: 40)
        let handler: (_ button: ButtonNode) -> Void = { print("\($0)") }
        let button = ButtonNode(withPosition: position, size: size, text: "Fisk", handler: handler)
        button.textNode.fontSize = 17.0
        button.zPosition = 15

        addChild(button)
    }
}
