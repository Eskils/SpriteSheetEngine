//
//  ModelOperation+MaterialDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import Testing
import Foundation
import CoreGraphics
@testable import SpriteSheetEngine

struct ModelOperationMaterialDTOTests {
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let decoder = JSONDecoder()
    
    @Test
    func encode() throws {
        let dto = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"color":"#336699","nodeID":"abc123","type":"material"}
        """
        #expect(string == expected)
    }
    
    @Test
    func decode() throws {
        let string = """
        {"color":"#336699","nodeID":"abc123","type":"material"}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ModelOperation.MaterialDTO.self, from: encoded)
        let expected = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        #expect(dto == expected)
    }
    
    @Test
    func toModel() throws {
        let dto = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let model = dto.toModel()
        let expected = ModelOperation.Material(
            nodeID: "abc123",
            color: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
        )
        #expect(model == expected)
    }
    
    @Test
    func fromModel() throws {
        let model = ModelOperation.Material(
            nodeID: "abc123",
            color: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
        )
        let dto = ModelOperation.MaterialDTO(model: model)
        let expected = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        #expect(dto == expected)
    }
}
