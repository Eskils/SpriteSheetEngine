//
//  ModelApplicable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//


/// Implement this interface to describe an operation performable on a 3D-model
public protocol ModelApplicable: SpriteSheetOperation {
    /// A name that refers to a particular node or mesh
    var nodeID: String { get }
}
