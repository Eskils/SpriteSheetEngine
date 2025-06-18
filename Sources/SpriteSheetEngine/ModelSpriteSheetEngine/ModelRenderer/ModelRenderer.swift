//
//  ModelRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

/// Implement this interface to support rendering 3D models into sprite sheet tiles.
///
/// This interface is uses the associated type `Model` which is intended to be the primary data structure the underlying rendering engine uses.
/// For example `Entity` in RealityKit and `SCNScene` in SceneKit.
///
/// - SeeAlso: ``RealityKitModelRenderer``
public protocol ModelRenderer: Sendable {
    associatedtype Model
    
    /// Add the model to the rendering environment.
    ///
    /// ``ModelSpriteSheetRenderer`` will call this method in its initializer.
    ///
    /// - Parameter model: The model to render as the primary data structure used by the underlying rendering engine.
    @MainActor
    func add(model: Model)
    
    /// Configure the camera used in the rendering environment.
    ///
    /// ``ModelSpriteSheetRenderer`` will call this method in the setup part of its lifecycle.
    ///
    /// - Parameter camera: Collection of properties affecting the rendering camera.
    @MainActor
    func configure(camera: CameraSettings) async throws
    
    /// Render an image for the given operation.
    ///
    /// ``ModelSpriteSheetRenderer`` may call this method multiple times.
    /// Make sure any operation performed also is reverted after rendering an image.
    ///
    /// - Parameter operation: The operation to be performed on a node in the rendering environment
    /// - Returns: A CoreGraphics image of the rendered output.
    @MainActor
    func perform(operation: ModelOperation) async throws -> CGImage
}
