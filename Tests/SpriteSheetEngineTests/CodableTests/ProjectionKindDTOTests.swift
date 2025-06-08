//
//  ProjectionKindDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

import Foundation
import Testing
import CoreGraphics
@testable import SpriteSheetEngine

struct ProjectionKindDTOTests {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    @Test
    func encodePerspective() throws {
        let dto = ProjectionKindDTO.perspective
        let encoded = try encoder.encode(dto)
        let string = String(data: encoded, encoding: .utf8)
        #expect(string == "\"perspective\"")
    }
    
    @Test
    func decodePerspective() throws {
        let string = "\"perspective\""
        let encoded = string.data(using: .utf8)!
        let dto = try decoder.decode(ProjectionKindDTO.self, from: encoded)
        #expect(dto == .perspective)
    }
    
    @Test
    func perspectiveToModel() throws {
        let dto = ProjectionKindDTO.perspective
        let projection = dto.toModel()
        #expect(projection == .perspective)
    }
    
    @Test
    func orthographicToModel() throws {
        let dto = ProjectionKindDTO.orthographic
        let projection = dto.toModel()
        #expect(projection == .orthographic)
    }
    
    @Test
    func modelToPerspective() throws {
        let projection = CameraSettings.ProjectionKind.perspective
        let dto = ProjectionKindDTO(model: projection)
        #expect(dto == .perspective)
    }
    
    @Test
    func modelToOrthographic() throws {
        let projection = CameraSettings.ProjectionKind.orthographic
        let dto = ProjectionKindDTO(model: projection)
        #expect(dto == .orthographic)
    }
}
