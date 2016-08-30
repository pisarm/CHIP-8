//
//  AppCoordinator.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 25/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator {
    ///MARK: Properties
    fileprivate let window: UIWindow
    fileprivate (set) var sceneViewController: SceneViewController?
    fileprivate var menuViewController: MenuViewController {
        return MenuViewController(with: self)
    }

    ///MARK: Initialization
    init(with window: UIWindow) {
        self.window = window

        showMenu()
    }

}

extension AppCoordinator {
    func showMenu() {
        window.rootViewController = menuViewController

        sceneViewController = nil
    }

    func showEmulator(with rom: Rom) {
        sceneViewController = SceneViewController(with: rom, coordinator: self)

        window.rootViewController = sceneViewController
    }

}
