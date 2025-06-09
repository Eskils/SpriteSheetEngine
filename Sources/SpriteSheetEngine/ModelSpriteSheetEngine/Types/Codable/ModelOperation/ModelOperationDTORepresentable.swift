//
//  ModelOperationDTORepresentable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 09/06/2025.
//


protocol ModelOperationDTORepresentable: Codable, DataTransferObject {
    var type: ModelOperation.Kind { get }
}
