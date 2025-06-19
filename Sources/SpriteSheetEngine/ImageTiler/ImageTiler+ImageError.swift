//
//  ImageTiler+ImageError.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

extension ImageTiler {
    /// Errors related to making the grid image
    public enum ImageError: Error {
        /// Could not make a Core Graphics context with the given configuration.
        /// Possibly due to invalid dimensions.
        case cannotMakeCGContext(width: Int, height: Int)
        /// The final image could not be made.
        case cannotMakeImage
    }
}

extension ImageTiler.ImageError: Equatable {
}
