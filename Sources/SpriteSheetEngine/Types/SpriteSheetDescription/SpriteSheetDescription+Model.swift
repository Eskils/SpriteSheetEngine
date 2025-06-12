//
//  SpriteSheetDescription+Model.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

extension SpriteSheetDescription {
    struct Model: SpriteSheetDescribable {
        var model: ModelKind
        var camera = CameraSettings()
        var operations = [ModelOperation]()
        var numberOfColumns = Int.max
        var export = ExportSettings()
    }
}

extension SpriteSheetDescription.Model: Equatable {
}
