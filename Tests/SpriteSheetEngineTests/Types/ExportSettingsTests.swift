//
//  ExportSettingsTests.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 05/02/2026.
//

import Testing
import CoreGraphics
@testable import SpriteSheetEngine

struct ExportSettingsTests {
    @Test
    func normalizeWithAlreadyNormalizedCropRect() {
        let expectedCropRect = CGRect(x: 1, y: 2, width: 3, height: 4)
        let exportSettings = ExportSettings(
            size: CGSize(width: 10, height: 10),
            cropRect: expectedCropRect
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    // FIXME: Add more tests
}
