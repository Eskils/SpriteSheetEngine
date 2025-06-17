//
//  CameraSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd
import CoreGraphics

/// Collection of properties that affect the camera in a 3D scene.
public struct CameraSettings {
    /// The position and  orientation of the camera.
    /// Default is 2 meters behind the scene origin on the Z-axis
    public var transform: simd_float4x4
    /// The type of projection to use. Default is `perspective`
    public var projection: ProjectionKind
    /// The kind of background to draw. Default is `transparent`
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
    /// The type of projection to use
    public enum ProjectionKind: Sendable {
        /// This simulates how the eye sees the worls and is the most common.
        case perspective
        /// This gives a view where all angles and lengths are preserved, but distance is difficult to perceive.
        /// In RealityKit, only available on macOS 15.0 or newer. Throws ``RealityKitModelRendererError.orthographicCameraRequiresMacOS15`` if used on an unsupported system.
        case orthographic
    }
}

extension CameraSettings {
    /// The kind of background to draw.
    public enum BackgroundKind: Equatable, Sendable {
        /// Draw a transparent background. Equivalent to `.color(CGColor.clear)`
        case transparent
        /// Draw a color to the background
        case color(CGColor)
    }
}
