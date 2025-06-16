//
//  Model3DSpriteSheet.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 03/06/2025.
//

import Foundation
import ArgumentParser

struct Model3DSpriteSheet: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "model",
        abstract: "Make sprite sheet from a 3D model."
    )
    
    @Argument(
        help: ArgumentHelp(
            "Path to model sprite sheet description file",
            discussion: "Supported input formats are: json"
        ),
    )
    var input: String
    
    @Argument(
        help: ArgumentHelp(
            "Path to output sprite sheet",
            discussion: "The output format is read from export.format in the sprite sheet description file."
        ),
    )
    var output: String
    
    func validate() throws(ValidationError) {
        guard FileManager.default.fileExists(atPath: input) else {
            throw .invalidInputPath(input)
        }
        
        guard FileManager.default.isWritableFile(atPath: output) else {
            throw .invalidOutputPath(output)
        }
    }

    mutating func run() {
    }
}

extension Model3DSpriteSheet {
    enum ValidationError: Error {
        case invalidInputPath(String)
        case invalidOutputPath(String)
    }
}

extension Model3DSpriteSheet.ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidInputPath(let path):
            "No sprite sheet description exists at the given input path “\(path)”."
        case .invalidOutputPath(let path):
            "The given output path “\(path)” is not writable."
        }
    }
}
