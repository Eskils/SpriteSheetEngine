//
//  ModelOperation+MaterialDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

extension ModelOperation {
    struct MaterialDTO: ModelOperationDTORepresentable {
        var type: ModelOperation.Kind
        var nodeID: String
        var color: ColorDTO
    }
}

extension ModelOperation.MaterialDTO: Codable {
}

extension ModelOperation.MaterialDTO: DataTransferObject {
    func toModel() -> ModelOperation.Material {
        ModelOperation.Material(
            nodeID: nodeID,
            color: color.toModel()
        )
    }
    
    init(model: ModelOperation.Material) {
        self.init(
            type: .material,
            nodeID: model.nodeID,
            color: ColorDTO(model: model.color)
        )
    }
}
