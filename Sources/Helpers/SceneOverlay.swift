//
//  SceneOverlay.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

struct SceneOverlayElement {
    let elementType: SceneOverlayType.ElementType
    let location: SceneOverlayType.Location
}

enum SceneOverlayType {
    enum ElementType {
        case button(action: ButtonNode.ButtonAction, text: String)
        case label(text: String)

        func size(in frame: CGRect) -> CGSize {
            return SceneOverlayType.sizeCalc(in: frame)
        }
    }

    enum Location {
        case topLeft
        case top
        case topRight
        case bottomRight
        case bottomLeft

        private static let margin: CGFloat = 8
        private static let offsetMargin: CGFloat = Location.margin * 2

        func position(for index: Int, in frame: CGRect) -> CGPoint {
            let size = SceneOverlayType.sizeCalc(in: frame)
            let halfHeight: CGFloat = size.height / 2
            let halfWidth: CGFloat = size.width / 2

            switch self {
            case .topLeft:
                let yIndexOffset = ((size.height + Location.offsetMargin) * CGFloat(index))
                let x: CGFloat = Location.margin + halfWidth
                let y: CGFloat = frame.size.height - halfHeight - Location.margin - yIndexOffset
                return CGPoint(x: round(x), y: round(y))

            case .top:
                let yIndexOffset = ((size.height + Location.offsetMargin) * CGFloat(index))
                let x: CGFloat = frame.size.width / 2 + halfWidth
                let y: CGFloat = frame.size.height - halfHeight - Location.margin - yIndexOffset
                return CGPoint(x: round(x), y: round(y))

            case .topRight:
                let yIndexOffset = ((size.height + Location.offsetMargin) * CGFloat(index))
                let x: CGFloat = frame.size.width - halfWidth - Location.margin
                let y: CGFloat = frame.size.height - halfHeight - Location.margin - yIndexOffset
                return CGPoint(x: round(x), y: round(y))

            case .bottomRight:
                let yIndexOffset = ((size.height + Location.offsetMargin) * CGFloat(index))
                let x: CGFloat = frame.size.width - halfWidth - Location.margin
                let y: CGFloat = Location.margin + halfHeight + yIndexOffset
                return CGPoint(x: round(x), y: round(y))

            case .bottomLeft:
                let yIndexOffset = ((size.height + Location.offsetMargin) * CGFloat(index))
                let x: CGFloat = Location.margin + halfWidth
                let y: CGFloat = Location.margin + halfHeight + yIndexOffset
                return CGPoint(x: round(x), y: round(y))
            }
        }
    }

    ///MARK:
    private static func sizeCalc(in frame: CGRect) -> CGSize {
        return CGSize(width: frame.size.width * 0.1, height: frame.size.height * 0.1)
    }
}

protocol SceneOverlay {
    func add(_ element: SceneOverlayType.ElementType, at location: SceneOverlayType.Location)
    func add(_ elements: [SceneOverlayType.ElementType], at location: SceneOverlayType.Location)
}

extension SceneOverlay where Self: SKScene {
    ///MARK: SceneOverlay
    func add(_ element: SceneOverlayType.ElementType, at location: SceneOverlayType.Location) {
        add([element], at: location)
    }

    func add(_ elements: [SceneOverlayType.ElementType], at location: SceneOverlayType.Location) {
        for (index, elementType) in elements.enumerated() {
            switch elementType {
            case let .button(action, text):
                let button = ButtonNode(with: location.position(for: index, in: frame), size: elementType.size(in: frame), text: text, action: action)
                button.name = text
                button.zPosition = 2
                button.textNode.fontSize = 17.0
                button.textNode.fontName = "SanFranciscoDisplay-Regular"
                addChild(button)

            case let .label(text):
                let label = SKLabelNode()
                label.position = location.position(for: index, in: frame)
                label.text = text
                label.name = text
                label.zPosition = 2
                label.fontSize = 17.0
                label.fontName = "SanFranciscoDisplay-Regular"
                addChild(label)
            }
        }
    }
}
