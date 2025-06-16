//
//  ImageTiler+TileError.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

extension ImageTiler {
    public enum TileError: Error {
        case tileImageIsTooLarge(actualWidth: Int, actualHeight: Int, expectedWidth: Int, expectedHeight: Int)
        case tileIndexOutOfBounds(index: Int, count: Int)
    }
}

extension ImageTiler.TileError: Equatable {
}
