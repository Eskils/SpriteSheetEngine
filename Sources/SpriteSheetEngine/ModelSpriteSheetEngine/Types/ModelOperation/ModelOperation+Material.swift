//
//  ModelOperation+Material.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import CoreGraphics

extension ModelOperation {
    struct Material: ModelApplicable {
        var nodeID: String
        var color: CGColor
    }
}

extension ModelOperation.Material: Equatable {
}
