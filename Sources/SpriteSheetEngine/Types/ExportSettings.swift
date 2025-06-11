//
//  ExportSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

struct ExportSettings {
    var size = CGSize(width: 128, height: 128)
    var kind = FormatKind.image
    var format = ImageFormat.png
}

extension ExportSettings {
    enum FormatKind {
        case image
    }
}

extension ExportSettings {
    enum ImageFormat {
        case jpeg
        case png
    }
}
