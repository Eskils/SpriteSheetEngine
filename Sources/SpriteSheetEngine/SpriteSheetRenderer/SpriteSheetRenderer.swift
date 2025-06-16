//
//  SpriteSheetRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import CoreGraphics

public protocol SpriteSheetRenderer: Sendable {
    associatedtype Description: SpriteSheetDescribable
    
    func setup(description: Description) async throws
    func makeImage(for operation: Description.Operation) async throws -> CGImage
}
