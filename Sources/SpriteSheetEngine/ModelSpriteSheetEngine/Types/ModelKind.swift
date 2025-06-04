//
//  ModelKind.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import RealityKit
import SceneKit

enum ModelKind {
    case realityKit(Entity)
    case sceneKit(SCNScene)
}
