//
//  SnapshotAssertable.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 13/02/2026.
//

import Testing
import CoreGraphics

protocol SnapshotAssertable: TestsDirectoryBrowsable {
}

extension SnapshotAssertable {
    func assertSnapshot(name: String, for operations: @Sendable () async throws -> CGImage) async throws {
        let image = try await operations()
        try assert(image: image, name: name)
    }
    
    func assertSnapshot(name: String, for operations: () throws -> CGImage) throws {
        let image = try operations()
        try assert(image: image, name: name)
    }
    
    private func assert(image: CGImage, name: String) throws {
        let fileName = name.lowercased().replacingOccurrences(of: " ", with: "-")
        #expect(
            try isImageEqual(
                actual: image,
                transformed: filePath(name: "\(fileName).png", directory: "ProducedOutputs"),
                expected: filePath(name: "\(fileName).png", directory: "ExpectedOutputs")
            )
        )
    }
}
