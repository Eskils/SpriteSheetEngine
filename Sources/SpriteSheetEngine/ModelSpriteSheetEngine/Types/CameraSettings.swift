//
//  CameraSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd
import CoreGraphics

public struct CameraSettings {
    public var transform: simd_float4x4
    public var projection: ProjectionKind
    public var background: BackgroundKind
    
    public init(
        transform: simd_float4x4 = simd_float4x4(
            rows: [
                SIMD4(1, 0, 0, 0),
                SIMD4(0, 1, 0, 0),
                SIMD4(0, 0, 1, 2),
                SIMD4(0, 0, 0, 1),
            ]
        ),
        projection: ProjectionKind = ProjectionKind.perspective,
        background: BackgroundKind = BackgroundKind.transparent
    ) {
        self.transform = transform
        self.projection = projection
        self.background = background
    }
}

extension CameraSettings: Sendable {
}

extension CameraSettings: Equatable {
}

extension CameraSettings {
    public enum ProjectionKind: Sendable {
        case perspective
        case orthographic
    }
}

extension CameraSettings {
    public enum BackgroundKind: Equatable, Sendable {
        case transparent
        case color(CGColor)
    }
}
