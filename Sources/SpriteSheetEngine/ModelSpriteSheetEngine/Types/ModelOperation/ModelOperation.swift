//
//  ModelOperation.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd
import CoreGraphics

/// Possible operations for a node in a 3D scene
public enum ModelOperation: SpriteSheetOperation {
    /// Apply transform to a node
    case transform(Transform)
    /// Change the color / material of  a node
    case material(Material)
    /// Do nothing.
    /// Can be used to produce a placeholder image to fill the sprite sheet grid.
    case none
}

extension ModelOperation: Sendable {
}

extension ModelOperation: Equatable {
}

extension ModelOperation {
    enum Kind: String, Codable, Hashable {
        case transform
        case material
        case none
    }
    
    var kind: Kind {
        switch self {
        case .transform: .transform
        case .material: .material
        case .none: .none
        }
    }
}
