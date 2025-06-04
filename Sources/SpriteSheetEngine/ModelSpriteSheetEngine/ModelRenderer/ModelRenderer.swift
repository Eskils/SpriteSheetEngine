//
//  ModelRenderer.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

import CoreGraphics

protocol ModelRenderer {
    associatedtype Model
    
    func add(model: Model)
    func configure(camera: CameraSettings)
    func perform(operation: ModelOperation) async -> CGImage
}
