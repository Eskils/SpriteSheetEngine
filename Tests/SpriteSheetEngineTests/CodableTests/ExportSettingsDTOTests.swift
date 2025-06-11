//
//  ExportSettingsDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

import Testing
@testable import SpriteSheetEngine
import Foundation
import CoreGraphics
import simd

struct ExportSettingsDTOTests {
    let encoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    let decoder = JSONDecoder()
    
    @Test
    func encode() throws {
        let dto = ExportSettingsDTO(
            size: Vector2DTO(x: 1, y: 2),
            kind: .image,
            format: .jpeg
        )
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        let expected = """
        {"format":"jpeg","kind":"image","size":[1,2]}
        """
        #expect(string == expected)
    }
    
    @Test
    func decode() throws {
        let string = """
        {"format":"jpeg","kind":"image","size":[1,2]}
        """
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ExportSettingsDTO.self, from: encoded)
        let expected = ExportSettingsDTO(
            size: Vector2DTO(x: 1, y: 2),
            kind: .image,
            format: .jpeg
        )
        #expect(dto == expected)
    }
    
    @Test
    func toModel() throws {
        let dto = ExportSettingsDTO(
            size: Vector2DTO(x: 1, y: 2),
            kind: .image,
            format: .jpeg
        )
        let model = dto.toModel()
        let expected = ExportSettings(
            size: CGSize(width: 1, height: 2),
            kind: .image,
            format: .jpeg
        )
        #expect(model == expected)
    }
    
    @Test
    func fromModel() throws {
        let model = ExportSettings(
            size: CGSize(width: 1, height: 2),
            kind: .image,
            format: .jpeg
        )
        let dto = ExportSettingsDTO(model: model)
        let expected = ExportSettingsDTO(
            size: Vector2DTO(x: 1, y: 2),
            kind: .image,
            format: .jpeg
        )
        #expect(dto == expected)
    }
    
    @Test
    func emptyToModel() throws {
        let dto = ExportSettingsDTO()
        let model = dto.toModel()
        let expected = ExportSettings(
            size: CGSize(width: 128, height: 128),
            kind: .image,
            format: .png
        )
        #expect(model == expected)
    }
}
