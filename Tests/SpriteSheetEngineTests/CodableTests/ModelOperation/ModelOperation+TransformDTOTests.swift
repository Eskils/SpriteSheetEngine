//
//  ModelOperation+TransformDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import Testing
import Foundation
import simd
@testable import SpriteSheetEngine

struct ModelOperationTransformDTOTests {
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let decoder = JSONDecoder()
    
    @Test
    func encode() throws {
        let dto = ModelOperation.TransformDTO(
            type: .transform,
            nodeID: "abc123",
            matrix: Matrix4x4DTO(
                numbers: [
                    2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 1
                ]
            )
        )
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"matrix":[2,0,0,0,0,2,0,0,0,0,2,0,0,0,0,1],"nodeID":"abc123","type":"transform"}
        """
        #expect(string == expected)
    }
    
    @Test
    func decode() throws {
        let string = """
        {"matrix":[2,0,0,0,0,2,0,0,0,0,2,0,0,0,0,1],"nodeID":"abc123","type":"transform"}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ModelOperation.TransformDTO.self, from: encoded)
        let expected = ModelOperation.TransformDTO(
            type: .transform,
            nodeID: "abc123",
            matrix: Matrix4x4DTO(
                numbers: [
                    2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 1
                ]
            )
        )
        #expect(dto == expected)
    }
    
    @Test
    func toModel() throws {
        let dto = ModelOperation.TransformDTO(
            type: .transform,
            nodeID: "abc123",
            matrix: Matrix4x4DTO(
                numbers: [
                    2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 1
                ]
            )
        )
        let model = dto.toModel()
        let expected = ModelOperation.Transform(
            nodeID: "abc123",
            matrix: simd_float4x4(
                rows: [
                    SIMD4(2, 0, 0, 0),
                    SIMD4(0, 2, 0, 0),
                    SIMD4(0, 0, 2, 0),
                    SIMD4(0, 0, 0, 1),
                ]
            )
        )
        #expect(model == expected)
    }
    
    @Test
    func fromModel() throws {
        let model = ModelOperation.Transform(
            nodeID: "abc123",
            matrix: simd_float4x4(
                rows: [
                    SIMD4(2, 0, 0, 0),
                    SIMD4(0, 2, 0, 0),
                    SIMD4(0, 0, 2, 0),
                    SIMD4(0, 0, 0, 1),
                ]
            )
        )
        let dto = ModelOperation.TransformDTO(model: model)
        let expected = ModelOperation.TransformDTO(
            type: .transform,
            nodeID: "abc123",
            matrix: Matrix4x4DTO(
                numbers: [
                    2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 1
                ]
            )
        )
        #expect(dto == expected)
    }
}
