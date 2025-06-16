//
//  ModelKind.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import RealityKit
@preconcurrency import SceneKit

public enum ModelKind {
    case realityKit(Entity)
    #if SE_SCENE_KIT
    case sceneKit(SCNScene)
    #endif
}

extension ModelKind {
    enum Kind {
        case realityKit
        #if SE_SCENE_KIT
        case sceneKit
        #endif
    }
    
    var kind: Kind {
        switch self {
        case .realityKit:
            .realityKit
        #if SE_SCENE_KIT
        case .sceneKit:
            .sceneKit
        #endif
        }
    }
}

extension ModelKind: Equatable {
    public static func == (lhs: ModelKind, rhs: ModelKind) -> Bool {
        lhs.kind == rhs.kind
    }
}

extension ModelKind: Sendable {
}
