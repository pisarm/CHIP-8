//
//  HUD.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

enum HUDElement {

    private static func sizeCalc(in frame: CGRect) -> CGSize {
        return CGSize(width: frame.size.width * 0.1, height: frame.size.height * 0.1)
    }

    enum Variety {
        case button(handler: ButtonNode.ButtonHandler)
        case label

        func size(in frame: CGRect) -> CGSize {
            return HUDElement.sizeCalc(in: frame)
        }
    }

    enum Location {
        case topLeft
        case top
        case topRight
        case bottomRight
        case bottomLeft

        private static let margin: CGFloat = 8

        func position(in frame: CGRect) -> CGPoint {
            let size = HUDElement.sizeCalc(in: frame)
            let halfHeight: CGFloat = size.height / 2
            let halfWidth: CGFloat = size.width / 2

            switch self {
            case .topLeft:
                let x: CGFloat = Location.margin + halfWidth
                let y: CGFloat = frame.size.height - halfHeight - Location.margin
                return CGPoint(x: x, y: y)

            case .top:
                let x: CGFloat = frame.size.width / 2 + halfWidth
                let y: CGFloat = frame.size.height - halfHeight - Location.margin
                return CGPoint(x: x, y: y)

            case .topRight:
                let x: CGFloat = frame.size.width - halfWidth - Location.margin
                let y: CGFloat = frame.size.height - halfHeight - Location.margin
                return CGPoint(x: x, y: y)

            case .bottomRight:
                let x: CGFloat = frame.size.width - halfWidth - Location.margin
                let y: CGFloat = Location.margin + halfHeight
                return CGPoint(x: x, y: y)

            case .bottomLeft:
                let x: CGFloat = Location.margin + halfWidth
                let y: CGFloat = Location.margin + halfHeight
                return CGPoint(x: x, y: y)
            }
        }
    }
}

protocol HUD {
    func add(element variety: HUDElement.Variety, location: HUDElement.Location, text: String)
}

extension HUD where Self: SKScene {
    func add(element variety: HUDElement.Variety, location: HUDElement.Location, text: String) {
        switch variety {
        case .button(let handler):
            let button = ButtonNode(with: location.position(in: frame), size: variety.size(in: frame), text: text, handler: handler)
            button.name = text
            button.zPosition = 2
            button.textNode.fontSize = 17.0
            button.textNode.fontName = "SanFranciscoDisplay-Regular"
            addChild(button)

        case .label:
            let label = SKLabelNode()
            label.position = location.position(in: frame)
            label.text = text
            label.name = text
            label.zPosition = 2
            label.fontSize = 17.0
            label.fontName = "SanFranciscoDisplay-Regular"
            addChild(label)
        }
    }

}
