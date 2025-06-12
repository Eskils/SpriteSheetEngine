//
//  SpriteSheetDescription+ModelDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 12/06/2025.
//

extension SpriteSheetDescription {
    struct ModelDTO {
        var model: ModelKindDTO
        var camera: CameraSettingsDTO?
        var operations: [ModelOperationDTO]?
        var numberOfColumns: Int?
        var export: ExportSettingsDTO?
    }
}

extension SpriteSheetDescription.ModelDTO: Equatable {
}

extension SpriteSheetDescription.ModelDTO: Decodable {
}

// FIXME: Change to `@MainActor DataTransferModelable` in Swift 6.2
extension SpriteSheetDescription.ModelDTO: @preconcurrency DataTransferModelable {
    @MainActor
    func toModel() throws -> SpriteSheetDescription.Model {
        var model = SpriteSheetDescription.Model(model: try model.toModel())
        
        if let camera {
            model.camera = camera.toModel()
        }
        
        if let operations {
            model.operations = operations.map { $0.toModel() }
        }
        
        if let numberOfColumns {
            model.numberOfColumns = numberOfColumns
        }
        
        if let export {
            model.export = export.toModel()
        }
        
        return model
    }
}
