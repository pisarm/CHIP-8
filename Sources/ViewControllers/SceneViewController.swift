//
//  SceneViewController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 25/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

protocol SceneCoordinator: class {
    func showPause()
    func showEmulator()
    func showMenu()
    func resetEmulator()
}

class SceneViewController: UIViewController {
    ///MARK: Properties
    fileprivate lazy var skView: SKView = {
        let skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        return skView
    }()

    fileprivate lazy var screenScene: ScreenScene? = ScreenScene(with: self.view.bounds.size, coordinator: self)
    fileprivate lazy var pauseScene: PauseScene? = PauseScene(with: self.view.bounds.size, coordinator: self)
    fileprivate let emulator: Emulator
    fileprivate let coordinator: AppCoordinator

    ///MARK: Initialization
    init(with rom: Rom, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.emulator = Emulator(with: rom)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///MARK: View controller
    override func loadView() {
        self.view = skView
    }

    override func viewDidLayoutSubviews() {
        emulator.screen.delegate = screenScene

        showEmulator()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension SceneViewController: SceneCoordinator {
    ///MARK: SceneCoordinator
    func showEmulator() {
        skView.presentScene(screenScene)
        screenScene?.isPaused = false
        emulator.resume()
    }

    func showPause() {
        emulator.suspend()
        screenScene?.isPaused = true
        skView.presentScene(pauseScene)
    }

    func showMenu() {
        emulator.suspend()
        screenScene = nil
        pauseScene = nil
        coordinator.showMenu()
    }
    
    func resetEmulator() {
        //TODO: add this
    }
}
