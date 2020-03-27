//
//  FileManager+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 14/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

extension FileManager {
    
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
    
   static func getDocumentsDirectory() -> URL {
        let paths = FileManager.self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
