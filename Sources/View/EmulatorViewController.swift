//
//  EmulatorViewController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 03/07/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

final class EmulatorViewController: UIViewController {
    var emulator: Emulator?
    var screenScene: ScreenScene?

    lazy var skView: SKView = {
        let skView = SKView()
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        return skView
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gameUrl = Bundle(for: self.dynamicType).url(forResource: "Blinky", withExtension: "ch8"), let data = try? Data(contentsOf: gameUrl) {
            emulator = Emulator(rom: Rom(data: data))
            emulator?.delegate = self
        } else {
            fatalError(".ch8 file not found")
        }

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.addSubview(skView)
    }

    private func setupConstraints() {
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        guard let emulator = emulator else {
            fatalError("No emulator")
        }

        screenScene = ScreenScene(size: skView.bounds.size, screen: emulator.screen)
        skView.presentScene(screenScene)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let emulator = emulator else {
            fatalError("No emulator")
        }

        emulator.resume()
    }
}

extension EmulatorViewController: EmulatorDelegate {
    func beep() {
        //TODO: Implement
    }

    func draw(screen: Screen) {
        screenScene?.screen = screen
    }
}
