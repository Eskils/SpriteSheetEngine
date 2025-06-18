import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

/// Engine used for making sprite sheets.
public struct SpriteSheetEngine<Renderer: SpriteSheetRenderer> {
    let renderer: Renderer
    let description: Renderer.Description
    
    /// Make a sprite sheet from the provided description using the given renderer.
    /// - Returns: Tiled images as a single CoreGraphics image
    /// - Throws:
    ///     - ``ImageTiler.ImageError`` when there is a failure with making the image hosting all the tiles.
    ///     - Renderer specific errors, when there is a failure with setting up the environment or making one of the tiles.
    public func spriteSheet() async throws -> CGImage {
        try await renderer.setup(description: description)
        
        let imageTiler = try ImageTiler(
            tileSize: description.export.size,
            numberOfColumns: description.numberOfColumns,
            numberOfImages: description.operations.count
        )
        
        for operation in description.operations {
            let tile = try await renderer.makeImage(for: operation)
            imageTiler.append(tile: tile)
        }
        
        return try imageTiler.checkedFinish()
    }
    
    /// Make a sprite sheet from the provided description using the given renderer and write to disk.
    ///
    /// The export type and image format can be set using the `export` property in the sprite sheet description.
    /// For more information, see ``ExportSettings``
    ///
    /// - Parameter url: File URL pointing to where the produced image should be saved.
    ///
    /// - Throws:
    ///     - ``ExportError`` when there is a failure encoding the image to the desired format
    ///     - ``ImageTiler.ImageError`` when there is a failure with making the image hosting all the tiles.
    ///     - Renderer specific errors, when there is a failure with setting up the environment or making one of the tiles.
    ///     - Other errors, for example if a failure occurs when the image is being written to disk.
    public func export(to url: URL) async throws {
        switch description.export.kind {
        case .image:
            let image = try await spriteSheet()
            let data = switch description.export.format {
            case .png: try makeImageData(for: image, type: .png)
            case .jpeg: try makeImageData(for: image, type: .jpeg)
            }
            try data.write(to: url)
        }
    }
    
    private func makeImageData(for image: CGImage, type: UTType) throws(ExportError)  -> Data {
        let data = NSMutableData()
        guard
            let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, type.identifier as CFString, 1, nil)
        else {
            throw .cannotMakeImageDestination(type)
        }
        
        CGImageDestinationAddImage(imageDestination, image, nil)
        CGImageDestinationFinalize(imageDestination)
        
        return data as Data
    }
}

extension SpriteSheetEngine: Sendable {
}

public extension SpriteSheetEngine {
    /// Errors related to encoding images into image formats for saving to disk.
    enum ExportError: Error {
        /// The image destination could not be made for the desired image format.
        case cannotMakeImageDestination(UTType)
    }
}
