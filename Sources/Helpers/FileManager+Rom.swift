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
            .map { Rom(name: $0.lastPathComponent, data: NSData(contentsOf: $0)!) }
    }
    
}
