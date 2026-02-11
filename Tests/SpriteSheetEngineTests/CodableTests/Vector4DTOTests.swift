//
//  Vector4DTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/02/2026.
//

import Foundation
import Testing
import simd
import CoreGraphics
@testable import SpriteSheetEngine

struct Vector4DTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeVector() throws {
        let dto = Vector4DTO(x: 1, y: 2, z: 3, w: 4)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "[1,2,3,4]")
    }
    
    @Test
    func decodeVector() throws {
        let string = "[1,2,3,4]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Vector4DTO.self, from: encoded)
        #expect(dto == Vector4DTO(x: 1, y: 2, z: 3, w: 4))
    }
    
    @Test
    func decodeVectorWithTooFewEntriesThrowsError() throws {
        let string = "[1]"
        let encoded = string.data(using: .utf8)!
        #expect(throws: Vector4DTO.DecoderError.tooFewVectorEntries(count: 1, required: 4)) {
            try decoder.decode(Vector4DTO.self, from: encoded)
        }
    }
    
    @Test
    func decodeMatrixWithTooManyEntries() throws {
        let string = "[1,2,3,4,5]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Vector4DTO.self, from: encoded)
        #expect(dto == Vector4DTO(x: 1, y: 2, z: 3, w: 4))
    }
    
    @Test
    func vectorToModel() throws {
        let dto = Vector4DTO(x: 1, y: 2, z: 3, w: 4)
        let model = dto.toModel()
        #expect(model == simd_float4(1, 2, 3, 4))
    }
    
    @Test
    func modelToVector() throws {
        let model = simd_float4(1, 2, 3, 4)
        let dto = Vector4DTO(model: model)
        #expect(dto == Vector4DTO(x: 1, y: 2, z: 3, w: 4))
    }
    
    @Test
    func vectorToCGRect() throws {
        let dto = Vector4DTO(x: 1, y: 2, z: 3, w: 4)
        let model = dto.toCGRect()
        #expect(model == CGRect(x: 1, y: 2, width: 3, height: 4))
    }
    
    @Test
    func cgRectToVector() throws {
        let model = CGRect(x: 1, y: 2, width: 3, height: 4)
        let dto = Vector4DTO(cgRect: model)
        #expect(dto == Vector4DTO(x: 1, y: 2, z: 3, w: 4))
    }
}
