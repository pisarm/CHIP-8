//
//  MenuViewController.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 12/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

final class MenuViewController: UIViewController {
    ///MARK: Elements
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 72)
        label.text = "CHIP-8"
        label.textAlignment = .center
        label.textColor = .white

        return label
    }()

    fileprivate lazy var romCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RomCell.self, forCellWithReuseIdentifier: RomCell.identifier)
        collectionView.delegate = self

        return collectionView
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        return layout
    }()

    fileprivate lazy var dataSource: RomDataSource = {
        let dataSource = RomDataSource()
        dataSource.reload()

        return dataSource

    }()


    fileprivate let coordinator: AppCoordinator

    ///MARK: Initialization
    init(with coordinator: AppCoordinator) {
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    ///MARK: Constraints
    private var logoLabelCenterYConstraint: NSLayoutConstraint?
    var logoLabelTopConstraint: NSLayoutConstraint?

    ///MARK:
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    ///MARK: Setup
    private func setupViews() {
        view.addSubview(logoLabel)
        view.addSubview(romCollectionView)
    }

    private func setupConstraints() {
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        logoLabelCenterYConstraint = logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        logoLabelCenterYConstraint?.isActive = true

        logoLabelTopConstraint = logoLabel.topAnchor.constraint(equalTo: view.topAnchor)
        logoLabelTopConstraint?.isActive = false

        romCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        romCollectionView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor).isActive = true
        romCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        romCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        logoLabelCenterYConstraint?.isActive = false
        logoLabelTopConstraint?.isActive = true

        UIView.animate(withDuration: 0.7, animations: {
            self.logoLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.view.layoutIfNeeded()
            }, completion: { _ in
                self.romCollectionView.dataSource = self.dataSource
                self.romCollectionView.reloadData()
        })
    }

}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    ///MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        romCollectionView.cellForItem(at: indexPath)?.animatePush()
        coordinator.showEmulator(with: dataSource[indexPath])
        print("\(dataSource[indexPath].name)")
    }

}
