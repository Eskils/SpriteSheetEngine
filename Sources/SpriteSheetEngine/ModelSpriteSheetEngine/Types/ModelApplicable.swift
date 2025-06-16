//
//  ModelApplicable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//


public protocol ModelApplicable: SpriteSheetOperation {
    var nodeID: String { get }
}
