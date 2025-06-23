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
    
    #if canImport(AppKit)
    @Test
    func encodeHSB() throws {
        let dto = ColorDTO.hsb(0.1, 0.2, 0.3)
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"hsb(0.1, 0.2, 0.3)\"")
    }
    
    @Test
    func decodeHSB() throws {
        let string = "\"hsb(0.1, 0.2, 0.3)\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ColorDTO.self, from: encoded)
        #expect(dto == .hsb(0.1, 0.2, 0.3))
    }
    
    @Test
    func hsbToModel() throws {
        let dto = ColorDTO.hsb(0.1, 0.2, 0.3)
        let model = dto.toModel()
        let components = model.components ?? []
        #expect(0.295..<0.305 ~= components[0])
        #expect(0.271..<0.281 ~= components[1])
        #expect(0.235..<0.245 ~= components[2])
        #expect(1 == components[3])
    }
    
    @Test
    func hsbToBackgroundKind() throws {
        let dto = ColorDTO.hsb(0.1, 0.2, 0.3)
        let model = dto.toBackgroundKind()
        if case let .color(color) = model {
            let components = color.components ?? []
            #expect(0.295..<0.305 ~= components[0])
            #expect(0.271..<0.281 ~= components[1])
            #expect(0.235..<0.245 ~= components[2])
            #expect(1 == components[3])
        } else {
            try #require(Bool(false))
        }
    }
    #endif
    
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
    
    @Test
    func backgroundKindToHex() throws {
        let model = CGColor(red: 170.0 / 255, green: 187.0 / 255, blue: 204.0 / 255, alpha: 1)
        let backgroundKind = CameraSettings.BackgroundKind.color(model)
        let dto = ColorDTO(backgroundKind: backgroundKind)
        #expect(dto == .hex(0xAABBCC))
    }
    
    @Test
    func backgroundKindToTransparent() throws {
        let backgroundKind = CameraSettings.BackgroundKind.transparent
        let dto = ColorDTO(backgroundKind: backgroundKind)
        #expect(dto == .transparent)
    }
}
