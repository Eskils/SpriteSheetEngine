//
//  TestsDirectoryBrowsable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 13/02/2026.
//


protocol TestsDirectoryBrowsable {
    var testsDirectory: String { get }
}

extension TestsDirectoryBrowsable {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
}
