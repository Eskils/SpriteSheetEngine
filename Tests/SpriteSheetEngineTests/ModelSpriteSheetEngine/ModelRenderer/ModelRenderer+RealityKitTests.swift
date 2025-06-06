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
