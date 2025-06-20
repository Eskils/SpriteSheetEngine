//
//  Model3DSpriteSheet.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 03/06/2025.
//

import Foundation
import ArgumentParser
import SpriteSheetEngine

struct Model3DSpriteSheet: AsyncParsableCommand {
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

    mutating func run() async throws {
        let currentWorkingDirectory = if #available(macOS 13.0, *) {
            #if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUN"] != nil {
                URL(filePath: #filePath + "../../../../../").standardizedFileURL
            } else {
                URL(filePath: FileManager.default.currentDirectoryPath)
            }
            #else
            URL(filePath: FileManager.default.currentDirectoryPath)
            #endif
        } else {
            URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        }
        
        let inputURL = if #available(macOS 13.0, *) {
            URL(filePath: input, relativeTo: currentWorkingDirectory)
        } else {
            URL(fileURLWithPath: input, relativeTo: currentWorkingDirectory)
        }
        
        let outputURL = if #available(macOS 13.0, *) {
            URL(filePath: output, relativeTo: currentWorkingDirectory)
        } else {
            URL(fileURLWithPath: output, relativeTo: currentWorkingDirectory)
        }
        
        guard FileManager.default.fileExists(atPath: inputURL.path) else {
            throw ValidationError.invalidInputPath(input)
        }
        
        guard FileManager.default.isWritableFile(atPath: outputURL.deletingLastPathComponent().path) else {
            throw ValidationError.invalidOutputPath(output)
        }
        
        let engine = try await ModelSpriteSheetEngine(
            url: inputURL,
            type: .json,
            relativeTo: inputURL.deletingLastPathComponent()
        )
        
        try await engine.export(to: outputURL)
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
