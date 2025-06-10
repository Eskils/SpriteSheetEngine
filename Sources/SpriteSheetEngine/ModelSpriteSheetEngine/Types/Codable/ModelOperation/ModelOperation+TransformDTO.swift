//
//  ModelOperation+TransformDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

extension ModelOperation {
    struct TransformDTO: ModelOperationDTORepresentable {
        var type: ModelOperation.Kind
        var nodeID: String
        var matrix: Matrix4x4DTO
    }
}

extension ModelOperation.TransformDTO: Equatable {
}

extension ModelOperation.TransformDTO: Codable {
}

extension ModelOperation.TransformDTO: DataTransferObject {
    func toModel() -> ModelOperation.Transform {
        ModelOperation.Transform(
            nodeID: nodeID,
            matrix: matrix.toModel()
        )
    }
    
    init(model: ModelOperation.Transform) {
        self.init(
            type: .transform,
            nodeID: model.nodeID,
            matrix: Matrix4x4DTO(model: model.matrix)
        )
    }
}
