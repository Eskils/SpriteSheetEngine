//
//  SpriteSheetDescription+Model.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

extension SpriteSheetDescription {
    struct Model: SpriteSheetDescribable {
        var model: ModelKind
        var camera: CameraSettings
        var operations: [SpriteSheetAxis.Kind: [ModelOperation]]
        var export: ExportSettings
    }
}
