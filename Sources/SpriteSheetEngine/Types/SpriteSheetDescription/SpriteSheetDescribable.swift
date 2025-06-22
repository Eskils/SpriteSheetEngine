//
//  SpriteSheetDescribable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 04/06/2025.
//

/// Implement this interface to be recognized as a sprite sheet description.
///
/// - SeeAlso: ``SpriteSheetDescription/Model``
public protocol SpriteSheetDescribable: Sendable {
    associatedtype Operation: SpriteSheetOperation
    /// Operations used to produce the tiles.
    /// Each operation corresponds to a tile.
    var operations: [Operation] { get }
    /// The number of tiles to place next to each other horizontally before expanding the sprite sheet verically.
    var numberOfColumns: Int { get }
    /// Collection of properties used to describe how to export the sprite sheet.
    var export: ExportSettings { get }
}
