//
//  SpriteSheetDescription+Model.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

extension SpriteSheetDescription {
    /// Description used for making a sprite sheet from a 3D-model
    ///
    /// - SeeAlso: ``SpriteSheetDescription.ModelDTO``
    public struct Model: SpriteSheetDescribable {
        /// The kind of 3D Model to use for rendering
        public var model: ModelKind
        /// Collection of properties that affect the camera in the scene.
        public var camera = CameraSettings()
        /// Operations used to produce the tiles.
        public var operations = [ModelOperation]()
        /// The number of tiles to place next to each other horizontally before expanding the sprite sheet verically.
        public var numberOfColumns = Int.max
        /// Collection of properties used to describe how to export the sprite sheet.
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
