//
//  ImageFormatDTOTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

import Foundation
import Testing
@testable import SpriteSheetEngine

struct ImageFormatDTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodeJpeg() throws {
        let dto = ImageFormatDTO.jpeg
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"jpeg\"")
    }
    
    @Test
    func encodePng() throws {
        let dto = ImageFormatDTO.png
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"png\"")
    }
    
    @Test
    func decodeJpeg() throws {
        let string = "\"jpeg\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .jpeg)
    }
    
    @Test
    func decodeJpg() throws {
        let string = "\"jpg\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .jpeg)
    }
    
    @Test
    func decodeUppercaseJpeg() throws {
        let string = "\"JPEG\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .jpeg)
    }
    
    @Test
    func decodeUppercaseJpg() throws {
        let string = "\"JPG\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .jpeg)
    }
    
    @Test
    func decodePng() throws {
        let string = "\"png\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .png)
    }
    
    @Test
    func decodeUppercasePng() throws {
        let string = "\"PNG\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ImageFormatDTO.self, from: encoded)
        #expect(dto == .png)
    }
    
    
    @Test
    func jpegToModel() throws {
        let dto = ImageFormatDTO.jpeg
        let model = dto.toModel()
        #expect(model == .jpeg)
    }
    
    @Test
    func jpegToImage() throws {
        let model = ExportSettings.ImageFormat.jpeg
        let dto = ImageFormatDTO(model: model)
        #expect(dto == .jpeg)
    }
    
    @Test
    func pngToModel() throws {
        let dto = ImageFormatDTO.png
        let model = dto.toModel()
        #expect(model == .png)
    }
    
    @Test
    func pngToImage() throws {
        let model = ExportSettings.ImageFormat.png
        let dto = ImageFormatDTO(model: model)
        #expect(dto == .png)
    }
}
