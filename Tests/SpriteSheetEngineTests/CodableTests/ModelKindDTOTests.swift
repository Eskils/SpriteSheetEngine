//
//  ModelKindDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 12/06/2025.
//

import Testing
@testable import SpriteSheetEngine
import SceneKit
import RealityKit

struct ModelKindDTOTests {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    private var usdModelPath: String {
        filePath(name: "cyllinder-and-cone.usdc", directory: "Models")
    }
    private var scnModelPath: String {
        filePath(name: "cyllinder-and-cone.scn", directory: "Models")
    }
    let decoder = JSONDecoder()
    
    @Test
    func decodeRealityKitEntity() throws {
        let url = "\"\(usdModelPath)\""
        let encoded = url.data(using: .utf8)!
        let dto = try decoder.decode(ModelKindDTO.self, from: encoded)
        #expect(dto.url.path() == URL(filePath: usdModelPath).path())
    }
    
    @Test
    func decodeSceneKitScene() throws {
        let url = "\"\(scnModelPath)\""
        let encoded = url.data(using: .utf8)!
        let dto = try decoder.decode(ModelKindDTO.self, from: encoded)
        #expect(dto.url.path() == URL(filePath: scnModelPath).path())
    }
    
    @Test
    @MainActor
    func usdToRealityKitEntity() throws {
        let url = URL(filePath: usdModelPath)
        let dto = ModelKindDTO(url: url)
        let model = try dto.toModel()
        #expect(model.kind == .realityKit)
    }
    
    @Test
    @MainActor
    func scnToSceneKitScene() throws {
        let url = URL(filePath: scnModelPath)
        let dto = ModelKindDTO(url: url)
        let model = try dto.toModel()
        #expect(model.kind == .sceneKit)
    }
}

private extension ModelKindDTOTests {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
}
