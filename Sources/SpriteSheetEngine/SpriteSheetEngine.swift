import Foundation
import CoreGraphics

struct SpriteSheetEngine<Renderer: SpriteSheetRenderer> {
    let renderer: Renderer
    let description: Renderer.Description
    
    func spriteSheet() async throws -> CGImage {
        try await renderer.setup(description: description)
        
        let imageTiler = try ImageTiler(
            tileSize: description.export.size,
            numberOfColumns: description.numberOfColumns,
            numberOfImages: description.operations.count
        )
        
        for operation in description.operations {
            let tile = try await renderer.makeImage(for: operation)
            try imageTiler.checkedAppend(tile: tile)
        }
        
        return try imageTiler.checkedFinish()
    }
    
    func export(to url: URL) async throws {
    }
}
