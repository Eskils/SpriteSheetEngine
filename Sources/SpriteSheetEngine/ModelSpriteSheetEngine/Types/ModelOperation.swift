//
//  ModelOperation.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd
import CoreGraphics

enum ModelOperation: SpriteSheetOperation {
    case transform(Transform)
    case material(Material)
    case none
}

extension ModelOperation {
    struct Transform: ModelApplicable {
        var nodeID: String
        var matrix = simd_float4x4(diagonal: .one)
    }
    
    struct Material: ModelApplicable {
        var nodeID: String
        var color: CGColor
    }
}

extension ModelOperation.Transform: Equatable {
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
