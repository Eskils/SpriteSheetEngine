//
//  ModelOperationDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 10/06/2025.
//

import Testing
import Foundation
import CoreGraphics
import simd
@testable import SpriteSheetEngine

struct ModelOperationDTOTests {
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let decoder = JSONDecoder()
    
    @Test
    func encodeTransform() throws {
        let dtoValue = ModelOperation.TransformDTO(
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
        let dto = ModelOperationDTO.transform(dtoValue)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"matrix":[2,0,0,0,0,2,0,0,0,0,2,0,0,0,0,1],"nodeID":"abc123","type":"transform"}
        """
        #expect(string == expected)
    }
    
    @Test
    func decodeTransform() throws {
        let string = """
        {"matrix":[2,0,0,0,0,2,0,0,0,0,2,0,0,0,0,1],"nodeID":"abc123","type":"transform"}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ModelOperationDTO.self, from: encoded)
        let expectedValue = ModelOperation.TransformDTO(
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
        let expected = ModelOperationDTO.transform(expectedValue)
        #expect(dto == expected)
    }
    
    @Test
    func encodeMaterial() throws {
        let dtoValue = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let dto = ModelOperationDTO.material(dtoValue)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"color":"#336699","nodeID":"abc123","type":"material"}
        """
        #expect(string == expected)
    }
    
    @Test
    func decodeMaterial() throws {
        let string = """
        {"color":"#336699","nodeID":"abc123","type":"material"}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ModelOperationDTO.self, from: encoded)
        let expectedValue = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let expected = ModelOperationDTO.material(expectedValue)
        #expect(dto == expected)
    }
    
    @Test
    func encodeNone() throws {
        let dto = ModelOperationDTO.none
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"type":"none"}
        """
        #expect(string == expected)
    }
    
    @Test
    func decodeNone() throws {
        let string = """
        {"type":"none"}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ModelOperationDTO.self, from: encoded)
        let expected = ModelOperationDTO.none
        #expect(dto == expected)
    }
    
    @Test
    func transformToModel() throws {
        let dtoValue = ModelOperation.TransformDTO(
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
        let dto = ModelOperationDTO.transform(dtoValue)
        let model = dto.toModel()
        let expectedValue = ModelOperation.Transform(
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
        let expected = ModelOperation.transform(expectedValue)
        #expect(model == expected)
    }
    
    @Test
    func transformFromModel() throws {
        let expectedValue = ModelOperation.TransformDTO(
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
        let expected = ModelOperationDTO.transform(expectedValue)
        let modelValue = ModelOperation.Transform(
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
        let model = ModelOperation.transform(modelValue)
        let dto = ModelOperationDTO(model: model)
        #expect(dto == expected)
    }
    
    @Test
    func materialToModel() throws {
        let dtoValue = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let dto = ModelOperationDTO.material(dtoValue)
        let model = dto.toModel()
        let expectedValue = ModelOperation.Material(
            nodeID: "abc123",
            color: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
        )
        let expected = ModelOperation.material(expectedValue)
        #expect(model == expected)
    }
    
    @Test
    func materialFromModel() throws {
        let expectedValue = ModelOperation.MaterialDTO(
            type: .material,
            nodeID: "abc123",
            color: ColorDTO(model: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1))
        )
        let expected = ModelOperationDTO.material(expectedValue)
        let modelValue = ModelOperation.Material(
            nodeID: "abc123",
            color: CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1)
        )
        let model = ModelOperation.material(modelValue)
        let dto = ModelOperationDTO(model: model)
        #expect(dto == expected)
    }
    
    @Test
    func noneToModel() throws {
        #expect(ModelOperationDTO.none.toModel() == .none)
    }
    
    @Test
    func noneFromModel() throws {
        #expect(ModelOperationDTO(model: .none) == .none)
    }
}
