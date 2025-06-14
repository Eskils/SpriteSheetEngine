//
//  MockSpriteSheetDescription.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

@testable import SpriteSheetEngine

struct MockSpriteSheetDescription: SpriteSheetDescribable {
    var numberOfColumns = Int.max
    var export = ExportSettings()
    var operations: [MockSpriteSheetOperation]
}
