//
//  CameraSettingsDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

struct CameraSettingsDTO {
    var transform: Matrix4x4DTO?
    var projection: ProjectionKindDTO?
    var background: ColorDTO?
}

extension CameraSettingsDTO: Codable {
}

extension CameraSettingsDTO: DataTransferObject {
    func toModel() -> CameraSettings {
        var settings = CameraSettings()
        
        if let transform {
            settings.transform = transform.toModel()
        }
        
        if let projection {
            settings.projection = projection.toModel()
        }
        
        if let background {
            settings.background = background.toBackgroundKind()
        }
        
        return settings
    }
    
    init(model: CameraSettings) {
        self.init(
            transform: Matrix4x4DTO(model: model.transform),
            projection: ProjectionKindDTO(model: model.projection),
            background: ColorDTO(backgroundKind: model.background)
        )
    }
}
