//
//  ModelKind.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import RealityKit
@preconcurrency import SceneKit

/// The kind of 3D Model to use for rendering
public enum ModelKind {
    /// A reality kit 3D model, such as a USD entity.
    case realityKit(Entity)
    #if SE_SCENE_KIT
    /// A scene kit 3D model, such as a SCN scene.
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
