//
//  SpriteSheetDescribable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

protocol SpriteSheetDescribable {
    associatedtype Operation: SpriteSheetOperation
    var operations: [Operation] { get }
    var numberOfColumns: Int { get }
    var export: ExportSettings { get }
}
