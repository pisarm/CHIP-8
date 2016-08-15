//
//  AppController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 10/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

final class AppController {
    //MARK: Properties
    private let window: UIWindow

    //MARK: View controllers
    private lazy var menuViewController: MenuViewController = {
        let viewController = MenuViewController(withController: self)

        return viewController
    }()

    //MARK: Initialization
    init(withWindow window: UIWindow) {
        self.window = window

        showMenu()
    }

}

extension AppController {
    func showMenu() {
        window.rootViewController = menuViewController
    }

    func showEmulator(withRom rom: Rom) {
        let emulatorViewController = EmulatorViewController(withRom: rom)
        window.rootViewController = emulatorViewController
    }
}
