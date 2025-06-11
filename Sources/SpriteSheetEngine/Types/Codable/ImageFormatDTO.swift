//
//  ImageFormatDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

enum ImageFormatDTO {
    case jpeg
    case png
}

extension ImageFormatDTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .jpeg:
            try container.encode(ImageFormatDTO.jpegKey)
        case .png:
            try container.encode(ImageFormatDTO.pngKey)
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        switch string {
        case ImageFormatDTO.jpegKey,
             ImageFormatDTO.jpgKey,
             ImageFormatDTO.jpegKey.uppercased(),
             ImageFormatDTO.jpgKey.uppercased():
            self = .jpeg
        case ImageFormatDTO.pngKey,
             ImageFormatDTO.pngKey.uppercased():
            self = .png
        default: throw DecoderError.cannotParseStringIntoImageFormat(string)
        }
    }
    
    private static let jpegKey = "jpeg"
    private static let jpgKey = "jpg"
    private static let pngKey = "png"
    
    enum DecoderError: Error {
        case cannotParseStringIntoImageFormat(String)
    }
}

extension ImageFormatDTO: DataTransferObject {
    func toModel() -> ExportSettings.ImageFormat {
        switch self {
        case .jpeg:
            .jpeg
        case .png:
            .png
        }
    }
    
    init(model: ExportSettings.ImageFormat) {
        switch model {
        case .jpeg:
            self = .jpeg
        case .png:
            self = .png
        }
    }
}
