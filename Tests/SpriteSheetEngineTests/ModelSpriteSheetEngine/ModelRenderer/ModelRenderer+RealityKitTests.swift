//
//  File.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/06/2025.
//

import Foundation
import RealityKit
import Testing
@testable import SpriteSheetEngine
import CoreGraphics

@MainActor
struct ModelRendererRealityKitTests {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL.path
    private var modelPath: String {
        filePath(name: "cyllinder-and-cone.usdc", directory: "Models")
    }
    
    let rendererSize = CGSize(width: 256, height: 256)
    
    @Test
    @MainActor
    func rendersModelWithNoOperations() async throws {
        try await assertSnapshot(name: "No operations") { renderer in
            try await renderer.configure(camera: CameraSettings())
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(operation: .none)
        }
    }
    
    @Test
    @MainActor
    func rendersModelWithMaterialOperation() async throws {
        try await assertSnapshot(name: "Material operation") { renderer in
            try await renderer.configure(camera: CameraSettings())
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(
                operation: .material(
                    ModelOperation.Material(
                        nodeID: "Cylinder",
                        color: .init(red: 1, green: 0, blue: 0.2, alpha: 1.0)
                    )
                )
            )
        }
    }
    
    @Test
    @MainActor
    func rendersModelWithTransformOperation() async throws {
        try await assertSnapshot(name: "Transform operation") { renderer in
            try await renderer.configure(camera: CameraSettings())
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(
                operation: .transform(
                    ModelOperation.Transform(
                        nodeID: "Cone",
                        matrix:
                            simd_float4x4(rows: [
                                SIMD4(0.5, 0, 0, 0.5),
                                SIMD4(0, 0.5 * cos(0.1), sin(0.1), 0.5),
                                SIMD4(0, -sin(0.1), 0.5 * cos(0.1), 0),
                                SIMD4(0, 0, 0, 1),
                            ])
                    )
                )
            )
        }
    }
    
    @Test
    @MainActor
    func appliesCameraTransform() async throws {
        try await assertSnapshot(name: "Camera transform") { renderer in
            let cameraSettings = CameraSettings(
                transform: simd_float4x4(rows: [
                    SIMD4(1, 0, 0, 0),
                    SIMD4(0, 1, 0, 0),
                    SIMD4(0, 0, 1, 5),
                    SIMD4(0, 0, 0, 1),
                ])
            )
            try await renderer.configure(camera: cameraSettings)
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(operation: .none)
        }
    }
    
    @Test
    @MainActor
    func usesLatestCameraSetting() async throws {
        let renderer = RealityKitModelRenderer(size: rendererSize)
        let firstCameraSettings = CameraSettings(
            transform: simd_float4x4(rows: [
                SIMD4(1, 0, 0, 0),
                SIMD4(0, 1, 0, 0),
                SIMD4(0, 0, 1, 5),
                SIMD4(0, 0, 0, 1),
            ])
        )
        let secondCameraSettings = CameraSettings(
            transform: simd_float4x4(rows: [
                SIMD4(1, 0, 0, 0),
                SIMD4(0, 1, 0, 0),
                SIMD4(0, 0, 1, 10),
                SIMD4(0, 0, 0, 1),
            ])
        )
        try await renderer.configure(camera: firstCameraSettings)
        #expect(renderer.cameraTransform.columns.3.z == 5)
        
        try await renderer.configure(camera: secondCameraSettings)
        #expect(renderer.cameraTransform.columns.3.z == 10)
    }
    
    @Test
    @MainActor
    func appliesOrthographicCameraProjection() async throws {
        try await assertSnapshot(name: "Orthographic camera projection") { renderer in
            let cameraSettings = CameraSettings(
                projection: .orthographic
            )
            try await renderer.configure(camera: cameraSettings)
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(operation: .none)
        }
    }
    
    @Test
    @MainActor
    func appliesCameraBackground() async throws {
        try await assertSnapshot(name: "Camera background") { renderer in
            let cameraSettings = CameraSettings(
                background: .color(.init(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0))
            )
            try await renderer.configure(camera: cameraSettings)
            renderer.add(model: try load(model: modelPath))
            return try await renderer.perform(operation: .none)
        }
    }
}

private extension ModelRendererRealityKitTests {
    @MainActor
    func load(model path: String) throws -> Entity {
        let url = URL(fileURLWithPath: path)
        return try Entity.load(contentsOf: url)
    }
    
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
    
    @MainActor
    func assertSnapshot(name: String, for operations: (RealityKitModelRenderer) async throws -> CGImage) async throws {
        let renderer = RealityKitModelRenderer(size: rendererSize)
        let image = try await operations(renderer)
        let fileName = name.lowercased().replacingOccurrences(of: " ", with: "-")
        #expect(
            try isImageEqual(
                actual: image,
                transformed: filePath(name: "\(fileName).png", directory: "ProducedOutputs"),
                expected: filePath(name: "\(fileName).png", directory: "ExpectedOutputs")
            )
        )
    }
}
