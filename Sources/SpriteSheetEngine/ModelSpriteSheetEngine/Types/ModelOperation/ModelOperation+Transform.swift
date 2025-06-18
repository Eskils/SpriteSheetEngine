//
//  ModelOperation+Transform.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import simd

extension ModelOperation {
    /// Structure that describes a transform operation
    public struct Transform: ModelApplicable {
        /// A name that refers to a particular node or mesh
        public var nodeID: String
        /// A matrix describing the transform to make on the node
        public var matrix: simd_float4x4
        
        public init(nodeID: String, matrix: simd_float4x4 = simd_float4x4(diagonal: .one)) {
            self.nodeID = nodeID
            self.matrix = matrix
        }
    }
}

extension ModelOperation.Transform: Sendable {
}

extension ModelOperation.Transform: Equatable {
}
