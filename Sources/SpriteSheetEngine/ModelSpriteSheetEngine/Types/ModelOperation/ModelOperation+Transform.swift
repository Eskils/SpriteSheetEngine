//
//  ModelOperation+Transform.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import simd

extension ModelOperation {
    struct Transform: ModelApplicable {
        var nodeID: String
        var matrix = simd_float4x4(diagonal: .one)
    }
}

extension ModelOperation.Transform: Equatable {
}
