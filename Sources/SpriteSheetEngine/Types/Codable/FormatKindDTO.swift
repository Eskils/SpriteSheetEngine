//
//  FormatKindDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

enum FormatKindDTO {
    case image
}

extension FormatKindDTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .image:
            try container.encode(FormatKindDTO.imageKey)
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        switch string {
        case FormatKindDTO.imageKey:
            self = .image
        default: throw DecoderError.cannotParseStringIntoFormatKind(string)
        }
    }
    
    private static let imageKey = "image"
    
    enum DecoderError: Error {
        case cannotParseStringIntoFormatKind(String)
    }
}

extension FormatKindDTO: DataTransferObject {
    func toModel() -> ExportSettings.FormatKind {
        switch self {
        case .image:
            .image
        }
    }
    
    init(model: ExportSettings.FormatKind) {
        switch model {
        case .image:
            self = .image
        }
    }
}
