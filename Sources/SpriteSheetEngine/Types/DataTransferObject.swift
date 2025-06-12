//
//  DataTransferObject.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

protocol DataTransferModelable: Decodable {
    associatedtype Model
    associatedtype Failure: Error
    func toModel() throws(Failure) -> Model
}

protocol DataTransferTransferable: Decodable {
    associatedtype Model
    init(model: Model)
}

protocol DataTransferObject: DataTransferModelable, DataTransferTransferable {
}
