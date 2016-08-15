//
//  ButtonNode.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 15/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

final class ButtonNode: SKNode {
    //MARK: Typealiases
    typealias ButtonHandler = (button: ButtonNode) -> Void

    //MARK: Properties
    private let backgroundNode: SKShapeNode
    let textNode: SKLabelNode
    private let handler: ButtonHandler

    //MARK: Initialization
    init(withPosition position: CGPoint, size: CGSize, text: String, handler: ButtonHandler) {
        (self.backgroundNode, self.textNode) = ButtonNode.commonInit(size: size, text: text)
        self.handler = handler

        super.init()

        self.position = position
        isUserInteractionEnabled = true

        addChild(backgroundNode)
        addChild(textNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Setup
    private static func commonInit(size: CGSize, text: String) -> (SKShapeNode, SKLabelNode) {
        let backgroundNode = SKShapeNode(rectOf: size)
        backgroundNode.fillColor = .purple

        let textNode = SKLabelNode()
        textNode.horizontalAlignmentMode = .center
        textNode.verticalAlignmentMode = .center
        textNode.text = text

        return (backgroundNode, textNode)
    }
}

extension ButtonNode {
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textNode.run(SKAction.scale(to: 0.9, duration: 0.09))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        if !contains(location) {
            textNode.run(SKAction.scale(to: 1.0, duration: 0.06))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //FIXME: This is not working according to plan
        textNode.run(SKAction.scale(to: 1.0, duration: 0.06), completion: {
            guard let touch = touches.first else {
                return
            }

            let location = touch.location(in: self)
            if self.contains(location) {
                self.handler(button: self)
            }
        })
    }
}
