//
//  RomDataSource.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 13/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

final class RomDataSource: NSObject {
    var roms: [Rom] = []

    func reload() {
        do {
            roms = try FileManager.default.loadRoms()
        } catch {
            roms = []
        }
    }

    subscript (indexPath: IndexPath) -> Rom {
        get {
            return roms[indexPath.row]
        }
    }

}

extension RomDataSource: UICollectionViewDataSource {
    ///MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rom = self[indexPath]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RomCell.identifier, for: indexPath) as! RomCell
        cell.backgroundColor = .clear
        cell.name = rom.name
        return cell
    }

}
