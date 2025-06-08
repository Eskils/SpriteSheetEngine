//
//  DataTransferObject.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

protocol DataTransferObject: Codable {
    associatedtype Model
    func toModel() -> Model
    init(model: Model)
}
