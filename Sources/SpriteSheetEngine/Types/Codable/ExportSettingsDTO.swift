//
//  ExportSettingsDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 11/06/2025.
//

struct ExportSettingsDTO {
    var size: Vector2DTO?
    var kind: FormatKindDTO?
    var format: ImageFormatDTO?
}

extension ExportSettingsDTO: Equatable {
}

extension ExportSettingsDTO: Codable {
}

extension ExportSettingsDTO: DataTransferObject {
    func toModel() -> ExportSettings {
        var settings = ExportSettings()
        
        if let size {
            settings.size = size.toCGSize()
        }
        
        if let kind {
            settings.kind = kind.toModel()
        }
        
        if let format {
            settings.format = format.toModel()
        }
        
        return settings
    }
    
    init(model: ExportSettings) {
        self.init(
            size: Vector2DTO(cgSize: model.size),
            kind: FormatKindDTO(model: model.kind),
            format: ImageFormatDTO(model: model.format)
        )
    }
}
