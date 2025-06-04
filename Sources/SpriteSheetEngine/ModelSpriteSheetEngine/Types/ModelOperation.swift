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
