//
//  ModelSpriteSheetEngine.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import Foundation
import CoreGraphics

public nonisolated struct ModelSpriteSheetEngine {
    let description: SpriteSheetDescription.Model
    let engine: SpriteSheetEngine<ModelSpriteSheetRenderer>
    
    @MainActor
    public init(description: SpriteSheetDescription.Model) {
        self.description = description
        let renderer = ModelSpriteSheetRenderer(description: description)
        self.engine = SpriteSheetEngine(renderer: renderer, description: description)
    }
    
    public func spriteSheet() async throws -> CGImage {
        try await engine.spriteSheet()
    }
    
    public func export(to url: URL) async throws {
        try await engine.export(to: url)
    }
}

extension ModelSpriteSheetEngine {
    @MainActor
    public init(decoding data: Data, type: SpriteSheetDescription.TransferableType) throws {
        switch type {
        case .json:
            let dto = try JSONDecoder().decode(SpriteSheetDescription.ModelDTO.self, from: data)
            let description = try dto.toModel()
            self.init(description: description)
        }
    }
    
    @MainActor
    public init(url: URL, type: SpriteSheetDescription.TransferableType) throws {
        let data = try Data(contentsOf: url)
        try self.init(decoding: data, type: type)
    }
}

extension ModelSpriteSheetEngine: Sendable {
}
