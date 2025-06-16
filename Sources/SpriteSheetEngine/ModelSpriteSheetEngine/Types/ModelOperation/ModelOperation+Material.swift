//
//  ModelOperation+Material.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import CoreGraphics

extension ModelOperation {
    public struct Material: ModelApplicable {
        public var nodeID: String
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
