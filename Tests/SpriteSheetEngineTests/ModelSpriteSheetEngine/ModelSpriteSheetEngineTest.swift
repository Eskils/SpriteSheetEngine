//
//  ModelSpriteSheetEngineTest.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

import Foundation
import Testing
import CoreGraphics
import RealityKit
@testable import SpriteSheetEngine

struct ModelSpriteSheetEngineTests: SnapshotAssertable {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    private var modelPath: String {
        filePath(name: "cylinder-and-cone.usdc", directory: "TestAssets")
    }
    
    @Test
    @MainActor
    func spriteSheet() async throws {
        let model = try await MainActor.run {
            try Entity.load(contentsOf: URL(filePath: modelPath))
        }
        let description = SpriteSheetDescription.Model(
            model: .realityKit(model),
            operations: [
                .none, .none,
                .none, .none
            ],
            numberOfColumns: 2,
        )
        let engine = ModelSpriteSheetEngine(description: description)
        
        try await assertSnapshot(name: "model-sprite-sheet-2x2-none") {
            try await engine.spriteSheet()
        }
    }
    
    @Test
    @MainActor
    func spriteSheetTransform() async throws {
        let model = try await MainActor.run {
            try Entity.load(contentsOf: URL(filePath: modelPath))
        }
        let description = SpriteSheetDescription.Model(
            model: .realityKit(model),
            operations: [
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.2))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.4))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.8))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(1)))
            ],
        )
        let engine = ModelSpriteSheetEngine(description: description)
        
        try await assertSnapshot(name: "model-sprite-sheet-4-transform") {
            try await engine.spriteSheet()
        }
    }
    
    @Test
    @MainActor
    func spriteSheetMaterial() async throws {
        let model = try await MainActor.run {
            try Entity.load(contentsOf: URL(filePath: modelPath))
        }
        let description = SpriteSheetDescription.Model(
            model: .realityKit(model),
            operations: [
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.2, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.4, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.6, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.8, green: 0.6, blue: 0.8, alpha: 1)))
            ],
        )
        let engine = ModelSpriteSheetEngine(description: description)
        
        try await assertSnapshot(name: "model-sprite-sheet-4-material") {
            try await engine.spriteSheet()
        }
    }
    
    @Test
    @MainActor
    func spriteSheetTransformLarge() async throws {
        let model = try await MainActor.run {
            try Entity.load(contentsOf: URL(filePath: modelPath))
        }
        let description = SpriteSheetDescription.Model(
            model: .realityKit(model),
            operations: [
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.2))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.4))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(0.8))),
                .transform(ModelOperation.Transform(nodeID: "Cylinder", matrix: simd_float4x4(1))),
                
                .transform(ModelOperation.Transform(nodeID: "Cone", matrix: simd_float4x4(0.2))),
                .transform(ModelOperation.Transform(nodeID: "Cone", matrix: simd_float4x4(0.4))),
                .transform(ModelOperation.Transform(nodeID: "Cone", matrix: simd_float4x4(0.8))),
                .transform(ModelOperation.Transform(nodeID: "Cone", matrix: simd_float4x4(1))),
            ],
            numberOfColumns: 4
        )
        let engine = ModelSpriteSheetEngine(description: description)
        
        try await assertSnapshot(name: "model-sprite-sheet-2x4-transform") {
            try await engine.spriteSheet()
        }
    }
    
    @Test
    @MainActor
    func spriteSheetMaterialWithCroppedRegion() async throws {
        let model = try await MainActor.run {
            try Entity.load(contentsOf: URL(filePath: modelPath))
        }
        let description = SpriteSheetDescription.Model(
            model: .realityKit(model),
            operations: [
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.2, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.4, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.6, green: 0.6, blue: 0.8, alpha: 1))),
                .material(ModelOperation.Material(nodeID: "Cone", color: .init(red: 0.8, green: 0.6, blue: 0.8, alpha: 1)))
            ],
            export: ExportSettings(
                size: CGSize(width: 128, height: 128),
                cropRect: CGRect(x: 64, y: 40, width: 64, height: 88)
            )
        )
        let engine = ModelSpriteSheetEngine(description: description)
        
        try await assertSnapshot(name: "model-sprite-sheet-4-material-cropped") {
            try await engine.spriteSheet()
        }
    }
}

private extension ModelSpriteSheetEngineTests {
    @MainActor
    func load(model path: String) throws -> Entity {
        let url = URL(fileURLWithPath: path)
        return try Entity.load(contentsOf: url)
    }
}
