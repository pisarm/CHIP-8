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


    init(withRom rom: Rom) {
        super.init(nibName: nil, bundle: nil)

        emulator = Emulator(rom: rom)
        emulator?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.addSubview(skView)
    }

    private func setupConstraints() {
        skView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        skView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        skView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        guard let emulator = emulator else {
            fatalError("No emulator")
        }

        screenScene = ScreenScene(size: skView.bounds.size)
        emulator.screen.delegate = screenScene

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
    
}
