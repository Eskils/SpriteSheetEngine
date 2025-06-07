//
//  CameraSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd
import CoreGraphics

struct CameraSettings {
    var transform = simd_float4x4(
        rows: [
            SIMD4(1, 0, 0, 0),
            SIMD4(0, 1, 0, 0),
            SIMD4(0, 0, 1, 2),
            SIMD4(0, 0, 0, 1),
        ]
    )
    var projection = ProjectionKind.perspective
    var background = BackgroundKind.transparent
}

extension CameraSettings {
    enum ProjectionKind {
        case perspective
        case orthographic
    }
}

extension CameraSettings {
    enum BackgroundKind {
        case transparent
        case color(CGColor)
    }
}
