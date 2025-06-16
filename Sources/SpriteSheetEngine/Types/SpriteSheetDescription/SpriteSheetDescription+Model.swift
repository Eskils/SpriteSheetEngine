//
//  SpriteSheetDescription+Model.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

extension SpriteSheetDescription {
    public struct Model: SpriteSheetDescribable {
        public var model: ModelKind
        public var camera = CameraSettings()
        public var operations = [ModelOperation]()
        public var numberOfColumns = Int.max
        public var export = ExportSettings()
        
        public init(
            model: ModelKind,
            camera: CameraSettings = CameraSettings(),
            operations: [ModelOperation] = [ModelOperation](),
            numberOfColumns: Int = Int.max,
            export: ExportSettings = ExportSettings()
        ) {
            self.model = model
            self.camera = camera
            self.operations = operations
            self.numberOfColumns = numberOfColumns
            self.export = export
        }
    }
}

extension SpriteSheetDescription.Model: Equatable {
}
