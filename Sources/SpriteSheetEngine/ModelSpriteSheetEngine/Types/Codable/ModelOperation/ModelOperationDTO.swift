//
//  ModelOperationDTO.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//

enum ModelOperationDTO {
    case transform(ModelOperation.TransformDTO)
    case material(ModelOperation.MaterialDTO)
    case none
}

extension ModelOperationDTO: Equatable {
}

extension ModelOperationDTO: Codable {
    func encode(to encoder: any Encoder) throws {
        switch self {
        case .transform(let transform):
            try transform.encode(to: encoder)
        case .material(let material):
            try material.encode(to: encoder)
        case .none:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(ModelOperationDTO.noneKey, forKey: .type)
        }
    }
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(ModelOperation.Kind.self, forKey: .type)
        switch kind {
        case .transform:
            self = .transform(try ModelOperation.TransformDTO(from: decoder))
        case .material:
            self = .material(try ModelOperation.MaterialDTO(from: decoder))
        case .none:
            self = .none
        }
    }
    
    static let noneKey = "none"
}

extension ModelOperationDTO: DataTransferObject {
    func toModel() -> ModelOperation {
        switch self {
        case .transform(let transformDTO):
            .transform(transformDTO.toModel())
        case .material(let materialDTO):
            .material(materialDTO.toModel())
        case .none:
            .none
        }
    }
    
    init(model: ModelOperation) {
        switch model {
        case .transform(let transform):
            self = .transform(ModelOperation.TransformDTO(model: transform))
        case .material(let material):
            self = .material(ModelOperation.MaterialDTO(model: material))
        case .none:
            self = .none
        }
    }
}
