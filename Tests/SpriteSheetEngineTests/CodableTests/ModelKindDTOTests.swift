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
        filePath(name: "cylinder-and-cone.usdc", directory: "TestAssets")
    }
    private var scnModelPath: String {
        filePath(name: "cylinder-and-cone.scn", directory: "TestAssets")
    }
    let decoder = JSONDecoder()
    
    @Test
    func decodeRealityKitEntity() throws {
        let url = "\"\(usdModelPath)\""
        let encoded = url.data(using: .utf8)!
        let dto = try decoder.decode(ModelKindDTO.self, from: encoded)
        #expect(dto.url == URL(filePath: usdModelPath))
    }
    
    @Test
    func decodeSceneKitScene() throws {
        let url = "\"\(scnModelPath)\""
        let encoded = url.data(using: .utf8)!
        let dto = try decoder.decode(ModelKindDTO.self, from: encoded)
        #expect(dto.url == URL(filePath: scnModelPath))
    }
    
    @Test
    @MainActor
    func usdToRealityKitEntity() throws {
        let url = URL(filePath: usdModelPath)
        let dto = ModelKindDTO(url: url)
        let model = try dto.toModel()
        #expect(model.kind == .realityKit)
    }
    
    #if SE_SCENE_KIT
    @Test
    @MainActor
    func scnToSceneKitScene() throws {
        let url = URL(filePath: scnModelPath)
        let dto = ModelKindDTO(url: url)
        let model = try dto.toModel()
        #expect(model.kind == .sceneKit)
    }
    #endif
}

private extension ModelKindDTOTests {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
}
