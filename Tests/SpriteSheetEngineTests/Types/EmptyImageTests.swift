//
//  EmptyImageTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/02/2026.
//

import Foundation
import Testing
import CoreGraphics
@testable import SpriteSheetEngine

struct EmptyImageTests {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    
    @Test
    func magentaOfNonZeroSize() async throws {
        try await assertSnapshot(name: "empty-image-non-zero") {
            EmptyImage.magenta(of: CGSize(width: 10, height: 10))
        }
    }
    
    @Test
    func magentaOfZeroSize() async throws {
        try await assertSnapshot(name: "empty-image-zero") {
            EmptyImage.magenta(of: CGSize(width: 0, height: 0))
        }
    }
}

extension EmptyImageTests {
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
    
    @MainActor
    func assertSnapshot(name: String, for operations: () async throws -> CGImage) async throws {
        let image = try await operations()
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
