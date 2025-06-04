//
//  ExportSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

struct ExportSettings {
    let sizeMode = SizeMode.natural
    let format = FormatKind.image
}

extension ExportSettings {
    enum SizeMode {
        /// The smallest fitting square
        case square
        /// The default output by the rendering engine
        case natural
    }
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
