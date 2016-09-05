//
//  PauseScene.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 12/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

class PauseScene: SKScene, SceneOverlay {
    ///MARK: Properties
    private let coordinator: SceneCoordinator

    ///MARK: Initialization
    init(with size: CGSize, coordinator: SceneCoordinator) {
        self.coordinator = coordinator

        super.init(size: size)

        setupOverlay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///MARK: Setup
    private func setupOverlay() {
        let buttons: [SceneOverlayType.ElementType] = [
            .button(action: { [weak self] _ in self?.coordinator.showEmulator() }, text: "Resume"),
            .button(action: { [weak self] _ in self?.coordinator.resetEmulator() }, text: "Reset"),
            .button(action: { [weak self] _ in self?.coordinator.showMenu() }, text: "Quit")
        ]
        add(buttons, at: .topRight)
        add(.label(text: "Paused"), at: .top)
    }
}
