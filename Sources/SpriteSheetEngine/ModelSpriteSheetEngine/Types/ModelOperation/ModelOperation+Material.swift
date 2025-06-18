//
//  ModelOperation+Material.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import CoreGraphics

extension ModelOperation {
    /// Structure that describes a material change operation
    public struct Material: ModelApplicable {
        /// A name that refers to a particular mesh.
        /// If a node is found with this name, the operation will be applied to its first direct child mesh.
        /// If the node has no mesh, an error will be thrown.
        public var nodeID: String
        /// The diffuse color to be applied to the primary material.
        public var color: CGColor
        
        public init(nodeID: String, color: CGColor) {
            self.nodeID = nodeID
            self.color = color
        }
    }
}

extension ModelOperation.Material: Sendable {
}

extension ModelOperation.Material: Equatable {
}
