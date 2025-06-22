//
//  ColorDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

import CoreGraphics
#if canImport(AppKit)
import AppKit
#endif

enum ColorDTO {
    case transparent
    case hex(Int)
    case hsb(Float, Float, Float)
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
        #if canImport(AppKit)
        case .hsb(let hue, let saturation, let brightness):
            try container.encode("hsb(\(hue), \(saturation), \(brightness))")
        #endif
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
                throw DecoderError.cannotParseStringAsHex(string)
            }
            self = .hex(hex)
        #if canImport(AppKit)
        case string.starts(with: "hsb"):
            let componentsString = string[string.index(string.startIndex, offsetBy: 4)..<string.index(before: string.endIndex)]
            let components = componentsString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            guard components.count >= 3 else {
                throw DecoderError.tooFewComponentsForHSB(count: components.count, expected: 3)
            }
            let floatComponents = try components.map { component in
                guard let value = Float(component) else {
                    throw DecoderError.cannotConvertStringToFloat(component)
                }
                
                guard 0...1 ~= value else {
                    throw DecoderError.numberExceedsAllowedBounds(value: value, min: 0, max: 1)
                }
                
                return value
            }
            self = .hsb(floatComponents[0], floatComponents[1], floatComponents[2])
        #endif
        case string.count == 6:
            guard let hex = Int(string, radix: 16) else {
                throw DecoderError.cannotParseStringAsHex(string)
            }
            self = .hex(hex)
        default: throw DecoderError.cannotParseStringIntoColor(string)
        }
    }
    
    private static let transparentKey = "transparent"
    
    enum DecoderError: Error {
        case cannotParseStringIntoColor(String)
        case cannotParseStringAsHex(String)
        case tooFewComponentsForHSB(count: Int, expected: Int)
        case cannotConvertStringToFloat(String)
        case numberExceedsAllowedBounds(value: Float, min: Float, max: Float)
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
        #if canImport(AppKit)
        case .hsb(let hue, let saturation, let brightness):
            return NSColor(
                hue: CGFloat(hue),
                saturation: CGFloat(saturation),
                brightness: CGFloat(brightness),
                alpha: 1
            ).cgColor
        #endif
        }
    }
    
    func toBackgroundKind() -> CameraSettings.BackgroundKind {
        switch self {
        case .transparent:
            .transparent
        case .hex:
            .color(toModel())
        #if canImport(AppKit)
        case .hsb:
            .color(toModel())
        #endif
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
    
    init(backgroundKind: CameraSettings.BackgroundKind) {
        switch backgroundKind {
        case .transparent: self = .transparent
        case .color(let color): self.init(model: color)
        }
    }
}
