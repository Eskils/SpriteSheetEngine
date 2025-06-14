//
//  ImageTiler+ImageError.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//

extension ImageTiler {
    enum ImageError: Error {
        case cannotMakeCGContext(width: Int, height: Int)
        case cannotMakeImage
    }
}
