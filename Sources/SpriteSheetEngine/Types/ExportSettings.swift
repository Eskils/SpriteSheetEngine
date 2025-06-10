//
//  ExportSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

struct ExportSettings {
    var size = CGSize(width: 128, height: 128)
    var format = FormatKind.image
}

extension ExportSettings {
    enum FormatKind {
        case image
        case imageAndSchema
    }
}

extension ExportSettings.FormatKind {
    enum ImageFormat {
        case jpeg
        case jpegWithBackground(CGColor)
        case png
    }
}
