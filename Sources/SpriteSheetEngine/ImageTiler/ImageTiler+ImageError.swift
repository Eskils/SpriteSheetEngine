//
//  ImageTiler+ImageError.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

extension ImageTiler {
    public enum ImageError: Error {
        case cannotMakeCGContext(width: Int, height: Int)
        case cannotMakeImage
    }
}

extension ImageTiler.ImageError: Equatable {
}
