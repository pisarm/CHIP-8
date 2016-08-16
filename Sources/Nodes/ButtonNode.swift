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
    //MARK:
    fileprivate enum ButtonState {
        case active
        case inactive
    }

    //MARK: Typealiases
    typealias ButtonHandler = (ButtonNode) -> Void

    //MARK: Properties

    private let backgroundNode: SKShapeNode
    let textNode: SKLabelNode
    fileprivate let handler: ButtonHandler
    fileprivate var state: ButtonState {
        didSet {
            switch state {
            case .active:
                run(SKAction.scale(to: 0.8, duration: 0.09))
            case .inactive:
                run(SKAction.scale(to: 1.0, duration: 0.09))
            }
        }
    }

    //MARK: Initialization
    init(withPosition position: CGPoint, size: CGSize, text: String, handler: ButtonHandler) {
        (self.backgroundNode, self.textNode) = ButtonNode.commonInit(size: size, text: text)
        self.handler = handler
        self.state = .inactive

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
        state = .active
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let scene = scene else {
            return
        }

        let location = touch.location(in: scene)

        if !contains(location ) {
            state = .inactive
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let scene = scene else {
            return
        }

        let location = touch.location(in: scene)

        if contains(location ) {
            handler(self)
        }

        state = .inactive
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .inactive
    }
}
