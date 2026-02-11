//
//  Vector4DTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 03/02/2026.
//

import simd
import CoreGraphics

struct Vector4DTO {
    let x: Float
    let y: Float
    let z: Float
    let w: Float
}

extension Vector4DTO: Equatable {
}

extension Vector4DTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, z, w])
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let numbers = try container.decode([Float].self)
        guard numbers.count >= 4 else {
            throw DecoderError.tooFewVectorEntries(count: numbers.count)
        }
        self.x = numbers[0]
        self.y = numbers[1]
        self.z = numbers[2]
        self.w = numbers[3]
    }
    
    enum DecoderError: Error, Equatable {
        case tooFewVectorEntries(count: Int, required: Int = 4)
    }
}

extension Vector4DTO: DataTransferObject {
    func toModel() -> simd_float4 {
        simd_float4(x: x, y: y, z: z, w: w)
    }
    
    init(model: simd_float4) {
        self.x = model.x
        self.y = model.y
        self.z = model.z
        self.w = model.w
    }
    
    func toCGRect() -> CGRect {
        CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(z), height: CGFloat(w))
    }
    
    init(cgRect: CGRect) {
        self.x = Float(cgRect.minX)
        self.y = Float(cgRect.minY)
        self.z = Float(cgRect.width)
        self.w = Float(cgRect.height)
    }
}
