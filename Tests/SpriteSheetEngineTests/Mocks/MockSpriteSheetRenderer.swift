//
//  MockSpriteSheetRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

@testable import SpriteSheetEngine
import CoreGraphics
import CoreImage

struct MockSpriteSheetRenderer: SpriteSheetRenderer {
    var setupHandler: (@MainActor (MockSpriteSheetDescription) -> Void)?
    var makeImageHandler: (@MainActor (MockSpriteSheetOperation) -> CGImage)?
    
    func setup(description: MockSpriteSheetDescription) async throws {
        await setupHandler?(description)
    }
    
    func makeImage(for operation: MockSpriteSheetOperation) async throws -> CGImage {
        await makeImageHandler?(operation) ?? CIContext().createCGImage(CIImage.green, from: CGRect(x: 0, y: 0, width: 100, height: 100))!
    }
}
