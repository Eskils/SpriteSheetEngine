//
//  ModelKind.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import RealityKit
@preconcurrency import SceneKit

enum ModelKind {
    case realityKit(Entity)
    case sceneKit(SCNScene)
}

extension ModelKind {
    enum Kind {
        case realityKit
        case sceneKit
    }
    
    var kind: Kind {
        switch self {
        case .realityKit:
            .realityKit
        case .sceneKit:
            .sceneKit
        }
    }
}

extension ModelKind: Equatable {
    static func == (lhs: ModelKind, rhs: ModelKind) -> Bool {
        lhs.kind == rhs.kind
    }
}

extension ModelKind: Sendable {
}
