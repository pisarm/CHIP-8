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
        let bundleUrl = Bundle(for: self.dynamicType).bundleURL

        let urls = try contentsOfDirectory(at: bundleUrl, includingPropertiesForKeys: [], options: [])
        let romUrls = urls.filter { $0.pathExtension == "ch8" }
        let romData = try romUrls.map { try Data(contentsOf: $0) }
        return romData.map { Rom(data: $0) }
    }

}
