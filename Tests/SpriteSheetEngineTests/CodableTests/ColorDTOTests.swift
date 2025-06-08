//
//  ColorDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

import Foundation
import Testing
import CoreGraphics
@testable import SpriteSheetEngine

struct ColorDTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeTransparent() throws {
        let dto = ColorDTO.transparent
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"transparent\"")
    }
    
    @Test
    func decodeTransparent() throws {
        let string = "\"transparent\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ColorDTO.self, from: encoded)
        #expect(dto == .transparent)
    }
    
    @Test
    func encodeHex() throws {
        let dto = ColorDTO.hex(0xAABBCC)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"#aabbcc\"")
    }
    
    @Test
    func decodeHexWithHash() throws {
        let string = "\"#aabbcc\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ColorDTO.self, from: encoded)
        #expect(dto == .hex(0xAABBCC))
    }
    
    @Test
    func decodeHexWithoutHash() throws {
        let string = "\"aabbcc\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ColorDTO.self, from: encoded)
        #expect(dto == .hex(0xAABBCC))
    }
    
    @Test
    func hexToModel() throws {
        let dto = ColorDTO.hex(0xAABBCC)
        let color = dto.toModel()
        #expect(color == CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1))
    }
    
    @Test
    func transparentToModel() throws {
        let dto = ColorDTO.transparent
        let color = dto.toModel()
        #expect(color == CGColor(gray: 0, alpha: 0))
    }
    
    @Test
    func hexToBackgroundKind() throws {
        let dto = ColorDTO.hex(0xAABBCC)
        let color = dto.toBackgroundKind()
        #expect(color == .color(CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1)))
    }
    
    @Test
    func transparentToBackgroundKind() throws {
        let dto = ColorDTO.transparent
        let color = dto.toBackgroundKind()
        #expect(color == .transparent)
    }
    
    @Test
    func modelToHex() throws {
        let model = CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1)
        let dto = ColorDTO(model: model)
        #expect(dto == .hex(0xAABBCC))
    }
    
    @Test
    func modelToTransparent() throws {
        let model = CGColor(gray: 0, alpha: 0)
        let dto = ColorDTO(model: model)
        #expect(dto == .transparent)
    }
}
