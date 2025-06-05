//
//  ModelRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

protocol ModelRenderer {
    associatedtype Model
    
    @MainActor
    func add(model: Model)
    @MainActor
    func configure(camera: CameraSettings) async throws
    @MainActor
    func perform(operation: ModelOperation) async throws -> CGImage
}
