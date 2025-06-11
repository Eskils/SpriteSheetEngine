//
//  Vector2DTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

import Foundation
import Testing
import simd
import CoreGraphics
@testable import SpriteSheetEngine

struct Vector2DTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeVector() throws {
        let dto = Vector2DTO(x: 1, y: 2)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "[1,2]")
    }
    
    @Test
    func decodeVector() throws {
        let string = "[1,2]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Vector2DTO.self, from: encoded)
        #expect(dto == Vector2DTO(x: 1, y: 2))
    }
    
    @Test
    func decodeVectorWithTooFewEntriesThrowsError() throws {
        let string = "[1]"
        let encoded = string.data(using: .utf8)!
        #expect(throws: Vector2DTO.DecoderError.tooFewVectorEntries(count: 1, required: 2)) {
            try decoder.decode(Vector2DTO.self, from: encoded)
        }
    }
    
    @Test
    func decodeMatrixWithTooManyEntries() throws {
        let string = "[1,2,3]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Vector2DTO.self, from: encoded)
        #expect(dto == Vector2DTO(x: 1, y: 2))
    }
    
    @Test
    func vectorToModel() throws {
        let dto = Vector2DTO(x: 1, y: 2)
        let model = dto.toModel()
        #expect(model == simd_float2(1, 2))
    }
    
    @Test
    func modelToVector() throws {
        let model = simd_float2(1, 2)
        let dto = Vector2DTO(model: model)
        #expect(dto == Vector2DTO(x: 1, y: 2))
    }
    
    @Test
    func vectorToCGPoint() throws {
        let dto = Vector2DTO(x: 1, y: 2)
        let model = dto.toCGPoint()
        #expect(model == CGPoint(x: 1, y: 2))
    }
    
    @Test
    func cgPointToVector() throws {
        let model = CGPoint(x: 1, y: 2)
        let dto = Vector2DTO(cgPoint: model)
        #expect(dto == Vector2DTO(x: 1, y: 2))
    }
    
    @Test
    func vectorToCGSize() throws {
        let dto = Vector2DTO(x: 1, y: 2)
        let model = dto.toCGSize()
        #expect(model == CGSize(width: 1, height: 2))
    }
    
    @Test
    func cgSizeToVector() throws {
        let model = CGSize(width: 1, height: 2)
        let dto = Vector2DTO(cgSize: model)
        #expect(dto == Vector2DTO(x: 1, y: 2))
    }
}
