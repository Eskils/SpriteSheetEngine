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

struct EmptyImageTests: SnapshotAssertable {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    
    @Test
    func magentaOfNonZeroSize() async throws {
        try assertSnapshot(name: "empty-image-non-zero") {
            EmptyImage.magenta(of: CGSize(width: 10, height: 10))
        }
    }
    
    @Test
    func magentaOfZeroSize() async throws {
        try assertSnapshot(name: "empty-image-zero") {
            EmptyImage.magenta(of: CGSize(width: 0, height: 0))
        }
    }
}
