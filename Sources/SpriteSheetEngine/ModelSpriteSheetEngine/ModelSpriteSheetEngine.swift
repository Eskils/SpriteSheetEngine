//
//  ModelSpriteSheetEngine.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import Foundation
import CoreGraphics

/// Engine used to make sprite sheets from 3D-models.
///
/// You create this engine with a sprite sheet description ``SpriteSheetDescription/Model`` defining the model, camera and operations used to make the sprite sheet..
/// This description can be made in code or parsed from a file, for instance json.
/// For codable structure, see `SpriteSheetDescription.ModelDTO`.
public nonisolated struct ModelSpriteSheetEngine {
    let description: SpriteSheetDescription.Model
    let engine: SpriteSheetEngine<ModelSpriteSheetRenderer>
    
    /// Construct new engine for making sprite sheets from 3D-models.
    /// - Parameter description: Description defining the model, camera and operations used to make the sprite sheet.
    @MainActor
    public init(description: SpriteSheetDescription.Model) {
        self.description = description
        let renderer = ModelSpriteSheetRenderer(description: description)
        self.engine = SpriteSheetEngine(renderer: renderer, description: description)
    }
    
    /// Make sprite sheet as an image
    /// - Returns: Sprite sheet as a CoreGraphics image
    /// - Throws:
    ///     - ``ImageTiler/ImageError``
    ///     - ``RealityKitModelRendererError``
    ///     - Possibly undocumented errors
    public func spriteSheet() async throws -> CGImage {
        try await engine.spriteSheet()
    }
    
    /// Make sprite sheet as an image and save to disk
    /// - Parameter url: File URL to the output path of the sprite sheet image
    /// - Throws:
    ///     - ``ImageTiler/ImageError``
    ///     - ``RealityKitModelRendererError``
    ///     - Possibly undocumented errors
    public func export(to url: URL) async throws {
        try await engine.export(to: url)
    }
}

extension ModelSpriteSheetEngine {
    /// Construct new engine for making sprite sheets from 3D-models.
    /// - Parameters:
    ///   - data: Data of description defining the model, camera and operations used to make the sprite sheet.
    ///   - type: The data format used to store the description
    @MainActor
    public init(decoding data: Data, type: SpriteSheetDescription.TransferableType, relativeTo base: URL? = nil) throws {
        switch type {
        case .json:
            var dto = try JSONDecoder().decode(SpriteSheetDescription.ModelDTO.self, from: data)
            if let base {
                dto.model.resolvePath(relativeTo: base)
            }
            let description = try dto.toModel()
            self.init(description: description)
        }
    }
    
    /// Construct new engine for making sprite sheets from 3D-models.
    /// - Parameters:
    ///   - url: File URL to description defining the model, camera and operations used to make the sprite sheet.
    ///   - type: The data format used to store the description
    @MainActor
    public init(url: URL, type: SpriteSheetDescription.TransferableType, relativeTo base: URL? = nil) throws {
        let data = try Data(contentsOf: url)
        try self.init(decoding: data, type: type, relativeTo: base)
    }
}

extension ModelSpriteSheetEngine: Sendable {
}
