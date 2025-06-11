//
//  Vector2DTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

import simd
import CoreGraphics

struct Vector2DTO {
    let x: Float
    let y: Float
}

extension Vector2DTO: Equatable {
}

extension Vector2DTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y])
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let numbers = try container.decode([Float].self)
        guard numbers.count >= 2 else {
            throw DecoderError.tooFewVectorEntries(count: numbers.count)
        }
        self.x = numbers[0]
        self.y = numbers[1]
    }
    
    enum DecoderError: Error, Equatable {
        case tooFewVectorEntries(count: Int, required: Int = 2)
    }
}

extension Vector2DTO: DataTransferObject {
    func toModel() -> simd_float2 {
        simd_float2(x: x, y: y)
    }
    
    init(model: simd_float2) {
        self.x = model.x
        self.y = model.y
    }
    
    func toCGPoint() -> CGPoint {
        CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    init(cgPoint: CGPoint) {
        self.x = Float(cgPoint.x)
        self.y = Float(cgPoint.y)
    }
    
    func toCGSize() -> CGSize {
        CGSize(width: CGFloat(x), height: CGFloat(y))
    }
    
    init(cgSize: CGSize) {
        self.x = Float(cgSize.width)
        self.y = Float(cgSize.height)
    }
}
