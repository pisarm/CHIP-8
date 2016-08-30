//
//  FileManager+Rom.swift
//  CHIP-8
//
//  Created by Flemming Pedersen on 13/08/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

extension FileManager {

    func loadRoms() throws -> [Rom] {
        return try contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: [], options: [])
            .filter { $0.pathExtension == "ch8" }
            .map {
                let name = $0.lastPathComponent.substring(to: $0.lastPathComponent.characters.index(of: ".")!)
                return Rom(name: name, data: NSData(contentsOf: $0)!)
        }
    }

}
