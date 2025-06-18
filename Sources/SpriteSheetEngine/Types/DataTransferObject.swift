//
//  DataTransferObject.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 08/06/2025.
//

/// Implement this interface as a data transfer object to be able to transform into a framework-native model/entity.
protocol DataTransferModelable: Decodable {
    associatedtype Model
    associatedtype Failure: Error
    func toModel() throws(Failure) -> Model
}

/// Implement this interface as a data transfer object to be able to initialize from a framework-native model/entity.
protocol DataTransferTransferable: Encodable {
    associatedtype Model
    init(model: Model)
}

/// Implement this interface as a data transfer object to be able to transform to and from a framework-native model/entity
protocol DataTransferObject: DataTransferModelable, DataTransferTransferable {
}
