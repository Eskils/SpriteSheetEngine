//
//  SpriteSheetRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import CoreGraphics

/// Implement this interface to support making sprite sheets.
///
/// See example implementation in ``ModelSpriteSheetRenderer``.
public protocol SpriteSheetRenderer: Sendable {
    associatedtype Description: SpriteSheetDescribable
    
    /// This method is intended to configure the environment necessary
    /// for making images for the sprite sheet.
    ///
    /// For example configuring the camera and scene before rendering 3D-models.
    ///
    /// This method differs from making setup in the renderer initializer as the engine calls `setup` every time a new sprite sheet is made.
    /// If your setup work only needs to happen once, it can be done in the initializer.
    ///
    /// - Parameter description: Sprite sheet description describing how to setup the rendering environment.
    func setup(description: Description) async throws
    
    /// This method is intended to make the image described by the given operation.
    ///
    /// It is called by the engine for every operation defined in the sprite sheet description.
    ///
    /// After rendering the image, any work necessary to revert the changes in the environment should be performed before returning the image.
    /// See ``RealityKitModelRenderer.perform(operation:)`` for an example of resetting the performed operation.
    ///
    /// - Parameter operation: The operation describing the image to produce
    /// - Returns: A CoreGraphics image rendered by the implementing renderer
    func makeImage(for operation: Description.Operation) async throws -> CGImage
}
