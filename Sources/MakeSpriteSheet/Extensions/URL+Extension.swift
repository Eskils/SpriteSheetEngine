//
//  URL+Extension.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 20/06/2025.
//

import Foundation

extension URL {
    var compatibilityPath: String {
        if #available(macOS 13.0, *) {
            self.standardizedFileURL.path()
        } else {
            self.path
        }
    }
    
    init(compatibilityPath: String, relativeTo base: URL? = nil) {
        if #available(macOS 13.0, *) {
            self.init(filePath: compatibilityPath, relativeTo: base)
        } else {
            self.init(fileURLWithPath: compatibilityPath, relativeTo: base)
        }
    }
}
