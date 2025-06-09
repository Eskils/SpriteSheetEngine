//
//  CameraSettingsDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

import Testing
@testable import SpriteSheetEngine
import Foundation
import simd
import CoreGraphics

struct CameraSettingsDTOTests {
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let decoder = JSONDecoder()
    
    @Test
    func encode() throws {
        let dto = CameraSettingsDTO(
            transform: Matrix4x4DTO(
                numbers: [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 5,
                    0, 0, 0, 1
                ]
            ),
            projection: .orthographic,
            background: .hex(0xAABBCC)
        )
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"background":"#aabbcc","projection":"orthographic","transform":[1,0,0,0,0,1,0,0,0,0,1,5,0,0,0,1]}
        """
        #expect(string == expected)
    }
    
    @Test
    func decode() throws {
        let string = """
        {
            "background": "#aabbdd",
            "projection": "orthographic",
            "transform": [
                1,0,0,0,
                0,1,0,0,
                0,0,1,6,
                0,0,0,1
            ]
        }
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(CameraSettingsDTO.self, from: encoded)
        let expected = CameraSettingsDTO(
            transform: Matrix4x4DTO(
                numbers: [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 6,
                    0, 0, 0, 1
                ]
            ),
            projection: .orthographic,
            background: .hex(0xAABBDD)
        )
        #expect(dto == expected)
    }
    
    @Test
    func toModel() throws {
        let dto = CameraSettingsDTO(
            transform: Matrix4x4DTO(
                numbers: [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 6,
                    0, 0, 0, 1
                ]
            ),
            projection: .orthographic,
            background: .hex(0xAABBCC)
        )
        let model = dto.toModel()
        let expected = CameraSettings(
            transform: simd_float4x4(
                rows: [
                    SIMD4(1, 0, 0, 0),
                    SIMD4(0, 1, 0, 0),
                    SIMD4(0, 0, 1, 6),
                    SIMD4(0, 0, 0, 1),
                ]
            ),
            projection: .orthographic,
            background: .color(CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1))
        )
        #expect(model == expected)
    }
    
    @Test
    func fromModel() throws {
        let model = CameraSettings(
            transform: simd_float4x4(
                rows: [
                    SIMD4(1, 0, 0, 0),
                    SIMD4(0, 1, 0, 0),
                    SIMD4(0, 0, 1, 6),
                    SIMD4(0, 0, 0, 1),
                ]
            ),
            projection: .orthographic,
            background: .color(CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1))
        )
        let dto = CameraSettingsDTO(model: model)
        let expected = CameraSettingsDTO(
            transform: Matrix4x4DTO(
                numbers: [
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 6,
                    0, 0, 0, 1
                ]
            ),
            projection: .orthographic,
            background: .hex(0xAABBCC)
        )
        #expect(dto == expected)
    }
    
    @Test
    func emptyToModel() throws {
        let dto = CameraSettingsDTO()
        let model = dto.toModel()
        let expected = CameraSettings(
            transform: simd_float4x4(
                rows: [
                    SIMD4(1, 0, 0, 0),
                    SIMD4(0, 1, 0, 0),
                    SIMD4(0, 0, 1, 2),
                    SIMD4(0, 0, 0, 1),
                ]
            ),
            projection: .perspective,
            background: .transparent
        )
        #expect(model == expected)
    }
}
