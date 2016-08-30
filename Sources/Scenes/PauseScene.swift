//
//  PauseScene.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 12/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit

class PauseScene: SKScene, HUD {
    ///MARK: Properties
    private let coordinator: SceneCoordinator

    ///MARK: Initialization
    init(with size: CGSize, coordinator: SceneCoordinator) {
        self.coordinator = coordinator

        super.init(size: size)

        setupHUD()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///MARK: Setup
    private func setupHUD() {
        add(element: .label, location: .top, text: "Paused")
        add(element: .button(handler: { [weak self] _ in self?.coordinator.showEmulator() }), location: .topRight, text: "Resume")
        add(element: .button(handler: { [unowned self] _ in self.coordinator.showMenu() }), location: .bottomRight, text: "Quit")
    }
}
