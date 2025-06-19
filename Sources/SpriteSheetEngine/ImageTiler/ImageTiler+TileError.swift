//
//  ImageTiler+TileError.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

extension ImageTiler {
    /// Errors related to arranging tiles
    public enum TileError: Error {
        /// The tile cannot be arranged as its size exceeds the allocated bounds.
        case tileImageIsTooLarge(actualWidth: Int, actualHeight: Int, expectedWidth: Int, expectedHeight: Int)
        /// The tile cannot be arranged as the grid is full.
        case tileIndexOutOfBounds(index: Int, count: Int)
    }
}

extension ImageTiler.TileError: Equatable {
}
