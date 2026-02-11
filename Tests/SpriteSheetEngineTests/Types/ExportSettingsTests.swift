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
    private let size = CGSize(width: 10, height: 10)
    
    @Test
    func normalizeWithAlreadyNormalizedCropRect() {
        let expectedCropRect = CGRect(x: 1, y: 2, width: 3, height: 4)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: expectedCropRect
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithNegativeCropRect() {
        let expectedCropRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: -2, y: -2, width: -3, height: -3)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithTooLargeSizeInCropRect() {
        let expectedCropRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: 0, y: 0, width: 15, height: 12)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithAlmostTooLargeSizeInCropRect() {
        let expectedCropRect = CGRect(x: 0, y: 0, width: 10, height: 10)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: expectedCropRect
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithTooLargeSizeAndOffsetInCropRect() {
        let expectedCropRect = CGRect(x: 9, y: 8, width: 10, height: 10)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: 9, y: 8, width: 15, height: 12)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithAlmostTooLargeAndOffsetSizeInCropRect() {
        let expectedCropRect = CGRect(x: 9, y: 8, width: 10, height: 10)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: expectedCropRect
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithNanOffsetInCropRect() {
        let expectedCropRect = CGRect(x: 0, y: 0, width: 5, height: 5)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: CGFloat.nan, y: CGFloat.signalingNaN, width: 5, height: 5)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithNanSizeInCropRect() {
        let expectedCropRect = CGRect(x: 5, y: 5, width: 0, height: 0)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: 5, y: 5, width: CGFloat.nan, height: CGFloat.signalingNaN)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithInfinityInCropRect() {
        let expectedCropRect = CGRect(x: 10, y: 10, width: 10, height: 10)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: CGFloat.infinity, y: .infinity, width: .infinity, height: .infinity)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
    
    @Test
    func normalizeWithNegativeInfinityInCropRect() {
        let expectedCropRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let exportSettings = ExportSettings(
            size: size,
            cropRect: CGRect(x: -.infinity, y: -.infinity, width: -.infinity, height: -.infinity)
        )
        let normalized = exportSettings.normalized()
        #expect(normalized.cropRect == expectedCropRect)
    }
}
