//
//  Matrix4x4DTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

import Foundation
import Testing
import simd
@testable import SpriteSheetEngine

struct Matrix4x4DTOTest {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeMatrix() throws {
        let dto = Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15
            ]
        )
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]")
    }
    
    @Test
    func decodeMatrix() throws {
        let string = "[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Matrix4x4DTO.self, from: encoded)
        #expect(dto == Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15
            ]
        ))
    }
    
    @Test
    func decodeMatrixWithTooFewEntriesThrowsError() throws {
        let string = "[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]"
        let encoded = string.data(using: .utf8)!
        #expect(throws: Matrix4x4DTO.DecoderError.tooFewMatrixEntries(count: 15, required: 16)) {
            try decoder.decode(Matrix4x4DTO.self, from: encoded)
        }
    }
    
    @Test
    func decodeMatrixWithTooManyEntries() throws {
        let string = "[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]"
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(Matrix4x4DTO.self, from: encoded)
        #expect(dto == Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15, 16
            ]
        ))
    }
    
    @Test
    func matrixToModel() throws {
        let matrix = Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15
            ]
        )
        let model = matrix.toModel()
        #expect(model == simd_float4x4(
            rows: [
                SIMD4(0, 1, 2, 3),
                SIMD4(4, 5, 6, 7),
                SIMD4(8, 9, 10, 11),
                SIMD4(12, 13, 14, 15),
            ]
        ))
    }
    
    @Test
    func modelToMatrix() throws {
        let model = simd_float4x4(
            rows: [
                SIMD4(0, 1, 2, 3),
                SIMD4(4, 5, 6, 7),
                SIMD4(8, 9, 10, 11),
                SIMD4(12, 13, 14, 15),
            ]
        )
        let matrix = Matrix4x4DTO(model: model)
        #expect(matrix == Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15
            ]
        ))
    }
    
    @Test
    func matrixToModelTooManyNumbers() throws {
        let matrix = Matrix4x4DTO(
            numbers: [
                0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11,
                12, 13, 14, 15, 16
            ]
        )
        let model = matrix.toModel()
        #expect(model == simd_float4x4(
            rows: [
                SIMD4(0, 1, 2, 3),
                SIMD4(4, 5, 6, 7),
                SIMD4(8, 9, 10, 11),
                SIMD4(12, 13, 14, 15),
            ]
        ))
    }
}
