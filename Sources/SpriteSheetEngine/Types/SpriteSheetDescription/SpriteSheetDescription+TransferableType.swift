//
//  SpriteSheetDescription+TransferableType.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 14/06/2025.
//


extension SpriteSheetDescription {
    /// Supported file formats for decoding a codable sprite sheet description
    public enum TransferableType {
        /// Decode a codable sprite sheet description stored in JSON format
        case json
    }
}
