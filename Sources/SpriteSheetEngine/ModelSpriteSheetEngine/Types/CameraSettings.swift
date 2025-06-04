//
//  CameraSettings.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import simd

struct CameraSettings {
    var transform = simd_float4x4(diagonal: .one)
}
