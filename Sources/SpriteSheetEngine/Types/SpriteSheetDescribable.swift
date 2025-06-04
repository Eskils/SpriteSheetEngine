//
//  SpriteSheetDescribable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

protocol SpriteSheetDescribable {
    associatedtype Operation: SpriteSheetOperation
    var operations: [SpriteSheetAxis.Kind: [Operation]] { get }
    var axes: Set<SpriteSheetAxis> { get }
}
