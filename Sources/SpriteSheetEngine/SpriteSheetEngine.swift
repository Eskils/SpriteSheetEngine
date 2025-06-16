import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

public struct SpriteSheetEngine<Renderer: SpriteSheetRenderer> {
    let renderer: Renderer
    let description: Renderer.Description
    
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
    enum ExportError: Error {
        case cannotMakeImageDestination(UTType)
    }
}
