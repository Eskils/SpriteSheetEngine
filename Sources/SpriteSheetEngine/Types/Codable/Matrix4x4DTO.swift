//
//  Matrix4x4DTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

import simd

struct Matrix4x4DTO {
    let numbers: [Float]
}

extension Matrix4x4DTO: Equatable {   
}

extension Matrix4x4DTO: Codable {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(numbers)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let numbers = try container.decode([Float].self)
        guard numbers.count >= 16 else {
            throw DecoderError.tooFewMatrixEntries(count: numbers.count)
        }
        self.numbers = numbers
    }
    
    enum DecoderError: Error, Equatable {
        case tooFewMatrixEntries(count: Int, required: Int = 16)
    }
}

extension Matrix4x4DTO: DataTransferObject {
    func toModel() -> simd_float4x4 {
        guard numbers.count >= 16 else {
            assertionFailure("Array of numbers in matrix should have at least 16 entries")
            return simd_float4x4(diagonal: .one)
        }
        
        return simd_float4x4(
            rows: [
                SIMD4(numbers[0], numbers[1], numbers[2], numbers[3]),
                SIMD4(numbers[4], numbers[5], numbers[6], numbers[7]),
                SIMD4(numbers[8], numbers[9], numbers[10], numbers[11]),
                SIMD4(numbers[12], numbers[13], numbers[14], numbers[15]),
            ]
        )
    }
    
    init(model: simd_float4x4) {
        self.numbers = (0..<16).map { i in
            let row = i / 4
            let column = i % 4
            return model[column, row]
        }
    }
}
