//
//  ExportSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

/// Collection of properties used to describe how to export the sprite sheet.
public struct ExportSettings {
    /// Size of each tile in the sprite sheet.
    /// A zero size is invalid and will in most cases throw an error.
    /// Default is `width: 128`, `height: 128`
    public var size: CGSize
    /// The type of export used when writing to disk. Currently, only `image` is supported.
    /// This property is intended as a reserved property for possible future expansions.
    public var kind: FormatKind
    /// The image format used for exporting the sprite sheet when writing to disk.
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
    /// The type of export used when writing to disk.
    enum FormatKind: Sendable {
        /// Export the sprite sheet as an image
        case image
    }
}

public extension ExportSettings {
    /// The image format used for exporting the sprite sheet when writing to disk.
    enum ImageFormat: Sendable {
        /// Export the sprite sheet as a JPEG image
        case jpeg
        /// Export the sprite sheet as a PNG image
        case png
    }
}
