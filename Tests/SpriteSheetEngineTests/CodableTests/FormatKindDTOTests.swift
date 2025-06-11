//
//  FormatKindDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

import Foundation
import Testing
import CoreGraphics
@testable import SpriteSheetEngine

struct FormatKindDTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeImage() throws {
        let dto = FormatKindDTO.image
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"image\"")
    }
    
    @Test
    func decodeImage() throws {
        let string = "\"image\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(FormatKindDTO.self, from: encoded)
        #expect(dto == .image)
    }
    
    @Test
    func imageToModel() throws {
        let dto = FormatKindDTO.image
        let model = dto.toModel()
        #expect(model == .image)
    }
    
    @Test
    func modelToImage() throws {
        let model = ExportSettings.FormatKind.image
        let dto = FormatKindDTO(model: model)
        #expect(dto == .image)
    }
}
