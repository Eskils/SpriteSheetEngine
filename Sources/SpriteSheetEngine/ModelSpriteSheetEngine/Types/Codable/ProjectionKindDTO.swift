//
//  ProjectionKindDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

enum ProjectionKindDTO {
    case perspective
    case orthographic
}

extension ProjectionKindDTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .perspective:
            try container.encode(ProjectionKindDTO.perspectiveKey)
        case .orthographic:
            try container.encode(ProjectionKindDTO.orthographicKey)
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        switch string {
        case ProjectionKindDTO.perspectiveKey:
            self = .perspective
        case ProjectionKindDTO.orthographicKey:
            self = .orthographic
        default: throw DecoderError.cannotParseStringIntoProjectionKind(string)
        }
    }
    
    private static let perspectiveKey = "perspective"
    private static let orthographicKey = "orthographic"
    
    enum DecoderError: Error {
        case cannotParseStringIntoProjectionKind(String)
    }
}

extension ProjectionKindDTO: DataTransferObject {
    func toModel() -> CameraSettings.ProjectionKind {
        switch self {
        case .perspective:
            .perspective
        case .orthographic:
            .orthographic
        }
    }
    
    init(model: CameraSettings.ProjectionKind) {
        switch model {
        case .perspective:
            self = .perspective
        case .orthographic:
            self = .orthographic
        }
    }
}
