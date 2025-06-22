//
//  ModelSpriteSheetRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import CoreGraphics

/// Renders 3D-models to sprite sheet tiles
public struct ModelSpriteSheetRenderer: SpriteSheetRenderer {
    let renderer: any ModelRenderer
    
    @MainActor
    init(description: SpriteSheetDescription.Model) {
        switch description.model {
        case .realityKit(let entity):
            let renderer = RealityKitModelRenderer(size: description.export.size)
            renderer.add(model: entity)
            self.renderer = renderer
        #if SE_SCENE_KIT
        case .sceneKit:
            fatalError("Not implemented")
        #endif
        }
    }
    
    public func setup(description: SpriteSheetDescription.Model) async throws {
        try await renderer.configure(camera: description.camera)
    }
    
    public func makeImage(for operation: ModelOperation) async throws -> CGImage {
        try await renderer.perform(operation: operation)
    }
}
