//
//  MakeSpriteSheet.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 03/06/2025.
//

import ArgumentParser

@main
struct MakeSpriteSheet: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "mk-sprite-sheet",
        abstract: "A utility to make sprite sheets.",
        subcommands: [Model3DSpriteSheet.self]
    )
}
