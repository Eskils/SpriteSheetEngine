//
//  ExportSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

public struct ExportSettings {
    public var size: CGSize
    public var kind: FormatKind
    public var format: ImageFormat
    
    public init(
        size: CGSize = CGSize(width: 128, height: 128),
        kind: FormatKind = FormatKind.image,
        format: ImageFormat = ImageFormat.png
    ) {
        self.size = size
        self.kind = kind
        self.format = format
    }
}

extension ExportSettings: Sendable {
}

extension ExportSettings: Equatable {
}

public extension ExportSettings {
    enum FormatKind: Sendable {
        case image
    }
}

public extension ExportSettings {
    enum ImageFormat: Sendable {
        case jpeg
        case png
    }
}
