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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gameUrl = NSBundle(forClass: self.dynamicType).URLForResource("Blinky", withExtension: "ch8"), data = NSData(contentsOfURL: gameUrl) {
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
        skView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 100).active = true
        skView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        skView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -100).active = true
        skView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard let emulator = emulator else {
            fatalError("No emulator")
        }

        emulator.resume()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension EmulatorViewController: EmulatorDelegate {
    func beep() {
        //TODO: Implement
    }

    func draw(screen screen: Screen) {
        screenScene?.screen = screen
    }
}
