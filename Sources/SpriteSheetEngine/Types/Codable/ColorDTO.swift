//
//  ColorDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

import CoreGraphics

enum ColorDTO {
    case transparent
    case hex(Int)
}

extension ColorDTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .transparent:
            try container.encode(ColorDTO.transparentKey)
        case .hex(let int):
            let hexString = String(int, radix: 16)
            try container.encode("#\(hexString)")
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        switch true {
        case string == ColorDTO.transparentKey: self = .transparent
        case string.starts(with: "#"):
            let hexString = string[string.index(string.startIndex, offsetBy: 1)..<string.endIndex]
            guard let hex = Int(hexString, radix: 16) else {
                throw ColorDTODecoderError.cannotParseStringAsHex(string)
            }
            self = .hex(hex)
        case string.count == 6:
            guard let hex = Int(string, radix: 16) else {
                throw ColorDTODecoderError.cannotParseStringAsHex(string)
            }
            self = .hex(hex)
        default: throw ColorDTODecoderError.cannotParseStringIntoColor(string)
        }
    }
    
    private static let transparentKey = "transparent"
    
    enum ColorDTODecoderError: Error {
        case cannotParseStringIntoColor(String)
        case cannotParseStringAsHex(String)
    }
}

extension ColorDTO: Equatable {
}

extension ColorDTO: DataTransferObject {
    func toModel() -> CGColor {
        switch self {
        case .transparent:
            return CGColor(gray: 0, alpha: 0)
        case .hex(let int):
            let red = int >> 16 & 0xFF
            let green = int >> 8 & 0xFF
            let blue = int >> 0 & 0xFF
            return CGColor(
                red: CGFloat(red) / 255,
                green: CGFloat(green) / 255,
                blue: CGFloat(blue) / 255,
                alpha: 1
            )
        }
    }
    
    func toBackgroundKind() -> CameraSettings.BackgroundKind {
        switch self {
        case .transparent:
            .transparent
        case .hex:
            .color(toModel())
        }
    }
    
    init(model: CGColor) {
        guard let components = model.components, components.count >= 3 else {
            self = .transparent
            return
        }
        
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        
        let hex = red << 16 + green << 8 + blue << 0
        self = .hex(hex)
    }
}
